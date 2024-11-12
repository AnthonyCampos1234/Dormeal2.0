import SwiftUI

struct MenuItemDetailView: View {
    let item: MenuItem
    @Environment(\.dismiss) var dismiss
    var onAddPress: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image Section with Overlaid Close Button
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: item.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 250)
                    }
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                    .padding(16)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Price
                    HStack {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(String(format: "%.2f", item.price))")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    // Description
                    Text(item.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Add to Cart Button
                    Button(action: {
                        onAddPress()
                        dismiss()
                    }) {
                        HStack {
                            Text("Add to Cart")
                            Image(systemName: "cart.badge.plus")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
    }
} 