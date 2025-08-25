import SwiftUI

struct SellTermsView: View {
    @State private var hasAgreedToTerms: Bool = false
    @State private var navigateToSell: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Sell on LocalCart")
                    .font(.largeTitle)
                    .bold()

                // Why sell with LocalCart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Why sell with LocalCart")
                        .font(.title2)
                        .bold()
                    Text("Reach nearby customers who value locally-made products. Keep more of your earnings with fair fees and get discovery through our curated storefronts.")
                        .foregroundColor(.gray)
                }

                // Features
                VStack(alignment: .leading, spacing: 8) {
                    Text("Features")
                        .font(.title2)
                        .bold()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("• Simple product listing and inventory management")
                        Text("• Secure payments and fast payouts")
                        Text("• Local discovery and category pages")
                        Text("• Analytics to understand your sales")
                        Text("• Dedicated seller support")
                    }
                    .foregroundColor(.gray)
                }

                // Terms and Conditions
                VStack(alignment: .leading, spacing: 8) {
                    Text("Terms and Conditions")
                        .font(.title2)
                        .bold()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("By listing products on LocalCart, you agree to:")
                            .bold()
                        VStack(alignment: .leading, spacing: 6) {
                            Text("• Provide accurate product information and pricing")
                            Text("• Fulfill orders on time and maintain product quality")
                            Text("• Comply with local laws and regulations for your business")
                            Text("• Only sell items you have the right to sell")
                            Text("• Respect customer data and privacy")
                        }
                        .foregroundColor(.gray)
                        Text("LocalCart may remove listings that violate our policies. Fees and payout schedules are subject to change with notice.")
                            .foregroundColor(.gray)
                    }
                }

                // Agreement toggle
                Toggle(isOn: $hasAgreedToTerms) {
                    Text("I have read and agree to the Terms and Conditions")
                }
                .padding(.top, 8)

                // Continue button
                NavigationLink(destination: SellerDashboardView(), isActive: $navigateToSell) {
                    EmptyView()
                }
                Button(action: {
                    if hasAgreedToTerms {
                        navigateToSell = true
                    }
                }) {
                    Text(hasAgreedToTerms ? "Continue" : "Agree to continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(hasAgreedToTerms ? Color.orange : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!hasAgreedToTerms)
            }
            .padding()
        }
        .navigationTitle("Seller Terms")
    }
}

struct SellTermsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SellTermsView()
        }
    }
}


