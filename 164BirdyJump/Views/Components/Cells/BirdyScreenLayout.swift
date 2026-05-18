import SwiftUI

struct BirdyScreenLayout<Content: View>: View {
    let title: String
    let icon: String
    var theme: LevelTheme = .sunny
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            ThemedSkyBackground(theme: theme, showAmbient: true)

            VStack(spacing: 0) {
                BirdyScreenHeader(title: title, icon: icon)

                content()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BirdySectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.birdyBird, Color(red: 1, green: 0.9, blue: 0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Spacer()

            if let actionTitle {
                if let action {
                    Button(actionTitle, action: action)
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.12))
                                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        )
                } else {
                    Text(actionTitle)
                        .font(.caption.weight(.bold))
                        .foregroundColor(.birdyBird)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.birdyBird.opacity(0.15))
                                .overlay(Capsule().stroke(Color.birdyBird.opacity(0.35), lineWidth: 1))
                        )
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

struct BirdyStatPill: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundColor(.birdyBird)
                .shadow(color: .birdyBird.opacity(0.4), radius: 2, y: 1)

            Text(value)
                .font(.headline.weight(.heavy))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundColor(.birdyBird)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .birdyPillSurface(cornerRadius: 14)
    }
}

struct BirdyEmptyState: View {
    let icon: String
    let title: String
    let message: String
    var buttonTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 18) {
            BirdyIconBadge(systemName: icon, size: 72)

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)

            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            if let buttonTitle, let action {
                BirdyPrimaryButton(buttonTitle, icon: "play.fill", action: action)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 20)
        .birdyGlassSurface(cornerRadius: 28, elevation: .medium)
        .padding(.horizontal, 24)
    }
}

struct BirdyProgressCard: View {
    let title: String
    let subtitle: String
    let progress: Double
    let valueText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                Text(valueText)
                    .font(.headline.weight(.black))
                    .foregroundColor(.birdyBird)
                    .shadow(color: .birdyBird.opacity(0.35), radius: 2, y: 1)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.30))
                        .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))

                    Capsule()
                        .fill(BirdyGradients.progress)
                        .frame(width: max(0, geo.size.width * progress))
                        .shadow(color: .birdyBird.opacity(0.35), radius: 3, y: 1)
                }
            }
            .frame(height: 10)
        }
        .padding(14)
        .birdyCellSurface(style: .highlight)
    }
}
