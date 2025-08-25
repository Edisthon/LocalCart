import SwiftUI
import Firebase

@main
struct LocalCartApp: App {
     
    
    init() {
        FirebaseApp.configure()
        print("firebase configured successful")
    }

    var body: some Scene {
        WindowGroup {
            WelcomeHomePageView()
                
        }	    }
}
