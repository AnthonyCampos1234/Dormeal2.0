import SwiftUI

struct CartView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var showingCheckout = false
    
    private func submitOrder() async {
        guard let cart = appState.cart else { return }
        isSubmitting = true
        do {
            guard let user = appState.user else { return }
            let order = try await APIService.shared.submitOrder(
                cart: cart,
                building: user.homeBuilding,
                location: "Room 123"
            )
            appState.cart = nil
            dismiss()
        } catch {
            errorMessage = "Failed to submit order: \(error.localizedDescription)"
        }
        isSubmitting = false
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let cart = appState.cart {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(cart.items, id: \.id) { item in
                                CartItemRow(item: item) {
                                    appState.removeFromCart(item: item)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // Bottom checkout section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Total")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("$\(cart.totalPrice, specifier: "%.2f")")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .padding(.horizontal)
                        
                        PrimaryButton(title: "Proceed to Checkout") {
                            showingCheckout = true
                        }
                    }
                    .background(Color(UIColor.systemBackground))
                } else {
                    EmptyCartView()
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Your cart is empty")
                .font(.system(size: 20, weight: .semibold))
            
            Text("Add items to get started")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct CartItemRow: View {
    let item: Item
    let onDelete: () -> Void
    @EnvironmentObject private var appState: AppState
    @State private var quantity: Int = 1
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                // Display selected options
                if !item.selectedOptions.isEmpty {
                    ForEach(item.selectedOptions, id: \.self) { option in
                        Text("• \(option)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Text("$\(item.basePrice, specifier: "%.2f")")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Quantity controls
            HStack(spacing: 12) {
                Button(action: {
                    quantity -= 1
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                        .frame(width: 28, height: 28)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                
                Text("\(quantity)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(minWidth: 24)
                
                Button(action: {
                    quantity += 1
                    // TODO: Update cart quantity
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .frame(width: 28, height: 28)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(8)
    }
}

struct CartItemRow_Previews: PreviewProvider {
    static var previews: some View {
        let mockAppState = AppState()
        let mockItem = Item(
            id: "i1",
            name: "Test Item",
            basePrice: 9.99,
            addonsSections: [],
            additionalsSections: [],
            choicesSections: [],
            icon: "test-icon"
        )
        
        CartItemRow(item: mockItem, onDelete: {})
            .environmentObject(mockAppState)
            .padding()
    }
}

#Preview {
    let appState = AppState()
    appState.user = User(
        id: "u1",
        homeBuilding: Building(
            id: "b1",
            name: "Warren College",
            location: "Warren Campus"
        ),
        name: "John Doe",
        phoneNumber: "+1234567890"
    )
    appState.cart = Cart(
        id: "c1",
        menu: RestaurantMenu(
            id: "r1",
            restaurantName: "Panda Express",
            logo: "https://example.com/logo.png",
            location: "Price Center",
            categories: ["Chinese", "Asian"],
            menu: []
        ),
        items: [
            Item(
                id: "i1",
                name: "Orange Chicken",
                basePrice: 12.99,
                addonsSections: [],
                additionalsSections: [],
                choicesSections: [],
                icon: "orange-chicken-icon"
            ),
            Item(
                id: "i2",
                name: "Beijing Beef",
                basePrice: 13.99,
                addonsSections: [],
                additionalsSections: [],
                choicesSections: [],
                icon: "beijing-beef-icon"
            )
        ],
        totalPrice: 26.98
    )
    
    return CartView()
        .environmentObject(appState)
} 
