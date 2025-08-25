import SwiftUI

struct ShopView: View {
    @AppStorage("username") var username: String = "User"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("🛒 Welcome to your Shop, \(username)")
                .font(.largeTitle)
                .bold()

            Text("Personalize your interest and start browsing!")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            // Categories Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Personalize your interest:")
                    .font(.title2)
                    .bold()

                // Categories buttons
                VStack(spacing: 12) {
                    NavigationLink(destination: FoodView()) {
                        CategoryButton(category: "Food")
                    }

                    NavigationLink(destination: DrinksView()) {
                        CategoryButton(category: "Drinks")
                    }

                    NavigationLink(destination: InteriorDesignsView()) {
                        CategoryButton(category: "Interior Designs")
                    }

                    NavigationLink(destination: BeautyAccessoriesView()) {
                        CategoryButton(category: "Beauty & Accessories")
                    }

                    Button(action: {
                        // Action for Explore More
                    }) {
                        Text("Explore More")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        // Action for Prefer My Feed
                    }) {
                        Text("Prefer My Feed")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Shop")
    }
}

struct CategoryButton: View {
    var category: String
    
    var body: some View {
        Text(category)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.purple)
            .cornerRadius(10)
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}

