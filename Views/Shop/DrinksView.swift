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
    @StateObject private var store = ProductStore()
    
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
                if !store.drinksListings.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("From Sellers")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        ForEach(store.drinksListings) { listing in
                            HStack(spacing: 12) {
                                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 80, height: 80).cornerRadius(8)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(listing.name).bold()
                                    Text(String(format: "%.0f RWF", listing.price)).foregroundColor(.green)
                                    Text(listing.location).font(.caption).foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Drinks")
        }
        .onAppear { store.fetchDrinksListings() }
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
        private enum PaymentMethod: String, Identifiable { case mtn = "MTN Mobile Money", airtel = "Airtel Mobile Money", paypal = "PayPal"; var id: String { rawValue } }
        @State private var selectedPaymentMethod: PaymentMethod? = nil
        
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
                    Button("MTN Mobile Money") { selectedPaymentMethod = .mtn }
                    Button("Airtel Mobile Money") { selectedPaymentMethod = .airtel }
                    Button("PayPal") { selectedPaymentMethod = .paypal }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Select how you would like to pay.")
                }
                .sheet(item: $selectedPaymentMethod) { method in
                    switch method {
                    case .mtn:
                        MobileMoneyFormView(product: product, providerName: method.rawValue) { details in
                            paymentStatusMessage = "Processing \(method.rawValue) for \(product.name) — \(details.summary)"
                        }
                    case .airtel:
                        MobileMoneyFormView(product: product, providerName: method.rawValue) { details in
                            paymentStatusMessage = "Processing \(method.rawValue) for \(product.name) — \(details.summary)"
                        }
                    case .paypal:
                        PayPalFormView(product: product) { email in
                            paymentStatusMessage = "Redirecting to PayPal for \(product.name) — Account: \(email)"
                        }
                    }
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

    // Reuse the same forms from FoodView file by copying minimal definitions for this file scope
    fileprivate struct MobileMoneyDetails {
        let fullName: String
        let phoneNumber: String
        let location: String
        let note: String
        var summary: String { "\(fullName), \(phoneNumber), \(location)" }
    }
    fileprivate struct MobileMoneyFormView: View {
        let product: Product
        let providerName: String
        var onConfirm: (MobileMoneyDetails) -> Void
        @Environment(\.dismiss) private var dismiss
        @State private var fullName: String = ""
        @State private var phoneNumber: String = ""
        @State private var locationText: String = ""
        @State private var note: String = ""
        @State private var isSubmitting: Bool = false
        var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text(providerName)) {
                        HStack { Text("Amount"); Spacer(); Text("\(product.price, specifier: "%.2f") RWF").foregroundColor(.secondary) }
                    }
                    Section(header: Text("Payer Information")) {
                        TextField("Full name", text: $fullName)
                        TextField("Phone number", text: $phoneNumber).keyboardType(.phonePad)
                        TextField("Location (City/District)", text: $locationText)
                        TextField("Note (optional)", text: $note)
                    }
                    Section {
                        Button(action: submit) {
                            if isSubmitting { ProgressView().frame(maxWidth: .infinity) } else { Text("Pay with \(providerName)").frame(maxWidth: .infinity) }
                        }.disabled(!isValid)
                    }
                }
                .navigationTitle("\(providerName)")
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
            }
        }
        private var isValid: Bool { !fullName.isEmpty && isValidPhone(phoneNumber) && !locationText.isEmpty }
        private func isValidPhone(_ value: String) -> Bool { let d = value.filter { $0.isNumber }; return d.count >= 9 && d.count <= 12 }
        private func submit() { isSubmitting = true; DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { isSubmitting = false; onConfirm(MobileMoneyDetails(fullName: fullName, phoneNumber: phoneNumber, location: locationText, note: note)); dismiss() } }
    }
    fileprivate struct PayPalFormView: View {
        let product: Product
        var onConfirm: (String) -> Void
        @Environment(\.dismiss) private var dismiss
        @State private var email: String = ""
        @State private var password: String = ""
        @State private var isSubmitting: Bool = false
        var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text("PayPal")) { HStack { Text("Amount"); Spacer(); Text("\(product.price, specifier: "%.2f") RWF").foregroundColor(.secondary) } }
                    Section(header: Text("Account")) {
                        TextField("Email", text: $email).textInputAutocapitalization(.never).keyboardType(.emailAddress)
                        SecureField("Password", text: $password)
                    }
                    Section { Button(action: submit) { if isSubmitting { ProgressView().frame(maxWidth: .infinity) } else { Text("Continue with PayPal").frame(maxWidth: .infinity) } }.disabled(!isValid) }
                }
                .navigationTitle("PayPal")
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
            }
        }
        private var isValid: Bool { email.contains("@") && email.contains(".") && password.count >= 6 }
        private func submit() { isSubmitting = true; DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { isSubmitting = false; onConfirm(email); dismiss() } }
    }

}
struct DrinksView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksView()
        
    }
}
