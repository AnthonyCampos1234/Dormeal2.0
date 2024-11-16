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
                    .padding(.top, 30)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    TextField("Last Name", text: $firstName)
                        .font(.system(size: 24))
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .focused($isFirstNameFocused)
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
                    .background(firstName.isEmpty ? Color.gray : Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .disabled(firstName.isEmpty)
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
    LastNameEntryView(showOnboarding: .constant(true))
}
