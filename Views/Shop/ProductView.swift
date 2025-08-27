import SwiftUI

struct ProductView: View {
    let product: Product

    var body: some View {
        VStack(spacing: 20) {
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .cornerRadius(12)

            Text(product.name)
                .font(.title)
                .fontWeight(.bold)

            Text(product.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(String(format: "$%.2f", product.price))
                .font(.title2)
                .foregroundColor(.green)

            Spacer()
        }
        .padding()
        .navigationTitle("Product Details")
    }
}
//struct ProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductView(product: <#T##Product#>)
//    }
//}

