import SwiftUI

enum BirdyCellStyle {
    case standard
    case selected
    case disabled
    case highlight
}

struct BirdyCell<Trailing: View>: View {
    let icon: String
    let iconColor: Color
    var title: String
    var subtitle: String?
    var badge: String?
    var style: BirdyCellStyle
    var action: (() -> Void)?
    @ViewBuilder var trailing: () -> Trailing

    init(
        icon: String,
        iconColor: Color = .birdyBird,
        title: String,
        subtitle: String? = nil,
        badge: String? = nil,
        style: BirdyCellStyle = .standard,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.badge = badge
        self.style = style
        self.action = action
        self.trailing = trailing
    }

    var body: some View {
        Group {
            if let action {
                Button(action: action) { cellContent }
                    .buttonStyle(BirdyCellButtonStyle())
            } else {
                cellContent
            }
        }
        .disabled(style == .disabled)
        .opacity(style == .disabled ? 0.55 : 1)
    }

    private var cellContent: some View {
        HStack(spacing: 14) {
            BirdyIconBadge(systemName: icon, color: iconColor, size: 44)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.body.weight(.bold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    if let badge {
                        Text(badge)
                            .font(.caption2.weight(.black))
                            .foregroundColor(.birdySkyBottom)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(BirdyGradients.primaryButton)
                                    .shadow(color: .birdyBird.opacity(0.35), radius: 3, y: 1)
                            )
                    }
                }

                if let subtitle {
                    Text(subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }

            Spacer(minLength: 8)

            trailing()
        }
        .padding(14)
        .birdyCellSurface(style: style)
    }
}

struct BirdyIconBadge: View {
    let systemName: String
    var color: Color = .birdyBird
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.4, weight: .bold))
            .foregroundStyle(
                LinearGradient(
                    colors: [color, color.opacity(0.75)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(BirdyGradients.iconBadge(color: color))
                    .overlay(Circle().stroke(color.opacity(0.45), lineWidth: 1))
                    .shadow(color: color.opacity(0.25), radius: 4, y: 2)
            )
    }
}

struct BirdyCellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
