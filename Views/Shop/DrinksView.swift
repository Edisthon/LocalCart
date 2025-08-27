import SwiftUI

// Map product names to example locations for display under the card
private func locationForProduct(_ product: Product) -> String {
    switch product.name {
    case "Herbal Tea": return "Remera"
    case "Fresh Juice": return "Kimironko"
    case "Coffee Beans": return "Kiyovu"
    case "Sparkling Water": return "Kacyiru"
    default: return "Kigali"
    }
}

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
                            VStack(alignment: .leading, spacing: 10) {
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    Image(product.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame( width: 180, height: 160)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(.systemGray4), lineWidth: 1)
                                        )
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
                                }
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Name: \(product.name)")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Text("Price: \(product.price, specifier: "%.0f") frw")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        Text("Location: \(locationForProduct(product))")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    HStack(spacing: 10) {
                                        Image(systemName: "bag")
                                            .font(.title3)
                                            .foregroundColor(.primary)
                                        NavigationLink(destination: PaymentView(product: product)) {
                                            Image(systemName: "bag.badge.plus")
                                                .font(.title3)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                                .padding(12)
                                .frame(height: 90, alignment: .top)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .frame(height: 270, alignment: .top)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Drinks")
        }
    }
    
    
    struct ProductDetailView: View {
        let product: Product
        
        var body: some View {
            ScrollView {
                VStack(spacing: 16) {
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
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Text("\(product.price, specifier: "%.2f") RWF")
                        .font(.title2)
                        .foregroundColor(.green)

                    if product.calories != nil || product.servingSize != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nutrition")
                                .font(.headline)
                            if let calories = product.calories {
                                Text("Calories: \(calories) kcal")
                                    .font(.subheadline)
                            }
                            if let serving = product.servingSize {
                                Text("Serving: \(serving)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

                    if let ingredients = product.ingredients, !ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)
                            ForEach(ingredients, id: \.self) { item in
                                Text("• \(item)")
                                    .font(.subheadline)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

                    if let precautions = product.precautions, !precautions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Precautions")
                                .font(.headline)
                            ForEach(precautions, id: \.self) { note in
                                Text("• \(note)")
                                    .font(.subheadline)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

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
            }
            .navigationTitle(product.name)
        }
    }
    struct PaymentView: View {
        let product: Product
        @State private var isShowingPaymentOptions: Bool = false
        @State private var paymentStatusMessage: String? = nil
        
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
                if let message = paymentStatusMessage {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Button(action: { isShowingPaymentOptions = true }) {
                    Text("Pay Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .confirmationDialog("Choose Payment Method", isPresented: $isShowingPaymentOptions, titleVisibility: .visible) {
                    Button("MTN Mobile Money") { startPayment(using: "MTN Mobile Money") }
                    Button("Airtel Mobile Money") { startPayment(using: "Airtel Mobile Money") }
                    Button("PayPal") { startPayment(using: "PayPal") }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Select how you would like to pay.")
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Payment")
        }
        private func startPayment(using method: String) {
            paymentStatusMessage = "Processing \(method) for \(product.name)..."
            // Implement your payment processing flow here
            // e.g., trigger SDK / API call based on `method`
        }
    }

}
struct DrinksView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksView()
        
    }
}
