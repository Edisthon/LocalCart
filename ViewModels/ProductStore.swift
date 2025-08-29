import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

enum ListingCategory: String, CaseIterable, Codable, Hashable {
    case food = "Food"
    case drinks = "Drinks"
    case interior = "Interior Designs"
    case beauty = "Beauty & Accessories"
    var displayName: String { rawValue }
}

struct Listing: Identifiable, Codable, Hashable {
    var id: String
    var userId: String
    var name: String
    var description: String
    var price: Double
    var location: String
    var category: String
    var imageURLs: [String]
    var createdAt: Date
    var sold: Bool
}

final class ProductStore: ObservableObject {
    @Published var userListings: [Listing] = []
    @Published var foodListings: [Listing] = []
    @Published var drinksListings: [Listing] = []
    @Published var beautyListings: [Listing] = []
    @Published var interiorListings: [Listing] = []

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    func fetchUserListings() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("listings")
            .whereField("userId", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self?.userListings = documents.compactMap { Self.mapListing($0) }
            }
    }

    func fetchFoodListings() {
        db.collection("listings")
            .whereField("category", isEqualTo: ListingCategory.food.displayName)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self?.foodListings = documents.compactMap { Self.mapListing($0) }
            }
    }

    func fetchDrinksListings() {
        db.collection("listings")
            .whereField("category", isEqualTo: ListingCategory.drinks.displayName)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self?.drinksListings = documents.compactMap { Self.mapListing($0) }
            }
    }

    func fetchBeautyListings() {
        db.collection("listings")
            .whereField("category", isEqualTo: ListingCategory.beauty.displayName)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self?.beautyListings = documents.compactMap { Self.mapListing($0) }
            }
    }

    func fetchInteriorListings() {
        db.collection("listings")
            .whereField("category", isEqualTo: ListingCategory.interior.displayName)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self?.interiorListings = documents.compactMap { Self.mapListing($0) }
            }
    }

    func uploadListing(name: String,
                       description: String,
                       price: Double,
                       location: String,
                       category: ListingCategory,
                       images: [UIImage]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not signed in"]) }

        // Upload images to Storage
        var urls: [String] = []
        for (index, image) in images.enumerated() {
            let path = "productImages/\(uid)/\(UUID().uuidString)_\(index).jpg"
            let ref = storage.reference(withPath: path)
            guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
            _ = try await ref.putDataAsync(data, metadata: nil)
            let url = try await ref.downloadURL()
            urls.append(url.absoluteString)
        }

        // Create Firestore document
        _ = try await db.collection("listings").addDocument(data: [
            "userId": uid,
            "name": name,
            "description": description,
            "price": price,
            "location": location,
            "category": category.displayName,
            "imageURLs": urls,
            "createdAt": FieldValue.serverTimestamp(),
            "sold": false
        ])
    }

    func deleteListing(listingID: String) {
        db.collection("listings").document(listingID).delete { [weak self] error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                self?.userListings.removeAll { $0.id == listingID }
            }
        }
    }

    var earnings: Double {
        userListings.filter { $0.sold }.reduce(0) { $0 + $1.price }
    }

    private static func mapListing(_ doc: QueryDocumentSnapshot) -> Listing? {
        let data = doc.data()
        guard let userId = data["userId"] as? String,
              let name = data["name"] as? String,
              let description = data["description"] as? String,
              let price = data["price"] as? Double,
              let location = data["location"] as? String,
              let category = data["category"] as? String,
              let imageURLs = data["imageURLs"] as? [String],
              let sold = data["sold"] as? Bool else { return nil }

        let createdAt: Date
        if let ts = data["createdAt"] as? Timestamp { createdAt = ts.dateValue() } else { createdAt = Date() }

        return Listing(id: doc.documentID,
                       userId: userId,
                       name: name,
                       description: description,
                       price: price,
                       location: location,
                       category: category,
                       imageURLs: imageURLs,
                       createdAt: createdAt,
                       sold: sold)
    }
}


