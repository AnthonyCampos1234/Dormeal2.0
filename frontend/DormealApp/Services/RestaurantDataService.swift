import Foundation

class RestaurantDataService {
    static func loadRestaurantData() -> [RestaurantMenu] {
        guard let url = Bundle.main.url(forResource: "restaurant_data", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error loading restaurant data")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(RestaurantsResponse.self, from: data)
            return response.restaurants
        } catch {
            print("Error decoding restaurant data: \(error)")
            return []
        }
    }
}

struct RestaurantsResponse: Codable {
    let restaurants: [RestaurantMenu]
} 