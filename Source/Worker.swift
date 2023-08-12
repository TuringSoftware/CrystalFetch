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
    
    @Published var esdCatalog: [ESDCatalog.File] = []
    
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
    
    static nonisolated var defaultLocale: String? {
        // There is a naming conversation required for UUP API and macOS API
        //  see https://github.com/TuringSoftware/CrystalFetch/issues/2 for details
        let localeMapper = [
            "zh-hans-cn": "zh-cn"
        ]
        if let preferred = UserDefaults.standard.string(forKey: "LastSelectedLocale") ?? Locale.preferredLanguages.first?.lowercased() {
            return localeMapper[preferred] ?? preferred
        } else {
            return nil
        }
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
    
    func lookupPossibleLocale(fromBuildDetails buildDetails: UUPDetails, withPreferredLanguage language: String? = nil) -> String {
        var decisionLocale = language ?? Self.defaultLocale ?? "netural"
        if !buildDetails.langList.contains(decisionLocale) {
            // unable to find this locale, use the English if possible
            decisionLocale = "en-us"
        }
        if !buildDetails.langList.contains(decisionLocale) {
            // unable to find the en-us, use the first value supported if possible
            decisionLocale = buildDetails.langList.first ?? ""
        }
        // if still not possible, throw the error UNSUPPORTED_LANG from server side
        return decisionLocale
    }
    
    func refreshDetails(uuid: String, language: String? = nil, _ onCompletion: @escaping (BuildDetails, BuildEditions) -> Void) {
        withBusyIndication { [self] in
            let detailsResponse = try await api.fetchDetails(for: uuid)
            let language = lookupPossibleLocale(fromBuildDetails: detailsResponse, withPreferredLanguage: language)
            let editionsResponse = try await api.fetchEditions(for: uuid, language: language)
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
                    let progress = (Float(bytesWritten) / Float(bytesTotal))
                    self.progress = progress > 1.0 ? 1.0 : progress
                }
            }
            progressStatus = NSLocalizedString("Converting download to ISO...", comment: "Worker")
            progress = nil
            try await convert(files: baseUrl)
        }
    }
    
    private nonisolated func extractLine(from data: Data) -> String? {
        if let string = String(data: data, encoding: .utf8) {
            let lines = string.split(whereSeparator: \.isNewline)
            if let line = lines.filter({ !$0.isEmpty }).last {
                let stringLine = String(line)
                if let pattern = try? NSRegularExpression(pattern: "\\033\\[(0|1).*?m") {
                    return pattern.stringByReplacingMatches(in: stringLine, range: NSRange(location: 0, length: stringLine.count), withTemplate: "")
                }
                return stringLine
            }
        }
        return nil
    }
    
    private func convert(files url: URL) async throws {
        let script = Bundle.main.url(forResource: "convert", withExtension: "sh")!
        try await exec(at: url, executableURL: script, "wim", ".", "1")
        completedDownloadUrl = findIso(at: url)
    }
    
    @discardableResult
    private func execv(at currentDirectoryURL: URL?, executableURL: URL, _ args: [String]) async throws -> Int32 {
        let executablePath = Bundle.main.executableURL!.deletingLastPathComponent().path
        let process = Process()
        process.executableURL = executableURL
        process.currentDirectoryURL = currentDirectoryURL
        process.environment = ["PATH": "\(executablePath):/usr/bin:/bin:/usr/sbin:/sbin"]
        process.arguments = args
        let outputPipe = Pipe()
        outputPipe.fileHandleForReading.readabilityHandler = { handle in
            if let line = self.extractLine(from: handle.availableData) {
                NSLog("[%@ stdout]: %@", executableURL.lastPathComponent, line)
                Task { @MainActor in
                    self.progressStatus = line
                }
            }
        }
        let errorPipe = Pipe()
        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            if let line = self.extractLine(from: handle.availableData) {
                NSLog("[%@ stderr]: %@", executableURL.lastPathComponent, line)
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
        return process.terminationStatus
    }
    
    @discardableResult
    private func exec(at currentDirectoryURL: URL?, executableURL: URL, _ args: String...) async throws -> Int32 {
        try await execv(at: currentDirectoryURL, executableURL: executableURL, args)
    }
    
    @discardableResult
    private func exec(_ args: String...) async throws -> Int32 {
        let executableURL = Bundle.main.url(forAuxiliaryExecutable: args[0])!
        let args = Array(args.dropFirst())
        return try await execv(at: nil, executableURL: executableURL, args)
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

// MARK: - ESD Catalog
extension Worker {
    private var windows10CatalogUrl: URL {
        URL(string: "https://go.microsoft.com/fwlink/?LinkId=841361")!
    }
    
    private var windows11CatalogUrl: URL {
        URL(string: "https://go.microsoft.com/fwlink?linkid=2156292")!
    }
    
    func refreshEsdCatalog(windows10: Bool = false) {
        let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let catalogUrl = cacheUrl.appendingPathComponent("catalog.cab")
        let productsUrl = cacheUrl.appendingPathComponent("products.xml")
        withBusyIndication { [self] in
            let fm = FileManager.default
            let downloader = Downloader()
            try? fm.removeItem(at: catalogUrl)
            if windows10 {
                await downloader.enqueue(downloadUrl: windows10CatalogUrl, to: catalogUrl)
            } else {
                await downloader.enqueue(downloadUrl: windows11CatalogUrl, to: catalogUrl)
            }
            try await downloader.start()
            try await exec("cabextract", "-d", cacheUrl.path, catalogUrl.path)
            let data = try Data(contentsOf: productsUrl)
            let esd = try await ESDCatalog(from: data)
            esdCatalog = await esd.files
        }
    }
    
    func download(_ file: ESDCatalog.File) {
        let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let baseUrl = cacheUrl.appendingPathComponent(UUID().uuidString)
        let esdUrl = baseUrl.appendingPathComponent(file.name)
        let isoUrl = esdUrl.deletingPathExtension().appendingPathExtension("iso")
        withBusyIndication { [self] in
            let fm = FileManager.default
            if fm.fileExists(atPath: isoUrl.path) {
                completedDownloadUrl = isoUrl
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
            progressStatus = NSLocalizedString("Starting download...", comment: "Worker")
            let downloader = Downloader()
            await downloader.enqueue(downloadUrl: URL(string: file.filePath)!, to: esdUrl)
            try await downloader.start { bytesWritten, bytesTotal in
                let written = ByteCountFormatter.string(fromByteCount: bytesWritten, countStyle: .file)
                let total = ByteCountFormatter.string(fromByteCount: bytesTotal, countStyle: .file)
                Task { @MainActor in
                    self.progressStatus = String.localizedStringWithFormat(NSLocalizedString("Downloading %@ of %@...", comment: "Worker"), written, total)
                    let progress = (Float(bytesWritten) / Float(bytesTotal))
                    self.progress = progress > 1.0 ? 1.0 : progress
                }
            }
            progressStatus = NSLocalizedString("Converting download to ISO...", comment: "Worker")
            progress = nil
            try await convert(esd: esdUrl, to: isoUrl)
        }
    }
    
    private func convert(esd esdUrl: URL, to isoUrl: URL) async throws {
        let script = Bundle.main.url(forResource: "esd2iso", withExtension: "sh")!
        var build = buildString(from: esdUrl.lastPathComponent)
        if build.count > 32 {
            build = String(build.prefix(32))
        }
        try await exec(at: nil, executableURL: script, esdUrl.path, isoUrl.path, build)
        completedDownloadUrl = isoUrl
    }
    
    private func buildString(from name: String) -> String {
        var count = 0
        for (index, ch) in name.enumerated() {
            if ch == "." {
                count += 1
            }
            if count == 3 {
                let endIndex = name.index(name.startIndex, offsetBy: index-1)
                return String(name[name.startIndex...endIndex])
            }
        }
        return name
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
