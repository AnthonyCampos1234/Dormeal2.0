import SwiftUI

struct CompletedOrdersView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var completedOrders: [Order] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private func loadCompletedOrders() async {
        // Temporarily disabled
        return
        
        // Original implementation commented out
        /*
        isLoading = true
        do {
            completedOrders = try await APIService.shared.fetchCompletedOrders()
        } catch {
            errorMessage = "Failed to load completed orders: \(error.localizedDescription)"
        }
        isLoading = false
        */
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                } else if completedOrders.isEmpty {
                    EmptyCompletedOrdersView()
                } else {
                    List {
                        ForEach(completedOrders, id: \.id) { order in
                            VStack(alignment: .leading, spacing: 12) {
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
                                
                                ForEach(order.cart.items, id: \.id) { item in
                                    Text(item.name)
                                        .font(.subheadline)
                                }
                                
                                HStack {
                                    Text("$\(order.totalPrice, specifier: "%.2f")")
                                        .font(.headline)
                                    Spacer()
                                    Text("Completed")
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Completed Orders")
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
            .task {
                await loadCompletedOrders()
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

struct EmptyCompletedOrdersView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("large_checkmark_outline")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("No completed orders")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Completed orders will appear here")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    CompletedOrdersView()
} 