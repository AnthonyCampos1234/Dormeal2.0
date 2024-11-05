import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    NavigationLink(destination: Text("Edit Profile")) {
                        HStack(spacing: 15) {
                            Image("large_user_outline")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("User Name")
                                    .font(.headline)
                                Text("User Phone Number")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                    }
                }
                
                // Orders & Delivery section
                Section {
                    NavigationLink(destination: Text("Orders")) {
                        Label {
                            Text("My Orders")
                        } icon: {
                            Image("order_outline")  // Changed to outline
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                        .foregroundColor(.black)
                    }
                    
                    NavigationLink(destination: Text("Addresses")) {
                        Label {
                            Text("Delivery Addresses")
                        } icon: {
                            Image("location_outline")  // Changed to outline
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                        .foregroundColor(.black)
                    }
                } header: {
                    Text("Orders & Delivery")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .textCase(nil)
                }
                
                // Payment section
                Section {
                    NavigationLink(destination: Text("Payment Methods")) {
                        Label {
                            Text("Payment Methods")
                        } icon: {
                            Image("card_outline")  // Changed to outline
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                        .foregroundColor(.black)
                    }
                } header: {
                    Text("Payment")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .textCase(nil)
                }
                
                // Support section
                Section {
                    NavigationLink(destination: Text("Settings")) {
                        Label {
                            Text("Settings")
                        } icon: {
                            Image("settings_outline")  // Changed to outline
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                        .foregroundColor(.black)
                    }
                    
                    NavigationLink(destination: Text("Help & Support")) {
                        Label {
                            Text("Help & Support")
                        } icon: {
                            Image("help_outline")  // Changed to outline
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                        .foregroundColor(.black)
                    }
                } header: {
                    Text("Support")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .textCase(nil)
                }
                
                // Account section
                Section {
                    Button(action: {
                        appState.logout()
                    }) {
                        Label {
                            Text("Log Out")
                                .foregroundColor(.red)
                        } icon: {
                            Image("logout_outline")  // Changed to outline
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .listStyle(InsetGroupedListStyle())
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            Task {
                await appState.loadUserProfile()
            }
        }
    }
}