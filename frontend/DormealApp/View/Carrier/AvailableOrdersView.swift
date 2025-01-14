import SwiftUI

struct AvailableOrdersView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedOrder: AvailableOrder?
    
    var body: some View {
        Group {
            if appState.isLoading {
                ProgressView("Loading available orders...")
            } else if appState.availableOrders.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No orders available")
                        .font(.headline)
                    Text("Check back soon!")
                        .foregroundColor(.gray)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(appState.availableOrders) { order in
                            AvailableOrderCard(order: order) {
                                Task {
                                    await appState.claimOrder(orderId: String(order.id))
                                }
                            }
                                .onTapGesture {
                                    selectedOrder = order
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Available Orders")
        .sheet(item: $selectedOrder) { order in
            OrderDetailsView(order: order)
        }
        .task {
            await appState.loadAvailableOrders()
        }
        .refreshable {
            await appState.loadAvailableOrders()
        }
    }
}

struct AvailableOrderCard: View {
    let order: AvailableOrder
    let onClaim: () -> Void
    @State private var showingClaimConfirmation = false
    
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
            
            Button(action: {
                showingClaimConfirmation = true
            }) {
                Text("Claim Order")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .alert("Confirm Claim", isPresented: $showingClaimConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Claim", role: .destructive) {
                onClaim()
            }
        } message: {
            Text("Are you sure you want to claim this order?")
        }
    }
}

#Preview {
    NavigationStack {
        AvailableOrdersView()
            .environmentObject(AppState())
    }
} 