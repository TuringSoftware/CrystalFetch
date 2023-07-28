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

struct UUPDetails: Codable {
    let apiVersion: String
    let langList: [String]
    let langFancyNames: [String: String]
    let updateInfo: UpdateInfo
    
    enum CodingKeys: String, CodingKey {
        case apiVersion = "apiVersion"
        case langList = "langList"
        case langFancyNames = "langFancyNames"
        case updateInfo = "updateInfo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        apiVersion = try values.decode(String.self, forKey: .apiVersion)
        langList = try values.decode([String].self, forKey: .langList)
        if langList.isEmpty {
            langFancyNames = [:]
        } else {
            langFancyNames = try values.decode([String: String].self, forKey: .langFancyNames)
        }
        updateInfo = try values.decode(UpdateInfo.self, forKey: .updateInfo)
    }
}

extension UUPDetails {
    struct UpdateInfo : Codable {
        let title: String
        let ring: String
        let flight: String
        let arch: String
        let build: String
        let checkBuild: String
        let sku: Int
        let created: Int
        let sha256ready: Bool

        enum CodingKeys: String, CodingKey {
            case title = "title"
            case ring = "ring"
            case flight = "flight"
            case arch = "arch"
            case build = "build"
            case checkBuild = "checkBuild"
            case sku = "sku"
            case created = "created"
            case sha256ready = "sha256ready"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            title = try values.decode(String.self, forKey: .title)
            ring = try values.decode(String.self, forKey: .ring)
            flight = try values.decode(String.self, forKey: .flight)
            arch = try values.decode(String.self, forKey: .arch)
            build = try values.decode(String.self, forKey: .build)
            checkBuild = try values.decode(String.self, forKey: .checkBuild)
            sku = try values.decodeIfPresent(Int.self, forKey: .sku) ?? 0
            created = try values.decodeIfPresent(Int.self, forKey: .created) ?? 0
            sha256ready = try values.decodeIfPresent(Bool.self, forKey: .sha256ready) ?? false
        }
    }
}
