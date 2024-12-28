//
//  FirstNameEntryView.swift
//  DormealApp
//
//  Created by Anthony Campos on 11/16/24.
//

import SwiftUI

struct FirstNameEntryView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @Binding var showOnboarding: Bool
    @FocusState private var isFirstNameFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToLastName = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter your first name")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 80)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    TextField("First Name", text: $firstName)
                        .font(.system(size: 24))
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .focused($isFirstNameFocused)
                }

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(
                title: "Next",
                isDisabled: firstName.isEmpty
            ) {
                navigateToLastName = true
            }
            .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToLastName) {
            LastNameEntryView(showOnboarding: $showOnboarding)
        }
        .onAppear { isFirstNameFocused = true }
    }
}

#Preview {
    FirstNameEntryView(showOnboarding: .constant(true))
}
