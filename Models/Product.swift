import Foundation

struct Product: Identifiable, Hashable{
    var id = UUID()
    var name: String
    var price: Double
    var category: String
    var description: String
    var imageName: String
}

// Adding more products for each category

let sampleProducts: [Product] = [
    // Food Category
    Product(name: "Pasta", price: 3500, category: "Food", description: "Delicious Italian-style pasta made from premium durum wheat.", imageName: "food_pasta"),
    Product(name: "Fruits", price: 5000, category: "Food", description: "A colorful mix of fresh, seasonal fruits, handpicked for quality.", imageName: "food_fruits"),
    Product(name: "Burrito", price: 6500, category: "Food", description: "Soft tortilla filled with fresh ingredients, perfect for a quick meal.", imageName: "food_buritto"),
    Product(name: "Fresh Strawberries", price: 3000, category: "Food", description: "Juicy and sweet strawberries, freshly harvested from local farms.", imageName: "food_strawberries"),
    Product(name: "Chocolate Chip Cookies", price: 1000, category: "Food", description: "Crispy on the outside, chewy on the inside, loaded with chocolate chips.", imageName: "food_chocos"),
    Product(name: "Beef Stew", price: 3000, category: "Food", description: "Hearty beef stew slow-cooked with fresh vegetables and spices.", imageName: "food_beef"),


    // Drinks Category
    Product(name: "Herbal Tea", price: 299, category: "Drinks", description: "A soothing blend of herbs and natural ingredients.", imageName: "drinks_tea"),
    Product(name: "Fresh Juice", price: 3.50, category: "Drinks", description: "Cold-pressed juice made from fresh local fruits.", imageName: "drinks_juice"),
    Product(name: "Coffee Beans", price: 9.99, category: "Drinks", description: "Organic, freshly roasted coffee beans for the perfect brew.", imageName: "drinks_coffee"),
    Product(name: "Sparkling Water", price: 1.99, category: "Drinks", description: "Refreshing sparkling water with natural mineral essence.", imageName: "drinks_water"),
    
    // Beauty & Accessories Category
    Product(name: "Handmade Soap", price: 3.50, category: "Beauty & Accessories", description: "All-natural handmade soap with essential oils.", imageName: "beauty_soap"),
    Product(name: "Beaded Necklace", price: 15.00, category: "Beauty & Accessories", description: "Handcrafted beaded necklace for a stylish look.", imageName: "beauty_necklace"),
    Product(name: "Organic Lip Balm", price: 2.50, category: "Beauty & Accessories", description: "Moisturizing lip balm made from organic ingredients.", imageName: "beauty_lipbalm"),
    Product(name: "Handmade Earrings", price: 12.00, category: "Beauty & Accessories", description: "Unique handmade earrings that add elegance to any outfit.", imageName: "beauty_earrings"),
    
    // Interior Designs Category
    Product(name: "Decorative Vase", price: 12.99, category: "Interior Designs", description: "A beautifully crafted vase to decorate your space.", imageName: "interior_vase"),
    Product(name: "Handmade Rugs", price: 40.00, category: "Interior Designs", description: "Locally made rugs with intricate designs and craftsmanship.", imageName: "interior_rugs"),
    Product(name: "Ceramic Pottery", price: 20.00, category: "Interior Designs", description: "Handmade ceramic pottery with modern designs.", imageName: "interior_pottery"),
    Product(name: "Wall Art", price: 30.00, category: "Interior Designs", description: "Beautiful and unique art to enhance any room.", imageName: "interior_wallart")
]

