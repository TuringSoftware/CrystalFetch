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

import SwiftUI

let defaultUUPDumpJsonApiUrl = "https://uupdump.net/json-api/"

struct GeneralSettingsView: View {
    @AppStorage("uupDumpJsonApiUrl") private var uupDumpJsonApiUrl = defaultUUPDumpJsonApiUrl

    var body: some View {
        Form {
            TextField("UUP Dump JSON API URL", text: Binding(
                get: { uupDumpJsonApiUrl },
                set: { uupDumpJsonApiUrl = $0.isBlank ? defaultUUPDumpJsonApiUrl : $0 })
            ).autocorrectionDisabled()
        }
        .padding(20)
        .frame(width: 500, height: 100)
    }
}

extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}
