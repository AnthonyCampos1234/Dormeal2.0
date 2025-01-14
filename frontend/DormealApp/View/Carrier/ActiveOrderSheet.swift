import SwiftUI

enum DeliveryState {
    case pickingUp
    case delivering
    case arrived
}

struct ActiveOrderSheet: View {
    @EnvironmentObject private var appState: AppState
    let order: Order
    @Environment(\.dismiss) private var dismiss
    @State private var isCompletingOrder = false
    @State private var showingConfirmation = false
    @State private var deliveryState: DeliveryState = .pickingUp
    @State private var showingPickupConfirmation = false
    @State private var showingNearbyConfirmation = false
    @State private var showingExchangePointConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Dormeal Logo Section
                        brandSection
                        
                        Divider()
                            .background(Color.gray)
                        
                        // Status Bar
                        statusSection
                        
                        // Notification Section
                        notificationSection
                        
                        Divider()
                            .background(Color.gray)
                        
                        // Restaurant Pickup
                        pickupSection
                        
                        // Directions Button
                        directionsButton
                        
                        Divider()
                            .background(Color.gray)
                        
                        // Order Details
                        orderDetailsSection
                        
                        Divider()
                            .background(Color.gray)
                        
                        // Delivery Location
                        deliverySection
                        
                        if order.deliveryMethod == .meetAtDoor {
                            VStack {
                                if let timer = appState.exchangePointTimer {
                                    Text("Waiting for customer: \(timeString(from: appState.exchangePointTimeRemaining))")
                                        .font(.headline)
                                        .foregroundColor(.yellow)
                                } else {
                                    Button(action: {
                                        showingExchangePointConfirmation = true
                                    }) {
                                        Text("At Customer's Door")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .disabled(appState.isLoading)
                                }
                            }
                            .alert("Confirm Arrival", isPresented: $showingExchangePointConfirmation) {
                                Button("Cancel", role: .cancel) { }
                                Button("Confirm", role: .destructive) {
                                    Task {
                                        await appState.markOrderAtExchangePoint(orderId: order.id)
                                    }
                                }
                            } message: {
                                Text("Please confirm you're at the customer's door")
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .safeAreaInset(edge: .bottom) {
                completeOrderButton
            }
        }
        .preferredColorScheme(.dark)
        .alert(alertTitle, isPresented: $showingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm", role: .destructive) {
                isCompletingOrder = true
                // Simulate a network call
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isCompletingOrder = false
                    switch deliveryState {
                    case .pickingUp:
                        deliveryState = .delivering
                    case .delivering:
                        deliveryState = .arrived
                    case .arrived:
                        dismiss()
                    }
                }
            }
        } message: {
            Text(alertMessage)
        }
        .alert("Confirm Pickup", isPresented: $showingPickupConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm", role: .destructive) {
                Task {
                    await appState.markOrderAsPickedUp(orderId: order.id)
                }
            }
        } message: {
            Text("Please confirm you have picked up the order from \(order.cart.restaurant.name)")
        }
        .alert("Confirm Arrival", isPresented: $showingNearbyConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm", role: .destructive) {
                Task {
                    await appState.markOrderAsNearby(orderId: order.id)
                }
            }
        } message: {
            Text("Please confirm you're almost at \(order.building.name)")
        }
        .overlay {
            if appState.isLoading {
                ProgressView()
                    .background(Color.black.opacity(0.5))
            }
        }
    }
    
    private var brandSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Dormeal")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Order #\(order.id.prefix(6))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
    }
    
    private var statusSection: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(statusColor)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: statusIcon)
                        .font(.title3)
                        .foregroundColor(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Order Status")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(statusText)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
    }
    
    private var statusColor: Color {
        switch deliveryState {
        case .pickingUp:
            return .blue
        case .delivering:
            return .orange
        case .arrived:
            return .green
        }
    }
    
    private var statusIcon: String {
        switch deliveryState {
        case .pickingUp:
            return "bicycle"
        case .delivering:
            return "arrow.forward"
        case .arrived:
            return "checkmark"
        }
    }
    
    private var statusText: String {
        switch deliveryState {
        case .pickingUp:
            return "Picking Up"
        case .delivering:
            return "On The Way"
        case .arrived:
            return "Arrived"
        }
    }
    
    private var notificationSection: some View {
        HStack {
            Image(systemName: "bell.fill")
                .foregroundColor(.green)
            Text(notificationText)
                .font(.subheadline)
                .foregroundColor(.green)
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private var notificationText: String {
        switch deliveryState {
        case .pickingUp:
            return "Customer has been notified you're on the way"
        case .delivering:
            return "Customer has been notified their order is being delivered"
        case .arrived:
            return "Customer has been notified you've arrived"
        }
    }
    
    private var directionsButton: some View {
        Button(action: {
            let destination = deliveryState == .pickingUp 
                ? order.cart.restaurant.address
                : order.location
            // TODO: Open maps with destination
        }) {
            HStack {
                Image(systemName: "map")
                Text("Open in Maps")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
    
    private var pickupSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(deliveryState == .pickingUp ? "Restaurant Pickup" : "Delivery Location", 
                  systemImage: deliveryState == .pickingUp ? "bag" : "location.fill")
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
                if deliveryState == .pickingUp {
                    AsyncImage(url: URL(string: order.cart.restaurant.imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.cart.restaurant.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(order.cart.restaurant.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.building.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(order.location)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    private var deliverySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Delivery Information", systemImage: "location.fill")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(order.building.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(order.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if let user = order.user {
                Divider()
                    .background(Color.gray)
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var orderDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Order Items", systemImage: "list.bullet")
                .font(.headline)
                .foregroundColor(.gray)
            
            ForEach(order.cart.items, id: \.id) { item in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.menuItem.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        Text("1x")
                            .foregroundColor(.gray)
                        Text("$\(item.itemTotal, specifier: "%.2f")")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .font(.system(.body, design: .rounded))
            }
            
            Divider()
                .background(Color.gray)
                .padding(.vertical, 8)
            
            HStack {
                Text("Carrier Payout")
                    .foregroundColor(.white)
                Spacer()
                Text("$\(order.carrierPayout, specifier: "%.2f")")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .font(.system(.body, design: .rounded))
        }
    }
    
    private var completeOrderButton: some View {
        VStack(spacing: 8) {
            Text(buttonInstructionText)
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                showingConfirmation = true
            }) {
                HStack {
                    Text(buttonText)
                        .fontWeight(.semibold)
                    if isCompletingOrder {
                        ProgressView()
                            .tint(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(12)
            }
            .disabled(isCompletingOrder)
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
    
    private var buttonText: String {
        switch deliveryState {
        case .pickingUp:
            return "Order Picked Up"
        case .delivering:
            return "Almost There"
        case .arrived:
            return "I'm Here"
        }
    }
    
    private var buttonInstructionText: String {
        switch deliveryState {
        case .pickingUp:
            return "Only click this once you've picked up the order"
        case .delivering:
            return "Click this when you're almost at the delivery location"
        case .arrived:
            return "Click this when you've arrived at the delivery location"
        }
    }
    
    private var alertTitle: String {
        switch deliveryState {
        case .pickingUp:
            return "Confirm Pickup"
        case .delivering:
            return "Confirm Almost There"
        case .arrived:
            return "Confirm Arrival"
        }
    }
    
    private var alertMessage: String {
        switch deliveryState {
        case .pickingUp:
            return "Please confirm you have picked up the order from \(order.cart.restaurant.name)"
        case .delivering:
            return "Please confirm you're almost at \(order.building.name)"
        case .arrived:
            return "Please confirm you've arrived at the delivery location"
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    ActiveOrderSheet(order: Order.sampleOrder)
} 