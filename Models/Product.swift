import Foundation

struct Product: Identifiable, Hashable{
    var id = UUID()
    var name: String
    var price: Double
    var category: String
    var description: String
    var imageName: String
    
    // Optional enriched details (defaulted to allow existing initializers to work)
    var calories: Int? = nil
    var servingSize: String? = nil
    var ingredients: [String]? = nil
    var allergens: [String]? = nil
    var precautions: [String]? = nil
    var materials: [String]? = nil
    var dimensions: String? = nil
    var origin: String? = nil
    var careInstructions: [String]? = nil
}

// Adding more products for each category

let sampleProducts: [Product] = [
    // Food Category
    Product(
        name: "Pasta",
        price: 3500,
        category: "Food",
        description: "Delicious Italian-style pasta made from premium durum wheat.",
        imageName: "food_pasta",
        calories: 420,
        servingSize: "1 plate (250 g)",
        ingredients: ["Durum wheat", "Tomato", "Basil", "Olive oil", "Garlic"],
        allergens: ["Gluten"],
        precautions: ["Contains gluten. Not suitable for celiac diet."]
    ),
    Product(
        name: "Fruits",
        price: 5000,
        category: "Food",
        description: "A colorful mix of fresh, seasonal fruits, handpicked for quality.",
        imageName: "food_fruits",
        calories: 180,
        servingSize: "1 bowl (300 g)",
        ingredients: ["Mango", "Pineapple", "Banana", "Apple"],
        precautions: ["Wash thoroughly before eating."]
    ),
    Product(
        name: "Burrito",
        price: 6500,
        category: "Food",
        description: "Soft tortilla filled with fresh ingredients, perfect for a quick meal.",
        imageName: "food_buritto",
        calories: 560,
        servingSize: "1 wrap (300 g)",
        ingredients: ["Tortilla", "Beans", "Rice", "Beef", "Cheese"],
        allergens: ["Gluten", "Dairy"],
        precautions: ["Contains dairy and gluten."]
    ),
    Product(
        name: "Fresh Strawberries",
        price: 3000,
        category: "Food",
        description: "Juicy and sweet strawberries, freshly harvested from local farms.",
        imageName: "food_strawberries",
        calories: 48,
        servingSize: "1 cup (150 g)",
        precautions: ["Rinse before consumption."]
    ),
    Product(
        name: "Chocolate Chip Cookies",
        price: 1000,
        category: "Food",
        description: "Crispy on the outside, chewy on the inside, loaded with chocolate chips.",
        imageName: "food_chocos",
        calories: 220,
        servingSize: "2 cookies (50 g)",
        ingredients: ["Wheat flour", "Sugar", "Chocolate chips", "Butter", "Eggs"],
        allergens: ["Gluten", "Dairy", "Eggs"],
        precautions: ["May contain traces of nuts."]
    ),
    Product(
        name: "Beef Stew",
        price: 3000,
        category: "Food",
        description: "Hearty beef stew slow-cooked with fresh vegetables and spices.",
        imageName: "food_beef",
        calories: 480,
        servingSize: "1 bowl (300 g)",
        ingredients: ["Beef", "Carrots", "Potatoes", "Onions", "Tomatoes"],
        precautions: ["Contains bones fragments rarely; chew with care."]
    ),


    // Drinks Category
    Product(
        name: "Herbal Tea",
        price: 3000,
        category: "Drinks",
        description: "A soothing blend of herbs and natural ingredients.",
        imageName: "drinks_tea",
        calories: 2,
        servingSize: "1 cup (240 ml)",
        ingredients: ["Lemongrass", "Chamomile", "Mint"],
        precautions: ["If pregnant or nursing, consult a doctor before consuming herbal blends."]
    ),
    Product(
        name: "Fresh Juice",
        price: 3500,
        category: "Drinks",
        description: "Cold-pressed juice made from fresh local fruits.",
        imageName: "drinks_juice",
        calories: 120,
        servingSize: "1 bottle (300 ml)",
        ingredients: ["Orange", "Pineapple", "Passion fruit"],
        precautions: ["Keep refrigerated. Best consumed within 24 hours."]
    ),
    Product(
        name: "Coffee Beans",
        price: 10000,
        category: "Drinks",
        description: "Organic, freshly roasted coffee beans for the perfect brew.",
        imageName: "drinks_coffee",
        precautions: ["High caffeine content. Limit intake during late hours."]
    ),
    Product(
        name: "Sparkling Water",
        price: 2000,
        category: "Drinks",
        description: "Refreshing sparkling water with natural mineral essence.",
        imageName: "drinks_water",
        calories: 0,
        servingSize: "1 bottle (500 ml)",
        precautions: ["Carbonated beverage may cause bloating in sensitive individuals."]
    ),    
    
    // Beauty & Accessories Category
    Product(
        name: "Handmade Soap",
        price: 4000,
        category: "Beauty & Accessories",
        description: "All-natural handmade soap with essential oils.",
        imageName: "beauty_soap",
        ingredients: ["Shea butter", "Olive oil", "Coconut oil", "Lavender oil"],
        materials: ["Plant oils"],
        careInstructions: ["Keep dry between uses", "Store in a cool place"],
        precautions: ["Patch test before first use", "Avoid contact with eyes"]
    ),
    Product(
        name: "Beaded Necklace",
        price: 17000,
        category: "Beauty & Accessories",
        description: "Handcrafted beaded necklace for a stylish look.",
        imageName: "beauty_necklace",
        materials: ["Glass beads", "Strong nylon thread"],
        careInstructions: ["Avoid water exposure", "Store separately to prevent scratches"],
        origin: "Made in Rwanda"
    ),
    Product(
        name: "Organic Lip Balm",
        price: 3000,
        category: "Beauty & Accessories",
        description: "Moisturizing lip balm made from organic ingredients.",
        imageName: "beauty_lipbalm",
        ingredients: ["Beeswax", "Shea butter", "Cocoa butter", "Vitamin E"],
        precautions: ["Contains beeswax; not suitable for those with bee product allergies"]
    ),
    Product(
        name: "Handmade Earrings",
        price: 13500,
        category: "Beauty & Accessories",
        description: "Unique handmade earrings that add elegance to any outfit.",
        imageName: "beauty_earrings",
        materials: ["Alloy metal", "Glass"],
        careInstructions: ["Wipe with soft cloth", "Avoid perfumes and lotions"]
    ),
    
    // Interior Designs Category
    Product(
        name: "Decorative Vase",
        price: 13000,
        category: "Interior Designs",
        description: "A beautifully crafted vase to decorate your space.",
        imageName: "interior_vase",
        materials: ["Ceramic"],
        dimensions: "30 cm (h) x 12 cm (w)",
        origin: "Kigali, Rwanda",
        careInstructions: ["Wipe with a dry cloth"]
    ),
    Product(
        name: "Handmade Rugs",
        price: 45000,
        category: "Interior Designs",
        description: "Locally made rugs with intricate designs and craftsmanship.",
        imageName: "interior_rugs",
        materials: ["Wool"],
        dimensions: "2.0 m x 1.5 m",
        origin: "Gisenyi, Rwanda",
        careInstructions: ["Vacuum weekly", "Spot clean with mild detergent"]
    ),
    Product(
        name: "Ceramic Pottery",
        price: 20000,
        category: "Interior Designs",
        description: "Handmade ceramic pottery with modern designs.",
        imageName: "interior_pottery",
        materials: ["Ceramic"],
        origin: "Huye, Rwanda",
        careInstructions: ["Handle with care", "Avoid sudden temperature changes"]
    ),
    Product(
        name: "Wall Art",
        price: 35000,
        category: "Interior Designs",
        description: "Beautiful and unique art to enhance any room.",
        imageName: "interior_wallart",
        materials: ["Canvas", "Acrylic paint"],
        dimensions: "60 cm x 90 cm",
        origin: "Kigali, Rwanda",
        careInstructions: ["Keep away from direct sunlight"]
    )
]

