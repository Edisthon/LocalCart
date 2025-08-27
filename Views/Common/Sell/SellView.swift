import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SellView: View {
    private enum SellStep: Int, CaseIterable {
        case profile, preferences, payout, review
        var title: String {
            switch self {
            case .profile: return "Your profile"
            case .preferences: return "Selling preferences"
            case .payout: return "Payout details"
            case .review: return "Review"
            }
        }
    }

    @State private var currentStep: SellStep = .profile

    // Profile fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var locationText: String = ""

    // Preferences
    private let allCategories: [String] = ["Food", "Drinks", "Interior Designs", "Beauty & Accessories"]
    @State private var selectedCategories: Set<String> = []
    @State private var shopName: String = ""
    @State private var shopDescription: String = ""

    // Payout
    private enum PayoutMethod: String, CaseIterable, Identifiable { case mobileMoney = "Mobile Money", paypal = "PayPal"; var id: String { rawValue } }
    @State private var payoutMethod: PayoutMethod = .mobileMoney
    @State private var payoutMobilePhone: String = ""
    @State private var payoutPayPalEmail: String = ""

    // UX state
    @State private var isLoading: Bool = false
    @State private var showSavedToast: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 16) {
            stepHeader

            Group {
                switch currentStep {
                case .profile:
                    profileForm
                case .preferences:
                    preferencesForm
                case .payout:
                    payoutForm
                case .review:
                    reviewView
                }
            }
            .disabled(isLoading)

            footerControls
        }
        .padding()
        .navigationTitle("Sell")
        .task { await loadProfile() }
        .alert(isPresented: .constant(errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")) { errorMessage = nil })
        }
    }

    // MARK: - Header
    private var stepHeader: some View {
        VStack(spacing: 8) {
            Text(currentStep.title)
                .font(.title2)
                .bold()
            HStack(spacing: 6) {
                ForEach(Array(SellStep.allCases.enumerated()), id: \.offset) { idx, step in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(step == currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 6)
                        .animation(.easeInOut, value: currentStep)
                }
            }
        }
    }

    // MARK: - Forms
    private var profileForm: some View {
        Form {
            Section(header: Text("Personal information")) {
                TextField("First name", text: $firstName)
                TextField("Last name", text: $lastName)
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                TextField("Phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                TextField("Location (City/District)", text: $locationText)
            }
            Section {
                Button(action: { Task { await saveProfile() } }) {
                    if isLoading { ProgressView().frame(maxWidth: .infinity) } else { Text("Save profile").frame(maxWidth: .infinity) }
                }
                .disabled(!isValidProfile)
            }
        }
        .frame(maxHeight: 420)
        .cornerRadius(12)
    }

    private var preferencesForm: some View {
        Form {
            Section(header: Text("Shop")) {
                TextField("Shop name", text: $shopName)
                TextField("Short description", text: $shopDescription)
            }
            Section(header: Text("What will you sell?")) {
                ForEach(allCategories, id: \.self) { category in
                    Toggle(isOn: Binding(get: { selectedCategories.contains(category) }, set: { on in
                        if on { selectedCategories.insert(category) } else { selectedCategories.remove(category) }
                    })) {
                        Text(category)
                    }
                }
            }
            Section {
                Button(action: { Task { await savePreferences() } }) {
                    if isLoading { ProgressView().frame(maxWidth: .infinity) } else { Text("Save preferences").frame(maxWidth: .infinity) }
                }
                .disabled(!isValidPreferences)
            }
        }
        .frame(maxHeight: 480)
    }

    private var payoutForm: some View {
        Form {
            Section(header: Text("Payout method")) {
                Picker("Method", selection: $payoutMethod) {
                    ForEach(PayoutMethod.allCases) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .pickerStyle(.segmented)
            }
            if payoutMethod == .mobileMoney {
                Section(header: Text("Mobile Money details")) {
                    TextField("Payout phone number", text: $payoutMobilePhone)
                        .keyboardType(.phonePad)
                }
            } else {
                Section(header: Text("PayPal details")) {
                    TextField("PayPal email", text: $payoutPayPalEmail)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
            }
            Section {
                Button(action: { Task { await savePayout() } }) {
                    if isLoading { ProgressView().frame(maxWidth: .infinity) } else { Text("Save payout").frame(maxWidth: .infinity) }
                }
                .disabled(!isValidPayout)
            }
        }
        .frame(maxHeight: 360)
    }

    private var reviewView: some View {
        VStack(alignment: .leading, spacing: 12) {
            GroupBox(label: Text("Profile").bold()) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Name: \(firstName) \(lastName)")
                    Text("Email: \(email)")
                    Text("Phone: \(phoneNumber)")
                    Text("Location: \(locationText)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Text("Preferences").bold()) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Shop: \(shopName)")
                    Text("About: \(shopDescription)")
                    Text("Categories: \(selectedCategories.sorted().joined(separator: ", "))")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Text("Payout").bold()) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Method: \(payoutMethod.rawValue)")
                    if payoutMethod == .mobileMoney { Text("Phone: \(payoutMobilePhone)") } else { Text("PayPal: \(payoutPayPalEmail)") }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            NavigationLink(destination: SellerDashboardView()) {
                Text("Go to Seller dashboard")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }

    // MARK: - Footer
    private var footerControls: some View {
        HStack(spacing: 12) {
            if currentStep != .profile {
                Button(action: { withAnimation { goPrevious() } }) { Text("Back") }
            }
            Spacer()
            if currentStep != .review {
                Button(action: { withAnimation { goNext() } }) {
                    Text("Next")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .disabled(!canProceed)
            }
        }
    }

    // MARK: - Step navigation
    private func goNext() { if let next = SellStep(rawValue: currentStep.rawValue + 1) { currentStep = next } }
    private func goPrevious() { if let prev = SellStep(rawValue: currentStep.rawValue - 1) { currentStep = prev } }

    private var canProceed: Bool {
        switch currentStep {
        case .profile: return isValidProfile
        case .preferences: return isValidPreferences
        case .payout: return isValidPayout
        case .review: return true
        }
    }

    // MARK: - Validation
    private var isValidProfile: Bool {
        !firstName.isEmpty && !lastName.isEmpty && email.contains("@") && !phoneNumber.isEmpty && !locationText.isEmpty
    }
    private var isValidPreferences: Bool {
        !shopName.isEmpty && !selectedCategories.isEmpty
    }
    private var isValidPayout: Bool {
        switch payoutMethod {
        case .mobileMoney: return payoutMobilePhone.filter { $0.isNumber }.count >= 9
        case .paypal: return payoutPayPalEmail.contains("@") && payoutPayPalEmail.contains(".")
        }
    }

    // MARK: - Firestore I/O
    private func currentUID() -> String? { Auth.auth().currentUser?.uid }

    private func loadProfileValues(from data: [String: Any]) {
        firstName = (data["firstName"] as? String) ?? firstName
        lastName = (data["lastName"] as? String) ?? lastName
        email = (data["email"] as? String) ?? email
        phoneNumber = (data["phone"] as? String) ?? phoneNumber
        locationText = (data["location"] as? String) ?? locationText
        shopName = (data["shopName"] as? String) ?? shopName
        shopDescription = (data["shopDescription"] as? String) ?? shopDescription
        if let cats = data["sellCategories"] as? [String] { selectedCategories = Set(cats) }
        if let payout = data["payoutMethod"] as? String { payoutMethod = payout == PayoutMethod.paypal.rawValue ? .paypal : .mobileMoney }
        payoutMobilePhone = (data["payoutMobilePhone"] as? String) ?? payoutMobilePhone
        payoutPayPalEmail = (data["payoutPayPalEmail"] as? String) ?? payoutPayPalEmail
    }

    private func usersDoc() throws -> DocumentReference {
        guard let uid = currentUID() else { throw NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not signed in"]) }
        return Firestore.firestore().collection("users").document(uid)
    }

    private func loadProfile() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let doc = try await usersDoc().getDocument()
            if let data = doc.data() { loadProfileValues(from: data) }
        } catch {
            errorMessage = error.localizedDescription
        }
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
            showSavedToast = true
        } catch { errorMessage = error.localizedDescription }
    }

    private func savePreferences() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await usersDoc().setData([
                "shopName": shopName,
                "shopDescription": shopDescription,
                "sellCategories": Array(selectedCategories)
            ], merge: true)
            showSavedToast = true
        } catch { errorMessage = error.localizedDescription }
    }

    private func savePayout() async {
        isLoading = true
        defer { isLoading = false }
        do {
            var payload: [String: Any] = ["payoutMethod": payoutMethod.rawValue]
            if payoutMethod == .mobileMoney { payload["payoutMobilePhone"] = payoutMobilePhone } else { payload["payoutPayPalEmail"] = payoutPayPalEmail }
            try await usersDoc().setData(payload, merge: true)
            showSavedToast = true
        } catch { errorMessage = error.localizedDescription }
    }
}
//
//  SellView.swift
//  LocalCart
//
//  Created by Umurava Monday on 05/05/2025.
//

