import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage

    @State private var animateFly = false

    var body: some View {
        VStack(spacing: 20) {
            illustration
                .frame(height: 220)

            VStack(spacing: 10) {
                Text(page.title)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.white.opacity(0.88)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.2), radius: 2, y: 1)

                Text(page.subtitle)
                    .font(.headline.weight(.bold))
                    .foregroundColor(.birdyBird)

                Text(page.detail)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 8)
            }

            VStack(spacing: 8) {
                ForEach(page.highlights) { item in
                    highlightRow(item)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var illustration: some View {
        BirdyGlassCard {
            switch page.id {
            case 0:
                flyIllustration
            case 1:
                worldsIllustration
            default:
                launchIllustration
            }
        }
    }

    private var flyIllustration: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.birdyBird.opacity(0.45), Color.birdyBird.opacity(0.05)],
                        center: .center,
                        startRadius: 8,
                        endRadius: 70
                    )
                )
                .frame(width: 120, height: 120)
                .shadow(color: .birdyBird.opacity(0.35), radius: 10, y: 4)

            VectorBirdShape(wingAngle: animateFly ? -14 : 10)
                .frame(width: 88, height: 88)
                .offset(y: animateFly ? -8 : 6)

            Image(systemName: "hand.tap.fill")
                .font(.title2.weight(.bold))
                .foregroundColor(.white.opacity(0.9))
                .offset(x: 58, y: 48)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.05).repeatForever(autoreverses: true)) {
                animateFly = true
            }
        }
    }

    private var worldsIllustration: some View {
        HStack(spacing: 14) {
            ForEach(LevelTheme.allCases, id: \.rawValue) { theme in
                VStack(spacing: 8) {
                    BirdyIconBadge(systemName: theme.icon, color: theme.primaryColor, size: 52)
                    Text(theme.title)
                        .font(.caption2.weight(.bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(width: 72)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var launchIllustration: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [.birdyBird, Color(red: 1, green: 0.85, blue: 0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )
                .frame(width: 100, height: 100)
                .shadow(color: .birdyBird.opacity(0.35), radius: 8, y: 3)

            Image(systemName: "trophy.fill")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(BirdyGradients.primaryButton)

            VectorBirdShape(wingAngle: -8)
                .frame(width: 44, height: 44)
                .offset(x: -52, y: -36)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func highlightRow(_ item: OnboardingHighlight) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .font(.subheadline.weight(.bold))
                .foregroundColor(page.theme.primaryColor)
                .frame(width: 28)

            Text(item.text)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .birdyPillSurface(cornerRadius: 12)
    }
}
