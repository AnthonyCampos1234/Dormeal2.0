import SwiftUI

struct NoOrdersView: View {
    let isActiveOrders: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isActiveOrders ? "No active orders" : "No completed orders")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(isActiveOrders ? "Orders you accept will appear here" : "Your completed orders will appear here")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    Group {
        NoOrdersView(isActiveOrders: true)
        NoOrdersView(isActiveOrders: false)
    }
} 