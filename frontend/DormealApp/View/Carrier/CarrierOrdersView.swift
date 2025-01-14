import SwiftUI

struct CarrierOrdersView: View {
    @EnvironmentObject private var appState: AppState
    @State private var activeOrders: [CarrierOrder] = []
    @State private var completedOrders: [CarrierOrder] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                VStack {
                    Picker("Order Type", selection: $selectedTab) {
                        Text("Active").tag(0)
                        Text("Completed").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if selectedTab == 0 {
                        if activeOrders.isEmpty {
                            CarrierEmptyOrdersView(message: "No active orders")
                        } else {
                            CarrierOrdersList(orders: activeOrders)
                        }
                    } else {
                        if completedOrders.isEmpty {
                            CarrierEmptyOrdersView(message: "No completed orders")
                        } else {
                            CarrierOrdersList(orders: completedOrders)
                        }
                    }
                }
            }
        }
        .navigationTitle("My Orders")
        .task {
            await loadOrders()
        }
        .refreshable {
            await loadOrders()
        }
    }
    
    private func loadOrders() async {
        guard let userId = appState.user?.id else {
            errorMessage = "User not found"
            return
        }
        
        isLoading = true
        do {
            let response = try await APIService.shared.fetchCarrierOrders(userId: userId)
            activeOrders = response.activeOrders
            completedOrders = response.completedOrders
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

struct CarrierOrdersList: View {
    let orders: [CarrierOrder]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(orders) { order in
                    CarrierOrderCard(order: order)
                }
            }
            .padding()
        }
    }
}

struct CarrierOrderCard: View {
    let order: CarrierOrder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(order.restaurant)
                    .font(.headline)
                Spacer()
                Text("$\(order.moneyToBeMade, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            Text(order.orderSummary)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                Text(order.deliveryLocation)
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.orange)
                Text(order.timePlaced, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !order.orderStatus.isEmpty {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text(order.orderStatus)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct CarrierEmptyOrdersView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text(message)
                .font(.headline)
        }
    }
}

#Preview {
    NavigationView {
        CarrierOrdersView()
            .environmentObject(AppState())
    }
} 