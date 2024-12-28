import Foundation

enum APIError: Error {
    case invalidURL
    case networkError
    case decodingError
}

class APIService {
    static let shared = APIService() // Singleton instance

    private let baseURL = "http://your-flask-server.com/api"
    
    // Fetch all available menus (restaurants)
    func fetchMenus() async throws -> [RestaurantMenu] {
        guard let url = URL(string: "\(baseURL)/menus") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw APIError.networkError
        }
        
        return try JSONDecoder().decode([RestaurantMenu].self, from: data)
    }
    
    // Fetch specific menu by ID
    func fetchMenu(menuId: String) async throws -> RestaurantMenu {
        guard let url = URL(string: "\(baseURL)/menus/\(menuId)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw APIError.networkError
        }
        
        return try JSONDecoder().decode(RestaurantMenu.self, from: data)
    }
    
    // Submit order with cart details
    func submitOrder(cart: Cart, building: Building, location: String) async throws -> Order {
        // Mock implementation for now
        return Order(
            id: UUID().uuidString,
            cart: cart,
            building: building,
            carrier: nil,
            status: "pending",
            user: nil,
            location: location,
            totalPrice: cart.totalPrice,
            carrierPayout: 3.99,
            deliveryMethod: .dropoff,
            createdAt: Date()
        )
    }
    
    // Authentication methods
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
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.networkError
        }
        
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func fetchUserProfile() async throws -> User {
        guard let url = URL(string: "\(baseURL)/user/profile") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.networkError
        }
        
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func fetchUserOrders() async throws -> [Order] {
        guard let url = URL(string: "\(baseURL)/user/orders") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.networkError
        }
        
        return try JSONDecoder().decode([Order].self, from: data)
    }
    
    func updateUserProfile(name: String, phoneNumber: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/user/profile") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = ["name": name, "phoneNumber": phoneNumber]
        request.httpBody = try JSONEncoder().encode(updateData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.networkError
        }
        
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func fetchCarrierOrders() async throws -> [Order] {
        guard let url = URL(string: "\(baseURL)/carrier/orders") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.networkError
        }
        
        return try JSONDecoder().decode([Order].self, from: data)
    }
    
    func fetchCompletedOrders() async throws -> [Order] {
        guard let url = URL(string: "\(baseURL)/carrier/orders/completed") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.networkError
        }
        
        return try JSONDecoder().decode([Order].self, from: data)
    }
}