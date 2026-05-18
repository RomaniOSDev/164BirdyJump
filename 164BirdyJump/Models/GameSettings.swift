import Foundation

struct GameSettings: Codable, Equatable {
    static let minTapLiftPixels: Double = 30
    static let maxTapLiftPixels: Double = 100
    static let defaultTapLiftPixels: Double = 60

    var soundEnabled: Bool
    var vibrationEnabled: Bool
    /// How many pixels the bird rises on a single tap (peak height).
    var tapLiftPixels: Double

    init(
        soundEnabled: Bool = true,
        vibrationEnabled: Bool = true,
        tapLiftPixels: Double = GameSettings.defaultTapLiftPixels
    ) {
        self.soundEnabled = soundEnabled
        self.vibrationEnabled = vibrationEnabled
        self.tapLiftPixels = Self.clampTapLift(tapLiftPixels)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        soundEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundEnabled) ?? true
        vibrationEnabled = try container.decodeIfPresent(Bool.self, forKey: .vibrationEnabled) ?? true
        let lift = try container.decodeIfPresent(Double.self, forKey: .tapLiftPixels) ?? Self.defaultTapLiftPixels
        tapLiftPixels = Self.clampTapLift(lift)
    }

    static func clampTapLift(_ value: Double) -> Double {
        min(max(value, minTapLiftPixels), maxTapLiftPixels)
    }
}
