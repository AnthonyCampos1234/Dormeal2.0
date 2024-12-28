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
    @Published var isAuthenticated = true
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showCarrierOnboarding = true
    @Published var selectedTab: Tab = .home
    
    func login(email: String, password: String) async {
        isLoading = true
        do {
            user = try await APIService.shared.login(email: email, password: password)
            isAuthenticated = true
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
    
    func addToCart(item: Item, menu: RestaurantMenu) {
        // Initialize cart if needed
        if cart == nil {
            cart = Cart(id: UUID().uuidString, menu: RestaurantMenu(
                id: menu.id,
                restaurantName: menu.restaurantName,
                logo: menu.logo,
                location: menu.location,
                categories: menu.categories,
                menu: []  // Empty menu since we're just using it for cart reference
            ), items: [], totalPrice: 0)
        }
        
        // Add item and update total price
        cart?.items.append(item)
        cart?.totalPrice += item.basePrice
    }
    
    func removeFromCart(item: Item) {
        guard var currentCart = cart else { return }
        currentCart.items.removeAll(where: { $0.id == item.id })
        
        // Update total price
        currentCart.totalPrice = currentCart.items.reduce(0) { $0 + $1.basePrice }
        
        // If cart is empty, set to nil, otherwise update it
        cart = currentCart.items.isEmpty ? nil : currentCart
    }
    
    @MainActor
    func loadUserProfile() async {
        isLoading = true
        do {
            user = try await APIService.shared.fetchUserProfile()
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func updateItemQuantity(item: Item, quantity: Int) {
        guard var currentCart = cart else { return }
        if let index = currentCart.items.firstIndex(where: { $0.id == item.id }) {
            if quantity > 0 {
                // Replace the item with multiple copies based on quantity
                let currentQuantity = currentCart.items.filter { $0.id == item.id }.count
                if quantity > currentQuantity {
                    // Add more items
                    for _ in 0..<(quantity - currentQuantity) {
                        currentCart.items.append(item)
                    }
                } else if quantity < currentQuantity {
                    // Remove excess items
                    let itemsToRemove = currentQuantity - quantity
                    for _ in 0..<itemsToRemove {
                        if let indexToRemove = currentCart.items.lastIndex(where: { $0.id == item.id }) {
                            currentCart.items.remove(at: indexToRemove)
                        }
                    }
                }
            }
        }
        
        // Update total price
        currentCart.totalPrice = currentCart.items.reduce(0) { $0 + $1.basePrice }
        
        // If cart is empty, set to nil, otherwise update it
        cart = currentCart.items.isEmpty ? nil : currentCart
    }
} 