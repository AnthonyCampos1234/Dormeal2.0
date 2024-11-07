import SwiftUI

struct CarrierOnboardingView: View {
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image("delivery_illustration")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    Text("Become a Carrier")
                        .font(.system(size: 32, weight: .bold))
                    
                    Text("Earn money by delivering food to students on campus")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    NavigationLink {
                        CarrierEmailView(
                            showCarrierOnboarding: $showCarrierOnboarding,
                            hideTabBar: $hideTabBar
                        )
                        .onAppear {
                            hideTabBar = true
                        }
                    } label: {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
    }
} 