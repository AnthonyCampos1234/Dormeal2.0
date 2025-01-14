import Foundation
import SwiftUI

enum Tab {
    case home
    case orders
    case account
}

class AppState: ObservableObject {
    @Published var user: User?
    @Published var cart: Cart?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedTab: Tab = .home
    @Published var isCarrier = false
    @Published var carrierVerificationStatus: String?
    @Published var schoolEmailSuffix: String?
    @Published var isEmailVerified = false
    @Published var showCarrierTraining = false
    @Published var availableOrders: [AvailableOrder] = []
    @Published var selectedOrderDetails: OrderDetailsResponse?
    @Published var currentOrderStatus: OrderStatusResponse?
    @Published var exchangePointTimer: Timer?
    @Published var exchangePointTimeRemaining: Int = 300 // 5 minutes in seconds
    
    func login(email: String, password: String) async {
        isLoading = true
        do {
            user = try await APIService.shared.login(email: email, password: password)
            isAuthenticated = true
            await checkCarrierStatus()
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func logout() {
        user = nil
        cart = nil
        isAuthenticated = false
    }
    
    func addToCart(menuItem: MenuItem, restaurant: Restaurant) {
        if cart == nil {
            cart = Cart(
                id: UUID().uuidString,
                restaurant: restaurant,
                items: [],
                totalPrice: 0
            )
        }
        
        // Only add if the restaurant matches the current cart
        guard cart?.restaurant.id == restaurant.id else {
            errorMessage = "Cannot add items from different restaurants"
            return
        }
        
        let cartItem = CartItem(
            id: UUID().uuidString,
            menuItem: menuItem,
            quantity: 1,
            selectedOptions: [:],
            selectedAddOns: Set<String>(),
            itemTotal: menuItem.price
        )
        
        cart?.items.append(cartItem)
        updateCartTotal()
    }
    
    func removeFromCart(itemId: String) {
        cart?.items.removeAll(where: { $0.id == itemId })
        updateCartTotal()
        
        if cart?.items.isEmpty == true {
            cart = nil
        }
    }
    
    private func updateCartTotal() {
        cart?.totalPrice = cart?.items.reduce(0) { $0 + $1.itemTotal } ?? 0
    }
    
    func updateItemQuantity(itemId: String, quantity: Int) {
        guard let itemIndex = cart?.items.firstIndex(where: { $0.id == itemId }) else { return }
        
        if quantity <= 0 {
            removeFromCart(itemId: itemId)
        } else {
            cart?.items[itemIndex].quantity = quantity
            cart?.items[itemIndex].itemTotal = cart?.items[itemIndex].menuItem.price ?? 0 * Double(quantity)
            updateCartTotal()
        }
    }
    
    @MainActor
    func loadUserProfile() async {
        isLoading = true
        do {
            #if DEBUG
            // Use mock data in debug mode
            if user == nil {
                user = User(
                    id: "u1",
                    homeBuilding: Building(
                        id: "b1",
                        name: "Warren College",
                        location: "Warren Campus"
                    ),
                    name: "John Doe",
                    phoneNumber: "+1234567890"
                )
            }
            #else
            // Real API call
            let updatedUser = try await APIService.shared.fetchUserProfile()
            self.user = updatedUser
            #endif
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    @MainActor
    func checkCarrierStatus() async {
        guard let userId = user?.id else { return }
        
        do {
            #if DEBUG
            // Mock data for debug
            isCarrier = true
            carrierVerificationStatus = "verified"
            #else
            let status = try await APIService.shared.fetchCarrierStatus(userId: userId)
            isCarrier = status.isCarrier
            carrierVerificationStatus = status.verificationStatus
            #endif
        } catch {
            errorMessage = "Failed to check carrier status: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func fetchSchoolEmailSuffix() async {
        guard let userId = user?.id else { return }
        
        do {
            #if DEBUG
            // Mock data for debug
            schoolEmailSuffix = "@university.edu"
            #else
            let suffix = try await APIService.shared.fetchSchoolEmailSuffix(userId: userId)
            schoolEmailSuffix = suffix.emailSuffix
            #endif
        } catch {
            errorMessage = "Failed to fetch school email suffix: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func sendVerificationEmail(email: String) async {
        guard let userId = user?.id else {
            errorMessage = "User not found"
            return
        }
        
        isLoading = true
        do {
            #if DEBUG
            // Mock success in debug mode
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            print("Verification email sent to \(email)")
            #else
            try await APIService.shared.sendVerificationEmail(userId: userId, email: email)
            #endif
        } catch APIError.invalidEmail {
            errorMessage = "Please enter a valid email address"
        } catch APIError.invalidSchoolEmail {
            errorMessage = "Please use your school email address"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func verifyEmailToken(token: String) async {
        isLoading = true
        do {
            #if DEBUG
            // Mock success in debug mode
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            isEmailVerified = true
            showCarrierTraining = true
            isCarrier = true
            carrierVerificationStatus = "verified"
            #else
            try await APIService.shared.verifyEmailToken(token: token)
            isEmailVerified = true
            showCarrierTraining = true
            await checkCarrierStatus() // Refresh carrier status after verification
            #endif
        } catch APIError.invalidVerificationCode {
            errorMessage = "Invalid verification code. Please try again."
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func loadAvailableOrders() async {
        guard let userId = user?.id else { return }
        
        isLoading = true
        do {
            #if DEBUG
            // Mock data for debug
            availableOrders = [
                AvailableOrder(
                    id: 1234,
                    restaurant: "Pizza Hut",
                    orderSummary: "Pepperoni Pizza (2), Garlic Bread (1), Coke (3)",
                    moneyToBeMade: 12.50,
                    deliveryLocation: "123 Dorm Building, Room 456"
                ),
                AvailableOrder(
                    id: 1235,
                    restaurant: "Chipotle",
                    orderSummary: "Burrito Bowl (1), Chips & Guac (1)",
                    moneyToBeMade: 8.75,
                    deliveryLocation: "Student Union Building, Room 201"
                )
            ]
            #else
            availableOrders = try await APIService.shared.fetchAvailableOrders(userId: userId)
            #endif
        } catch {
            errorMessage = "Failed to load available orders: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    @MainActor
    func loadOrderDetails(orderId: String) async {
        isLoading = true
        do {
            #if DEBUG
            // Mock data for debug
            selectedOrderDetails = OrderDetailsResponse(
                statusCode: 200,
                orderStatus: .claimed,
                exchangeType: .dropOff,
                orderId: orderId,
                restaurant: "Sample Restaurant",
                restaurantLocation: "123 Restaurant St",
                deliveryLocation: "456 Delivery Ave",
                customerName: "John Doe",
                earnings: 5.50,
                orderCode: "1234",
                foodDetails: [
                    DetailedOrderItem(
                        itemId: "1",
                        itemName: "Burger",
                        price: 9.99,
                        imageLink: "https://example.com/burger.jpg",
                        quantity: 2,
                        optionsSections: [],
                        addOnsSections: []
                    )
                ]
            )
            #else
            selectedOrderDetails = try await APIService.shared.fetchOrderDetails(orderId: orderId)
            #endif
        } catch {
            errorMessage = "Failed to load order details: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    @MainActor
    func claimOrder(orderId: String) async {
        guard let userId = user?.id else {
            errorMessage = "User not found"
            return
        }
        
        isLoading = true
        do {
            #if DEBUG
            // Mock success in debug mode
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            // Update local state as needed
            if let index = availableOrders.firstIndex(where: { String($0.id) == orderId }) {
                availableOrders.remove(at: index)
            }
            #else
            try await APIService.shared.claimOrder(orderId: orderId, carrierId: userId)
            // Refresh available orders after successful claim
            await loadAvailableOrders()
            #endif
        } catch APIError.orderAlreadyClaimed {
            errorMessage = "This order has already been claimed by another carrier"
            // Refresh available orders to get updated list
            await loadAvailableOrders()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func checkOrderStatus(orderId: String) async {
        isLoading = true
        do {
            #if DEBUG
            // Mock data for debug
            currentOrderStatus = OrderStatusResponse(
                orderStatus: 5,
                exchangeType: 1
            )
            #else
            currentOrderStatus = try await APIService.shared.getOrderStatus(
                orderId: orderId,
                carrierId: user?.id
            )
            #endif
        } catch APIError.orderAlreadyComplete {
            errorMessage = "This order has already been completed"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func startOrderStatusChecks(orderId: String) -> AsyncStream<OrderStatusResponse> {
        AsyncStream { continuation in
            Task {
                while !Task.isCancelled {
                    do {
                        let status = try await APIService.shared.getOrderStatus(
                            orderId: orderId,
                            carrierId: user?.id
                        )
                        continuation.yield(status)
                        
                        // If order is complete, stop checking
                        if status.orderStatus >= 5 {
                            continuation.finish()
                            break
                        }
                        
                        // Wait 10 seconds before next check
                        try await Task.sleep(nanoseconds: 10_000_000_000)
                    } catch {
                        print("Error checking order status: \(error.localizedDescription)")
                        try await Task.sleep(nanoseconds: 10_000_000_000)
                    }
                }
            }
        }
    }
    
    @MainActor
    func markOrderAsPickedUp(orderId: String) async {
        guard let userId = user?.id else {
            errorMessage = "User not found"
            return
        }
        
        isLoading = true
        do {
            #if DEBUG
            // Mock success in debug mode
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            print("Order \(orderId) marked as picked up")
            #else
            try await APIService.shared.markOrderAsPickedUp(orderId: orderId, userId: userId)
            #endif
            
            // Update order status after successful pickup
            await checkOrderStatus(orderId: orderId)
        } catch APIError.orderAlreadyComplete {
            errorMessage = "This order has already been completed"
        } catch APIError.pushNotificationFailed {
            errorMessage = "Order picked up, but customer notification failed"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func markOrderAsNearby(orderId: String) async {
        guard let userId = user?.id else {
            errorMessage = "User not found"
            return
        }
        
        isLoading = true
        do {
            #if DEBUG
            // Mock success in debug mode
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            print("Order \(orderId) marked as nearby")
            #else
            try await APIService.shared.markOrderAsNearby(orderId: orderId, userId: userId)
            #endif
            
            // Update order status after successful nearby notification
            await checkOrderStatus(orderId: orderId)
        } catch APIError.orderAlreadyComplete {
            errorMessage = "This order has already been completed"
        } catch APIError.pushNotificationFailed {
            errorMessage = "Marked as nearby, but customer notification failed"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func markOrderAsDroppedOff(orderId: String, photoUrl: String) async {
        guard let userId = user?.id else {
            errorMessage = "User not found"
            return
        }
        
        isLoading = true
        do {
            #if DEBUG
            // Mock success in debug mode
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            print("Order \(orderId) marked as dropped off with photo: \(photoUrl)")
            #else
            try await APIService.shared.markOrderAsDroppedOff(orderId: orderId, userId: userId, photoUrl: photoUrl)
            #endif
            
            // Update order status after successful dropoff
            await checkOrderStatus(orderId: orderId)
        } catch APIError.orderAlreadyComplete {
            errorMessage = "This order has already been completed"
        } catch APIError.pushNotificationFailed {
            errorMessage = "Order marked as dropped off, but customer notification failed"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func markOrderAtExchangePoint(orderId: String) async {
        guard let userId = user?.id else {
            errorMessage = "User not found"
            return
        }
        
        isLoading = true
        do {
            #if DEBUG
            // Mock success in debug mode
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            print("Order \(orderId) marked as at exchange point")
            startExchangePointTimer(orderId: orderId)
            #else
            try await APIService.shared.markOrderAtExchangePoint(orderId: orderId, userId: userId)
            startExchangePointTimer(orderId: orderId)
            #endif
            
            // Update order status after successful marking
            await checkOrderStatus(orderId: orderId)
        } catch APIError.orderAlreadyComplete {
            errorMessage = "This order has already been completed"
        } catch APIError.pushNotificationFailed {
            errorMessage = "Marked as at exchange point, but customer notification failed"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func startExchangePointTimer(orderId: String) {
        exchangePointTimeRemaining = 300 // Reset to 5 minutes
        exchangePointTimer?.invalidate() // Cancel any existing timer
        
        exchangePointTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.exchangePointTimeRemaining > 0 {
                self.exchangePointTimeRemaining -= 1
            } else {
                // Time's up - switch to dropoff mode
                timer.invalidate()
                self.exchangePointTimer = nil
                
                Task {
                    // Show alert to carrier that they should proceed with dropoff
                    self.errorMessage = "Customer not available. Please proceed with dropoff."
                    // You might want to update the UI or order status here
                }
            }
        }
    }
    
    func cancelExchangePointTimer() {
        exchangePointTimer?.invalidate()
        exchangePointTimer = nil
    }
    
    @MainActor
    func confirmOrderReceived(orderId: String) async {
        guard let userId = user?.id else {
            errorMessage = "User not found"
            return
        }
        
        isLoading = true
        do {
            #if DEBUG
            // Mock success in debug mode
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            print("Order \(orderId) confirmed as received")
            #else
            try await APIService.shared.confirmOrderReceived(orderId: orderId, userId: userId)
            #endif
            
            // Update order status after successful confirmation
            await checkOrderStatus(orderId: orderId)
        } catch APIError.pushNotificationFailed {
            errorMessage = "Order confirmed, but carrier notification failed"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
} 