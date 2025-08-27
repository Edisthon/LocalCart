import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ShopView: View {
    @AppStorage("username") var username: String = "User"
    @State private var showEditProfile: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
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
        VStack(alignment: .leading, spacing: 20) {
            Text("🛒 Welcome, \(username)")
                .font(.largeTitle)
                .bold()

            Text("Personalize your interest and start browsing!")
                .font(.subheadline)
                .foregroundColor(.gray)

            Button(action: { showEditProfile = true }) {
                Text("Edit Profile")
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Spacer()

            // Categories Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Personalize your interest:")
                    .font(.title2)
                    .bold()

                // Categories buttons
                VStack(spacing: 16) {
                    // Interests toggles
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your interests")
                            .font(.headline)
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
                    }

                    // Quick nav buttons
                    NavigationLink(destination: FoodView()) { CategoryButton(category: "Food") }
                    NavigationLink(destination: DrinksView()) { CategoryButton(category: "Drinks") }
                    NavigationLink(destination: InteriorDesignsView()) { CategoryButton(category: "Interior Designs") }
                    NavigationLink(destination: BeautyAccessoriesView()) { CategoryButton(category: "Beauty & Accessories") }
                }
                .padding(.top)
            }

            Spacer()
        }
        .padding()
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

