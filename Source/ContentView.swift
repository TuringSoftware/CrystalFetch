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

struct ContentView: View {
    @EnvironmentObject private var worker: Worker
    @AppStorage("ShowPreviewBuilds") private var hasPreviewBuilds: Bool = false
    @AppStorage("ShowServerBuilds") private var hasServerBuilds: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    Toggle("Prerelease Builds", isOn: $hasPreviewBuilds)
                        .help("Show unstable releases which previews upcoming features.")
                    Toggle("Server Builds", isOn: $hasServerBuilds)
                        .help("Show builds for running in a server environment.")
                    #if arch(arm64)
                    BuildsListView(arch: "arm64", hasPreviewBuilds: hasPreviewBuilds, hasServerBuilds: hasServerBuilds)
                    BuildsListView(arch: "amd64", hasPreviewBuilds: hasPreviewBuilds, hasServerBuilds: hasServerBuilds)
                    BuildsListView(arch: "x86", hasPreviewBuilds: hasPreviewBuilds, hasServerBuilds: hasServerBuilds)
                    #else
                    BuildsListView(arch: "amd64", hasPreviewBuilds: hasPreviewBuilds, hasServerBuilds: hasServerBuilds)
                    BuildsListView(arch: "x86", hasPreviewBuilds: hasPreviewBuilds, hasServerBuilds: hasServerBuilds)
                    BuildsListView(arch: "arm64", hasPreviewBuilds: hasPreviewBuilds, hasServerBuilds: hasServerBuilds)
                    #endif
                }.disabled(worker.isBusy)
            }.frame(minWidth: 200, idealWidth: 300)
            .listStyle(.sidebar)
            .searchable(text: $worker.search, placement: .toolbar)
            .onSubmit(of: .search) {
                if !worker.isBusy {
                    worker.refresh()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if worker.isBusy {
                    ProgressView()
                }
            }
            ToolbarItem(placement: .navigation) {
                ShowWindowButtonView(id: "ESDConvert") {
                    Label("Simple…", systemImage: "arrowshape.turn.up.backward.fill")
                }.disabled(worker.isBusy)
                .help("Build installation for the latest release through ESD conversion.")
            }
            ToolbarItem(placement: .principal) {
                Button {
                    worker.refresh(findDefault: true)
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }.disabled(worker.isBusy)
            }
        }
        .alert(item: $worker.lastSeenError) { lastSeenError in
            Alert(title: Text(lastSeenError.message))
        }
        .onAppear {
            worker.refresh(findDefault: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
