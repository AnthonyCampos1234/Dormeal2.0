import SwiftUI

struct MenuSectionView: View {
    let section: MenuSection
    let loadedItems: [String: MenuItem]
    let onItemAppear: (String) async -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            Text(section.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            // Items
            ForEach(section.items, id: \.self) { itemId in
                if let item = loadedItems[itemId] {
                    MenuItemView(item: item)
                } else {
                    MenuItemPlaceholder()
                        .task {
                            await onItemAppear(itemId)
                        }
                }
            }
        }
    }
}

// Placeholder view while item is loading
struct MenuItemPlaceholder: View {
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 20)
                    .frame(width: 120)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 16)
                    .frame(width: 200)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 16)
                    .frame(width: 80)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MenuSectionView(
        section: MenuSection(
            id: "1",
            name: "Burgers",
            imageUrl: "https://example.com/burgers.jpg",
            items: ["1"]
        ),
        loadedItems: [:],
        onItemAppear: { _ in }
    )
} 