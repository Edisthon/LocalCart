import SwiftUI

// Map product names to example locations for display under the card
private func locationForProduct(_ product: Product) -> String {
    switch product.name {
    case "Pasta": return "Nyarutarama"
    case "Fruits": return "Kimironko"
    case "Burrito": return "Kacyiru"
    case "Fresh Strawberries", "Strawberry Pie": return "Gishushu"
    case "Chocolate Chip Cookies": return "Gishushu"
    case "Beef Stew": return "Nyamirambo"
    default: return "Kigali"
    }
}

struct FoodView: View {
    @StateObject private var store = ProductStore()
    
    // Map a Firestore listing into a placeholder Product for detail/payment flows
    private func productFromListing(_ listing: Listing) -> Product {
        Product(name: listing.name,
                price: listing.price,
                category: "Food",
                description: listing.description,
                imageName: "")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                VStack {
                    Text("Food Products")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(Theme.text)

                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(sampleProducts.filter { $0.category == "Food" }) { product in
                                VStack(alignment: .leading, spacing: 10) {
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        if !product.imageName.isEmpty {
                                            Image(product.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 180, height: 160)
                                                .frame(maxWidth: .infinity)
                                                .clipped()
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.white, lineWidth: 1)
                                                )
                                                .cornerRadius(12)
                                                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
                                        } else {
                                            Rectangle()
                                                .fill(Theme.beige.opacity(0.2))
                                                .frame(width: 180, height: 160)
                                                .frame(maxWidth: .infinity)
                                                .cornerRadius(12)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .font(.largeTitle)
                                                        .foregroundColor(.gray)
                                                )
                                        }
                                    }
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Name: \(product.name)")
                                                .font(.subheadline)
                                                .foregroundColor(Theme.text)
                                            Text("Price: \(product.price, specifier: "%.0f") frw")
                                                .font(.footnote)
                                                .foregroundColor(Theme.text.opacity(0.7))
                                            Text("Location: \(locationForProduct(product))")
                                                .font(.footnote)
                                                .foregroundColor(Theme.text.opacity(0.7))
                                        }
                                        Spacer()
                                        HStack(spacing: 10) {
                                            Image(systemName: "bag")
                                                .font(.title3)
                                                .foregroundColor(Theme.button)
                                            NavigationLink(destination: ProductDetailView(product: product)) {
                                                Image(systemName: "bag.badge.plus")
                                                    .font(.title3)
                                                    .foregroundColor(Theme.button)
                                            }
                                        }
                                    }
                                    .padding(12)
                                    .frame(height: 90, alignment: .top)
                                    .background(Theme.beige)
                                    .cornerRadius(12)
                                }
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .frame(height: 270, alignment: .top) // make all cards equal height like Chocolate/Beef Stew

                            }
                            // User Listings appended
                            ForEach(store.foodListings) { listing in
                                let placeholderProduct = productFromListing(listing)
                                VStack(alignment: .leading, spacing: 10) {
                                    NavigationLink(destination: ProductDetailView(product: placeholderProduct)) {
                                        if !placeholderProduct.imageName.isEmpty {
                                            Image(placeholderProduct.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 180, height: 160)
                                                .frame(maxWidth: .infinity)
                                                .clipped()
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.white, lineWidth: 1)
                                                )
                                                .cornerRadius(12)
                                                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
                                        } else {
                                            Rectangle()
                                                .fill(Theme.beige.opacity(0.2))
                                                .frame(width: 180, height: 160)
                                                .frame(maxWidth: .infinity)
                                                .cornerRadius(12)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .font(.largeTitle)
                                                        .foregroundColor(.gray)
                                                )
                                        }
                                    }
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Name: \(listing.name)")
                                                .font(.subheadline)
                                                .foregroundColor(Theme.text)
                                            Text("Price: \(listing.price, specifier: "%.0f") frw")
                                                .font(.footnote)
                                                .foregroundColor(Theme.text.opacity(0.7))
                                            Text("Location: \(listing.location)")
                                                .font(.footnote)
                                                .foregroundColor(Theme.text.opacity(0.7))
                                        }
                                        Spacer()
                                        HStack(spacing: 10) {
                                            Image(systemName: "bag")
                                                .font(.title3)
                                                .foregroundColor(Theme.button)
                                            NavigationLink(destination: PaymentView(product: placeholderProduct)) {
                                                Image(systemName: "bag.badge.plus")
                                                    .font(.title3)
                                                    .foregroundColor(Theme.button)
                                            }
                                        }
                                    }
                                    .padding(12)
                                    .frame(height: 90, alignment: .top)
                                    .background(Theme.beige)
                                    .cornerRadius(12)
                                }
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .frame(height: 270, alignment: .top)
                            }
                        }
                        .padding()
                    }

                }
                .navigationTitle("Food")
            }
        }
        .onAppear { store.fetchFoodListings() }
    }
}

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
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
                        .foregroundColor(Theme.text)
                    Text(product.description)
                        .font(.title3)
                        .foregroundColor(Theme.text.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Text("\(product.price, specifier: "%.2f") RWF")
                        .font(.title2)
                        .foregroundColor(Theme.button)

                    if product.calories != nil || product.servingSize != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nutrition")
                                .font(.headline)
                                .foregroundColor(Theme.text)
                            if let calories = product.calories {
                                Text("Calories: \(calories) kcal")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.text)
                            }
                            if let serving = product.servingSize {
                                Text("Serving: \(serving)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.text.opacity(0.7))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.beige)
                        .cornerRadius(12)
                    }

                    if let ingredients = product.ingredients, !ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)
                                .foregroundColor(Theme.text)
                            ForEach(ingredients, id: \.self) { item in
                                Text("• \(item)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.text)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.beige)
                        .cornerRadius(12)
                    }

                    if let allergens = product.allergens, !allergens.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Allergens")
                                .font(.headline)
                                .foregroundColor(Theme.text)
                            Text(allergens.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundColor(Theme.text.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.beige)
                        .cornerRadius(12)
                    }

                    if let precautions = product.precautions, !precautions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Precautions")
                                .font(.headline)
                                .foregroundColor(Theme.text)
                            ForEach(precautions, id: \.self) { note in
                                Text("• \(note)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.text)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.beige)
                        .cornerRadius(12)
                    }

                    NavigationLink(destination: PaymentView(product: product)) {
                        Text("Proceed to Payment")
                            .font(.headline)
                            .foregroundColor(Theme.buttonText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.button)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle(product.name)
        }
    }
}

