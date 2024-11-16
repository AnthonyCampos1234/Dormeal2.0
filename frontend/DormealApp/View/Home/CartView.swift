import SwiftUI

struct CartView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
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
            VStack {
                if let cart = appState.cart {
                    List {
                        ForEach(cart.items, id: \.id) { item in
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("$\(item.basePrice, specifier: "%.2f")")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    // Checkout button
                    Button(action: {
                        Task {
                            await submitOrder()
                        }
                    }) {
                        Text("Proceed to Checkout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    EmptyCartView()
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
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
            Image("large_cart_empty_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add items to get started")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    CartView()
} 