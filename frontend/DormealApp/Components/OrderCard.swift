import SwiftUI

struct OrderCard: View {
    let order: Order
    let isPending: Bool
    let isCompleted: Bool
    @State private var showingOrderSheet = false
    @State private var hasPickedUp = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Restaurant Info
            HStack {
                AsyncImage(url: URL(string: order.cart.menu.logo)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading) {
                    Text(order.cart.menu.restaurantName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(order.building.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    if !isPending && !isCompleted {
                        Text(hasPickedUp ? "Navigating to drop-off location" : "Navigating to restaurant")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    Text(order.createdAt.timeAgoDisplay())
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
                .background(Color.black)
                .overlay(Color.white.opacity(0.5))
            
            // Order Items
            ForEach(order.cart.items, id: \.id) { item in
                Text(item.name)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.black)
                .overlay(Color.white.opacity(0.5))
            
            // Price and Action Button
            HStack {
                Text("Payout: $\(order.carrierPayout, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if isPending {
                    Button("View Order") {
                        showingOrderSheet = true
                    }
                    .foregroundColor(.black)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .sheet(isPresented: $showingOrderSheet) {
                        OrderDetailsSheet(order: order, hasPickedUp: $hasPickedUp)
                    }
                } else if isCompleted {
                    Text("Completed")
                        .foregroundColor(.green)
                        .font(.subheadline)
                } else {
                    if !hasPickedUp {
                        Button("Mark as Picked Up") {
                            hasPickedUp = true
                            // Here you would typically notify your navigation system
                            // to switch to customer's location
                        }
                        .foregroundColor(.black)
                        .buttonStyle(.borderedProminent)
                        .tint(.white)
                    } else {
                        Text("In Progress")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(12)
    }
}

#Preview {
    VStack {
        OrderCard(order: Order.sampleHandoffOrder, isPending: true, isCompleted: false)
        OrderCard(order: Order.sampleOrder, isPending: true, isCompleted: false)
    }
    .padding()
} 
