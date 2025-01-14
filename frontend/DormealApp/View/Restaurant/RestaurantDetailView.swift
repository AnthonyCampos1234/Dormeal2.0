import SwiftUI

struct RestaurantDetailView: View {
    let restaurantId: String
    @State private var menuSections: [MenuSection] = []
    @State private var loadedItems: [String: MenuItem] = [:]
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var retryCount = 0
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if let error = errorMessage {
                VStack(spacing: 16) {
                    Text(error)
                        .foregroundColor(.red)
                    Button("Retry") {
                        retryCount += 1
                        Task {
                            await loadMenu()
                        }
                    }
                }
            } else if !menuSections.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(menuSections) { section in
                            MenuSectionView(
                                section: section,
                                loadedItems: loadedItems,
                                onItemAppear: loadMenuItem
                            )
                        }
                    }
                    .padding()
                }
            } else {
                Text("No menu available")
            }
        }
        .task(id: retryCount) {
            await loadMenu()
        }
    }
    
    private func loadMenu() async {
        isLoading = true
        do {
            menuSections = try await APIService.shared.fetchRestaurantMenu(restaurantId: restaurantId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func loadMenuItem(itemId: String) async {
        guard loadedItems[itemId] == nil else { return }
        
        do {
            let item = try await APIService.shared.fetchMenuItem(itemId: itemId)
            loadedItems[itemId] = item
        } catch {
            print("Error loading item \(itemId): \(error)")
        }
    }
}

#Preview {
    NavigationView {
        RestaurantDetailView(restaurantId: "1")
    }
} 