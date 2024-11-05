// Basic structures
struct School: Codable {
    let id: String
    let name: String
}

struct Building: Codable {
    let id: String
    let name: String
    let location: String
}

struct User: Codable {
    let id: String
    let homeBuilding: Building
    let name: String
    let phoneNumber: String
}

// Menu-related structures
struct RestaurantMenu: Codable {
    let id: String
    let restaurantName: String
    let location: String
    let logo: String
    let sections: [MenuSection]
    let schools: [School]
}

struct MenuSection: Codable {
    let id: String
    let name: String
    let items: [Item]
}

struct Item: Codable {
    let id: String
    let name: String
    let basePrice: Double
    let addonsSections: [AddonsSection]
    let additionalsSections: [AdditionalsSection]
    let choicesSections: [ChoicesSection]
    let icon: String
}

struct AddonsSection: Codable {
    let id: String
    let name: String
    let addons: [Addon]
    let limit: Int
}

struct Addon: Codable {
    let id: String
    let name: String
    let price: Double
}

struct ChoicesSection: Codable {
    let id: String
    let name: String
    let choices: [Choice]
}

struct Choice: Codable {
    let id: String
    let name: String
    let price: Double
}

struct AdditionalsSection: Codable {
    let id: String
    let items: [Item]
}

// Order-related structures
struct Order: Codable {
    let id: String
    let cart: Cart
    let building: Building
    let carrier: Carrier?
    let status: String
    let user: User?
    let location: String
    let totalPrice: Double
}

struct Cart: Codable {
    let id: String
    let menu: RestaurantMenu
    var items: [Item]
    var totalPrice: Double
}

struct Carrier: Codable {
    let id: String
    let user: User
    let currentLocation: String
    let orders: [Order]
} 