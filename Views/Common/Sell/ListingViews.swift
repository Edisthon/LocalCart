import SwiftUI

struct ListingCard: View {
    let listing: Listing
    let placeholderSystemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let urlString = listing.imageURLs.first, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        default:
                            Rectangle().fill(Color.gray.opacity(0.2))
                                .overlay(Image(systemName: placeholderSystemImage).font(.largeTitle).foregroundColor(.gray))
                        }
                    }
                } else {
                    Rectangle().fill(Color.gray.opacity(0.2))
                        .overlay(Image(systemName: placeholderSystemImage).font(.largeTitle).foregroundColor(.gray))
                }
            }
            .frame(height: 160)
            .clipped()
            .cornerRadius(12)

            Text(listing.name)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(1)
            Text(String(format: "%.0f RWF", listing.price))
                .font(.footnote)
                .foregroundColor(.green)
            Text(listing.location)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

struct ListingDetailView: View {
    let listing: Listing

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ZStack {
                    if let urlString = listing.imageURLs.first, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image): image.resizable().scaledToFill()
                            default: Rectangle().fill(Color.gray.opacity(0.2))
                        }
                        }
                    } else {
                        Rectangle().fill(Color.gray.opacity(0.2))
                    }
                }
                .frame(height: 220)
                .clipped()
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 6) {
                    Text(listing.name)
                        .font(.title2)
                        .bold()
                    Text(String(format: "%.0f RWF", listing.price))
                        .font(.headline)
                        .foregroundColor(.green)
                    Text(listing.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if !listing.description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About this item").font(.headline)
                        Text(listing.description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
    }
}

