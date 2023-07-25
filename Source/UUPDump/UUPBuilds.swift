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

struct UUPBuilds: Codable {
    let apiVersion: String
    let builds: [Build]

    enum CodingKeys: String, CodingKey {
        case apiVersion = "apiVersion"
        case builds = "builds"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        apiVersion = try values.decode(String.self, forKey: .apiVersion)
        if let buildsDictionary = try? values.decode([String: Build].self, forKey: .builds) {
            builds = buildsDictionary.map { $0.1 }
        } else {
            builds = try values.decode([Build].self, forKey: .builds)
        }
    }
}

extension UUPBuilds {
    struct Build: Codable, Hashable, Identifiable {
        let title: String
        let build: String
        let arch: String
        let created: Int?
        let uuid: String
        
        var id: String {
            uuid
        }
        
        enum CodingKeys: String, CodingKey {
            case title = "title"
            case build = "build"
            case arch = "arch"
            case created = "created"
            case uuid = "uuid"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            title = try values.decode(String.self, forKey: .title)
            build = try values.decode(String.self, forKey: .build)
            arch = try values.decode(String.self, forKey: .arch)
            created = try values.decodeIfPresent(Int.self, forKey: .created)
            uuid = try values.decode(String.self, forKey: .uuid)
        }
    }
}
