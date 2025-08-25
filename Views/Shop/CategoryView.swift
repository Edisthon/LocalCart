import SwiftUI

struct CategoryView: View {
    var category: String
    var products: [Product]
    
    var body: some View {
        VStack {
            Text("\(category) Products")
                .font(.largeTitle)
                .bold()
                .padding()

            List {
                ForEach(products.filter { $0.category == category }) { product in
                    HStack {
                        Text(product.name)
                            .font(.headline)
                        Spacer()
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(category)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: "Food", products: sampleProducts)
    }
}
//
//  CategoryView.swift
//  LocalCart
//
//  Created by Umurava Monday on 05/05/2025.
//

