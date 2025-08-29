import SwiftUI
import Firebase

@main
struct LocalCartApp: App {
    @StateObject private var store = ProductStore()
    
    init() {
        FirebaseApp.configure()
        print("firebase configured successful")
    }

    var body: some Scene {
        WindowGroup {
            WelcomeHomePageView()
                .environmentObject(store)
        }
    }
}
