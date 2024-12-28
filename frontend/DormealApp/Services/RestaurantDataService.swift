import Foundation

class RestaurantDataService {
    static func loadRestaurantData() -> [RestaurantMenu] {
        return [
            RestaurantMenu(
                id: "1",
                restaurantName: "Panda Express",
                logo: "https://example.com/panda-logo.jpg",
                location: "Price Center",
                categories: ["Chinese", "Asian"],
                menu: [
                    MenuItem(
                        id: "1-1",
                        name: "Orange Chicken",
                        price: 12.99,
                        description: "Crispy chicken wok-tossed in our signature sweet and spicy orange sauce",
                        category: "Entrees",
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
                            )
                        ]
                    )
                ]
            ),
            RestaurantMenu(
                id: "2",
                restaurantName: "Subway",
                logo: "https://example.com/subway-logo.jpg",
                location: "Price Center",
                categories: ["Sandwiches", "Fast Food"],
                menu: [
                    MenuItem(
                        id: "2-1",
                        name: "Italian BMT",
                        price: 9.99,
                        description: "The classic Italian sub with pepperoni, salami, and ham",
                        category: "Subs",
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
                    )
                ]
            )
        ]
    }
}

struct RestaurantsResponse: Codable {
    let restaurants: [RestaurantMenu]
} 