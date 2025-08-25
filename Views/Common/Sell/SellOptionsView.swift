import SwiftUI

struct SellOptionsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 16) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                        .padding(.top, 16)

                    Text("RiseLocal")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color.blue)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("How about you start selling and making some money ??")
                        .font(.title3)
                    Text("Right!!!!!")
                        .font(.headline)
                        .padding(.top, 4)
                }

                VStack(spacing: 20) {
                    NavigationLink(destination: SellView()) {
                        Text("Sell Item")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(14)
                    }

                    NavigationLink(destination: HypeBoostView()) {
                        Text("HypeBoost")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(14)
                    }

                    NavigationLink(destination: MyAdvertsView()) {
                        Text("My Adverts")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(14)
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Sell Options")
    }
}

struct SellOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SellOptionsView()
        }
    }
}


