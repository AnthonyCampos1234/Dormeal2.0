import SwiftUI

struct CarrierView: View {
    @EnvironmentObject private var appState: AppState
    @State private var orders: [Order] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingCompletedOrders = false
    
    private func loadOrders() async {
        isLoading = true
        do {
            orders = try await APIService.shared.fetchCarrierOrders()
        } catch {
            errorMessage = "Failed to load orders: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                } else if orders.isEmpty {
                    EmptyOrdersView()
                } else {
                    List {
                        ForEach(orders, id: \.id) { order in
                            OrderCard(order: order)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation(.smooth) {
                            showingCompletedOrders.toggle()
                        }
                    }) {
                        Image(showingCompletedOrders ? "checkmark_filled" : "checkmark_outline")
                            .foregroundColor(.primary)
                            .animation(.smooth, value: showingCompletedOrders)
                    }
                }
            }
            .sheet(isPresented: $showingCompletedOrders) {
                CompletedOrdersView()
            }
            .task {
                await loadOrders()
            }
        }
    }
}

struct EmptyOrdersView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("large_order_outline_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("No orders available")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Check back later for new orders")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct OrderCard: View {
    let order: Order
    
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
                    Text(order.building.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            // Order Items
            ForEach(order.cart.items, id: \.id) { item in
                Text(item.name)
                    .font(.subheadline)
            }
            
            Divider()
            
            // Price and Action Button
            HStack {
                Text("$\(order.totalPrice, specifier: "%.2f")")
                    .font(.headline)
                
                Spacer()
                
                Button("Accept Order") {
                    // Handle accept order
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    CarrierView()
        .environmentObject(AppState())
} 
