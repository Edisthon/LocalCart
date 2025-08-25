import SwiftUI
#if os(iOS)
import UIKit
#endif

struct ProductCard<Trailing: View>: View {
    let product: Product
    private let trailing: () -> Trailing
    
    init(product: Product, @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }) {
        self.product = product
        self.trailing = trailing
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .bottomLeading) {
                productImage
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.35)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            
            Text(product.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
                .frame(height: 40, alignment: .top) // reserve space for up to 2 lines
            
            StarRatingView(rating: 4.5)
                .frame(height: 16)
            
            Spacer(minLength: 0)

            HStack {
                Text("\(product.price, specifier: "%.2f") RWF")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        Capsule().fill(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing))
                    )
                Spacer()
                trailing()
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 6)
        )
        .frame(height: 240) // fixed card height for alignment
    }
    
    private var gradientColors: [Color] {
        switch product.category {
        case "Food": return [Color.orange.opacity(0.9), Color.red.opacity(0.8)]
        case "Drinks": return [Color.blue.opacity(0.9), Color.cyan.opacity(0.8)]
        case "Beauty & Accessories": return [Color.pink.opacity(0.9), Color.purple.opacity(0.8)]
        case "Interior Designs": return [Color.green.opacity(0.9), Color.teal.opacity(0.8)]
        default: return [Color.gray.opacity(0.8), Color.black.opacity(0.7)]
        }
    }
    
    private var fallbackSymbolName: String {
        switch product.category {
        case "Food": return "fork.knife.circle.fill"
        case "Drinks": return "cup.and.saucer.fill"
        case "Beauty & Accessories": return "sparkles"
        case "Interior Designs": return "house.lodge.fill"
        default: return "shippingbox.fill"
        }
    }
    
    private var productImage: Image {
        #if os(iOS)
        if let uiImage = UIImage(named: product.imageName) {
            return Image(uiImage: uiImage)
        }
        #endif
        return Image(systemName: fallbackSymbolName)
    }
}


