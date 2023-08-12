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

struct ShowWindowButtonView<Label: View>: View {
    let id: String
    let label: () -> Label
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if #available(macOS 13, *) {
            ShowWindowButtonViewNew(id: id, label: label)
        } else {
            Button(action: {
                open(id: id)
                dismiss()
            }, label: label)
        }
    }
    
    private func open(id: String) {
        let url = URL(string: "crystalfetch://\(id)")!
        NSWorkspace.shared.open(url)
    }
}

@available(macOS 13, *)
private struct ShowWindowButtonViewNew<Label: View>: View {
    let id: String
    let label: () -> Label
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            openWindow(id: id)
            dismiss()
        }, label: label)
    }
}

struct ShowWindowButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ShowWindowButtonView(id: "UUPDump") {
            Text("All builds…")
        }
    }
}
