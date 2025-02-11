import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var showingConfirmation = false
    @State private var selectedPaymentMethod = "Apple Pay" 
    let paymentMethods = ["Apple Pay", "Credit Card", "Debit Card"]
    
    private var subtotal: Double {
        appState.cart?.totalPrice ?? 0
    }
    
    private var deliveryFee: Double {
        3.99
    }
    
    private var serviceFee: Double {
        (subtotal * 0.10).rounded(to: 2)
    }
    
    private var total: Double {
        subtotal + deliveryFee + serviceFee
    }
    
    private func submitOrder() {
        isSubmitting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isSubmitting = false
            showingConfirmation = true
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        if let items = appState.cart?.items {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Order")
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.horizontal)
                                
                                ForEach(items) { item in
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.menuItem.name)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                            Text("$\(item.itemTotal, specifier: "%.2f")")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Delivery Details")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.horizontal)
                            
                            if let building = appState.user?.homeBuilding {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Delivery Location")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray)
                                        Text(building.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color.black)
                                .cornerRadius(8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Payment Details")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                ForEach(paymentMethods, id: \.self) { method in
                                    Button(action: {
                                        selectedPaymentMethod = method
                                    }) {
                                        HStack {
                                            Image(systemName: selectedPaymentMethod == method ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(selectedPaymentMethod == method ? .white : .gray)
                                            
                                            HStack(spacing: 12) {
                                                Image(systemName: method == "Apple Pay" ? "apple.logo" : "creditcard")
                                                    .foregroundColor(.white)
                                                
                                                Text(method)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.white)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding()
                                        .background(selectedPaymentMethod == method ? Color.black : Color.black.opacity(0.8))
                                    }
                                    
                                    if method != paymentMethods.last {
                                        Divider()
                                            .background(Color.gray.opacity(0.3))
                                    }
                                }
                            }
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Save Big with Dormeal")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.horizontal)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Other Delivery Apps")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "FF3008"))
                                    Text("$\((total * 1.4).rounded(to: 2), specifier: "%.2f")")
                                        .strikethrough()
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                    Text("(actual price from a certain dashing competitor)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                    
                                    Text("Dormeal Price")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.green)
                                    Text("$\(total, specifier: "%.2f")")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.green)
                                    
                                    Text("You're saving $\(((total * 1.4) - total).rounded(to: 2), specifier: "%.2f")! 🎉")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.green)
                                        .padding(.top, 4)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Order Summary")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.horizontal)
                            
                            VStack(spacing: 16) {
                                Group {
                                    PriceLine(title: "Subtotal", amount: subtotal)
                                    PriceLine(title: "Delivery Fee", amount: deliveryFee)
                                    PriceLine(title: "Service Fee", amount: serviceFee)
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                    PriceLine(title: "Total", amount: total, isTotal: true)
                                }
                            }
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                
                VStack {
                    PrimaryButton(
                        title: "Pay",
                        isLoading: isSubmitting
                    ) {
                        submitOrder()
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -4)
                .disabled(isSubmitting)
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingConfirmation) {
            OrderConfirmationView(orderNumber: "DM\(Int.random(in: 100000...999999))")
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

struct PriceLine: View {
    let title: String
    let amount: Double
    var isTotal: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: isTotal ? 16 : 14, weight: isTotal ? .semibold : .regular))
                .foregroundColor(isTotal ? .white : .gray)
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
                .font(.system(size: isTotal ? 16 : 14, weight: isTotal ? .semibold : .regular))
                .foregroundColor(isTotal ? .white : .gray)
        }
    }
}

extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    let mockAppState = AppState()
    mockAppState.user = User(
        id: "u1",
        homeBuilding: Building(
            id: "b1",
            name: "Warren College",
            location: "Warren Campus"
        ),
        name: "John Doe",
        phoneNumber: "+1234567890"
    )
    
    let restaurant = Restaurant(
        id: "r1",
        name: "Sample Restaurant",
        address: "123 Main St",
        website: "example.com",
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
    )
    
    mockAppState.cart = Cart(
        id: "c1",
        restaurant: restaurant,
        items: [],
        totalPrice: 0
    )
    
    return NavigationStack {
        CheckoutView()
            .environmentObject(mockAppState)
    }
} 
