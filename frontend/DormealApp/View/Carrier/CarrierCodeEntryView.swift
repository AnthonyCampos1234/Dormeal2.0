import SwiftUI

struct CarrierCodeEntryView: View {
    @EnvironmentObject private var appState: AppState
    @State private var verificationCode = ""
    @Environment(\.dismiss) private var dismiss
    let email: String
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    var onBecomeCarrier: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Enter Verification Code")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Please enter the verification code sent to \(email)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            TextField("Verification Code", text: $verificationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .disabled(appState.isLoading)
            
            Button(action: {
                Task {
                    await appState.verifyEmailToken(token: verificationCode)
                    if appState.isEmailVerified {
                        onBecomeCarrier()
                        showCarrierOnboarding = false
                        hideTabBar = false
                        dismiss()
                    }
                }
            }) {
                if appState.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Verify")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(appState.isLoading || verificationCode.count != 6)
            
            if let error = appState.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .navigationTitle("Email Verification")
    }
}

#Preview {
    NavigationStack {
        CarrierCodeEntryView(
            email: "test@example.com",
            showCarrierOnboarding: .constant(true),
            hideTabBar: .constant(true),
            onBecomeCarrier: {}
        )
        .environmentObject(AppState())
    }
} 
