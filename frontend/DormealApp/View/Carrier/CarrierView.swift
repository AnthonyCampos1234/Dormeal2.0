import SwiftUI

struct CarrierView: View {
    @State private var pendingOrders: [Order] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            CarrierOrdersView()
        }
    }
}

#Preview {
    CarrierView()
        .environmentObject(AppState())
} 
