import Foundation

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

struct MenuSection: Codable {
    let id: String
    let name: String
    let items: [Item]
}

struct Item: Identifiable, Codable {
    let id: String
    let name: String
    let basePrice: Double
    let addonsSections: [AddonsSection]
    let additionalsSections: [AdditionalsSection]
    let choicesSections: [ChoicesSection]
    let icon: String
    var selectedOptions: [String] = [] 
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
enum DeliveryMethod: String, Codable {
    case handoff
    case dropoff
}

struct Order: Codable {
    let id: String
    let cart: Cart
    let building: Building
    let carrier: Carrier?
    let status: String
    let user: User?
    let location: String
    let totalPrice: Double
    let carrierPayout: Double
    let deliveryMethod: DeliveryMethod
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, cart, building, carrier, status, user, location, totalPrice, carrierPayout, deliveryMethod, createdAt
    }
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

