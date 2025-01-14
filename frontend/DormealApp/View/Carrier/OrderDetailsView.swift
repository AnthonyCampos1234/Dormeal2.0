import SwiftUI

struct OrderDetailsView: View {
    let order: AvailableOrder
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Restaurant Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(order.restaurant)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Earnings: $\(order.moneyToBeMade, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    
                    // Order Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Order Summary")
                            .font(.headline)
                        Text(order.orderSummary)
                            .foregroundColor(.secondary)
                    }
                    
                    // Delivery Location
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Delivery Location")
                            .font(.headline)
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                            Text(order.deliveryLocation)
                        }
                    }
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
                }
            }
        }
    }
}

#Preview {
    OrderDetailsView(order: AvailableOrder(
        id: 1,
        restaurant: "Sample Restaurant",
        orderSummary: "Burger (1), Fries (1)",
        moneyToBeMade: 5.50,
        deliveryLocation: "123 Dorm St"
    ))
} 