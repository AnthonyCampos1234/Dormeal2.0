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
    
    var body: some View {
        ZStack {
            // Main app content
            MainTabView(selectedTab: $selectedTab)
                .environmentObject(appState)
                .opacity(isLoading ? 0 : 1)
            
            // Loading screen
            if isLoading {
                SplashScreenView()
            }
        }
        .onAppear {
            // Adjust this time to match your animation duration
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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                CarrierView()
                    .tag(1)
                
                ProfileView()
                    .tag(2)
            }
            
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
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            .animation(.interpolatingSpring(mass: 0.5, stiffness: 200, damping: 12, initialVelocity: 0.8), value: selectedTab)
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
            VStack {
                Spacer().frame(height: 60)
                Image(isSelected ? "\(imageName)_filled" : "\(imageName)_outline")
                    .scaleEffect(isSelected ? 1.0 : 0.9)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5).repeatCount(1, autoreverses: true), value: isSelected)
                Spacer().frame(height: 10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
