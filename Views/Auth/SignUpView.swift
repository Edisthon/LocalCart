import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToLogin = false // State to trigger navigation
    
    @AppStorage("username") var username: String = "User" // Store name for later use

    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.top)
                    Text("Create an Account")
                        .font(.title)
                        .bold()
                        .padding(.top)
                        .foregroundColor(Theme.text)

                    TextField("First Name", text: $firstName)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(8)

                    TextField("Last Name", text: $lastName)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(8)

                    TextField("Email Address", text: $email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(8)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(8)

                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? Login")
                            .font(.footnote)
                            .foregroundColor(Theme.button)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    // Hidden NavigationLink for programmatic navigation
                    NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                        EmptyView()
                    }

                    Button(action: {
                        if validateFields() {
                            signUpUser(firstName: firstName, lastName: lastName, email: email, password: password)
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(Theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.button)
                            .cornerRadius(8)
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle("Sign Up")
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Sign Up"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            if alertMessage == "Account created successfully!" {
                                navigateToLogin = true // Trigger navigation after alert dismissal
                            }
                        }
                    )
                }
            }
        }
    }

    private func validateFields() -> Bool {
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return false
        }
        if !email.contains("@") || !email.contains(".") {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return false
        }
        if password.count < 6 {
            alertMessage = "Password must be at least 6 characters."
            showAlert = true
            return false
        }
        return true
    }

    private func signUpUser(firstName: String, lastName: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = "Signup Error: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            guard let uid = result?.user.uid else {
                alertMessage = "Error: User ID not found."
                showAlert = true
                return
            }
            
            // Save name and email in Firestore
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "firstName": firstName,
                "lastName": lastName,
                "email": email
            ]) { err in
                if let err = err {
                    alertMessage = "Error saving user info: \(err.localizedDescription)"
                    showAlert = true
                } else {
                    username = firstName // Save locally for SwiftUI views
                    alertMessage = "Account created successfully!"
                    showAlert = true
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
