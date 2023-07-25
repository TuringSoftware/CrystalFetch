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

typealias DownloadItem = (task: URLSessionDownloadTask, destinationUrl: URL, retry: Int)
typealias ProgressCallback = (_ bytesWritten: Int64, _ bytesTotal: Int64) -> Void

actor Downloader {
    private class Delegate: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
        let downloader: Downloader
        
        init(for downloader: Downloader) {
            self.downloader = downloader
        }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
            do {
                try FileManager.default.moveItem(at: location, to: tempUrl)
                Task {
                    await downloader.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: tempUrl)
                }
            } catch {
                Task {
                    await downloader.urlSession(session, task: downloadTask, didCompleteWithError: error)
                }
            }
        }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            Task {
                await downloader.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
            }
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            Task {
                await downloader.urlSession(session, task: task, didCompleteWithError: error)
            }
        }
    }
    
    private let kMaxConcurrentDownloads = 5
    private let kMaxRetries = 5
    
    private var downloads: [URLSessionDownloadTask: CheckedContinuation<URL, Error>] = [:]
    private var queue: [DownloadItem] = []
    private var totalExpectedSize: Int64 = 0
    private var totalDownloadedSize: Int64 = 0
    private var progressCallback: ProgressCallback?
    
    private lazy var coordinator: Delegate = {
        Delegate(for: self)
    }()
    
    private lazy var session: URLSession = {
        URLSession(configuration: .default, delegate: coordinator, delegateQueue: nil)
    }()
    
    private func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let continuation = downloads.removeValue(forKey: downloadTask) {
            continuation.resume(returning: location)
        } else {
            try? FileManager.default.removeItem(at: location)
        }
    }
    
    private func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        totalDownloadedSize += bytesWritten
        progressCallback?(totalDownloadedSize, totalExpectedSize)
    }
    
    private func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let continuation = downloads.removeValue(forKey: task as! URLSessionDownloadTask) {
            continuation.resume(throwing: error!)
        }
    }
    
    private func register(_ task: URLSessionDownloadTask, continuation: CheckedContinuation<URL, Error>) {
        downloads[task] = continuation
    }
    
    /// Add an item to the download queue
    /// - Parameters:
    ///   - downloadUrl: What to download
    ///   - destinationUrl: Where to put it
    ///   - size: Estimated size for progress updates
    func enqueue(downloadUrl: URL, to destinationUrl: URL, size: Int64) {
        let task = session.downloadTask(with: downloadUrl)
        queue.append((task: task, destinationUrl: destinationUrl, retry: kMaxRetries))
        totalExpectedSize += size
    }
    
    /// Start downloading a single item from the queue and retry if the download is interrupted
    private func dequeue() async throws {
        let (task, destinationUrl, retry) = queue.removeFirst()
        do {
            let resultUrl = try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    register(task, continuation: continuation)
                    task.resume()
                }
            } onCancel: {
                task.cancel()
            }
            try FileManager.default.moveItem(at: resultUrl, to: destinationUrl)
        } catch {
            let error = error as NSError
            if retry > 0 {
                let newTask: URLSessionDownloadTask
                if let resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                    newTask = session.downloadTask(withResumeData: resumeData)
                } else {
                    newTask = session.downloadTask(with: task.originalRequest!)
                    totalDownloadedSize -= task.countOfBytesReceived
                }
                queue.insert((task: newTask, destinationUrl: destinationUrl, retry: retry - 1), at: 0)
                return
            }
            if error.code == NSURLErrorCancelled {
                throw CancellationError()
            } else {
                throw error
            }
        }
    }
    
    /// Starts downloading all enqueued items
    /// - Parameter onProgressUpdated: Optional callback for download progress
    func start(_ onProgressUpdated: ProgressCallback? = nil) async throws {
        progressCallback = onProgressUpdated
        defer {
            progressCallback = nil
        }
        try await withThrowingTaskGroup(of: Void.self) { group in
            for _ in 0..<kMaxConcurrentDownloads {
                group.addTask {
                    try await self.dequeue()
                }
            }
            for try await _ in group {
                if !queue.isEmpty {
                    try Task.checkCancellation()
                    group.addTask {
                        try await self.dequeue()
                    }
                }
            }
        }
    }
}
