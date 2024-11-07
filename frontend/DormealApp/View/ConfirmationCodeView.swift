import SwiftUI

struct ConfirmationCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var confirmationCode: String = ""
    @Binding var showOnboarding: Bool
    @FocusState private var isCodeFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter verification code")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 80)
                    .padding(.horizontal)
                
                Text("Enter the 6-digit code sent to your phone")
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

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                NameEntryView(showOnboarding: $showOnboarding)
            } label: {
                Text("Verify")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
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
    }
} 

#Preview {
    ConfirmationCodeView(showOnboarding: .constant(true))
}
