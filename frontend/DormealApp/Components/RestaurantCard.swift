import SwiftUI

struct RestaurantCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        NavigationLink(destination: RestaurantDetailView(restaurantId: restaurant.id)) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: restaurant.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                
                Text(restaurant.name)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}

#Preview {
    RestaurantCard(restaurant: Restaurant(
        id: "1",
        name: "Example Restaurant",
        address: "123 Example St",
        website: "www.example.com",
        imageUrl: "https://example.com/image.jpg",
        operatingHours: OperatingHours(
            monday: Hours(open: "09:00:00", close: "22:00:00"),
            tuesday: Hours(open: "09:00:00", close: "22:00:00"),
            wednesday: Hours(open: "09:00:00", close: "22:00:00"),
            thursday: Hours(open: "09:00:00", close: "22:00:00"),
            friday: Hours(open: "09:00:00", close: "22:00:00"),
            saturday: Hours(open: "10:00:00", close: "23:00:00"),
            sunday: Hours(open: "10:00:00", close: "21:00:00")
        )
    ))
} 
