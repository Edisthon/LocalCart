import SwiftUI

struct BeautyAccessoriesView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Beauty Accessories Products")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(sampleProducts.filter { $0.category == "Beauty & Accessories" }) { product in
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
                                        Text("Location: Kigali")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    HStack(spacing: 10) {
                                        Image(systemName: "bag")
                                            .font(.title3)
                                            .foregroundColor(.primary)
                                        NavigationLink(destination: ProductDetailView(product: product)) {
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
//            .navigationTitle("Interior Designs")
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
        }
    }
  
}
struct BeautyAccessoriesView_Previews: PreviewProvider {
    static var previews: some View {
        BeautyAccessoriesView()
    }
}

