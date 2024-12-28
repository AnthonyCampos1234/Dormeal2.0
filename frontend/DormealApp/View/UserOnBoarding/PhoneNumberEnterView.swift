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
    @State private var navigateToConfirmation = false
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

                PrimaryButton(
                    title: "Next",
                    isDisabled: phoneNumber.count != numberLimit
                ) {
                    navigateToConfirmation = true
                }
                .background(Color.white)
            }
            .background(Color.white)
        }
        .navigationDestination(isPresented: $navigateToConfirmation) {
            ConfirmationCodeView(showOnboarding: $showOnboarding)
        }
        .onAppear { 
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                isPhoneFieldFocused = true
            }
        }
    }
}

#Preview {
    PhoneNumberEnterView(showOnboarding: .constant(true))
}
