import SwiftUI

struct OrderConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    let orderNumber: String
    
    private func dismissToRoot() {
        // Dismiss all the way back to root view
        dismiss()
        
        // Small delay to ensure smooth transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Set the selected tab to Orders (assuming you have a tab selection in AppState)
            appState.selectedTab = .orders  // You'll need to add this to AppState if not already present
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Success Animation
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .padding(.top, 40)
            
            VStack(spacing: 12) {
                Text("Order Confirmed!")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Order #\(orderNumber)")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 8) {
                Text("Your order has been confirmed and will be delivered soon.")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                Text("You can track your order in the Orders tab.")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            PrimaryButton(title: "Track Order") {
                dismissToRoot()
            }
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let mockAppState = AppState()
    // Add any mock data you need
    mockAppState.user = User(
        id: "preview-user",
        homeBuilding: Building(
            id: "b1",
            name: "Warren College",
            location: "Warren Campus"
        ),
        name: "John Doe",
        phoneNumber: "+1234567890"
    )
    
    return NavigationStack {
        OrderConfirmationView(orderNumber: "DM123456")
            .environmentObject(mockAppState)
    }
} 