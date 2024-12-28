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
                MenuItem(
                    id: "1-1", 
                    name: "BMT",
                    price: 8.99,
                    description: "Classic BMT sandwich with fresh vegetables",
                    category: "Sandwiches",
                    imageUrl: "https://example.com/bmt.jpg",
                    optionGroups: [
                        MenuItemOptionGroup(
                            id: "bread",
                            name: "Choose your bread",
                            required: true,
                            multiSelect: false,
                            minSelections: 1,
                            maxSelections: 1,
                            options: [
                                MenuItemOption(id: "italian", name: "Italian", price: 0),
                                MenuItemOption(id: "wheat", name: "Wheat", price: 0),
                                MenuItemOption(id: "herbs", name: "Herbs & Cheese", price: 0)
                            ]
                        ),
                        MenuItemOptionGroup(
                            id: "veggies",
                            name: "Vegetables",
                            required: false,
                            multiSelect: true,
                            minSelections: 0,
                            maxSelections: 6,
                            options: [
                                MenuItemOption(id: "lettuce", name: "Lettuce", price: 0),
                                MenuItemOption(id: "tomato", name: "Tomatoes", price: 0),
                                MenuItemOption(id: "cucumber", name: "Cucumbers", price: 0),
                                MenuItemOption(id: "onion", name: "Onions", price: 0)
                            ]
                        )
                    ]
                ),
                MenuItem(
                    id: "1-2",
                    name: "Orange Chicken",
                    price: 10.99,
                    description: "Crispy chicken in sweet orange sauce",
                    category: "Chinese",
                    imageUrl: "https://example.com/orange-chicken.jpg",
                    optionGroups: [
                        MenuItemOptionGroup(
                            id: "rice",
                            name: "Choose your rice",
                            required: true,
                            multiSelect: false,
                            minSelections: 1,
                            maxSelections: 1,
                            options: [
                                MenuItemOption(id: "white", name: "White Rice", price: 0),
                                MenuItemOption(id: "brown", name: "Brown Rice", price: 0),
                                MenuItemOption(id: "fried", name: "Fried Rice", price: 1.50)
                            ]
                        ),
                        MenuItemOptionGroup(
                            id: "sides",
                            name: "Add sides",
                            required: false,
                            multiSelect: true,
                            minSelections: 0,
                            maxSelections: 3,
                            options: [
                                MenuItemOption(id: "eggroll", name: "Egg Roll", price: 1.99),
                                MenuItemOption(id: "soup", name: "Hot & Sour Soup", price: 2.99),
                                MenuItemOption(id: "rangoon", name: "Crab Rangoon", price: 3.99)
                            ]
                        )
                    ]
                )
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
    let imageUrl: String
    let optionGroups: [MenuItemOptionGroup]
}

struct MenuItemOptionGroup: Codable, Identifiable {
    let id: String
    let name: String
    let required: Bool
    let multiSelect: Bool
    let minSelections: Int
    let maxSelections: Int
    let options: [MenuItemOption]
}

struct MenuItemOption: Codable, Identifiable {
    let id: String
    let name: String
    let price: Double
} 