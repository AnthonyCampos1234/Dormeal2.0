import SwiftUI

struct MenuItemView: View {
    let item: MenuItem
    @State private var showingDetail = false
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: item.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                    
                    Text("$\(item.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !item.optionsSections.isEmpty {
                        Text("Customizable")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            MenuItemDetailView(item: item)
        }
    }
}

#Preview {
    MenuItemView(
        item: MenuItem(
            id: "1",
            name: "Classic Burger",
            price: 9.99,
            imageUrl: "https://example.com/burger.jpg",
            optionsSections: [],
            addOnsSections: []
        )
    )
} 
