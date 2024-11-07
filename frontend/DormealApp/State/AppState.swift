import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var user: User?
    @Published var cart: Cart?
    @Published var isAuthenticated = true
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showCarrierOnboarding = true
    
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
        cart?.items.removeAll(where: { $0.id == item.id })
        cart?.totalPrice -= item.basePrice
        
        // Clear cart if empty
        if cart?.items.isEmpty ?? false {
            cart = nil
        }
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
} 