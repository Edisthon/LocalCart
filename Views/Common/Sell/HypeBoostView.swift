import SwiftUI

struct HypeBoostView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("HypeBoost")
                .font(.largeTitle)
                .bold()
            Text("Promote your listings to reach more local buyers. Coming soon.")
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .navigationTitle("HypeBoost")
    }
}

struct HypeBoostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HypeBoostView()
        }
    }
}


