import SwiftUI

struct CarrierView: View {
    @EnvironmentObject private var appState: AppState
    @State private var pendingOrders: [Order] = []
    @State private var activeOrders: [Order] = []
    @State private var completedOrders: [Order] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingOrdersSheet = false
    @State private var showCarrierOnboarding = false
    @State private var isCarrier = false
    @Binding var hideTabBar: Bool
    
    private func loadOrders() async {
        isLoading = true
        do {
            // For now, just put all orders in pending
            // Later we'll need to fetch different order types
            pendingOrders = try await APIService.shared.fetchCarrierOrders()
            activeOrders = []
            completedOrders = []
        } catch {
            errorMessage = "Failed to load orders: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    var body: some View {
        Group {
            if isCarrier {
                NavigationStack {
                    CarrierOrdersView(
                        pendingOrders: pendingOrders,
                        activeOrders: activeOrders,
                        completedOrders: completedOrders,
                        isLoading: isLoading,
                        showingOrdersSheet: $showingOrdersSheet
                    )
                    .task {
                        await loadOrders()
                    }
                }
                .sheet(isPresented: $showingOrdersSheet) {
                    OrdersSheetView(
                        activeOrders: activeOrders,
                        completedOrders: completedOrders
                    )
                }
            } else {
                CarrierRecruitmentView(showCarrierOnboarding: $showCarrierOnboarding)
            }
        }
        .fullScreenCover(isPresented: $showCarrierOnboarding) {
            NavigationStack {
                CarrierSignupPromptView(
                    showCarrierOnboarding: $showCarrierOnboarding,
                    hideTabBar: $hideTabBar,
                    onBecomeCarrier: {
                        isCarrier = true
                    }
                )
            }
        }
    }
}

#Preview {
    CarrierView(hideTabBar: .constant(false))
        .environmentObject(AppState())
} 
