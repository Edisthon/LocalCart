import FirebaseFirestore

class FirestoreManager {
    private let db = Firestore.firestore()

    func addProductToCart(name: String, price: Double) {
        db.collection("cartItems").addDocument(data: [
            "name": name,
            "price": price,
            "timestamp": Timestamp()
        ]) { error in
            if let error = error {
                print("Error saving: \(error)")
            } else {
                print("Product saved to Firestore ✅")
            }
        }
    }
}
