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

struct UUPEditions: Codable {
    let apiVersion: String
    let editionList: [String]
    let editionFancyNames: [String: String]

    enum CodingKeys: String, CodingKey {
        case apiVersion = "apiVersion"
        case editionList = "editionList"
        case editionFancyNames = "editionFancyNames"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        apiVersion = try values.decode(String.self, forKey: .apiVersion)
        editionList = try values.decode([String].self, forKey: .editionList)
        editionFancyNames = try values.decode([String: String].self, forKey: .editionFancyNames)
    }
}
