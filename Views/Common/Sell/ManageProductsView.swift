import SwiftUI

struct ManageProductsView: View {
    @EnvironmentObject var store: ProductStore

    var body: some View {
        List {
            ForEach(store.userListings) { listing in
                HStack {
                    VStack(alignment: .leading) {
                        Text(listing.name)
                            .font(.headline)
                        Text(listing.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: {
                        store.deleteListing(listingID: listing.id)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Manage Products")
        .onAppear {
            store.fetchUserListings()
        }
    }
}

struct ManageProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageProductsView()
            .environmentObject(ProductStore())
    }
}
