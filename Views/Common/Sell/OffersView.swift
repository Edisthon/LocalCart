import SwiftUI

struct OffersView: View {
    var body: some View {
        List {
            Text("No offers yet")
        }
        .navigationTitle("Offers")
    }
}

struct OffersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { OffersView() }
    }
}


