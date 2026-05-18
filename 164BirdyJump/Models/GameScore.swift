import Foundation

struct GameScore: Identifiable, Codable, Equatable {
    let id: UUID
    let score: Int
    let date: Date
}
