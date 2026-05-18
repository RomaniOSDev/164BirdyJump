import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void

    @State private var currentPage = 0

    private let pages = OnboardingPage.all

    private var activeTheme: LevelTheme {
        pages[currentPage].theme
    }

    var body: some View {
        ZStack {
            ThemedSkyBackground(theme: activeTheme, showAmbient: true)
                .animation(.easeInOut(duration: 0.45), value: currentPage)

            VStack(spacing: 0) {
                topBar

                TabView(selection: $currentPage) {
                    ForEach(pages) { page in
                        OnboardingPageView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)

                pageIndicator
                    .padding(.top, 8)

                actionButton
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 28)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var topBar: some View {
        HStack {
            Spacer()
            if currentPage < pages.count - 1 {
                Button("Skip", action: onComplete)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.22))
                            .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    )
            } else {
                Color.clear.frame(height: 36)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(pages) { page in
                Capsule()
                    .fill(
                        page.id == currentPage
                            ? AnyShapeStyle(BirdyGradients.primaryButton)
                            : AnyShapeStyle(Color.white.opacity(0.35))
                    )
                    .frame(width: page.id == currentPage ? 28 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.25), value: currentPage)
            }
        }
    }

    private var actionButton: some View {
        Group {
            if currentPage < pages.count - 1 {
                BirdyPrimaryButton("Next", icon: "arrow.right") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage += 1
                    }
                }
            } else {
                BirdyPrimaryButton("Get Started", icon: "play.fill") {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
