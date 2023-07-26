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
import IOKit.pwr_mgt

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
    @Published private(set) var progress: Float?
    @Published private(set) var progressStatus: String?
    @Published var completedDownloadUrl: URL?
    
    private let api = UUPDumpAPI()
    private var runningTask: (Task<Void, Never>)?
    private var lastErrorLine: String?
    
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
    
    private func findIso(at url: URL) -> URL? {
        let files = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        return files?.first(where: { $0.pathExtension.lowercased() == "iso" })
    }
    
    private nonisolated func requestIdleAssertion() -> IOPMAssertionID? {
        var preventIdleSleepAssertion: IOPMAssertionID = .zero
        let success = IOPMAssertionCreateWithName(kIOPMAssertPreventUserIdleSystemSleep as CFString,
                                                  IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                  "CrystalFetch Downloader" as CFString,
                                                  &preventIdleSleepAssertion)
        return success == kIOReturnSuccess ? preventIdleSleepAssertion : nil
    }
    
    private nonisolated func releaseIdleAssertion(_ assertion: IOPMAssertionID) {
        IOPMAssertionRelease(assertion)
    }
    
    func download(uuid: String, language: String, editions: [String]) {
        let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let baseUrl = cacheUrl.appendingPathComponent(uuid)
        withBusyIndication { [self] in
            let fm = FileManager.default
            if let existingUrl = findIso(at: baseUrl) {
                // if we already have the ISO, go ahead and return it
                completedDownloadUrl = existingUrl
                return
            }
            try? fm.removeItem(at: baseUrl)
            try fm.createDirectory(at: baseUrl, withIntermediateDirectories: true)
            let idleAssertion = requestIdleAssertion()
            defer {
                if let idleAssertion = idleAssertion {
                    releaseIdleAssertion(idleAssertion)
                }
            }
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
                    self.progress = (Float(bytesWritten) / Float(bytesTotal))
                }
            }
            progressStatus = NSLocalizedString("Converting download to ISO...", comment: "Worker")
            progress = nil
            try await convert(files: baseUrl)
        }
    }
    
    private func convert(files url: URL) async throws {
        let script = Bundle.main.url(forResource: "convert", withExtension: "sh")!
        let executablePath = Bundle.main.executableURL!.deletingLastPathComponent().path
        let process = Process()
        process.executableURL = script
        process.currentDirectoryURL = url
        process.environment = ["PATH": "\(executablePath):/usr/bin:/bin:/usr/sbin:/sbin"]
        process.arguments = ["wim", ".", "1"]
        let outputPipe = Pipe()
        outputPipe.fileHandleForReading.readabilityHandler = { handle in
            if let line = String(data: handle.availableData, encoding: .ascii)?.filter({ $0.isASCII }), !line.isEmpty {
                NSLog("[convert.sh stdout]: %@", line)
                Task { @MainActor in
                    self.progressStatus = line
                }
            }
        }
        let errorPipe = Pipe()
        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            if let line = String(data: handle.availableData, encoding: .ascii)?.filter({ $0.isASCII }), !line.isEmpty {
                NSLog("[convert.sh stderr]: %@", line)
                Task { @MainActor in
                    self.lastErrorLine = line
                }
            }
        }
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                process.terminationHandler = { process in
                    let status = process.terminationStatus
                    if process.terminationReason == .exit && status == 0 {
                        continuation.resume()
                    } else if process.terminationReason == .uncaughtSignal && status == SIGTERM {
                        continuation.resume(throwing: CancellationError())
                    } else {
                        Task { @MainActor in
                            if let lastErrorLine = self.lastErrorLine {
                                continuation.resume(throwing: WorkerError.conversionFailedMessage(lastErrorLine))
                            } else {
                                continuation.resume(throwing: WorkerError.conversionFailedUnknown(status))
                            }
                        }
                    }
                }
                do {
                    lastErrorLine = nil
                    try process.run()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        } onCancel: {
            process.terminate()
        }
        completedDownloadUrl = findIso(at: url)
    }
    
    func finalize(isoUrl: URL, destinationUrl: URL) {
        let scoped = destinationUrl.startAccessingSecurityScopedResource()
        completedDownloadUrl = nil
        withBusyIndication {
            defer {
                if scoped {
                    destinationUrl.stopAccessingSecurityScopedResource()
                }
            }
            self.progressStatus = NSLocalizedString("Saving ISO...", comment: "Worker")
            do {
                try FileManager.default.moveItem(at: isoUrl, to: destinationUrl)
            } catch {
                let error = error as NSError
                if error.domain == NSCocoaErrorDomain && error.code == NSFileWriteFileExistsError {
                    // ignore this error
                } else {
                    throw error
                }
            }
            try FileManager.default.removeItem(at: isoUrl.deletingLastPathComponent())
        }
    }
    
    func stop() {
        runningTask?.cancel()
    }
    
    private func withBusyIndication(_ action: @escaping @MainActor () async throws -> Void) {
        isBusy = true
        progress = nil
        progressStatus = nil
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

enum WorkerError: Error {
    case conversionFailedUnknown(Int32)
    case conversionFailedMessage(String)
}

extension WorkerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .conversionFailedUnknown(let status): return String.localizedStringWithFormat(NSLocalizedString("The conversion script failed with error code %d", comment: "Worker"), status)
        case .conversionFailedMessage(let message): return message
        }
    }
}
