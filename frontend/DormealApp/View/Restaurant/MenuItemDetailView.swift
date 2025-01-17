import SwiftUI

struct MenuItemDetailView: View {
    let item: MenuItem
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOptions: [String: String] = [:]
    @State private var selectedAddOns: Set<String> = []
    @State private var quantity: Int = 1
    
    private var totalPrice: Double {
        let basePrice = item.price * Double(quantity)
        
        let optionsPrice = selectedOptions.compactMap { (sectionId, optionId) -> Double? in
            guard let section = item.optionsSections.first(where: { $0.id == sectionId }),
                  let option = section.options.first(where: { $0.id == optionId }) else {
                return nil
            }
            return option.price
        }.reduce(0, +) * Double(quantity)
        
        let addOnsPrice = selectedAddOns.compactMap { addOnId -> Double? in
            item.addOnsSections.flatMap { $0.addOns }.first { $0.id == addOnId }?.price
        }.reduce(0, +) * Double(quantity)
        
        return basePrice + optionsPrice + addOnsPrice
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Item Image
                    AsyncImage(url: URL(string: item.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Item Details
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Quantity Selector
                        HStack {
                            Text("Quantity")
                            Spacer()
                            HStack(spacing: 20) {
                                Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                }
                                Text("\(quantity)")
                                Button(action: { quantity += 1 }) {
                                    Image(systemName: "plus.circle.fill")
                                }
                            }
                        }
                        
                        // Options Sections
                        ForEach(item.optionsSections, id: \.id) { section in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(section.name)
                                    .font(.headline)
                                if section.mandatory {
                                    Text("Required")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                
                                ForEach(section.options, id: \.id) { option in
                                    OptionRow(
                                        name: option.name,
                                        price: option.price,
                                        isSelected: selectedOptions[section.id] == option.id
                                    ) {
                                        selectedOptions[section.id] = option.id
                                    }
                                }
                            }
                        }
                        
                        // Add-ons Sections
                        ForEach(item.addOnsSections, id: \.id) { section in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(section.name)
                                    .font(.headline)
                                Text("Maximum \(section.maxAddOns)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                ForEach(section.addOns, id: \.id) { addOn in
                                    AddOnRow(
                                        name: addOn.name,
                                        price: addOn.price,
                                        isSelected: selectedAddOns.contains(addOn.id)
                                    ) {
                                        if selectedAddOns.contains(addOn.id) {
                                            selectedAddOns.remove(addOn.id)
                                        } else if selectedAddOns.count < section.maxAddOns {
                                            selectedAddOns.insert(addOn.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(title: "Add to Cart • $\(String(format: "%.2f", totalPrice))") {
                    // Add to cart logic here
                    dismiss()
                }
            }
        }
    }
}

struct OptionRow: View {
    let name: String
    let price: Double
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "circle.fill" : "circle")
                Text(name)
                Spacer()
                if price > 0 {
                    Text("+$\(price, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }
        }
        .foregroundColor(isSelected ? .black : .primary)
    }
}

struct AddOnRow: View {
    let name: String
    let price: Double
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                Text(name)
                Spacer()
                if price > 0 {
                    Text("+$\(price, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }
        }
        .foregroundColor(isSelected ? .black : .primary)
    }
}

#Preview {
    MenuItemDetailView(item: MenuItem(
        id: "1",
        name: "Classic Burger",
        price: 9.99,
        imageUrl: "https://example.com/burger.jpg",
        optionsSections: [
            OptionsSection(
                id: "1",
                name: "Size",
                mandatory: true,
                options: [
                    Option(id: "1", name: "Regular", price: 0),
                    Option(id: "2", name: "Large", price: 2)
                ]
            )
        ],
        addOnsSections: [
            AddOnsSection(
                id: "1",
                name: "Toppings",
                maxAddOns: 3,
                addOns: [
                    AddOn(id: "1", name: "Cheese", price: 1),
                    AddOn(id: "2", name: "Bacon", price: 2)
                ]
            )
        ]
    ))
} 