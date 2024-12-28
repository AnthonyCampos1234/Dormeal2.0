import SwiftUI

struct CarrierSignupPromptView: View {
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    @State private var navigateToEmailEntry = false
    var onBecomeCarrier: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Image("food_delivery_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Text("Ready to make a difference?")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack(spacing: 12) {
                    PrimaryButtonNoBackground(title: "Yes") {
                        navigateToEmailEntry = true
                    }
                    
                    Button {
                        showCarrierOnboarding = false
                    } label: {
                        Text("Not Now")
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .navigationDestination(isPresented: $navigateToEmailEntry) {
            CarrierEmailEntryView(
                showCarrierOnboarding: $showCarrierOnboarding,
                hideTabBar: $hideTabBar,
                onBecomeCarrier: onBecomeCarrier
            )
        }
    }
}

#Preview {
    CarrierSignupPromptView(
        showCarrierOnboarding: .constant(true),
        hideTabBar: .constant(true),
        onBecomeCarrier: {}
    )
} 
