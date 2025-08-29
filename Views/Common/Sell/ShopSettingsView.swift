import SwiftUI

struct ShopSettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("Shop")) {
                Text("Shop name")
                Text("Bio")
            }
            Section(header: Text("Manage Products")) {
                NavigationLink(destination: ManageProductsView()) {
                    Text("Delete Products")
                }
            }
            Section(header: Text("Notifications")) {
                Toggle("Offers", isOn: .constant(true))
                Toggle("Sales", isOn: .constant(true))
            }
        }
        .navigationTitle("Shop settings")
    }
}

struct ShopSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { ShopSettingsView() }
    }
}


