//
//  PhoneNumberEnterView.swift
//  DormealApp
//
//  Created by Anthony Campos on 11/7/24.
//

import SwiftUI

struct PhoneNumberEnterView: View {
    @State private var phoneNumber: String = ""
    @Binding var showOnboarding: Bool
    @FocusState private var isPhoneFieldFocused: Bool
    private let numberLimit = 10
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter your phone")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 80)
                    .padding(.horizontal)

                HStack(spacing: 8) {
                    Text("+1")
                        .font(.system(size: 24))
                    TextField("Mobile Number", text: $phoneNumber)
                        .font(.system(size: 24))
                        .keyboardType(.phonePad)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isPhoneFieldFocused)
                        .onChange(of: phoneNumber) {
                            newValue in
                            if newValue.count > numberLimit {
                                phoneNumber = String(newValue.prefix(numberLimit))
                            }
                        }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 16) {
                if !phoneNumber.isEmpty {
                    Text("By entering and tapping Next, you agree to the Terms, E-Sign Consent & Privacy Notice")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                NavigationLink {
                    ConfirmationCodeView(showOnboarding: $showOnboarding)
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(phoneNumber.count == numberLimit ? Color.black : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .disabled(phoneNumber.isEmpty)
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
            .background(Color.white)
        }
        .onAppear { 
            // Delay focusing until after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                isPhoneFieldFocused = true
            }
        }
    }
}

#Preview {
    PhoneNumberEnterView(showOnboarding: .constant(true))
}
