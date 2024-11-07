import SwiftUI

struct CarrierCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var confirmationCode: String = ""
    @State private var navigateToSlides = false
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    @FocusState private var isCodeFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter verification code")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 80)
                    .padding(.horizontal)
                
                Text("Enter the 6-digit code sent to your email")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                TextField("000000", text: $confirmationCode)
                    .font(.system(size: 24))
                    .keyboardType(.numberPad)
                    .textFieldStyle(PlainTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .focused($isCodeFieldFocused)
                    .onChange(of: confirmationCode) { newValue in
                        confirmationCode = String(newValue.prefix(6))
                    }

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                navigateToSlides = true
            } label: {
                Text("Verify")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
            .padding(.bottom, 40)
            .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .regular))
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .onAppear { isCodeFieldFocused = true }
        .navigationDestination(isPresented: $navigateToSlides) {
            CarrierInfoSlidesView(
                showCarrierOnboarding: $showCarrierOnboarding,
                hideTabBar: $hideTabBar
            )
        }
    }
} 