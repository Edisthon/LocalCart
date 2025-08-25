import SwiftUI

struct PaymentsView: View {
    var body: some View {
        List {
            Text("Connect payout method")
        }
        .navigationTitle("Payments")
    }
}

struct PaymentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { PaymentsView() }
    }
}


