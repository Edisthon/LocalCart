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
            VStack(spacing: 20) {
                Text("Welcome to LocalCart")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
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
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 40)
                }
                    
                
                Spacer()
            }
            .padding()
        }
    }
}
struct WelcomeHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeHomePageView()
            }
}
