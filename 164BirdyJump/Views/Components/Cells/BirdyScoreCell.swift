import SwiftUI

struct BirdyScoreCell: View {
    let rank: Int
    let score: Int
    let date: Date

    var body: some View {
        BirdyCell(
            icon: rankIcon,
            iconColor: rankColor,
            title: "\(score) points",
            subtitle: formattedDate(date),
            badge: rank == 1 ? "TOP" : nil,
            style: rank == 1 ? .highlight : .standard
        ) {
            Text("#\(rank)")
                .font(.headline.weight(.black))
                .foregroundColor(rankColor)
        }
    }

    private var rankColor: Color {
        switch rank {
        case 1: return .birdyBird
        case 2: return .white
        case 3: return .birdyObstacle
        default: return .birdyBird
        }
    }

    private var rankIcon: String {
        switch rank {
        case 1: return "crown.fill"
        case 2: return "medal.fill"
        case 3: return "medal.fill"
        default: return "number"
        }
    }
}
