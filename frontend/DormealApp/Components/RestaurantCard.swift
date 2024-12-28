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
                Text(menu.restaurantName)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
            .padding(8)
            .background(Color.black)
            .cornerRadius(8)
        }
    }
}

#Preview {
    RestaurantCard(menu: RestaurantMenu.example) 
} 
