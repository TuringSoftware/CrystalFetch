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

actor UUPDumpAPI {
    // Server has a rate limit of 10us so we don't make more than one request per 100us
    private let kTimeoutSec = TimeInterval(0.0001)
    private let kNsInSec = TimeInterval(1000000000)
    private var session = URLSession.shared
    private var lastRequestTime: Date?
    
    private func makeRequest<Response: Decodable>(endpoint: String, arguments: [String: Any] = [:]) async throws -> Response {
        let nextRequestTime = lastRequestTime?.advanced(by: kTimeoutSec).timeIntervalSinceNow
        if let nextRequestTime = nextRequestTime, nextRequestTime > 0 {
            try await Task.sleep(nanoseconds: UInt64(nextRequestTime*kNsInSec))
            try Task.checkCancellation()
        }
        lastRequestTime = Date.now
        let uupDumpEndpointRaw = UserDefaults.standard.string(forKey: "uupDumpJsonApiUrl")!
        guard let uupDumpEndpointBase = URL(string: uupDumpEndpointRaw) else {
            throw UUPDumpAPIError.errorRequest(uupDumpEndpointRaw, "Unable to parse URL")
        }
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
        let data: Data
        do {
            (data, _) = try await session.data(from: components.url!)
        } catch {
            throw UUPDumpAPIError.errorRequest(uupDumpEndpointRaw, error.localizedDescription)
        }
        
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
        NSLog("Invalid response: %@", String(data: data, encoding: .utf8) ?? "")
        throw UUPDumpAPIError.responseNotFound
    }
    
    func fetchBuilds(search: String? = nil) async throws -> UUPBuilds {
        return try await makeRequest(endpoint: "listid.php", arguments: ["search": search ?? "", "sortByDate": "1"])
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
    case errorRequest(String, String)
    case errorResponse(String)
}

extension UUPDumpAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .responseNotFound: return NSLocalizedString("Cannot find data from the server response.", comment: "UUPDumpAPI")
        case .errorRequest(let url, let message): return String.localizedStringWithFormat(NSLocalizedString("Error calling server: %@ (%@)", comment: "UUPDumpAPI"), message, url)
        case .errorResponse(let message): return String.localizedStringWithFormat(NSLocalizedString("Error returned from server: %@", comment: "UUPDumpAPI"), message)

        }
    }
}