struct PaymentView: View {
    let product: Product
    
    private func location(for product: Product) -> String {
        switch product.name {
        case "Pasta": return "Nyarutarama"
        case "Fruits": return "Kimironko"
        case "Burrito": return "Kacyiru"
        case "Fresh Strawberries", "Strawberry Pie": return "Gishushu"
        case "Chocolate Chip Cookies": return "Gishushu"
        case "Beef Stew": return "Nyamirambo"
        default: return "Kigali"
        }
    }
    @State private var isShowingPaymentOptions: Bool = false
    @State private var paymentStatusMessage: String? = nil
    private enum PaymentMethod: String, Identifiable {
        case mtn = "MTN Mobile Money"
        case airtel = "Airtel Mobile Money"
        case paypal = "PayPal"
        var id: String { rawValue }
    }
    @State private var selectedPaymentMethod: PaymentMethod? = nil
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Payment for \(product.name)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Theme.text)
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                Text("Price: \(product.price, specifier: "%.2f") RWF")
                    .font(.title2)
                    .foregroundColor(Theme.button)
                if let message = paymentStatusMessage {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(Theme.text.opacity(0.7))
                }
                Button(action: { isShowingPaymentOptions = true }) {
                    Text("Pay Now")
                        .font(.headline)
                        .foregroundColor(Theme.buttonText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.button)
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
    }

    private func startPayment(using method: String) {
        paymentStatusMessage = "Processing \(method) for \(product.name)..."
        // Implement your payment processing flow here
        // e.g., trigger SDK / API call based on `method`
    }
}

// MARK: - Mobile Money Form
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
                    HStack {
                        Text("Amount")
                        Spacer()
                        Text("\(product.price, specifier: "%.2f") RWF").foregroundColor(.secondary)
                    }
                }
                Section(header: Text("Payer Information")) {
                    TextField("Full name", text: $fullName)
                    TextField("Phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Location (City/District)", text: $locationText)
                    TextField("Note (optional)", text: $note)
                }
                Section {
                    Button(action: submit) {
                        if isSubmitting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Pay with \(providerName)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!isValid)
                }
            }
            .navigationTitle("\(providerName)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    private var isValid: Bool {
        !fullName.isEmpty && isValidPhone(phoneNumber) && !locationText.isEmpty
    }
    private func isValidPhone(_ value: String) -> Bool {
        let digits = value.filter { $0.isNumber }
        return digits.count >= 9 && digits.count <= 12
    }
    private func submit() {
        isSubmitting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isSubmitting = false
            onConfirm(MobileMoneyDetails(fullName: fullName, phoneNumber: phoneNumber, location: locationText, note: note))
            dismiss()
        }
    }
}

// MARK: - PayPal Form
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
                Section(header: Text("PayPal")) {
                    HStack {
                        Text("Amount")
                        Spacer()
                        Text("\(product.price, specifier: "%.2f") RWF").foregroundColor(.secondary)
                    }
                }
                Section(header: Text("Account")) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                }
                Section {
                    Button(action: submit) {
                        if isSubmitting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Continue with PayPal")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!isValid)
                }
            }
            .navigationTitle("PayPal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    private var isValid: Bool {
        email.contains("@") && email.contains(".") && password.count >= 6
    }
    private func submit() {
        isSubmitting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isSubmitting = false
            onConfirm(email)
            dismiss()
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
            
    }
}
