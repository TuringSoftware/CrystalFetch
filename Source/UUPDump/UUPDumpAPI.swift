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

// Do not make more than 1 requests a second to avoid triggering rate limit
private let TIMEOUT = TimeInterval(1)
private let NS_IN_SECOND = TimeInterval(1000000000)

actor UUPDumpAPI {
    private let uupDumpEndpointBase = URL(string: "https://uupdump.net/json-api/")!
    private var session = URLSession.shared
    private var lastRequestTime: Date?
    
    private func makeRequest<Response: Decodable>(endpoint: String, arguments: [String: Any] = [:]) async throws -> Response {
        let nextRequestTime = lastRequestTime?.advanced(by: TIMEOUT).timeIntervalSinceNow
        if let nextRequestTime = nextRequestTime, nextRequestTime > 0 {
            try await Task.sleep(nanoseconds: UInt64(nextRequestTime*NS_IN_SECOND))
            try Task.checkCancellation()
        }
        lastRequestTime = Date.now
        var components = URLComponents()
        components.scheme = uupDumpEndpointBase.scheme
        components.host = uupDumpEndpointBase.host
        components.path = "\(uupDumpEndpointBase.path)/\(endpoint)"
        components.queryItems = arguments.flatMap { key, value in
            if let value = value as? String {
                return [URLQueryItem(name: key, value: value)]
            } else if let value = value as? [String] {
                return value.map({ URLQueryItem(name: "\(key)[]", value: $0) })
            } else {
                return []
            }
        }
        let (data, _) = try await session.data(from: components.url!)
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let response = json["response"] as? [String: Any] {
                if let error = response["error"] as? String {
                    throw UUPDumpAPIError.errorResponse(error)
                } else {
                    let wrapped = try JSONSerialization.data(withJSONObject: response)
                    return try JSONDecoder().decode(Response.self, from: wrapped)
                }
            }
        }
        throw UUPDumpAPIError.responseNotFound
    }
    
    func fetchBuilds(search: String? = nil) async throws -> UUPBuilds {
        return try await makeRequest(endpoint: "listid.php", arguments: ["search": search ?? ""])
    }
    
    func fetchDetails(for uuid: String) async throws -> UUPDetails {
        return try await makeRequest(endpoint: "listlangs.php", arguments: ["id": uuid])
    }
    
    func fetchEditions(for uuid: String, language: String = "neutral") async throws -> UUPEditions {
        return try await makeRequest(endpoint: "listeditions.php", arguments: ["id": uuid, "lang": language])
    }
    
    func fetchPackage(for uuid: String, language: String = "neutral", editions: [String] = []) async throws -> UUPPackage {
        return try await makeRequest(endpoint: "get.php", arguments: ["id": uuid, "lang": language, "edition": editions])
    }
}

enum UUPDumpAPIError: Error {
    case responseNotFound
    case errorResponse(String)
}

extension UUPDumpAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .responseNotFound: return NSLocalizedString("Cannot find data from the server response.", comment: "UUPDumpAPI")
        case .errorResponse(let message): return String.localizedStringWithFormat(NSLocalizedString("Error returned from server: %@", comment: "UUPDumpAPI"), message)
        }
    }
}
