import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    @AppStorage("username") var username: String = "User"

    var body: some View {
        NavigationView {
            if isLoggedIn {
                WelcomeView()
            } else {
                ZStack {
                    Theme.background
                        .ignoresSafeArea()
                    VStack(spacing: 20) {

                        // LOGO
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding(.top)

                        Text("Welcome Back 👋")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Theme.text)

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(8)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(8)

                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .foregroundColor(Theme.button)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        Button(action: {
                            if email.isEmpty || password.isEmpty {
                                alertMessage = "Email and password cannot be empty."
                                showAlert = true
                            } else {
                                // Firebase login
                                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                                    if let error = error {
                                        alertMessage = "Login error: \(error.localizedDescription)"
                                        showAlert = true
                                        return
                                    }

                                    guard let uid = result?.user.uid else { return }

                                    let db = Firestore.firestore()
                                    db.collection("users").document(uid).getDocument { snapshot, error in
                                        if let data = snapshot?.data(), let firstName = data["firstName"] as? String {
                                            username = firstName // Save the actual name
                                            isLoggedIn = true
                                        } else {
                                            username = "User"
                                            isLoggedIn = true
                                        }
                                    }
                                }
                            }
                        }) {
                            Text("Login")
                                .foregroundColor(Theme.buttonText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.button)
                                .cornerRadius(8)
                        }


                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(Theme.text)
                            NavigationLink("Sign Up", destination: SignUpView())
                                .foregroundColor(Theme.button)
                                .bold()
                        }
                        .padding(.top)

                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Login")
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertMessage))
                    }
                }
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            }
}


