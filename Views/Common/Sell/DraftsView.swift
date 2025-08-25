import SwiftUI

struct DraftsView: View {
    var body: some View {
        List {
            Text("No drafts yet")
        }
        .navigationTitle("Drafts")
    }
}

struct DraftsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { DraftsView() }
    }
}


