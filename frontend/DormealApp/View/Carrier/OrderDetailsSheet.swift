import SwiftUI

struct OrderDetailsSheet: View {
    let order: Order
    @Binding var hasPickedUp: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var isAccepting = false
    @State private var showingActiveOrder = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Restaurant Section
                        restaurantSection
                        
                        Divider()
                            .background(Color.gray)
                        
                        // Delivery Location Section
                        deliverySection
                        
                        Divider()
                            .background(Color.gray)
                        
                        // Order Items Section
                        orderItemsSection
                        
                        Divider()
                            .background(Color.gray)
                        
                        // Payment Section
                        paymentSection
                    }
                    .padding()
                }
                .navigationTitle("Order Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    acceptOrderButton
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var restaurantSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Restaurant")
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: order.cart.restaurant.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.cart.restaurant.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(order.cart.restaurant.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var deliverySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Delivery Location")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(order.building.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(order.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var orderItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Items")
                .font(.headline)
                .foregroundColor(.gray)
            
            ForEach(order.cart.items, id: \.id) { item in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.menuItem.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        Text("1x")
                            .foregroundColor(.gray)
                        Text("$\(item.itemTotal, specifier: "%.2f")")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment")
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack {
                Text("Your Payout")
                    .foregroundColor(.white)
                Spacer()
                Text("$\(order.carrierPayout, specifier: "%.2f")")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .font(.system(.body, design: .rounded))
        }
    }
    
    private var acceptOrderButton: some View {
        Button(action: {
            isAccepting = true
            // Add accept order logic here
            showingActiveOrder = true
            isAccepting = false
        }) {
            HStack {
                Text("Accept Order")
                    .fontWeight(.semibold)
                if isAccepting {
                    ProgressView()
                        .tint(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(12)
        }
        .disabled(isAccepting)
        .padding()
        .background(Color.black.ignoresSafeArea())
        .fullScreenCover(isPresented: $showingActiveOrder) {
            ActiveOrderSheet(order: order)
        }
    }
}

#Preview {
    OrderDetailsSheet(order: Order.sampleOrder, hasPickedUp: .constant(false))
} 