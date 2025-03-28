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
    @AppStorage("ShowAdvancedOptions") private var showAdvancedOptions: Bool = false
    @State private var isConfirmCancelShown: Bool = false
    @State private var isDownloadCompleted: Bool = false
    
    @State private var windowsVersion: MCTCatalogs.Windows = .windows11
    @State private var selectedBuild: MCTCatalogs.Release?
    @State private var selected: SelectedTuple = .default
    @State private var selectedFile: ESDCatalog.File?
    @State private var selectedEula: SelectedEULA?
    
    @State private var languages: [DisplayString] = []
    @State private var editions: [DisplayString] = []

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()

    var body: some View {
        VStack {
            Form {
                Picker("Version", selection: $windowsVersion) {
                    Text("Windows® 11").tag(MCTCatalogs.Windows.windows11)
                    Text("Windows® 10").tag(MCTCatalogs.Windows.windows10)
                }.pickerStyle(.radioGroup)
                buildsPicker
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
                if windowsVersion == .windows10 && selected.architecture == "ARM64" {
                    Text("Note: This build does not work for virtualization on Apple Silicon.")
                }
            }.disabled(worker.isBusy)
            .onChange(of: windowsVersion) { newValue in
                if selectedBuild == nil {
                    worker.refreshEsdCatalog(windowsVersion: newValue)
                } else {
                    selectedBuild = nil
                }
            }
            .onChange(of: selectedBuild) { newValue in
                worker.refreshEsdCatalog(windowsVersion: windowsVersion, release: newValue)
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
                if showAdvancedOptions {
                    ShowWindowButtonView(id: "UUPDump") {
                        Text("All builds…")
                    }.disabled(worker.isBusy)
                        .help("Build custom installation for any build through UUP Dump.")
                }
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
                        if let eula = selectedFile?.eula {
                            selectedEula = SelectedEULA(url: URL(string: eula)!)
                        } else if let selectedFile = selectedFile {
                            worker.download(selectedFile)
                        }
                    } label: {
                        Text("Download…")
                    }.disabled(selectedFile == nil)
                }
            }
        }
        .sheet(item: $selectedEula) { eula in
            EULAView(url: eula.url) {
                if let selectedFile = selectedFile {
                    worker.download(selectedFile)
                }
            }
        }
        .alert(item: $worker.lastSeenError) { lastSeenError in
            Alert(title: Text(lastSeenError.message))
        }
        .padding()
        .onAppear {
            worker.refreshCatalogUrls()
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
    var buildsPicker: some View {
        if let builds = worker.mctCatalogs[windowsVersion]?.releases {
            Picker("Build", selection: $selectedBuild) {
                Text("Latest").tag(nil as MCTCatalogs.Release?)
                ForEach(builds) { build in
                    if let date = build.date {
                        Text("\(build.build) (\(dateFormatter.string(from: date)))").tag(build)
                    } else {
                        Text(build.build).tag(build)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var progressLabel: some View {
        if let selectedFile = selectedFile {
            Text(selectedFile.name).font(.caption)
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
        selectedFile = languageFiltered.first(where: { $0.edition == selected.edition })
    }
}

private struct DisplayString: Identifiable, Hashable, Equatable {
    var id: String
    var display: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(display)
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

struct SimpleContentView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleContentView()
    }
}
