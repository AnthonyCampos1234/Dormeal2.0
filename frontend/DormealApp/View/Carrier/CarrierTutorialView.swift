import SwiftUI

struct CarrierTutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showCarrierOnboarding: Bool
    @Binding var hideTabBar: Bool
    @State private var currentPage = 0
    @State private var navigateToNext = false
    var onBecomeCarrier: () -> Void
    
    private let slides = [
        TutorialSlide(
            image: "order_filled",
            title: "Earn Money",
            description: "Make up to $25/hour delivering food on campus"
        ),
        TutorialSlide(
            image: "location_outline",
            title: "Flexible Schedule",
            description: "Choose when you want to work. No minimum hours required"
        ),
        TutorialSlide(
            image: "order_outline",
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
                
                PrimaryButton(
                    title: currentPage == slides.count - 1 ? "Get Started" : "Next",
                    isDisabled: false
                ) {
                    if currentPage < slides.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showCarrierOnboarding = false
                        hideTabBar = false
                        onBecomeCarrier()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private struct TutorialSlide {
    let image: String
    let title: String
    let description: String
}

#Preview {
    CarrierTutorialView(
        showCarrierOnboarding: .constant(true),
        hideTabBar: .constant(true),
        onBecomeCarrier: {}
    )
} 
