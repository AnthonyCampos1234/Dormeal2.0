struct RestaurantMenu: Codable, Identifiable {
    let id: String
    let restaurantName: String
    let logo: String
    let location: String
    let categories: [String]
    let menu: [MenuItem]
    
    static var example: RestaurantMenu {
        RestaurantMenu(
            id: "1",
            restaurantName: "Burger Haven",
            logo: "https://example.com/burger-haven-logo.jpg",
            location: "123 College Ave",
            categories: ["American", "Burgers", "Fast Food"],
            menu: [
                MenuItem(id: "1-1", name: "Classic Burger", price: 8.99, description: "Fresh beef patty with lettuce, tomato, and special sauce", category: "Burgers")
            ]
        )
    }
}

struct MenuItem: Codable, Identifiable {
    let id: String
    let name: String
    let price: Double
    let description: String
    let category: String
} 