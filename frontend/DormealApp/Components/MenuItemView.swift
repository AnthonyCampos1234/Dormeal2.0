import SwiftUI

struct MenuItemView: View {
    let item: MenuItem
    var onAddPress: () -> Void
    @State private var showingDetail = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: { showingDetail = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .padding(16)
            }
        }
        .sheet(isPresented: $showingDetail) {
            MenuItemDetailView(item: item, onAddPress: onAddPress)
        }
        .padding(.horizontal)
    }
} 