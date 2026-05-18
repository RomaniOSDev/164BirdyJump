import SwiftUI

extension Color {
    static let birdySky = Color(red: 0.0, green: 0.761, blue: 0.800)
    static let birdyObstacle = Color(red: 0.302, green: 0.831, blue: 0.0)
    static let birdyBird = Color(red: 1.0, green: 0.839, blue: 0.0)

    static let birdySkyTop = Color(red: 0.35, green: 0.90, blue: 0.94)
    static let birdySkyBottom = Color(red: 0.0, green: 0.62, blue: 0.68)
    static let birdyObstacleDark = Color(red: 0.22, green: 0.62, blue: 0.0)

    static let birdyTextPrimary = Color.white
    static let birdyTextSecondary = Color.white
    static let birdyTextMuted = Color.white.opacity(0.92)
    static let birdyTextCaption = Color.birdyBird
    static let birdyTextDisabled = Color.white.opacity(0.88)
}
