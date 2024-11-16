import SwiftUI

struct NameEntryView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @Binding var showOnboarding: Bool
    @FocusState private var isFirstNameFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter your name")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 80)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    TextField("First Name", text: $firstName)
                        .font(.system(size: 18))
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .focused($isFirstNameFocused)
                    
                    TextField("Last Name", text: $lastName)
                        .font(.system(size: 18))
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                showOnboarding = false
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(firstName.isEmpty || lastName.isEmpty ? Color.gray : Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .disabled(firstName.isEmpty || lastName.isEmpty)
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
        .onAppear { isFirstNameFocused = true }
    }
}

#Preview {
    NameEntryView(showOnboarding: .constant(true))
}
