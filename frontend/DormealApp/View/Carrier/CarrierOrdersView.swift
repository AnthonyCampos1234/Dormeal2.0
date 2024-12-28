import SwiftUI

struct CarrierOrdersView: View {
    let pendingOrders: [Order]
    let activeOrders: [Order]
    let completedOrders: [Order]
    let isLoading: Bool
    @Binding var showingOrdersSheet: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if pendingOrders.isEmpty {
                EmptyOrdersView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(pendingOrders, id: \.id) { order in
                            OrderCard(
                                order: order,
                                isPending: true,
                                isCompleted: false
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingOrdersSheet = true
                } label: {
                    Image("order_outline")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    CarrierOrdersView(
        pendingOrders: [Order.sampleOrder],
        activeOrders: [],
        completedOrders: [],
        isLoading: false,
        showingOrdersSheet: .constant(false)
    )
} 