import SwiftUI

// MARK: - Elevation (single shadow per surface — GPU-friendly)

enum BirdyElevation {
    case flat
    case low
    case medium
    case high

    var radius: CGFloat {
        switch self {
        case .flat: return 0
        case .low: return 4
        case .medium: return 8
        case .high: return 14
        }
    }

    var y: CGFloat {
        switch self {
        case .flat: return 0
        case .low: return 2
        case .medium: return 5
        case .high: return 9
        }
    }

    var opacity: Double {
        switch self {
        case .flat: return 0
        case .low: return 0.18
        case .medium: return 0.24
        case .high: return 0.32
        }
    }
}

// MARK: - Cached gradients (static — no per-frame allocation)

enum BirdyGradients {
    static let glass = LinearGradient(
        colors: [
            Color.white.opacity(0.28),
            Color.white.opacity(0.10),
            Color.white.opacity(0.06)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let glassShine = LinearGradient(
        colors: [Color.white.opacity(0.45), Color.white.opacity(0.05)],
        startPoint: .top,
        endPoint: .center
    )

    static let pill = LinearGradient(
        colors: [Color.white.opacity(0.14), Color.black.opacity(0.28)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let primaryButton = LinearGradient(
        colors: [
            Color(red: 1, green: 0.92, blue: 0.35),
            .birdyBird,
            Color(red: 0.92, green: 0.68, blue: 0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let progress = LinearGradient(
        colors: [.birdyBird, Color(red: 1, green: 0.78, blue: 0.2)],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let headerBar = LinearGradient(
        colors: [Color.black.opacity(0.35), Color.black.opacity(0.12)],
        startPoint: .top,
        endPoint: .bottom
    )

    static func cellFill(for style: BirdyCellStyle) -> LinearGradient {
        switch style {
        case .standard:
            return LinearGradient(
                colors: [Color.white.opacity(0.20), Color.white.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .selected:
            return LinearGradient(
                colors: [Color.birdyBird.opacity(0.35), Color.birdyBird.opacity(0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .disabled:
            return LinearGradient(
                colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .highlight:
            return LinearGradient(
                colors: [Color.white.opacity(0.26), Color.birdyBird.opacity(0.14)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    static func iconBadge(color: Color) -> LinearGradient {
        LinearGradient(
            colors: [color.opacity(0.32), color.opacity(0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func achievement(unlocked: Bool) -> LinearGradient {
        unlocked
            ? LinearGradient(
                colors: [Color.birdyBird.opacity(0.28), Color.birdyBird.opacity(0.10)],
                startPoint: .top,
                endPoint: .bottom
            )
            : LinearGradient(
                colors: [Color.white.opacity(0.14), Color.white.opacity(0.06)],
                startPoint: .top,
                endPoint: .bottom
            )
    }

    static func compactLevel(selected: Bool) -> LinearGradient {
        selected
            ? LinearGradient(
                colors: [Color.birdyBird.opacity(0.38), Color.birdyBird.opacity(0.14)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            : LinearGradient(
                colors: [Color.white.opacity(0.18), Color.white.opacity(0.07)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
    }
}

// MARK: - Ambient orbs (solid circles, no blur — cheap depth on menus)

struct BirdyAmbientLayer: View {
    var accent: Color = .birdyBird

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                Circle()
                    .fill(accent.opacity(0.14))
                    .frame(width: w * 0.55, height: w * 0.55)
                    .offset(x: w * 0.38, y: -h * 0.06)

                Circle()
                    .fill(Color.birdyObstacle.opacity(0.10))
                    .frame(width: w * 0.42, height: w * 0.42)
                    .offset(x: -w * 0.35, y: h * 0.22)

                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: w * 0.28, height: w * 0.28)
                    .offset(x: w * 0.1, y: h * 0.42)
            }
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
    }
}

// MARK: - Reusable surface shape

struct BirdySurfaceBackground: View {
    var cornerRadius: CGFloat
    var fill: LinearGradient
    var strokeColor: Color
    var strokeWidth: CGFloat
    var elevation: BirdyElevation
    var showShine: Bool = true

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        shape
            .fill(fill)
            .overlay {
                if showShine {
                    shape
                        .fill(BirdyGradients.glassShine)
                        .mask(shape)
                }
            }
            .overlay {
                shape.stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.42), strokeColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: strokeWidth
                )
            }
            .shadow(color: .black.opacity(elevation.opacity), radius: elevation.radius, y: elevation.y)
    }
}

// MARK: - View modifiers

extension View {
    func birdyCellSurface(style: BirdyCellStyle, cornerRadius: CGFloat = 18) -> some View {
        background(
            BirdySurfaceBackground(
                cornerRadius: cornerRadius,
                fill: BirdyGradients.cellFill(for: style),
                strokeColor: cellStrokeColor(style),
                strokeWidth: style == .selected ? 2 : 1,
                elevation: style == .selected ? .medium : .low
            )
        )
    }

    func birdyGlassSurface(cornerRadius: CGFloat = 24, elevation: BirdyElevation = .high) -> some View {
        background(
            BirdySurfaceBackground(
                cornerRadius: cornerRadius,
                fill: BirdyGradients.glass,
                strokeColor: Color.white.opacity(0.32),
                strokeWidth: 1,
                elevation: elevation
            )
        )
    }

    func birdyPillSurface(cornerRadius: CGFloat = 14) -> some View {
        background(
            BirdySurfaceBackground(
                cornerRadius: cornerRadius,
                fill: BirdyGradients.pill,
                strokeColor: Color.white.opacity(0.22),
                strokeWidth: 1,
                elevation: .low,
                showShine: true
            )
        )
    }
}

private func cellStrokeColor(_ style: BirdyCellStyle) -> Color {
    switch style {
    case .selected: return .birdyBird
    case .highlight: return Color.white.opacity(0.38)
    default: return Color.white.opacity(0.20)
    }
}
