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

struct BuildEditions {
    struct Edition: Identifiable {
        let code: String
        let display: String
        var id: String {
            code
        }
    }
    
    private static let unknownEdition = NSLocalizedString("Unknown Edition", comment: "BuildEditions")
    let editions: [Edition]
    
    static var empty = BuildEditions()
    
    private init() {
        editions = []
    }
    
    init(from uupEditions: UUPEditions) {
        editions = uupEditions.editionList.map({ Edition(code: $0, display: uupEditions.editionFancyNames[$0] ?? Self.unknownEdition) })
    }
}
