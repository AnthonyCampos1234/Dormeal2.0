import SwiftUI

struct CarrierInfoSlidesView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    @State private var currentPage = 0
    
    private let slides = [
        OnboardingSlide(
            image: "carrier_earnings",
            title: "Earn Money",
            description: "Make up to $25/hour delivering food on campus"
        ),
        OnboardingSlide(
            image: "carrier_schedule",
            title: "Flexible Schedule",
            description: "Choose when you want to work. No minimum hours required"
        ),
        OnboardingSlide(
            image: "carrier_campus",
            title: "Stay on Campus",
            description: "All deliveries are within campus boundaries"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        VStack(spacing: 24) {
                            Image(slides[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 280)
                                .padding(.top, 60)
                            
                            Text(slides[index].title)
                                .font(.system(size: 28, weight: .bold))
                            
                            Text(slides[index].description)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                            
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Custom page indicator
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
                
                Button {
                    if currentPage < slides.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dismiss()
                            showCarrierOnboarding = false
                            hideTabBar = false
                        }
                    }
                } label: {
                    Text(currentPage == slides.count - 1 ? "Get Started" : "Next")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
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
    }
}

// Helper struct for slide data
private struct OnboardingSlide {
    let image: String
    let title: String
    let description: String
}

#Preview {
    CarrierInfoSlidesView(
        showCarrierOnboarding: .constant(true),
        hideTabBar: .constant(false)
    )
} 