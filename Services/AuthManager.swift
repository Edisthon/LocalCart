import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()

    func signInAnonymously(completion: @escaping (String?) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Auth error: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(authResult?.user.uid)
            }
        }
    }
}
