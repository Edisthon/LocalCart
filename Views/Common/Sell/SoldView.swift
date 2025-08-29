import SwiftUI

struct SoldView: View {
    @EnvironmentObject var store: ProductStore

    var body: some View {
        List {
            ForEach(store.userListings.filter { $0.sold }) { listing in
                HStack {
                    VStack(alignment: .leading) {
                        Text(listing.name)
                            .font(.headline)
                        Text(listing.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if listing.approved {
                        Text("Approved")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Button("Approve") {
                            store.approveSale(listingID: listing.id)
                        }
                        .font(.caption)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .navigationTitle("Sold")
        .onAppear {
            store.fetchUserListings()
        }
    }
}

struct SoldView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { SoldView() }
    }
}


