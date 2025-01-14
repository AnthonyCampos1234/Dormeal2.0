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
            _ = try await APIService.shared.submitOrder(
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
                                    appState.removeFromCart(itemId: item.id)
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
    let item: CartItem
    let onDelete: () -> Void
    @EnvironmentObject private var appState: AppState
    @State private var quantity: Int
    
    init(item: CartItem, onDelete: @escaping () -> Void) {
        self.item = item
        self.onDelete = onDelete
        _quantity = State(initialValue: item.quantity)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.menuItem.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                if !item.selectedOptions.isEmpty {
                    ForEach(Array(item.selectedOptions.values), id: \.self) { option in
                        Text("• \(option)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Text("$\(item.itemTotal, specifier: "%.2f")")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Quantity controls
            HStack(spacing: 12) {
                Button(action: {
                    appState.updateItemQuantity(itemId: item.id, quantity: quantity - 1)
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
                    appState.updateItemQuantity(itemId: item.id, quantity: quantity + 1)
                    quantity += 1
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
        let mockMenuItem = MenuItem(
            id: "i1",
            name: "Test Item",
            price: 9.99,
            imageUrl: "https://example.com/image.jpg",
            optionsSections: [],
            addOnsSections: []
        )
        
        let mockCartItem = CartItem(
            id: "ci1",
            menuItem: mockMenuItem,
            quantity: 1,
            selectedOptions: [:],
            selectedAddOns: Set(),
            itemTotal: 9.99
        )
        
        CartItemRow(item: mockCartItem, onDelete: {})
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
    
    appState.cart = Cart(
        id: "c1",
        restaurant: restaurant,
        items: [],
        totalPrice: 0
    )
    
    return CartView()
        .environmentObject(appState)
} 
