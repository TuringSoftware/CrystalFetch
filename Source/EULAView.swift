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

struct EULAView: View {
    let url: URL
    let onAccept: () -> Void
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var loadedEula: NSAttributedString?
    
    var body: some View {
        ScrollView {
            if let loadedEula = loadedEula {
                Text(AttributedString(loadedEula)).padding()
            } else {
                HStack(alignment: .center) {
                    ProgressView().progressViewStyle(.circular).padding()
                }
            }
        }
        .task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                loadedEula = NSAttributedString(rtf: data, documentAttributes: nil) ?? NSAttributedString(string: NSLocalizedString("Failed to load EULA.", comment: "EULAView"))
            } catch {
                loadedEula = NSAttributedString(string: error.localizedDescription)
            }
        }
        .frame(minWidth: 400, minHeight: 200)
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItemGroup(placement: .confirmationAction) {
                Button {
                    onAccept()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Accept")
                }.disabled(loadedEula == nil)
            }
        }
    }
}

#Preview {
    EULAView(url: URL(string: "https://www.google.com/")!) {
        
    }
}
