import SwiftUI

struct CarrierEmailEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    @FocusState private var isEmailFieldFocused: Bool
    var onBecomeCarrier: () -> Void
    @State private var navigateToCode = false
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter your email")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 80)
                    .padding(.horizontal)

                TextField("Email Address", text: $email)
                    .font(.system(size: 24))
                    .keyboardType(.emailAddress)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding(.horizontal)
                    .focused($isEmailFieldFocused)

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 16) {
                if !email.isEmpty {
                    Text("By entering and tapping Next, you agree to the Terms, E-Sign Consent & Privacy Notice")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                PrimaryButton(
                    title: "Next",
                    isDisabled: !isValidEmail(email)
                ) {
                    navigateToCode = true
                }
                .background(Color.white)
                .background(Color.white)
            }
            .background(Color.white)
        }
        .navigationDestination(isPresented: $navigateToCode) {
            CarrierCodeEntryView(
                showCarrierOnboarding: $showCarrierOnboarding,
                hideTabBar: $hideTabBar,
                onBecomeCarrier: onBecomeCarrier
            )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { isEmailFieldFocused = true }
    }
}

#Preview {
    CarrierEmailEntryView(
        showCarrierOnboarding: .constant(true),
        hideTabBar: .constant(true),
        onBecomeCarrier: {}
    )
} 
