import SwiftUI

struct ConfirmationCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var confirmationCode: String = ""
    @Binding var showOnboarding: Bool
    @FocusState private var isCodeFieldFocused: Bool
    private let maxDigits = 6
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Please enter your 6-digit confirmation code")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 30)
                    .padding(.horizontal)

                TextField("Confirmation Code", text: $confirmationCode)
                    .font(.system(size: 24))
                    .keyboardType(.numberPad)
                    .textFieldStyle(PlainTextFieldStyle())
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .focused($isCodeFieldFocused)
                    .onChange(of: confirmationCode) {
                        newValue in
                        if newValue.count > maxDigits {
                            confirmationCode = String(newValue.prefix(maxDigits))
                        }
                    }
                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                FirstNameEntryView(showOnboarding: $showOnboarding)
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
                    HStack {
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
