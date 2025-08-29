import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ShopView: View {
    @AppStorage("username") var username: String = "User"
    @State private var showEditProfile: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var searchText: String = ""
    @State private var showPersonalize: Bool = false
    // Profile fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var locationText: String = ""
    // Interests
    private let allCategories: [String] = ["Food", "Drinks", "Interior Designs", "Beauty & Accessories"]
    @State private var selectedCategories: Set<String> = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with profile button
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hello, \(username)")
                            .font(.title)
                            .bold()
                        Text("Discover local products near you")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: { showEditProfile = true }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }

                // Search
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Search products, categories...", text: $searchText)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Hero banner
                ZStack(alignment: .bottomLeading) {
                    Image("buydashboard")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipped()
                        .cornerRadius(14)
                    LinearGradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.45)], startPoint: .top, endPoint: .bottom)
                        .cornerRadius(14)

                    NavigationLink(destination: SupportPayPalView()) {
                        Text("Support Local • Shop Smart")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                }

                // Categories chips
                VStack(alignment: .leading, spacing: 8) {
                    Text("Categories").font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            NavigationLink(destination: FoodView()) { CategoryChip(title: "Food", systemImage: "fork.knife") }
                            NavigationLink(destination: DrinksView()) { CategoryChip(title: "Drinks", systemImage: "cup.and.saucer") }
                            NavigationLink(destination: InteriorDesignsView()) { CategoryChip(title: "Interior", systemImage: "lamp.table") }
                            NavigationLink(destination: BeautyAccessoriesView()) { CategoryChip(title: "Beauty", systemImage: "sparkles") }
                        }
                    }
                }

                // Trending
                VStack(alignment: .leading, spacing: 12) {
                    Text("Trending now").font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sampleProducts.prefix(4)) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCard(product: product)
                                }
                            }
                        }
                    }
                }

                // Recommended
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommended for you").font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            let recs = recommendedProducts()
                            ForEach(recs) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCard(product: product)
                                }
                            }
                        }
                    }
                }

                // Personalize collapsible
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Personalize your interests").font(.headline)
                        Spacer()
                        Button(action: { withAnimation { showPersonalize.toggle() } }) {
                            Image(systemName: showPersonalize ? "chevron.up" : "chevron.down").foregroundColor(.blue)
                        }
                    }
                    if showPersonalize {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(allCategories, id: \.self) { category in
                                Toggle(isOn: Binding(get: { selectedCategories.contains(category) }, set: { on in
                                    if on { selectedCategories.insert(category) } else { selectedCategories.remove(category) }
                                })) {
                                    Text(category)
                                }
                            }
                            Button(action: { Task { await saveInterests() } }) {
                                if isLoading { ProgressView() } else { Text("Save interests") }
                            }
                            .disabled(selectedCategories.isEmpty)
                            .padding(.top, 4)
                        }
                    }
                }

            }
            .padding()
        }
        .navigationTitle("Shop")
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, locationText: $locationText, onSave: {
                Task { await saveProfile() }
            })
        }
        .task { await loadUser() }
        .alert(isPresented: .constant(errorMessage != nil)) { Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")) { errorMessage = nil }) }
    }
}

struct CategoryButton: View {
    var category: String
    
    var body: some View {
        Text(category)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.purple)
            .cornerRadius(10)
    }
}

// MARK: - Dashboard Components
private struct CategoryChip: View {
    let title: String
    let systemImage: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.subheadline)
            Text(title)
                .font(.subheadline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.blue.opacity(0.12))
        .foregroundColor(.blue)
        .cornerRadius(16)
    }
}

private struct ProductCards: View {
    let product: Product
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(product.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 100)
                .clipped()
                .cornerRadius(10)
            Text(product.name)
                .font(.subheadline)
                .lineLimit(1)
            Text(String(format: "%.0f RWF", product.price))
                .font(.caption)
                .foregroundColor(.green)
        }
        .frame(width: 140)
    }
}

// MARK: - Support via PayPal
private struct SupportPayPalView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSubmitting: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Support via PayPal")) {
                    Text("Thank you for supporting local makers! Enter your PayPal account to proceed.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Section(header: Text("Account")) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                }
                Section {
                    Button(action: submit) {
                        if isSubmitting { ProgressView().frame(maxWidth: .infinity) } else { Text("Continue with PayPal").frame(maxWidth: .infinity) }
                    }
                    .disabled(!isValid)
                }
            }
            .navigationTitle("Support Local")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
    }
    private var isValid: Bool { email.contains("@") && email.contains(".") && password.count >= 6 }
    private func submit() { isSubmitting = true; DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { isSubmitting = false; dismiss() } }
}

// MARK: - Edit Profile Sheet
private struct EditProfileView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var phoneNumber: String
    @Binding var locationText: String
    var onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal information")) {
                    TextField("First name", text: $firstName)
                    TextField("Last name", text: $lastName)
                    TextField("Email", text: $email).textInputAutocapitalization(.never).keyboardType(.emailAddress)
                    TextField("Phone number", text: $phoneNumber).keyboardType(.phonePad)
                    TextField("Location (City/District)", text: $locationText)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { onSave(); dismiss() } }
            }
        }
    }
}

// MARK: - Firestore helpers
extension ShopView {
    private func recommendedProducts() -> [Product] {
        let selected = selectedCategories
        let pool = selected.isEmpty ? sampleProducts : sampleProducts.filter { selected.contains($0.category) }
        if searchText.isEmpty { return Array(pool.prefix(10)) }
        return pool.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) }
    }
    private func usersDoc() throws -> DocumentReference {
        guard let uid = Auth.auth().currentUser?.uid else { throw NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not signed in"]) }
        return Firestore.firestore().collection("users").document(uid)
    }
    private func loadUser() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let doc = try await usersDoc().getDocument()
            if let data = doc.data() {
                firstName = (data["firstName"] as? String) ?? firstName
                lastName = (data["lastName"] as? String) ?? lastName
                email = (data["email"] as? String) ?? email
                phoneNumber = (data["phone"] as? String) ?? phoneNumber
                locationText = (data["location"] as? String) ?? locationText
                if let cats = data["sellCategories"] as? [String] { selectedCategories = Set(cats) }
                username = firstName.isEmpty ? username : firstName
            }
        } catch { errorMessage = error.localizedDescription }
    }
    private func saveProfile() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await usersDoc().setData([
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "phone": phoneNumber,
                "location": locationText
            ], merge: true)
            username = firstName
        } catch { errorMessage = error.localizedDescription }
    }
    private func saveInterests() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await usersDoc().setData(["sellCategories": Array(selectedCategories)], merge: true)
        } catch { errorMessage = error.localizedDescription }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}

