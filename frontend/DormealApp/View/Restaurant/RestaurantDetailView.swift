import SwiftUI

struct RestaurantDetailView: View {
    let restaurantId: String
    @State private var menuSections: [MenuSection] = []
    @State private var loadedItems: [String: MenuItem] = [:]
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var retryCount = 0
    @State private var selectedSectionId: String?
    
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
                VStack(spacing: 0) {
                    // Section Headers
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 24) {
                                ForEach(menuSections) { section in
                                    VStack {
                                        Text(section.name)
                                            .foregroundColor(selectedSectionId == section.id ? .black : .gray)
                                            .font(.subheadline)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 8)
                                        
                                        Rectangle()
                                            .fill(selectedSectionId == section.id ? Color.black : Color.clear)
                                            .frame(height: 2)
                                    }
                                    .id(section.id)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedSectionId = section.id
                                            proxy.scrollTo(section.id, anchor: .center)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .background(Color.white)
                    }
                    
                    Divider()
                    
                    // Menu Sections
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 16, pinnedViews: .sectionHeaders) {
                                ForEach(menuSections) { section in
                                    Section {
                                        MenuSectionView(
                                            section: section,
                                            loadedItems: loadedItems,
                                            onItemAppear: loadMenuItem
                                        )
                                        .id(section.id)
                                        .onChange(of: selectedSectionId) { _ in
                                            if selectedSectionId == section.id {
                                                withAnimation {
                                                    proxy.scrollTo(section.id, anchor: .top)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            } else {
                Text("No menu available")
            }
        }
        .task(id: retryCount) {
            await loadMenu()
            if menuSections.first != nil {
                selectedSectionId = menuSections.first?.id
            }
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