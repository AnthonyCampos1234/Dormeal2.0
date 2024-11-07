import SwiftUI

struct CarrierEmailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    @FocusState private var isEmailFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter your .edu email")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 80)
                    .padding(.horizontal)
                
                TextField("university@edu.com", text: $email)
                    .font(.system(size: 18))
                    .keyboardType(.emailAddress)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isEmailFieldFocused)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                CarrierCodeView(
                    showCarrierOnboarding: $showCarrierOnboarding,
                    hideTabBar: $hideTabBar
                )
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(email.isEmpty ? Color.gray : Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .disabled(email.isEmpty)
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
        .onAppear { isEmailFieldFocused = true }
    }
} 