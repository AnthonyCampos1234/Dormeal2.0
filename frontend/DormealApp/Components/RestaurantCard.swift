import SwiftUI

struct RestaurantCard: View {
    let menu: RestaurantMenu
    
    var body: some View {
        NavigationLink(destination: RestaurantDetailView(menu: menu)) {
            HStack(spacing: 12) {
                // Restaurant Image
                AsyncImage(url: URL(string: menu.logo)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.caption)
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                
                // Restaurant Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(menu.restaurantName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                        Text(menu.location)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Tags for food categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(menu.categories.prefix(3), id: \.self) { category in
                                Text(category)
                                    .font(.caption2)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(8)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    RestaurantCard(menu: RestaurantMenu.example) // You'll need to create an example menu for previews
} 