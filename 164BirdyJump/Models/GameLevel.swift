import CoreGraphics
import Foundation

struct GameLevel: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let subtitle: String
    let targetPipes: Int
    let obstacleSpeed: CGFloat
    let gapSize: CGFloat
    let spawnInterval: Double

    static let all: [GameLevel] = [
        GameLevel(id: 1, name: "Sunny Start", subtitle: "Wide gaps, slow pipes", targetPipes: 5, obstacleSpeed: 2.5, gapSize: 190, spawnInterval: 2.6),
        GameLevel(id: 2, name: "Morning Sky", subtitle: "Learn the rhythm", targetPipes: 8, obstacleSpeed: 3.0, gapSize: 180, spawnInterval: 2.4),
        GameLevel(id: 3, name: "Cloud Lane", subtitle: "Steady flying", targetPipes: 10, obstacleSpeed: 3.5, gapSize: 170, spawnInterval: 2.2),
        GameLevel(id: 4, name: "Breeze Run", subtitle: "Pipes come faster", targetPipes: 12, obstacleSpeed: 4.0, gapSize: 160, spawnInterval: 2.0),
        GameLevel(id: 5, name: "Green Valley", subtitle: "Tighter gaps", targetPipes: 14, obstacleSpeed: 4.5, gapSize: 150, spawnInterval: 1.9),
        GameLevel(id: 6, name: "Wind Tunnel", subtitle: "Stay focused", targetPipes: 16, obstacleSpeed: 5.0, gapSize: 140, spawnInterval: 1.8),
        GameLevel(id: 7, name: "Pipe Forest", subtitle: "No room for error", targetPipes: 18, obstacleSpeed: 5.5, gapSize: 130, spawnInterval: 1.7),
        GameLevel(id: 8, name: "Storm Front", subtitle: "Fast and narrow", targetPipes: 20, obstacleSpeed: 6.0, gapSize: 125, spawnInterval: 1.6),
        GameLevel(id: 9, name: "High Altitude", subtitle: "Expert timing", targetPipes: 22, obstacleSpeed: 6.5, gapSize: 120, spawnInterval: 1.5),
        GameLevel(id: 10, name: "Turbo Sky", subtitle: "Relentless pace", targetPipes: 25, obstacleSpeed: 7.0, gapSize: 115, spawnInterval: 1.4),
        GameLevel(id: 11, name: "Night Flight", subtitle: "Almost impossible", targetPipes: 28, obstacleSpeed: 7.5, gapSize: 110, spawnInterval: 1.35),
        GameLevel(id: 12, name: "Legend Path", subtitle: "Master the sky", targetPipes: 30, obstacleSpeed: 8.0, gapSize: 105, spawnInterval: 1.3)
    ]

    static func level(id: Int) -> GameLevel {
        all.first { $0.id == id } ?? all[0]
    }
}

struct LevelRecord: Identifiable, Codable, Equatable {
    let levelID: Int
    var isUnlocked: Bool
    var isCompleted: Bool
    var bestScore: Int

    var id: Int { levelID }
}
