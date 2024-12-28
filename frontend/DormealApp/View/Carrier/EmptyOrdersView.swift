import SwiftUI

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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    EmptyOrdersView()
} 
