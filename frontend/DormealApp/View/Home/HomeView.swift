import SwiftUI

struct HomeView: View {
    @State private var showingCart = false
    @State private var isLocationPressed = false
    @State private var selectedBuilding = "Select a location"
    @State private var menus: [RestaurantMenu] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    let buildings = [
        "Select a location",
        "10 Coventry",
        "106 St. Stephen Street",
        "110 St. Stephen Street",
        "116 St. Stephen Street",
        "122 St. Stephen Street",
        "144 Hemenway St",
        "153 Hemenway Street",
        "319 Huntington Ave",
        "337 Huntington Ave",
        "407 Huntington Ave",
        "60 Belvidere Street",
        "768 Columbus",
        "780 Columbus",
        "Burstein Hall",
        "Davenport Commons A & B",
        "East Village",
        "Hastings Hall",
        "International Village",
        "Kennedy Hall",
        "Kerr Hall",
        "Leased Properties",
        "Light Hall",
        "Loftman Hall",
        "Melvin Hall",
        "Midtown Hotel",
        "Rubenstein Hall",
        "Smith Hall",
        "Speare Hall",
        "Stetson Hall East",
        "Stetson Hall West",
        "West Village A",
        "West Village B",
        "West Village C",
        "West Village E",
        "West Village F",
        "West Village G",
        "West Village H",
        "Willis Hall"
    ]
    
    private func loadMenus() async {
        isLoading = true
        menus = RestaurantDataService.loadRestaurantData()
        isLoading = false
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
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
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Menu {
                        ForEach(buildings, id: \.self) { building in
                            Button(action: {
                                selectedBuilding = building
                                isLocationPressed = true
                            }) {
                                Text(building)
                            }
                        }
                    } label: {
                        HStack {
                            Image(isLocationPressed ? "location_filled" : "location_outline")
                                .foregroundColor(.primary)
                            Text(selectedBuilding)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation(.smooth) {
                            showingCart.toggle()
                        }
                    }) {
                        Image(showingCart ? "cart_empty_filled" : "cart_empty_outline")
                            .foregroundColor(.primary)
                            .animation(.smooth, value: showingCart)
                    }
                }
            })
            .toolbarBackground(.clear, for: .navigationBar)
            .overlay(
                Rectangle()
                    .fill(.white.opacity(0.95))
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 + 44)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                , alignment: .top
            )
            .sheet(isPresented: $showingCart) {
                CartView()
            }
            .onChange(of: selectedBuilding) { newBuilding in
                if newBuilding != "Select a location" {
                    Task {
                        await loadMenus()
                    }
                }
            }
            .task {
                await loadMenus()
            }
        }
    }
}

#Preview {
    HomeView()
} 