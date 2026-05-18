import SwiftUI

enum LevelTheme: Int, CaseIterable {
    case sunny = 0   // levels 1–4
    case sunset = 1  // levels 5–8
    case night = 2   // levels 9–12

    static func theme(forLevelId levelId: Int) -> LevelTheme {
        let index = max(0, min(2, (levelId - 1) / 4))
        return LevelTheme(rawValue: index) ?? .sunny
    }

    var backgroundImage: String {
        switch self {
        case .sunny: return "BgSkyDay"
        case .sunset: return "BgSkySunset"
        case .night: return "BgSkyNight"
        }
    }

    var obstacleImage: String {
        switch self {
        case .sunny: return "ObstaclePipes"
        case .sunset: return "ObstacleTrees"
        case .night: return "ObstacleCrystals"
        }
    }

    var title: String {
        switch self {
        case .sunny: return "Sunny Skies"
        case .sunset: return "Sunset Valley"
        case .night: return "Starlight Realm"
        }
    }

    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .sunset: return "sunset.fill"
        case .night: return "moon.stars.fill"
        }
    }

    var primaryColor: Color {
        switch self {
        case .sunny: return .birdyObstacle
        case .sunset: return Color(red: 0.55, green: 0.35, blue: 0.15)
        case .night: return Color(red: 0.55, green: 0.35, blue: 0.95)
        }
    }

    var secondaryColor: Color {
        switch self {
        case .sunny: return .birdyObstacleDark
        case .sunset: return Color(red: 0.35, green: 0.22, blue: 0.1)
        case .night: return Color(red: 0.35, green: 0.2, blue: 0.75)
        }
    }

    var skyTint: Color {
        switch self {
        case .sunny: return .birdySky
        case .sunset: return Color(red: 0.95, green: 0.45, blue: 0.25)
        case .night: return Color(red: 0.12, green: 0.15, blue: 0.45)
        }
    }
}
