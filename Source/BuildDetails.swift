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

struct BuildDetails {
    struct Language: Identifiable {
        let code: String
        let display: String
        var id: String {
            code
        }
    }
    
    private static let unknownLanguage = NSLocalizedString("Unknown Language", comment: "BuildDetails")
    let languages: [Language]
    let title: String
    let ring: String
    let arch: String
    let build: String
    let created: Date

    var sortedLanguages: [Language] {
      return languages.sorted(using: KeyPathComparator(\.display))
    }
    
    static var empty = BuildDetails()
    
    private init() {
        languages = []
        title = ""
        ring = ""
        arch = ""
        build = ""
        created = .distantPast
    }
    
    init(from uupDetails: UUPDetails) {
        languages = uupDetails.langList.map({ Language(code: $0, display: uupDetails.langFancyNames[$0] ?? Self.unknownLanguage) })
        title = uupDetails.updateInfo.title
        ring = uupDetails.updateInfo.ring
        arch = uupDetails.updateInfo.arch
        build = uupDetails.updateInfo.build
        created = Date(timeIntervalSince1970: TimeInterval(uupDetails.updateInfo.created))
    }
}
