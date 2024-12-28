import SwiftUI

struct HandoffCodeView: View {
    let order: Order
    @Environment(\.dismiss) private var dismiss
    @State private var code: String = ""
    @State private var isVerifying = false
    @State private var showError = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Enter Handoff Code")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Ask the customer for their 4-digit delivery code")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                TextField("Enter 4-digit code", text: $code)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                
                if showError {
                    Text("Invalid code. Please try again.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    verifyCode()
                }) {
                    HStack {
                        Text("Verify Code")
                            .fontWeight(.semibold)
                        if isVerifying {
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
                .disabled(code.count != 4 || isVerifying)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
    
    private func verifyCode() {
        isVerifying = true
        showError = false
        
        // Simulate verification
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isVerifying = false
            if code == "1234" { // Replace with actual verification
                dismiss()
            } else {
                showError = true
            }
        }
    }
} 