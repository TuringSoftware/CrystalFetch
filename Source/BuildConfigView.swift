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

struct BuildConfigView: View {
    let build: UUPBuilds.Build
    
    @EnvironmentObject private var worker: Worker
    @AppStorage("LastSelectedLocale") private var lastSelectedLocale: String?
    @State private var selectedLocale: String = ""
    @State private var selectedEditions = Set<String>()
    @State private var isTermsAgreed: Bool = false
    @State private var isConfirmCancelShown: Bool = false
    @State private var details = BuildDetails.empty
    @State private var edition = BuildEditions.empty
    @State private var isDownloadCompleted: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                Form {
                    Section {
                        HStack {
                            Label("Channel", systemImage: "shippingbox")
                            Spacer()
                            Text(details.ring.prettyRing)
                        }
                        HStack {
                            Label("Build", systemImage: "number")
                            Spacer()
                            Text(details.build)
                        }
                        HStack {
                            Label("Created", systemImage: "calendar")
                            Spacer()
                            Text(DateFormatter.localizedString(from: details.created, dateStyle: .long, timeStyle: .short))
                        }
                    }.padding(.bottom, 5)
                    Section("Language") {
                        Picker("", selection: $selectedLocale) {
                            ForEach(details.sortedLanguages) { language in
                                Text(language.display).tag(language.code)
                            }
                        }.onChange(of: selectedLocale) { newValue in
                            worker.refreshDetails(uuid: build.uuid, language: newValue) {
                                details = $0
                                edition = $1
                                selectedEditions.removeAll()
                                selectedEditions.formUnion(edition.editions.map({ $0.code }))
                                lastSelectedLocale = newValue
                            }
                        }
                    }
                    Section("Editions") {
                        ForEach(edition.editions) { edition in
                            Toggle(edition.display, isOn: Binding<Bool>(get: {
                                selectedEditions.contains(edition.code)
                            }, set: { newValue in
                                if newValue {
                                    selectedEditions.insert(edition.code)
                                } else {
                                    selectedEditions.remove(edition.code)
                                }
                            }))
                        }
                    }
                }.disabled(worker.isBusy)
            }
            Spacer()
            HStack {
                // SwiftUI BUG: ProgressView cannot go to indeterminate mode and back
                if let progress = worker.progress {
                    ProgressView(value: progress) {
                        
                    } currentValueLabel: {
                        Text(worker.progressStatus ?? "")
                    }
                } else {
                    ProgressView(value: nil as Float?) {
                        
                    } currentValueLabel: {
                        Text(worker.progressStatus ?? "")
                    }
                }
            }
            HStack {
                Toggle("I agree that I have a valid license to use this product.", isOn: $isTermsAgreed)
                    .disabled(worker.isBusy)
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
                        worker.download(uuid: build.uuid, language: selectedLocale, editions: Array(selectedEditions))
                    } label: {
                        Text("Download…")
                    }.disabled(!isTermsAgreed)
                }
            }
            
        }.padding()
        .navigationTitle(build.title)
        .navigationSubtitle(build.arch.prettyArch)
        .onAppear {
            worker.refreshDetails(uuid: build.uuid) {
                details = $0
                edition = $1
                selectedEditions.removeAll()
                selectedEditions.formUnion(edition.editions.map({ $0.code }))
                if let lastSelectedLocale = lastSelectedLocale {
                    selectedLocale = lastSelectedLocale
                } else {
                    selectedLocale = Worker.defaultLocale ?? "netural"
                }
            }
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
}
