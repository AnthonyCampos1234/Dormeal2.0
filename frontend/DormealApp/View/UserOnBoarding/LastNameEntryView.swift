//
//  LastNameEntryView.swift
//  DormealApp
//
//  Created by Anthony Campos on 11/16/24.
//

import SwiftUI

struct LastNameEntryView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @Binding var showOnboarding: Bool
    @FocusState private var isFirstNameFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter your last name")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 80)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    TextField("Last Name", text: $lastName)
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
                isDisabled: lastName.isEmpty
            ) {
                showOnboarding = false
            }
            .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { isFirstNameFocused = true }
    }
}

#Preview {
    LastNameEntryView(showOnboarding: .constant(true))
}
