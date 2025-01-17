import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "https://api.example.com"  // Replace with your actual base URL
    
    struct APIErrorResponse: Codable {
        let error: String
    }
    
    #if DEBUG
    var mockRestaurants: [Restaurant] = [
        Restaurant(
            id: "r1",
            name: "Burger Palace",
            address: "123 Campus Drive",
            website: "www.burgerpalace.com",
            imageUrl: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500",
            operatingHours: OperatingHours(
                monday: Hours(open: "10:00:00", close: "22:00:00"),
                tuesday: Hours(open: "10:00:00", close: "22:00:00"),
                wednesday: Hours(open: "10:00:00", close: "22:00:00"),
                thursday: Hours(open: "10:00:00", close: "22:00:00"),
                friday: Hours(open: "10:00:00", close: "23:00:00"),
                saturday: Hours(open: "11:00:00", close: "23:00:00"),
                sunday: Hours(open: "11:00:00", close: "21:00:00")
            )
        ),
        Restaurant(
            id: "r2",
            name: "Pizza Express",
            address: "456 University Ave",
            website: "www.pizzaexpress.com",
            imageUrl: "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500",
            operatingHours: OperatingHours(
                monday: Hours(open: "11:00:00", close: "23:00:00"),
                tuesday: Hours(open: "11:00:00", close: "23:00:00"),
                wednesday: Hours(open: "11:00:00", close: "23:00:00"),
                thursday: Hours(open: "11:00:00", close: "23:00:00"),
                friday: Hours(open: "11:00:00", close: "00:00:00"),
                saturday: Hours(open: "12:00:00", close: "00:00:00"),
                sunday: Hours(open: "12:00:00", close: "22:00:00")
            )
        ),
        Restaurant(
            id: "r3",
            name: "Sushi Zone",
            address: "789 College Blvd",
            website: "www.sushizone.com",
            imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500",
            operatingHours: OperatingHours(
                monday: Hours(open: "11:30:00", close: "21:30:00"),
                tuesday: Hours(open: "11:30:00", close: "21:30:00"),
                wednesday: Hours(open: "11:30:00", close: "21:30:00"),
                thursday: Hours(open: "11:30:00", close: "21:30:00"),
                friday: Hours(open: "11:30:00", close: "22:30:00"),
                saturday: Hours(open: "12:00:00", close: "22:30:00"),
                sunday: Hours(open: "12:00:00", close: "21:00:00")
            )
        )
    ]
    #endif
    
    // Fetch restaurants for a user
    func fetchRestaurants(userId: String) async throws -> [Restaurant] {
        #if DEBUG
        return mockRestaurants
        #else
        // guard let url = URL(string: "\(baseURL)/get-restaurants/\(userId)") else {
        //     throw APIError.invalidURL
        // }
        
        // let (data, response) = try await URLSession.shared.data(from: url)
        
        // guard let httpResponse = response as? HTTPURLResponse else {
        //     throw APIError.invalidResponse
        // }
        
        // switch httpResponse.statusCode {
        // case 200:
        //     return try JSONDecoder().decode([Restaurant].self, from: data)
        // case 404:
        //     throw APIError.notFound
        // case 500:
        //     throw APIError.serverError
        // default:
        //     throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        // }
        #endif
    }
    
    // Fetch menu for a restaurant
    func fetchRestaurantMenu(restaurantId: String) async throws -> [MenuSection] {
        #if DEBUG
        // Return mock menu sections based on restaurant ID
        return [
            MenuSection(
                id: "burgers",
                name: "Burgers",
                imageUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500",
                items: ["burger1", "burger2", "burger3"]
            ),
            MenuSection(
                id: "sides",
                name: "Sides",
                imageUrl: "https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?w=500",
                items: ["fries1", "rings1"]
            ),
            MenuSection(
                id: "drinks",
                name: "Drinks",
                imageUrl: "https://images.unsplash.com/photo-1437418747212-8d9709afab22?w=500",
                items: ["drink1", "drink2"]
            )
        ]
        #else
        // Your actual API implementation
        guard let url = URL(string: "\(baseURL)/restaurant-menu/\(restaurantId)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode([MenuSection].self, from: data)
        case 404:
            throw APIError.notFound
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
        #endif
    }
    
    // Fetch a specific menu item
    func fetchMenuItem(itemId: String) async throws -> MenuItem {
        #if DEBUG
        // Return mock menu items based on item ID
        let mockItems: [String: MenuItem] = [
            "burger1": MenuItem(
                id: "burger1",
                name: "Classic Cheeseburger",
                price: 8.99,
                imageUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500",
                optionsSections: [
                    OptionsSection(
                        id: "patty",
                        name: "Patty Temperature",
                        mandatory: true,
                        options: [
                            Option(id: "medium", name: "Medium", price: 0),
                            Option(id: "well", name: "Well Done", price: 0)
                        ]
                    )
                ],
                addOnsSections: [
                    AddOnsSection(
                        id: "toppings",
                        name: "Extra Toppings",
                        maxAddOns: 3,
                        addOns: [
                            AddOn(id: "bacon", name: "Bacon", price: 1.50),
                            AddOn(id: "avocado", name: "Avocado", price: 1.00)
                        ]
                    )
                ]
            ),
            "burger2": MenuItem(
                id: "burger2",
                name: "Bacon Deluxe",
                price: 10.99,
                imageUrl: "https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=500",
                optionsSections: [],
                addOnsSections: []
            ),
            "burger3": MenuItem(
                id: "burger3",
                name: "Veggie Burger",
                price: 9.99,
                imageUrl: "https://images.unsplash.com/photo-1520072959219-c595dc870360?w=500",
                optionsSections: [],
                addOnsSections: []
            ),
            "fries1": MenuItem(
                id: "fries1",
                name: "French Fries",
                price: 3.99,
                imageUrl: "https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?w=500",
                optionsSections: [
                    OptionsSection(
                        id: "size",
                        name: "Size",
                        mandatory: true,
                        options: [
                            Option(id: "regular", name: "Regular", price: 0),
                            Option(id: "large", name: "Large", price: 1.50)
                        ]
                    )
                ],
                addOnsSections: []
            ),
            "rings1": MenuItem(
                id: "rings1",
                name: "Onion Rings",
                price: 4.99,
                imageUrl: "https://images.unsplash.com/photo-1639024471283-03518883512d?w=500",
                optionsSections: [],
                addOnsSections: []
            ),
            "drink1": MenuItem(
                id: "drink1",
                name: "Soft Drink",
                price: 2.49,
                imageUrl: "https://images.unsplash.com/photo-1437418747212-8d9709afab22?w=500",
                optionsSections: [
                    OptionsSection(
                        id: "size",
                        name: "Size",
                        mandatory: true,
                        options: [
                            Option(id: "small", name: "Small", price: 0),
                            Option(id: "medium", name: "Medium", price: 0.50),
                            Option(id: "large", name: "Large", price: 1.00)
                        ]
                    )
                ],
                addOnsSections: []
            ),
            "drink2": MenuItem(
                id: "drink2",
                name: "Milkshake",
                price: 4.99,
                imageUrl: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=500",
                optionsSections: [
                    OptionsSection(
                        id: "flavor",
                        name: "Flavor",
                        mandatory: true,
                        options: [
                            Option(id: "chocolate", name: "Chocolate", price: 0),
                            Option(id: "vanilla", name: "Vanilla", price: 0),
                            Option(id: "strawberry", name: "Strawberry", price: 0)
                        ]
                    )
                ],
                addOnsSections: []
            )
        ]
        
        if let item = mockItems[itemId] {
            return item
        }
        throw APIError.notFound
        #else
        // Your actual API implementation
        guard let url = URL(string: "\(baseURL)/menu-items/\(itemId)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(MenuItem.self, from: data)
        case 404:
            throw APIError.notFound
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
        #endif
    }
    
    // Submit an order
    func submitOrder(cart: Cart, building: Building, location: String) async throws -> Order {
        guard let url = URL(string: "\(baseURL)/orders") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let orderRequest = [
            "cart": cart,
            "building": building,
            "location": location
        ] as [String : Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: orderRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(Order.self, from: data)
        case 404:
            throw APIError.notFound
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Authentication
    func login(email: String, password: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let credentials = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(credentials)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(User.self, from: data)
        case 404:
            throw APIError.notFound
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Fetch carrier orders
    func fetchCarrierOrders(userId: String) async throws -> CarrierOrdersResponse {
        guard let url = URL(string: "\(baseURL)/carrier/orders/\(userId)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(CarrierOrdersResponse.self, from: data)
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Fetch user profile
    func fetchUserProfile() async throws -> User {
        guard let url = URL(string: "\(baseURL)/user/profile") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(User.self, from: data)
        case 404:
            throw APIError.notFound
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Fetch carrier status
    func fetchCarrierStatus(userId: String) async throws -> CarrierStatus {
        guard let url = URL(string: "\(baseURL)/users/\(userId)/carrier-status") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(CarrierStatus.self, from: data)
        case 500:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Fetch school email suffix
    func fetchSchoolEmailSuffix(userId: String) async throws -> SchoolEmailSuffix {
        guard let url = URL(string: "\(baseURL)/users/\(userId)/school-email-suffix") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(SchoolEmailSuffix.self, from: data)
        case 500:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Send verification email
    func sendVerificationEmail(userId: String, email: String) async throws {
        guard let url = URL(string: "\(baseURL)/send-verification-email/\(userId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let verificationRequest = EmailVerificationRequest(email: email)
        request.httpBody = try JSONEncoder().encode(verificationRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(EmailVerificationResponse.self, from: data)
            print(response.message) // Success message if needed
        case 400:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("does not match any known school") {
                throw APIError.invalidSchoolEmail
            } else {
                throw APIError.invalidEmail
            }
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Verify email token
    func verifyEmailToken(token: String) async throws {
        guard let url = URL(string: "\(baseURL)/verify-email") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let verificationRequest = EmailVerificationTokenRequest(token: token)
        request.httpBody = try JSONEncoder().encode(verificationRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(EmailVerificationTokenResponse.self, from: data)
            print(response.message) // Success message if needed
        case 400:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("verification code is incorrect") {
                throw APIError.invalidVerificationCode
            } else {
                throw APIError.invalidResponse
            }
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Fetch available orders
    func fetchAvailableOrders(userId: String) async throws -> [AvailableOrder] {
        guard let url = URL(string: "\(baseURL)/available-orders/\(userId)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(AvailableOrdersResponse.self, from: data)
            return response.orders
        case 404:
            return [] // Return empty array for no orders
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Fetch order details
    func fetchOrderDetails(orderId: String) async throws -> OrderDetailsResponse {
        guard let url = URL(string: "\(baseURL)/order/details/\(orderId)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(OrderDetailsResponse.self, from: data)
        case 404:
            throw APIError.notFound
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Claim order
    func claimOrder(orderId: String, carrierId: String) async throws {
        guard let url = URL(string: "\(baseURL)/claim-order/\(orderId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let claimRequest = ClaimOrderRequest(userId: carrierId)
        request.httpBody = try JSONEncoder().encode(claimRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(ClaimOrderResponse.self, from: data)
            print(response.message) // Success message if needed
        case 400:
            throw APIError.orderAlreadyClaimed
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Get order status
    func getOrderStatus(orderId: String, carrierId: String? = nil) async throws -> OrderStatusResponse {
        var urlString = "\(baseURL)/get-order-status/\(orderId)"
        if let carrierId = carrierId {
            urlString += "?carrier_id=\(carrierId)"
        }
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(OrderStatusResponse.self, from: data)
        case 400:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("already complete") {
                throw APIError.orderAlreadyComplete
            } else {
                throw APIError.invalidResponse
            }
        case 500:
            throw APIError.serverError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Mark order as picked up
    func markOrderAsPickedUp(orderId: String, userId: String) async throws {
        guard let url = URL(string: "\(baseURL)/order/pickup/\(orderId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let pickupRequest = OrderPickupRequest(userId: userId)
        request.httpBody = try JSONEncoder().encode(pickupRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(OrderPickupResponse.self, from: data)
            print(response.message) // Success message if needed
        case 400:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("already complete") {
                throw APIError.orderAlreadyComplete
            } else {
                throw APIError.invalidResponse
            }
        case 500:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("push notification") {
                throw APIError.pushNotificationFailed
            } else {
                throw APIError.serverError
            }
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Mark order as nearby
    func markOrderAsNearby(orderId: String, userId: String) async throws {
        guard let url = URL(string: "\(baseURL)/order/nearby") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let nearbyRequest = OrderNearbyRequest(userId: userId)
        request.httpBody = try JSONEncoder().encode(nearbyRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(OrderNearbyResponse.self, from: data)
            print(response.message) // Success message if needed
        case 400:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("already complete") {
                throw APIError.orderAlreadyComplete
            } else {
                throw APIError.invalidResponse
            }
        case 500:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("Push notification failed") {
                throw APIError.pushNotificationFailed
            } else {
                throw APIError.serverError
            }
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Mark order as dropped off
    func markOrderAsDroppedOff(orderId: String, userId: String, photoUrl: String) async throws {
        guard let url = URL(string: "\(baseURL)/order/dropoff/\(orderId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dropoffRequest = OrderDropoffRequest(userId: userId, photoUrl: photoUrl)
        request.httpBody = try JSONEncoder().encode(dropoffRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(OrderDropoffResponse.self, from: data)
            print(response.message) // Success message if needed
        case 400:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("already complete") {
                throw APIError.orderAlreadyComplete
            } else {
                throw APIError.invalidResponse
            }
        case 500:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("push notification") {
                throw APIError.pushNotificationFailed
            } else {
                throw APIError.serverError
            }
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Mark order at exchange point
    func markOrderAtExchangePoint(orderId: String, userId: String) async throws {
        guard let url = URL(string: "\(baseURL)/order/at-exchange-point/\(orderId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let exchangeRequest = OrderAtExchangePointRequest(userId: userId)
        request.httpBody = try JSONEncoder().encode(exchangeRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(OrderAtExchangePointResponse.self, from: data)
            print(response.message) // Success message if needed
        case 400:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("already complete") {
                throw APIError.orderAlreadyComplete
            } else {
                throw APIError.invalidResponse
            }
        case 500:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("push notification") {
                throw APIError.pushNotificationFailed
            } else {
                throw APIError.serverError
            }
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Confirm order received
    func confirmOrderReceived(orderId: String, userId: String) async throws {
        guard let url = URL(string: "\(baseURL)/order/confirm-received/\(orderId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let confirmRequest = OrderConfirmReceivedRequest(userId: userId)
        request.httpBody = try JSONEncoder().encode(confirmRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let response = try JSONDecoder().decode(OrderConfirmReceivedResponse.self, from: data)
            print(response.message) // Success message if needed
        case 500:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            if errorResponse.error.contains("push notification") {
                throw APIError.pushNotificationFailed
            } else {
                throw APIError.serverError
            }
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
}