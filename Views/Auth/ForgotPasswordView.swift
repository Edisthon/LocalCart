//
//  ForgotPasswordView.swift
//  LocalCart
//
//  Created by Umurava Monday on 05/05/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Password")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Text("Enter your email to receive a password reset link.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("Email Address", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            Button(action: {
                if email.isEmpty || !email.contains("@") {
                    alertMessage = "Please enter a valid email address."
                } else {
                    // Password reset logic (mock or real)
                    alertMessage = "If this email is registered, a reset link has been sent."
                }
                showAlert = true
            }) {
                Text("Send Reset Link")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Forgot Password")
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage))
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
