import SwiftUI

struct HomeView: View {
    // MARK: - State Properties
    @State private var showingCart = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var menus: [RestaurantMenu] = []
    @State private var customerName = "John Doe"
    @State private var totalSavings = 25.50
    
    // MARK: - Private Methods
    private func loadMenus() async {
        isLoading = true
        menus = RestaurantDataService.loadRestaurantData()
        isLoading = false
    }
    
    // MARK: - View Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                restaurantList
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total Savings")
                            .font(.caption)
                            .foregroundColor(.gray)
                        HStack(spacing: 4) {
                            Image("piggy_bank")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                            Text("$\(totalSavings, specifier: "%.2f")")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.leading, 8)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    VStack(alignment: .center, spacing: 2) {
                        Text("Order Status")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Image("orderstatusempty_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                    }
                    .padding(.trailing, 8)
                    .onTapGesture {
                        // Add navigation to order status view here
                    }
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .overlay(navigationBarBackground, alignment: .top)
            .sheet(isPresented: $showingCart) {
                CartView()
            }
            .task {
                await loadMenus()
            }
        }
    }
    
    // MARK: - View Components
    private var restaurantList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if isLoading {
                    ProgressView()
                } else {
                    ForEach(menus, id: \.id) { menu in
                        RestaurantCard(menu: menu)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
    }
    
    private var navigationBarBackground: some View {
        Rectangle()
            .fill(.white.opacity(0.95))
            .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 + 44)
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

// MARK: - Preview
#Preview {
    let mockAppState = AppState()
    mockAppState.user = User(
        id: "u1",
        homeBuilding: Building(
            id: "b1",
            name: "Warren College",
            location: "Warren Campus"
        ),
        name: "John Doe",
        phoneNumber: "+1234567890"
    )
    
    return HomeView()
        .environmentObject(mockAppState)
} 
