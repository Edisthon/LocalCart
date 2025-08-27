import SwiftUI

struct WelcomeView: View {
    @AppStorage("username") var username: String = "User"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welcome back, \(username) 👋")
                .font(.largeTitle)
                .bold()

            Text("Welcome to your feed! We have curated unique, locally made products tailored to your needs. What do you want to do today?")
                .font(.body)
                .foregroundColor(.gray)

            Spacer()

            VStack(spacing: 16) {
                NavigationLink(destination: ShopView()) {
                    Text("🛒 I want to shop")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }

                NavigationLink(destination: SellTermsView()) {
                    Text("🧺 I want to sell")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }

            Spacer()
        }
        .padding()
    }
}
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}


