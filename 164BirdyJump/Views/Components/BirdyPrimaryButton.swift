import SwiftUI

struct BirdyPrimaryButton: View {
    let title: String
    let icon: String?
    let style: Style
    let action: () -> Void

    enum Style {
        case filled
        case outlined
    }

    init(_ title: String, icon: String? = nil, style: Style = .filled, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                }
                Text(title)
                    .font(.headline.weight(.bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(background)
            .foregroundColor(foreground)
            .clipShape(Capsule())
            .overlay { buttonOverlay }
            .shadow(color: shadowColor, radius: shadowRadius, y: shadowY)
        }
        .buttonStyle(BirdyButtonStyle())
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled:
            Capsule().fill(BirdyGradients.primaryButton)
        case .outlined:
            Capsule().fill(
                LinearGradient(
                    colors: [Color.white.opacity(0.14), Color.white.opacity(0.06)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }

    @ViewBuilder
    private var buttonOverlay: some View {
        switch style {
        case .filled:
            Capsule()
                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                .padding(1)
        case .outlined:
            Capsule().stroke(Color.birdyBird, lineWidth: 2)
        }
    }

    private var foreground: Color {
        style == .filled ? .birdySkyBottom : .birdyBird
    }

    private var shadowColor: Color {
        style == .filled ? Color.birdyBird.opacity(0.45) : Color.black.opacity(0.15)
    }

    private var shadowRadius: CGFloat {
        style == .filled ? 10 : 4
    }

    private var shadowY: CGFloat {
        style == .filled ? 5 : 2
    }
}

struct BirdyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
