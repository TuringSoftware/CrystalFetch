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

struct BuildsListView: View {
    let arch: String
    let hasPreviewBuilds: Bool
    let hasServerBuilds: Bool
    
    @EnvironmentObject private var worker: Worker
    
    var body: some View {
        Section(arch.prettyArch) {
            ForEach(worker.builds.filter({ $0.arch == arch && (hasPreviewBuilds || !$0.title.contains("Insider")) && (hasServerBuilds || !$0.title.contains("Server")) })) { build in
                NavigationLink(destination: BuildConfigView(build: build),
                               tag: build,
                               selection: $worker.selectedBuild) {
                    Text(build.title)
                        .lineLimit(2)
                }
            }
        }
    }
}

struct BuildsListView_Previews: PreviewProvider {
    static var previews: some View {
        BuildsListView(arch: "arm64", hasPreviewBuilds: true, hasServerBuilds: true)
    }
}
