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
                Theme.background
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Welcome to LocalCart")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                        .foregroundColor(Theme.text)

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
