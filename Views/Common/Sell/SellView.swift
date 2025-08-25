import SwiftUI

struct SellView: View {
    var body: some View {
        VStack {
            Text("🧺 List Your Product")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("This is where you can upload and manage your products.")
                .font(.body)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .navigationTitle("Sell")
    }
}
//
//  SellView.swift
//  LocalCart
//
//  Created by Umurava Monday on 05/05/2025.
//

