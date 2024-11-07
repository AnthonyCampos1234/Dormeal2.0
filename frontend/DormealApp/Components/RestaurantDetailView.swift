import SwiftUI

struct RestaurantDetailView: View {
    let menu: RestaurantMenu
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with restaurant image
                AsyncImage(url: URL(string: menu.logo)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 200)
                .clipped()
                
                // Restaurant info section
                VStack(alignment: .leading, spacing: 12) {
                    Text(menu.restaurantName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                        Text(menu.location)
                    }
                    .foregroundColor(.gray)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(menu.categories, id: \.self) { category in
                                Text(category)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Menu items
                VStack(alignment: .leading, spacing: 16) {
                    Text("Menu")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(menu.menu) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("$\(String(format: "%.2f", item.price))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        RestaurantDetailView(menu: RestaurantMenu.example)
    }
} 