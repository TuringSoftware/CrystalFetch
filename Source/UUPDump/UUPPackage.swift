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

struct UUPPackage: Codable {
    let apiVersion: String
    let updateName: String
    let arch: String
    let build: String
    let sku: Int
    let hasUpdates: Bool
    let files: [String: File]

    enum CodingKeys: String, CodingKey {
        case apiVersion = "apiVersion"
        case updateName = "updateName"
        case arch = "arch"
        case build = "build"
        case sku = "sku"
        case hasUpdates = "hasUpdates"
        case files = "files"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        apiVersion = try values.decode(String.self, forKey: .apiVersion)
        updateName = try values.decode(String.self, forKey: .updateName)
        arch = try values.decode(String.self, forKey: .arch)
        build = try values.decode(String.self, forKey: .build)
        sku = try values.decode(Int.self, forKey: .sku)
        hasUpdates = try values.decode(Bool.self, forKey: .hasUpdates)
        files = try values.decode([String: File].self, forKey: .files)
    }
}

extension UUPPackage {
    struct File: Codable {
        let sha1: String?
        let sha256: String?
        let size: Int64
        let url: String
        let uuid: String
        let expire: Int
        let debug: String?

        enum CodingKeys: String, CodingKey {
            case sha1 = "sha1"
            case sha256 = "sha256"
            case size = "size"
            case url = "url"
            case uuid = "uuid"
            case expire = "expire"
            case debug = "debug"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            sha1 = try values.decodeIfPresent(String.self, forKey: .sha1)
            sha256 = try values.decodeIfPresent(String.self, forKey: .sha256)
            if let sizeInt = try? values.decodeIfPresent(Int64.self, forKey: .size) {
                size = sizeInt
            } else if let sizeStr = try values.decodeIfPresent(String.self, forKey: .size) {
                size = Int64(sizeStr) ?? 0
            } else {
                size = 0
            }
            url = try values.decode(String.self, forKey: .url)
            uuid = try values.decode(String.self, forKey: .uuid)
            expire = try values.decode(Int.self, forKey: .expire)
            debug = try values.decodeIfPresent(String.self, forKey: .debug)
        }
    }
}
