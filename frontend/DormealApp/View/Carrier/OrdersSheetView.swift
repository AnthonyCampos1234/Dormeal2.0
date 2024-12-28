import SwiftUI

enum OrderType {
    case active, completed
}

struct OrdersSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let activeOrders: [Order]
    let completedOrders: [Order]
    @State private var selectedOrderType = OrderType.active
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Order Type", selection: $selectedOrderType) {
                    Text("Active Orders").tag(OrderType.active)
                    Text("Completed Orders").tag(OrderType.completed)
                }
                .pickerStyle(.segmented)
                .padding()
                .background(Color.white)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        let orders = selectedOrderType == .active ? activeOrders : completedOrders
                        if orders.isEmpty {
                            NoOrdersView(isActiveOrders: selectedOrderType == .active)
                        } else {
                            ForEach(orders, id: \.id) { order in
                                OrderCard(
                                    order: order,
                                    isPending: false,
                                    isCompleted: selectedOrderType == .completed
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    OrdersSheetView(activeOrders: [Order.sampleOrder], completedOrders: [Order.sampleOrder])
} 