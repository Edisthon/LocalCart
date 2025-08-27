import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SellView: View {
    @StateObject private var store = ProductStore()
    @State private var productName: String = ""
    @State private var selectedCategory: ListingCategory = .drinks
    @State private var descriptionText: String = ""
    @State private var priceText: String = ""
    @State private var locationText: String = ""

    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []

    private let maxPhotos: Int = 4

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Upload items(Max \(maxPhotos) pictures)")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                // Image grid and picker
                imagesSection

                labeledField(title: "Item Name") {
                    TextField("e.g. Air Jordan 1", text: $productName)
                        .textFieldStyle(.roundedBorder)
                }

                labeledField(title: "Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ListingCategory.allCases, id: \.self) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                labeledField(title: "Description") {
                    TextField("Describe your item", text: $descriptionText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3, reservesSpace: true)
                }

                labeledField(title: "Price") {
                    TextField("e.g. 30,000 frw", text: $priceText)
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(.roundedBorder)
                }

                labeledField(title: "Location") {
                    TextField("e.g. Downtown, Nyarugenge", text: $locationText)
                        .textFieldStyle(.roundedBorder)
                }

                NavigationLink(destination: MyAdvertsView(), isActive: $navigateToAdverts) { EmptyView() }
                Button(action: onAdvertise) {
                    Text("UPLOAD")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isUploading ? Color.gray : Color.blue)
                        .cornerRadius(16)
                }
                .disabled(isUploading)
                .padding(.vertical, 16)
                .alert("Upload Complete", isPresented: $showSuccessAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Your product has been uploaded successfully.")
                }
                .alert("Upload Failed", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage)
                }
            }
            .padding()
        }
        .navigationTitle("Sell")
    }

    private var imagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Selected images grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(selectedImages.indices, id: \.self) { index in
                    Image(uiImage: selectedImages[index])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipped()
                        .cornerRadius(8)
                }
            }

            PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: maxPhotos, matching: .images) {
                HStack {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                    Text(selectedImages.isEmpty ? "Select photos" : "Add/Change photos")
                        .foregroundColor(.blue)
                    Spacer()
                }
                .padding(.vertical, 6)
            }
            .onChange(of: selectedPhotoItems) { newItems in
                loadSelectedImages(from: newItems)
            }
        }
    }

    private func labeledField<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .bold()
            content()
        }
    }

    private func loadSelectedImages(from items: [PhotosPickerItem]) {
        Task {
            var images: [UIImage] = []
            for item in items.prefix(maxPhotos) {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                }
            }
            selectedImages = images
        }
    }

    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isUploading: Bool = false
    @State private var navigateToAdverts: Bool = false

    private func onAdvertise() {
        let priceValue = Double(priceText.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")) ?? 0
        isUploading = true
        Task {
            do {
                try await store.uploadListing(name: productName.isEmpty ? "Untitled" : productName,
                                               description: descriptionText,
                                               price: priceValue,
                                               location: locationText,
                                               category: selectedCategory,
                                               images: selectedImages)
                isUploading = false
                showSuccessAlert = true
                navigateToAdverts = true
            } catch {
                isUploading = false
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}
struct SellView_Previews: PreviewProvider {
    static var previews: some View {
        SellView()
            }
}
//
//  SellView.swift
//  LocalCart
//
//  Created by Umurava Monday on 05/05/2025.
//

