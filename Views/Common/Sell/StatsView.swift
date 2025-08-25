import SwiftUI

struct StatsView: View {
    var body: some View {
        VStack(spacing: 16) {
            statRow(title: "Items sold", value: "0")
            statRow(title: "Revenue", value: "US$0")
            Spacer()
        }
        .padding()
        .navigationTitle("Stats")
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).bold()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { StatsView() }
    }
}


