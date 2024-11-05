import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Login") {
                Task {
                    await appState.login(email: email, password: password)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(appState.isLoading)
            
            if appState.isLoading {
                ProgressView()
            }
        }
        .padding()
        .alert("Error", isPresented: .constant(appState.errorMessage != nil)) {
            Button("OK") { appState.errorMessage = nil }
        } message: {
            Text(appState.errorMessage ?? "")
        }
    }
} 