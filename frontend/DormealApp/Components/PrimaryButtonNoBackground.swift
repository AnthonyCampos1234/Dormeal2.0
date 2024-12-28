import SwiftUI

struct PrimaryButtonNoBackground: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let isDisabled: Bool
    
    init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = false
        self.isDisabled = false
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.black.opacity(isDisabled || isLoading ? 0.5 : 1))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.vertical, 15)
        }
        .disabled(isDisabled || isLoading)
    }
}

#Preview {
    VStack {
        PrimaryButtonNoBackground(title: "Next") {
            print("Button tapped")
        }
        
        PrimaryButtonNoBackground(title: "Loading", isLoading: true) {
            print("Button tapped")
        }
    }
}
