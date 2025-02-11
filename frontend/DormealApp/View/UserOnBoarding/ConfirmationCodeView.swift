import SwiftUI

struct ConfirmationCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var confirmationCode: String = ""
    @Binding var showOnboarding: Bool
    @FocusState private var isCodeFieldFocused: Bool
    @State private var navigateToFirstName = false
    private let maxDigits = 6
    @State private var showWrongNumberAlert = false
    @State private var showCodeExplanation = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Menu {
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Label("Wrong phone number", systemImage: "arrow.uturn.backward")
                    }
                    
                    Button {
                        showCodeExplanation = true
                    } label: {
                        Label("What code?", systemImage: "questionmark")
                    }
                } label: {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter verification code")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top, 22)
                
                HStack(spacing: 12) {
                    ForEach(0..<6) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .frame(width: 45, height: 55)
                            
                            if index < confirmationCode.count {
                                Text(String(Array(confirmationCode)[index]))
                                    .font(.system(size: 24))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay(
                    TextField("", text: $confirmationCode)
                        .keyboardType(.numberPad)
                        .focused($isCodeFieldFocused)
                        .opacity(0.001)
                )
                .padding(.horizontal)
                .onChange(of: confirmationCode) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered.count <= maxDigits {
                        confirmationCode = filtered
                    } else {
                        confirmationCode = String(filtered.prefix(maxDigits))
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            
            PrimaryButton(
                title: "Verify",
                isDisabled: confirmationCode.count != maxDigits
            ) {
                navigateToFirstName = true
            }
            .background(Color.white)
            .background(Color.white)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToFirstName) {
            FirstNameEntryView(showOnboarding: $showOnboarding)
        }
        .onAppear { isCodeFieldFocused = true }
        .alert("Verification Code", isPresented: $showCodeExplanation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We sent a code to the phone number entered.")
        }
    }
} 

#Preview {
    ConfirmationCodeView(showOnboarding: .constant(true))
}
