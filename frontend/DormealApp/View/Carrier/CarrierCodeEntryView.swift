import SwiftUI

struct CarrierCodeEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var code = ""
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    @FocusState private var isCodeFieldFocused: Bool
    var onBecomeCarrier: () -> Void
    private let maxDigits = 6
    @State private var showCodeExplanation = false
    @State private var navigateToTutorial = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Menu {
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Label("Wrong email", systemImage: "arrow.uturn.backward")
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
                    .padding(.top, 22)
                    .padding(.leading)
                
                HStack(spacing: 12) {
                    Spacer()
                    ForEach(0..<6) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .frame(width: 45, height: 55)
                            
                            if index < code.count {
                                Text(String(Array(code)[index]))
                                    .font(.system(size: 24))
                            }
                        }
                    }
                    Spacer()
                }
                .overlay(
                    TextField("", text: $code)
                        .keyboardType(.numberPad)
                        .focused($isCodeFieldFocused)
                        .opacity(0.001)
                )
                .padding(.horizontal)
                .onChange(of: code) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered.count <= maxDigits {
                        code = filtered
                    } else {
                        code = String(filtered.prefix(maxDigits))
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            
            PrimaryButton(
                title: "Verify",
                isDisabled: code.count != maxDigits
            ) {
                navigateToTutorial = true
            }
            .background(Color.white)
            .background(Color.white)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear { isCodeFieldFocused = true }
        .alert("Verification Code", isPresented: $showCodeExplanation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We sent a code to the email entered")
        }
        .navigationDestination(isPresented: $navigateToTutorial) {
            CarrierTutorialView(
                showCarrierOnboarding: $showCarrierOnboarding,
                hideTabBar: $hideTabBar,
                onBecomeCarrier: onBecomeCarrier
            )
        }
    }
}

#Preview {
    CarrierCodeEntryView(
        showCarrierOnboarding: .constant(true),
        hideTabBar: .constant(true),
        onBecomeCarrier: {}
    )
} 
