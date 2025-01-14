import Foundation

// Restaurant and Menu Models
struct Restaurant: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let website: String
    let imageUrl: String
    let operatingHours: OperatingHours
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case website
        case imageUrl = "image_url"
        case operatingHours = "operating_hours"
    }
}

struct OperatingHours: Codable {
    let monday: Hours
    let tuesday: Hours
    let wednesday: Hours
    let thursday: Hours
    let friday: Hours
    let saturday: Hours
    let sunday: Hours
}

struct Hours: Codable {
    let open: String
    let close: String
}

// Menu Section and Items
struct MenuSection: Codable, Identifiable {
    let id: String
    let name: String
    let imageUrl: String
    let items: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "section_id"
        case name = "section_name"
        case imageUrl = "section_image"
        case items
    }
}

struct MenuItem: Codable, Identifiable {
    let id: String
    let name: String
    let price: Double
    let imageUrl: String
    let optionsSections: [OptionsSection]
    let addOnsSections: [AddOnsSection]
    
    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case name = "item_name"
        case price
        case imageUrl = "image_link"
        case optionsSections = "options_sections"
        case addOnsSections = "add_ons_sections"
    }
}

struct OptionsSection: Codable {
    let id: String
    let name: String
    let mandatory: Bool
    let options: [Option]
    
    enum CodingKeys: String, CodingKey {
        case id = "section_id"
        case name = "section_name"
        case mandatory
        case options
    }
}

struct Option: Codable, Identifiable {
    let id: String
    let name: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "option_id"
        case name = "option_name"
        case price
    }
}

struct AddOnsSection: Codable {
    let id: String
    let name: String
    let maxAddOns: Int
    let addOns: [AddOn]
    
    enum CodingKeys: String, CodingKey {
        case id = "section_id"
        case name = "section_name"
        case maxAddOns = "max_add_ons"
        case addOns = "add_ons"
    }
}

struct AddOn: Codable, Identifiable {
    let id: String
    let name: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "add_on_id"
        case name = "add_on_name"
        case price
    }
}

// User and Authentication
struct User: Codable {
    let id: String
    let homeBuilding: Building
    let name: String
    let phoneNumber: String
}

struct Building: Codable {
    let id: String
    let name: String
    let location: String
}

// Cart and Order
struct Cart: Codable {
    let id: String
    let restaurant: Restaurant
    var items: [CartItem]
    var totalPrice: Double
}

struct CartItem: Codable, Identifiable {
    let id: String
    let menuItem: MenuItem
    var quantity: Int
    var selectedOptions: [String: String] // sectionId: optionId
    var selectedAddOns: Set<String> // addOnIds
    var itemTotal: Double
}

enum DeliveryMethod: String, Codable {
    case handoff
    case dropoff
    case meetAtDoor = "meet-at-door"
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
    var deliveryMethod: DeliveryMethod
    let createdAt: Date
}

struct Carrier: Codable {
    let id: String
    let user: User
    let currentLocation: String
    let orders: [Order]
}

struct CarrierStatus: Codable {
    let isCarrier: Bool
    let verificationStatus: String
    
    enum CodingKeys: String, CodingKey {
        case isCarrier = "is_carrier"
        case verificationStatus = "verification_status"
    }
}

struct SchoolEmailSuffix: Codable {
    let emailSuffix: String
    
    enum CodingKeys: String, CodingKey {
        case emailSuffix = "email_suffix"
    }
}

struct EmailVerificationRequest: Codable {
    let email: String
}

struct EmailVerificationResponse: Codable {
    let message: String
}

struct EmailVerificationTokenRequest: Codable {
    let token: String
}

struct EmailVerificationTokenResponse: Codable {
    let message: String
}

struct AvailableOrder: Codable, Identifiable {
    let id: Int
    let restaurant: String
    let orderSummary: String
    let moneyToBeMade: Double
    let deliveryLocation: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case restaurant
        case orderSummary = "order_summary"
        case moneyToBeMade = "money_to_be_made"
        case deliveryLocation = "delivery_location"
    }
}

struct AvailableOrdersResponse: Codable {
    let orders: [AvailableOrder]
}

enum OrderStatus: String, Codable {
    case pending = "pending"
    case claimed = "claimed"
    case pickedUp = "picked_up"
    case delivered = "delivered"
    case cancelled = "cancelled"
}

enum ExchangeType: String, Codable {
    case dropOff = "drop-off"
    case meetAtDoor = "meet-at-door"
}

struct OrderDetailsResponse: Codable {
    let statusCode: Int
    let orderStatus: OrderStatus
    let exchangeType: ExchangeType
    let orderId: String
    let restaurant: String
    let restaurantLocation: String
    let deliveryLocation: String
    let customerName: String?
    let earnings: Double
    let orderCode: String
    let foodDetails: [DetailedOrderItem]
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case orderStatus = "order_status"
        case exchangeType = "exchange_type"
        case orderId = "order_id"
        case restaurant
        case restaurantLocation = "restaurant_location"
        case deliveryLocation = "delivery_location"
        case customerName = "customer_name"
        case earnings
        case orderCode = "order_code"
        case foodDetails = "food_details"
    }
}

struct DetailedOrderItem: Codable, Identifiable {
    let itemId: String
    let itemName: String
    let price: Double
    let imageLink: String
    let quantity: Int
    let optionsSections: [DetailedOptionsSection]
    let addOnsSections: [DetailedAddOnsSection]
    
    var id: String { itemId }
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case itemName = "item_name"
        case price
        case imageLink = "image_link"
        case quantity
        case optionsSections = "options_sections"
        case addOnsSections = "add_ons_sections"
    }
}

