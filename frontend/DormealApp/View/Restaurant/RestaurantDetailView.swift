import SwiftUI

struct RestaurantDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let menu: RestaurantMenu
    @State private var selectedCategory: String?
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom navigation bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(menu.restaurantName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
            
            // Categories scroll view
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    ForEach(menu.categories, id: \.self) { category in
                        VStack(spacing: 4) {
                            Text(category)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedCategory == category ? .black : .gray)
                                .padding(.horizontal, 4)
                            
                            // Underline indicator
                            if selectedCategory == category {
                                Rectangle()
                                    .frame(height: 3)
                                    .foregroundColor(.black)
                                    .matchedGeometryEffect(id: "underline", in: namespace)
                            } else {
                                Rectangle()
                                    .frame(height: 3)
                                    .foregroundColor(.clear)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .overlay(
                Divider(),
                alignment: .bottom
            )
            
            // Menu items
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(menu.menu) { item in
                        MenuItemView(
                            item: item,
                            onAddPress: {
                                // Add your plus button action here
                            }
                        )
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Set the first category as selected when view appears
            if selectedCategory == nil && !menu.categories.isEmpty {
                selectedCategory = menu.categories[0]
            }
        }
    }
}

#Preview {
    NavigationView {
        RestaurantDetailView(menu: RestaurantMenu(
            id: "1",
            restaurantName: "Burger Haven",
            logo: "https://example.com/burger-haven-logo.jpg",
            location: "123 College Ave",
            categories: ["Burgers", "Sides", "Drinks"],
            menu: [
                MenuItem(
                    id: "1",
                    name: "Classic Burger",
                    price: 8.99,
                    description: "Fresh beef patty with lettuce, tomato, and special sauce",
                    category: "Burgers",
                    imageUrl: "https://example.com/classic-burger.jpg",
                    optionGroups: [] // Add empty array for preview
                )
            ]
        ))
    }
} 