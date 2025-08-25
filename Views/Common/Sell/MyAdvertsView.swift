import SwiftUI

struct MyAdvertsView: View {
    @StateObject private var store = ProductStore()

    var body: some View {
        List(store.userListings) { listing in
            HStack(spacing: 12) {
                if let urlString = listing.imageURLs.first, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFill()
                        default: Color.gray.opacity(0.2)
                        }
                    }
                    .frame(width: 64, height: 64)
                    .clipped()
                    .cornerRadius(8)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(listing.name).bold()
                    Text(listing.category).font(.caption).foregroundColor(.gray)
                    Text("\(listing.price, specifier: "%.2f") RWF").font(.caption)
                }
                Spacer()
                if listing.sold { Image(systemName: "checkmark.seal.fill").foregroundColor(.green) }
            }
        }
        .onAppear { store.fetchUserListings() }
        .navigationTitle("My Adverts")
        .toolbar {
            Text("Earnings: \(store.earnings, specifier: "%.2f") RWF")
        }
    }
}

struct MyAdvertsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { MyAdvertsView() }
    }
}


