//
// Copyright © 2023 Turing Software, LLC. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

@MainActor
class Worker: ObservableObject {
    struct ErrorMessage: Identifiable {
        var message: String
        
        var id: String {
            message
        }
    }
    
    @Published private(set) var isBusy: Bool = false
    @Published var lastSeenError: ErrorMessage?
    @Published var builds: [UUPBuilds.Build] = []
    @Published var selectedBuild: UUPBuilds.Build?
    @Published var search: String = ""
    @Published private(set) var progress: Float = 0.0
    @Published private(set) var progressStatus: String?
    @Published var completedDownloadUrl: URL?
    
    private let api = UUPDumpAPI()
    private var runningTask: (Task<Void, Never>)?
    
    private var currentArch: String {
        #if arch(arm64)
        "arm64"
        #else
        "amd64"
        #endif
    }
    
    private var hasPreviewBuilds: Bool {
        UserDefaults.standard.bool(forKey: "ShowPreviewBuilds")
    }
    
    private var hasServerBuilds: Bool {
        UserDefaults.standard.bool(forKey: "ShowServerBuilds")
    }
    
    var defaultLocale: String {
        UserDefaults.standard.string(forKey: "LastSelectedLocale") ?? Locale.preferredLanguages.first?.lowercased() ?? "netural"
    }
    
    func refresh(findDefault: Bool = false) {
        withBusyIndication { [self] in
            let lastSelectedUuid = selectedBuild?.uuid
            let response = try await api.fetchBuilds(search: search.count > 0 ? search : nil)
            builds = response.builds.filter({ !$0.title.lowercased().contains("update") })
            if findDefault || !builds.contains(where: { $0.uuid == lastSelectedUuid }) {
                selectedBuild = recommendedBuild()
            }
        }
    }
    
    func refreshDetails(uuid: String, language: String? = nil, _ onCompletion: @escaping (BuildDetails, BuildEditions) -> Void) {
        withBusyIndication { [self] in
            let detailsResponse = try await api.fetchDetails(for: uuid)
            let editionsResponse = try await api.fetchEditions(for: uuid, language: language ?? defaultLocale)
            onCompletion(BuildDetails(from: detailsResponse), BuildEditions(from: editionsResponse))
        }
    }
    
    private func recommendedBuild() -> UUPBuilds.Build? {
        builds.filter({ $0.arch == currentArch && (hasPreviewBuilds || !$0.title.contains("Insider")) && (hasServerBuilds || !$0.title.contains("Server")) }).first
    }
    
    func download(uuid: String, language: String, editions: [String]) {
        let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let baseUrl = cacheUrl.appendingPathComponent(uuid)
        withBusyIndication { [self] in
            let fm = FileManager.default
            let files = try? fm.contentsOfDirectory(at: baseUrl, includingPropertiesForKeys: nil)
            if let existingUrl = files?.first(where: { $0.pathExtension == "iso" }) {
                // if we already have the ISO, go ahead and return it
                completedDownloadUrl = existingUrl
                return
            }
            try? fm.removeItem(at: baseUrl)
            try fm.createDirectory(at: baseUrl, withIntermediateDirectories: true)
            completedDownloadUrl = nil
            progress = 0.0
            progressStatus = NSLocalizedString("Fetching files list...", comment: "Worker")
            let package = try await api.fetchPackage(for: uuid, language: language, editions: editions)
            progressStatus = NSLocalizedString("Starting download...", comment: "Worker")
            let downloader = Downloader()
            for (key, value) in package.files {
                await downloader.enqueue(downloadUrl: URL(string: value.url)!, to: baseUrl.appendingPathComponent(key), size: value.size)
            }
            try await downloader.start { bytesWritten, bytesTotal in
                let written = ByteCountFormatter.string(fromByteCount: bytesWritten, countStyle: .file)
                let total = ByteCountFormatter.string(fromByteCount: bytesTotal, countStyle: .file)
                Task { @MainActor in
                    self.progressStatus = String.localizedStringWithFormat(NSLocalizedString("Downloading %@ of %@...", comment: "Worker"), written, total)
                    self.progress = (Float(bytesWritten) / Float(bytesTotal)) * 0.9
                }
            }
            progressStatus = NSLocalizedString("Converting download to ISO...", comment: "Worker")
            throw CancellationError()
        }
    }
    
    func stop() {
        runningTask?.cancel()
    }
    
    private func withBusyIndication(_ action: @escaping @MainActor () async throws -> Void) {
        isBusy = true
        runningTask = Task {
            do {
                try await action()
            } catch is CancellationError {
                
            } catch {
                lastSeenError = ErrorMessage(message: error.localizedDescription)
            }
            runningTask = nil
            isBusy = false
            progress = 0.0
            progressStatus = nil
        }
    }
}
