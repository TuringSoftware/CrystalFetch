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

@main
struct Main: App {
    @StateObject private var worker = Worker()
    @AppStorage("ShowAdvancedOptions") private var showAdvancedOptions: Bool = false

    var body: some Scene {
        WindowGroup(id: "ESDConvert") {
            SimpleContentView().environmentObject(worker)
                .frame(minWidth: 500, idealWidth: 500, minHeight: 300, idealHeight: 300)
        }.handlesExternalEvents(matching: Set(["ESDConvert"]))
        
        WindowGroup(id: "UUPDump") {
            ContentView().environmentObject(worker)
                .frame(minWidth: 800, minHeight: 400)
        }.commands {
            SidebarCommands()
            CommandGroup(after: .sidebar) {
                Toggle("Show Advanced Options", isOn: $showAdvancedOptions)
            }
        }.handlesExternalEvents(matching: Set(["UUPDump"]))
    }
}
