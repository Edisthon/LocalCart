import SwiftUI

struct SoldView: View {
    var body: some View {
        List {
            Text("No sold items yet")
        }
        .navigationTitle("Sold")
    }
}

struct SoldView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { SoldView() }
    }
}


