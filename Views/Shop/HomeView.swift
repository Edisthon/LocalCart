import SwiftUI

// Define the Product struct outside of HomeView
struct LocalCartProduct: Identifiable {
    var id = UUID()  // Automatically generates a unique ID
    var name: String
    var price: Double
}

// Sample product data
let localCartProducts: [LocalCartProduct] = [
    LocalCartProduct(name: "Organic Honey", price: 5.99),
    LocalCartProduct(name: "Handmade Soap", price: 3.50)
]

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Welcome to LocalCart 👋")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)

                List(localCartProducts) { product in
                    HStack {
                        Image(systemName: "bag.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .bold()
                            Text("$\(product.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(PlainListStyle())  // Customize list style
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

// Preview provider for HomeView
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
