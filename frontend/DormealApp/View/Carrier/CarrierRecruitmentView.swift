import SwiftUI

struct CarrierRecruitmentView: View {
    @Binding var showCarrierOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image("savemoney_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("Become a Carrier")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Earn money delivering food on campus")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            PrimaryButtonNoBackground(title: "Start Earning") {
                showCarrierOnboarding = true
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
        }
        .padding()
    }
}

#Preview {
    CarrierRecruitmentView(showCarrierOnboarding: .constant(false))
} 
