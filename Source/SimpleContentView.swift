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

struct SimpleContentView: View {
    @EnvironmentObject private var worker: Worker
    @State private var isConfirmCancelShown: Bool = false
    @State private var isDownloadCompleted: Bool = false
    
    @State private var isWindows10: Bool = false
    @State private var selected: SelectedTuple = .default
    @State private var selectedBuild: ESDCatalog.File?
    @State private var selectedEula: SelectedEULA?
    
    @State private var languages: [DisplayString] = []
    @State private var editions: [DisplayString] = []
    
    var body: some View {
        VStack {
            Form {
                Picker("Version", selection: $isWindows10) {
                    Text("Windows® 11").tag(false)
                    Text("Windows® 10").tag(true)
                }.pickerStyle(.radioGroup)
                Picker("Architecture", selection: $selected.architecture) {
                    if hasArchitecture("ARM64") {
                        Text("Apple Silicon").tag("ARM64")
                    }
                    if hasArchitecture("x64") {
                        Text("Intel x64").tag("x64")
                    }
                    if hasArchitecture("x86") {
                        Text("Intel x86").tag("x86")
                    }
                }.pickerStyle(.radioGroup)
                Picker("Language", selection: $selected.language) {
                    ForEach(languages) { language in
                        Text(language.display).tag(language.id)
                    }
                }
                Picker("Edition", selection: $selected.edition) {
                    ForEach(editions) { edition in
                        Text(edition.display).tag(edition.id)
                    }
                }
            }.disabled(worker.isBusy)
            .onChange(of: isWindows10) { newValue in
                worker.refreshEsdCatalog(windows10: newValue)
            }
            .onChange(of: worker.esdCatalog) { _ in
                refreshList()
            }
            .onChange(of: selected) { _ in
                refreshList()
            }
            Spacer()
            HStack {
                // SwiftUI BUG: ProgressView cannot go to indeterminate mode and back
                if let progress = worker.progress {
                    ProgressView(value: progress) {
                        progressLabel
                    } currentValueLabel: {
                        Text(worker.progressStatus ?? "")
                    }
                } else {
                    ProgressView(value: nil as Float?) {
                        progressLabel
                    } currentValueLabel: {
                        Text(worker.progressStatus ?? "")
                    }
                }
            }
            HStack {
                ShowWindowButtonView(id: "UUPDump") {
                    Text("All builds…")
                }.disabled(worker.isBusy)
                .help("Build custom installation for any build through UUP Dump.")
                Spacer()
                if worker.isBusy {
                    Button(role: .cancel) {
                        isConfirmCancelShown.toggle()
                    } label: {
                        Text("Cancel")
                    }.keyboardShortcut(.cancelAction)
                    .confirmationDialog("Are you sure you want to stop the process?", isPresented: $isConfirmCancelShown) {
                        Button("Stop", role: .destructive) {
                            worker.stop()
                        }
                        Button("Cancel", role: .cancel) {
                            isConfirmCancelShown = false
                        }
                    }
                } else {
                    Button {
                        if let eula = selectedBuild?.eula {
                            selectedEula = SelectedEULA(url: URL(string: eula)!)
                        } else if let selectedBuild = selectedBuild {
                            worker.download(selectedBuild)
                        }
                    } label: {
                        Text("Download…")
                    }.disabled(selectedBuild == nil)
                }
            }
        }
        .sheet(item: $selectedEula) { eula in
            EULAView(url: eula.url) {
                if let selectedBuild = selectedBuild {
                    worker.download(selectedBuild)
                }
            }
        }
        .alert(item: $worker.lastSeenError) { lastSeenError in
            Alert(title: Text(lastSeenError.message))
        }
        .padding()
        .onAppear {
            worker.refreshEsdCatalog()
            refreshList()
        }
        .onChange(of: worker.completedDownloadUrl) { newValue in
            if newValue != nil {
                isDownloadCompleted = true
            }
        }
        .fileMover(isPresented: $isDownloadCompleted, file: worker.completedDownloadUrl) { result in
            switch result {
            case .success(let success):
                worker.finalize(isoUrl: worker.completedDownloadUrl!, destinationUrl: success)
            case .failure(let failure):
                worker.lastSeenError = Worker.ErrorMessage(message: failure.localizedDescription)
            }
        }
    }
    
    @ViewBuilder
    private var progressLabel: some View {
        if let selectedBuild = selectedBuild {
            Text(selectedBuild.name).font(.caption)
        } else if !worker.isBusy {
            Text("No build found.").font(.caption)
        }
    }
    
    private func hasArchitecture(_ name: String) -> Bool {
        worker.esdCatalog.contains(where: { $0.architecture == name })
    }
    
    private func refreshList() {
        let archFiltered = worker.esdCatalog.filter({ $0.architecture == selected.architecture })
        let languagesList = archFiltered.map({ DisplayString(id: $0.languageCode, display: $0.languagePretty )})
        languages = Set(languagesList).sorted(using: KeyPathComparator(\.display))
        let languageFiltered = archFiltered.filter({ $0.languageCode == selected.language })
        let editionsList = languageFiltered.map({ DisplayString(id: $0.edition, display: $0.editionPretty )})
        editions = Set(editionsList).sorted(using: KeyPathComparator(\.display))
        selectedBuild = languageFiltered.first(where: { $0.edition == selected.edition })
    }
}

private struct DisplayString: Identifiable, Hashable, Equatable {
    var id: String
    var display: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: DisplayString, rhs: DisplayString) -> Bool {
        lhs.display == rhs.display
    }
}

private struct SelectedTuple: Equatable {
    var architecture: String = ""
    var language: String = ""
    var edition: String = ""
    
    static var `default`: SelectedTuple = {
        var tuple = SelectedTuple()
        #if arch(arm64)
        tuple.architecture = "ARM64"
        #elseif arch(x86_64)
        tuple.architecture = "x64"
        #else
        tuple.architecture = "x86"
        #endif
        tuple.language = Worker.defaultLocale ?? "en-us"
        tuple.edition = "Professional"
        return tuple
    }()
}

private struct SelectedEULA: Identifiable {
    let url: URL
    
    var id: URL {
        url
    }
}

#Preview {
    SimpleContentView()
}
