import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SellerDashboardView: View {
    @AppStorage("username") var username: String = "User"
    @StateObject private var store = ProductStore()
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                quickActions

                section(title: "Weekly stats") {
                    HStack(spacing: 12) {
                        statCard(title: "Items sold", value: "\(store.userListings.filter{ $0.sold }.count)")
                        statCard(title: "Revenue", value: String(format: "%.2f RWF", store.earnings))
                    }
                }

                section(title: "Selling") {
                    if store.userListings.isEmpty {
                        placeholderRow()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(store.userListings) { listing in
                                HStack {
                                    if let urlString = listing.imageURLs.first, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .success(let image): image.resizable().scaledToFill()
                                            default: Color.gray.opacity(0.2)
                                            }
                                        }
                                        .frame(width: 56, height: 56)
                                        .clipped()
                                        .cornerRadius(8)
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(listing.name).bold()
                                        Text(String(format: "%.2f RWF", listing.price)).font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(radius: 1)
                            }
                        }
                    }
                }

                section(title: "Drafts") {
                    NavigationLink(destination: DraftsView()) {
                        rowLabel(title: "View drafts")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Seller")
        .onAppear { store.fetchUserListings() }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hey, \(username)")
                .font(.largeTitle)
                .bold()
            Text("Manage your listings and sales")
                .foregroundColor(.gray)
        }
    }

    private var quickActions: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                NavigationLink(destination: SellView()) { actionCard(icon: "square.and.pencil", title: "List an item") }
                NavigationLink(destination: MyAdvertsView()) { actionCard(icon: "doc.on.doc", title: "My adverts") }
            }
            HStack(spacing: 12) {
                NavigationLink(destination: SoldView()) { actionCard(icon: "checkmark.seal.fill", title: "Sold") }
                NavigationLink(destination: OffersView()) { actionCard(icon: "tag.fill", title: "Offers") }
            }
            HStack(spacing: 12) {
                NavigationLink(destination: StatsView()) { actionCard(icon: "chart.bar.fill", title: "Stats") }
                NavigationLink(destination: PaymentsView()) { actionCard(icon: "creditcard.fill", title: "Payments") }
            }
            NavigationLink(destination: ShopSettingsView()) { actionCard(icon: "gearshape.fill", title: "Shop settings") }
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            content()
        }
    }

    private func actionCard(icon: String, title: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
            Text(title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.12))
        .cornerRadius(14)
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value).bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }

    private func rowLabel(title: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }

    private func placeholderRow() -> some View {
        rowLabel(title: "You have no listings yet")
    }
}

struct SellerDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { SellerDashboardView() }
    }
}


