import SwiftUI

struct DrinksView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Drink Products")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(sampleProducts.filter { $0.category == "Drinks" }) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                VStack(spacing: 8) {
                                    Image(product.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(10)
                                    Text(product.name)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    Text(product.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                    Text("\(product.price, specifier: "%.2f") RWF")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                    // Shopping cart icon for payment
                                    NavigationLink(destination: PaymentView(product: product)) {
                                        Image(systemName: "cart.fill")
                                            .foregroundColor(.blue)
                                            .padding(8)
                                            .background(Color(.systemGray6))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .padding(.horizontal, 8)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Food")
        }
    }
    
    
    struct ProductDetailView: View {
        let product: Product
        
        var body: some View {
            VStack(spacing: 20) {
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(12)
                Text(product.name)
                    .font(.largeTitle)
                    .bold()
                Text(product.description)
                    .font(.title3)
                    .foregroundColor(.gray)
                Text("\(product.price, specifier: "%.2f") RWF")
                    .font(.title2)
                    .foregroundColor(.green)
                Spacer()
                NavigationLink(destination: PaymentView(product: product)) {
                    Text("Proceed to Payment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle(product.name)
        }
    }
    struct PaymentView: View {
        let product: Product
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Payment for \(product.name)")
                    .font(.largeTitle)
                    .bold()
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                Text("Price: \(product.price, specifier: "%.2f") RWF")
                    .font(.title2)
                    .foregroundColor(.green)
                Text("Proceed with payment (Placeholder)")
                    .font(.title3)
                    .foregroundColor(.gray)
                // Add your payment processing UI/logic here
                Spacer()
            }
            .padding()
            .navigationTitle("Payment")
        }
    }

}
struct DrinksView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksView()
        
    }
}
