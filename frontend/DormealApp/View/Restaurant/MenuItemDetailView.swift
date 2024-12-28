import SwiftUI

struct MenuItemDetailView: View {
    let item: MenuItem
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var appState: AppState
    var onAddPress: () -> Void
    
    @State private var selectedOptions: [String: Set<String>] = [:]
    @State private var quantity: Int = 1
    @State private var hasAddedToCart: Bool = false
    @State private var showingRequiredError = false
    
    // Add scroll proxy
    @Namespace private var topID
    @Namespace private var firstMissingRequiredID
    
    private var totalPrice: Double {
        let basePrice = item.price * Double(quantity)
        let optionsPrice = selectedOptions.flatMap { (groupId, optionIds) in
            item.optionGroups.first { $0.id == groupId }?.options
                .filter { optionIds.contains($0.id) }
                .map { $0.price } ?? []
        }.reduce(0, +) * Double(quantity)
        
        return basePrice + optionsPrice
    }
    
    private var missingRequiredOptions: [MenuItemOptionGroup] {
        item.optionGroups.filter { group in
            group.required && (selectedOptions[group.id]?.isEmpty ?? true)
        }
    }
    
    private var canAddToCart: Bool {
        missingRequiredOptions.isEmpty
    }
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
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
                            
                            // Quantity Selector
                            HStack {
                                Text("Quantity")
                                    .font(.headline)
                                Spacer()
                                HStack {
                                    Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                        Image(systemName: "minus.circle.fill")
                                    }
                                    Text("\(quantity)")
                                        .frame(width: 40)
                                    Button(action: { quantity += 1 }) {
                                        Image(systemName: "plus.circle.fill")
                                    }
                                }
                                .font(.title3)
                            }
                            
                            // Options Groups
                            ForEach(item.optionGroups) { group in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(group.name)
                                            .font(.headline)
                                        if group.required {
                                            Text("Required")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .id(group.id) // Add ID for scrolling
                                    
                                    Text(group.multiSelect ? 
                                         "Select \(group.minSelections)-\(group.maxSelections) options" :
                                         "Select 1 option")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    ForEach(group.options) { option in
                                        OptionRow(
                                            option: option,
                                            isSelected: selectedOptions[group.id]?.contains(option.id) ?? false,
                                            isMultiSelect: group.multiSelect
                                        ) {
                                            toggleOption(groupId: group.id, optionId: option.id, group: group)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                                .background(
                                    // Add background for missing required options
                                    Group {
                                        if showingRequiredError && group.required && (selectedOptions[group.id]?.isEmpty ?? true) {
                                            Color.red.opacity(0.1)
                                        }
                                    }
                                )
                            }
                        }
                        .padding()
                        
                        Spacer(minLength: 100)
                    }
                }
                .onChange(of: showingRequiredError) { newValue in
                    if newValue, let firstMissing = missingRequiredOptions.first {
                        withAnimation {
                            proxy.scrollTo(firstMissing.id, anchor: .center)
                        }
                    }
                }
            }
            
            // Updated Add/View Cart Button
            VStack {
                Spacer()
                PrimaryButton(
                    title: hasAddedToCart 
                        ? "View Cart (\(appState.cart?.items.count ?? 0))"
                        : "Add to Cart • $\(String(format: "%.2f", totalPrice))"
                ) {
                    if hasAddedToCart {
                        dismiss()
                    } else if canAddToCart {
                        onAddPress()
                        hasAddedToCart = true
                    } else {
                        showingRequiredError = true
                    }
                }
            }
        }
        .onChange(of: selectedOptions) { _ in
            // Reset error state when selections change
            if showingRequiredError {
                showingRequiredError = false
            }
        }
    }
    
    private func toggleOption(groupId: String, optionId: String, group: MenuItemOptionGroup) {
        var currentSelection = selectedOptions[groupId] ?? Set<String>()
        
        if group.multiSelect {
            if currentSelection.contains(optionId) {
                currentSelection.remove(optionId)
            } else if currentSelection.count < group.maxSelections {
                currentSelection.insert(optionId)
            }
        } else {
            currentSelection = [optionId]
        }
        
        selectedOptions[groupId] = currentSelection
    }
}

struct OptionRow: View {
    let option: MenuItemOption
    let isSelected: Bool
    let isMultiSelect: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isMultiSelect {
                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                } else {
                    Image(systemName: isSelected ? "circle.fill" : "circle")
                }
                
                Text(option.name)
                Spacer()
                if option.price > 0 {
                    Text("+$\(option.price, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview
struct MenuItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        appState.cart = Cart(
            id: "preview",
            menu: RestaurantMenu(
                id: "1",
                restaurantName: "Test Restaurant",
                logo: "",
                location: "Test Location",
                categories: [],
                menu: []
            ),
            items: [],
            totalPrice: 0
        )
        
        return MenuItemDetailView(
            item: MenuItem(
                id: "1",
                name: "Deluxe Burger",
                price: 12.99,
                description: "A juicy beef patty topped with fresh lettuce, tomatoes, cheese, and our special sauce. Served with crispy fries on the side.",
                category: "Main Course",
                imageUrl: "https://example.com/burger.jpg",
                optionGroups: [
                    MenuItemOptionGroup(
                        id: "patty-temp",
                        name: "How would you like your patty?",
                        required: true,
                        multiSelect: false,
                        minSelections: 1,
                        maxSelections: 1,
                        options: [
                            MenuItemOption(id: "rare", name: "Rare", price: 0),
                            MenuItemOption(id: "medium", name: "Medium", price: 0),
                            MenuItemOption(id: "well", name: "Well Done", price: 0)
                        ]
                    )
                ]
            ),
            onAddPress: {}
        )
        .environmentObject(appState)
    }
} 