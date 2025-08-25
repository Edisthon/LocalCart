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
        
        private enum PaymentMethod: String, CaseIterable, Identifiable {
            case mtn = "MTN Mobile Money"
            case airtel = "Airtel Mobile Money"
            case paypal = "PayPal"
            var id: String { rawValue }
        }
        
        @State private var showPaymentOptions: Bool = false
        @State private var selectedMethod: PaymentMethod? = nil
        @State private var showInputSheet: Bool = false
        @State private var phoneNumber: String = ""
        @State private var emailAddress: String = ""
        @State private var isProcessing: Bool = false
        @State private var showSuccessAlert: Bool = false
        @State private var errorMessage: String? = nil
        
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
                Button(action: { showPaymentOptions = true }) {
                    Text("Pay Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .confirmationDialog(
                    "Choose payment method",
                    isPresented: $showPaymentOptions,
                    titleVisibility: .visible
                ) {
                    Button(PaymentMethod.mtn.rawValue) {
                        selectedMethod = .mtn
                        phoneNumber = ""
                        emailAddress = ""
                        showInputSheet = true
                    }
                    Button(PaymentMethod.airtel.rawValue) {
                        selectedMethod = .airtel
                        phoneNumber = ""
                        emailAddress = ""
                        showInputSheet = true
                    }
                    Button(PaymentMethod.paypal.rawValue) {
                        selectedMethod = .paypal
                        phoneNumber = ""
                        emailAddress = ""
                        showInputSheet = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .sheet(isPresented: $showInputSheet) {
                    NavigationStack {
                        VStack(spacing: 16) {
                            Text(selectedMethod == .paypal ? "Enter PayPal Email" : "Enter Mobile Money Number")
                                .font(.title3)
                                .bold()
                                .padding(.top)
                            if selectedMethod == .paypal {
                                TextField("Email address", text: $emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                                    .keyboardType(.emailAddress)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            } else {
                                TextField("Phone number (e.g. 07xx...)", text: $phoneNumber)
                                    .keyboardType(.phonePad)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                            if isProcessing {
                                ProgressView("Processing...")
                                    .padding(.top, 8)
                            }
                            Button(action: {
                                errorMessage = nil
                                if selectedMethod == .paypal {
                                    guard !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty else {
                                        errorMessage = "Please enter your email address"
                                        return
                                    }
                                } else {
                                    guard !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
                                        errorMessage = "Please enter your phone number"
                                        return
                                    }
                                }
                                isProcessing = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    isProcessing = false
                                    showInputSheet = false
                                    showSuccessAlert = true
                                }
                            }) {
                                Text("Confirm and Pay \(product.price, specifier: "%.2f") RWF")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                            Button("Cancel", role: .cancel) {
                                showInputSheet = false
                            }
                            .padding(.top, 4)
                            Spacer()
                        }
                        .navigationTitle("Payment Details")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") { showInputSheet = false }
                            }
                        }
                    }
                }
                .alert("Payment Successful", isPresented: $showSuccessAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Your order for \(product.name) has been placed.")
                }
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
