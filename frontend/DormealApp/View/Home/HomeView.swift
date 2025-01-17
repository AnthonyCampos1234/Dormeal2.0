import SwiftUI

struct HomeView: View {
    // MARK: - State Properties
    @State private var showingCart = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var restaurants: [Restaurant] = []
    @State private var totalSavings = 25.50
    @EnvironmentObject var appState: AppState
    @State private var showingCheckout = false
    
    // MARK: - Private Methods
    private func loadRestaurants() async {
        isLoading = true
        errorMessage = nil
        
        do {
            #if DEBUG
            // Use mock data in debug mode
            restaurants = APIService.shared.mockRestaurants
            #else
            guard let userId = appState.user?.id else {
                errorMessage = "User not found"
                isLoading = false
                return
            }
            restaurants = try await APIService.shared.fetchRestaurants(userId: userId)
            #endif
        } catch APIError.notFound {
            errorMessage = "No restaurants found for your school"
        } catch APIError.serverError {
            errorMessage = "An unexpected error occurred. Please try again later"
        } catch {
            errorMessage = error.localizedDescription
        }
        
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
                    HStack(spacing: 16) {
                        // Cart Button
                        Button(action: { showingCart = true }) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "cart")
                                    .font(.system(size: 20))
                                if let itemCount = appState.cart?.items.count, itemCount > 0 {
                                    Text("\(itemCount)")
                                        .font(.caption2)
                                        .padding(4)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                        
                        // Order Status Button
                        VStack(alignment: .center, spacing: 2) {
                            Text("Order Status")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Image("orderstatusempty_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                        }
                    }
                    .padding(.trailing, 8)
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .overlay(navigationBarBackground, alignment: .top)
            .sheet(isPresented: $showingCart) {
                CartView()
            }
            .task {
                await loadRestaurants()
            }
        }
    }
    
    // MARK: - View Components
    private var restaurantList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ForEach(restaurants) { restaurant in
                        RestaurantCard(restaurant: restaurant)
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
            .frame(height: {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    return window.safeAreaInsets.top + 44
                }
                return 44
            }())
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
