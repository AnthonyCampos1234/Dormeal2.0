//
//  ContentView.swift
//  DormealApp
//
//  Created by Anthony Campos on 10/26/24.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject private var appState = AppState()
    @State private var selectedTab = 0
    @State private var isLoading = true
    @State private var showOnboarding = true
    
    var body: some View {
        ZStack {
            if showOnboarding {
                // Onboarding flow
                NavigationStack {
                    PhoneNumberEnterView(showOnboarding: $showOnboarding)
                }
                .opacity(isLoading ? 0 : 1)
            } else {
                // Main app content
                MainTabView(selectedTab: $selectedTab, showCarrierOnboarding: $appState.showCarrierOnboarding)
                    .environmentObject(appState)
                    .opacity(isLoading ? 0 : 1)
            }
            
            // Loading screen
            if isLoading {
                SplashScreenView()
                    .transition(.opacity)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            // Ensure keyboard is dismissed during loading
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                         to: nil, 
                                         from: nil, 
                                         for: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.50) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isLoading = false
                }
            }
        }
    }
}

struct SplashScreenView: View {
    @StateObject private var riveViewModel = RiveViewModel(fileName: "initial-loading-screen")
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            riveViewModel.view()
                .frame(width: 700, height: 700)
                .scaledToFill()
                .frame(minWidth: 0)
                .opacity(isVisible ? 1 : 0)
                .onAppear {
                    print("View appeared")
                    withAnimation(.easeIn(duration: 0.5)) {
                        isVisible = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        riveViewModel.reset()
                        print("Reset animation state")
                        riveViewModel.play(animationName: "Timeline 1")
                    }
                }
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: Int
    @Binding var showCarrierOnboarding: Bool
    @State private var hideTabBar = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                CarrierView(hideTabBar: $hideTabBar)
                    .tag(1)
                
                ProfileView()
                    .tag(2)
            }
            
            // Tab bar with visibility control
            if selectedTab != 1 || !hideTabBar {
                HStack(spacing: 0) {
                    Spacer()
                    // Home Tab Button
                    TabButton(
                        imageName: "home",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 }
                    )
                    
                    // Carrier Tab Button
                    TabButton(
                        imageName: "order",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 }
                    )
                    
                    // Profile Tab Button
                    TabButton(
                        imageName: "user",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )
                    Spacer()
                }
                .frame(height: 30)
                .padding(.vertical, 8)
                .background(
                    Rectangle()
                        .fill(.clear)
                        .background(.ultraThinMaterial)
                        .overlay(Color.white.opacity(0.95))
                        .edgesIgnoringSafeArea(.bottom)
                )
                .animation(.interpolatingSpring(mass: 0.5, stiffness: 200, damping: 12, initialVelocity: 0.8), value: selectedTab)
                .transition(.move(edge: .bottom))
            }
        }
        .onChange(of: selectedTab) { _ in
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.prepare()
            impact.impactOccurred(intensity: 0.7)
        }
    }
}

struct TabButton: View {
    let imageName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(isSelected ? "\(imageName)_filled" : "\(imageName)_outline")
                .scaleEffect(isSelected ? 1.0 : 0.9)
                .animation(.spring(response: 0.3, dampingFraction: 0.5).repeatCount(1, autoreverses: true), value: isSelected)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .contentShape(Rectangle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
