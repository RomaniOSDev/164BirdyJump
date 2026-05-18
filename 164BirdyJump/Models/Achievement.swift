import Foundation

struct Achievement: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var requiredScore: Int
    var isUnlocked: Bool
    var unlockedDate: Date?
}