struct DetailedOptionsSection: Codable {
    let sectionId: String
    let sectionName: String
    let selectedOption: DetailedOption
    
    enum CodingKeys: String, CodingKey {
        case sectionId = "section_id"
        case sectionName = "section_name"
        case selectedOption = "selected_option"
    }
}

struct DetailedOption: Codable {
    let optionId: String
    let optionName: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case optionId = "option_id"
        case optionName = "option_name"
        case price
    }
}

struct DetailedAddOnsSection: Codable {
    let sectionId: String
    let sectionName: String
    let selectedAddOns: [DetailedAddOn]
    
    enum CodingKeys: String, CodingKey {
        case sectionId = "section_id"
        case sectionName = "section_name"
        case selectedAddOns = "selected_add_ons"
    }
}

struct DetailedAddOn: Codable {
    let addOnId: String
    let addOnName: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case addOnId = "add_on_id"
        case addOnName = "add_on_name"
        case price
    }
}

struct ClaimOrderRequest: Codable {
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

struct ClaimOrderResponse: Codable {
    let message: String
}

struct OrderStatusResponse: Codable {
    let orderStatus: Int
    let exchangeType: Int
    
    enum CodingKeys: String, CodingKey {
        case orderStatus = "order_status"
        case exchangeType = "exchange_type"
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case notFound
    case serverError
    case networkError
    case unexpectedStatusCode(Int)
    case invalidEmail
    case invalidSchoolEmail
    case invalidVerificationCode
    case orderAlreadyClaimed
    case orderAlreadyComplete
    case pushNotificationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .notFound:
            return "Not found"
        case .serverError:
            return "Server error"
        case .networkError:
            return "Network error"
        case .unexpectedStatusCode(let code):
            return "Unexpected status code: \(code)"
        case .invalidEmail:
            return "Invalid email format."
        case .invalidSchoolEmail:
            return "The provided school email does not match any known school in the database."
        case .invalidVerificationCode:
            return "The verification code is incorrect."
        case .orderAlreadyClaimed:
            return "Order cannot be claimed. It may have already been taken."
        case .orderAlreadyComplete:
            return "Order is already complete."
        case .pushNotificationFailed:
            return "Unable to send push notification."
        }
    }
}

extension Order {
    static var sampleOrder: Order {
        let restaurant = Restaurant(
            id: "r1",
            name: "Sample Restaurant",
            address: "123 Main St",
            website: "example.com",
            imageUrl: "https://example.com/image.jpg",
            operatingHours: OperatingHours(
                monday: Hours(open: "09:00:00", close: "22:00:00"),
                tuesday: Hours(open: "09:00:00", close: "22:00:00"),
                wednesday: Hours(open: "09:00:00", close: "22:00:00"),
                thursday: Hours(open: "09:00:00", close: "22:00:00"),
                friday: Hours(open: "09:00:00", close: "22:00:00"),
                saturday: Hours(open: "10:00:00", close: "23:00:00"),
                sunday: Hours(open: "10:00:00", close: "21:00:00")
            )
        )
        
        let menuItem = MenuItem(
            id: "m1",
            name: "Sample Item",
            price: 9.99,
            imageUrl: "https://example.com/item.jpg",
            optionsSections: [],
            addOnsSections: []
        )
        
        let cartItem = CartItem(
            id: "ci1",
            menuItem: menuItem,
            quantity: 1,
            selectedOptions: [:],
            selectedAddOns: Set(),
            itemTotal: 9.99
        )
        
        return Order(
            id: "o1",
            cart: Cart(
                id: "c1",
                restaurant: restaurant,
                items: [cartItem],
                totalPrice: 9.99
            ),
            building: Building(
                id: "b1",
                name: "Sample Building",
                location: "Sample Location"
            ),
            carrier: nil,
            status: "pending",
            user: nil,
            location: "Room 123",
            totalPrice: 9.99,
            carrierPayout: 3.99,
            deliveryMethod: .dropoff,
            createdAt: Date()
        )
    }
    
    static var sampleHandoffOrder: Order {
        var order = sampleOrder
        order.deliveryMethod = .handoff
        return order
    }
}

struct OrderPickupRequest: Codable {
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

struct OrderPickupResponse: Codable {
    let message: String
}

struct OrderNearbyRequest: Codable {
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

struct OrderNearbyResponse: Codable {
    let message: String
}

struct OrderDropoffRequest: Codable {
    let userId: String
    let photoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case photoUrl = "photo_url"
    }
}

struct OrderDropoffResponse: Codable {
    let message: String
}

struct OrderAtExchangePointRequest: Codable {
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

struct OrderAtExchangePointResponse: Codable {
    let message: String
}

struct OrderConfirmReceivedRequest: Codable {
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

struct OrderConfirmReceivedResponse: Codable {
    let message: String
}

struct CarrierOrder: Codable, Identifiable {
    let id: String
    let restaurant: String
    let orderSummary: String
    let moneyToBeMade: Double
    let deliveryLocation: String
    let orderStatus: String
    let exchangeType: String
    let timePlaced: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case restaurant
        case orderSummary = "order_summary"
        case moneyToBeMade = "money_to_be_made"
        case deliveryLocation = "delivery_location"
        case orderStatus = "order_status"
        case exchangeType = "exchange_type"
        case timePlaced = "time_placed"
    }
}

struct CarrierOrdersResponse: Codable {
    let activeOrders: [CarrierOrder]
    let completedOrders: [CarrierOrder]
    
    enum CodingKeys: String, CodingKey {
        case activeOrders = "active_orders"
        case completedOrders = "completed_orders"
    }
} 