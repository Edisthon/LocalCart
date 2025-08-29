//
//  WelcomeView.swift
//  LocalCart
//
//  Created by Umurava Monday on 22/08/2025.
//


import SwiftUI

struct WelcomeHomePageView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Theme.background, Theme.beige]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Welcome to LocalCart")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                        .foregroundColor(Theme.text)

                    Text("Your one-stop shop for local goods.")
                        .font(.headline)
                        .foregroundColor(Theme.text.opacity(0.7))

                    Image("welcomeImg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding()

                    NavigationLink(destination: LoginView()) {
                        Text("Welcome to RiseLocal, click to proceed")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.button)
                            .foregroundColor(Theme.buttonText)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .padding(.horizontal, 40)
                    }


                    Spacer()
                }
                .padding()
            }
        }
    }
}
struct WelcomeHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeHomePageView()
            }
}
