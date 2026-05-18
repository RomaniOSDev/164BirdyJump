import SwiftUI

struct LevelCompleteOverlay: View {
    @ObservedObject var viewModel: GameViewModel
    let completedLevel: GameLevel
    let hasNextLevel: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            BirdyGlassCard {
                VStack(spacing: 18) {
                    BirdyIconBadge(systemName: "checkmark.circle.fill", color: .birdyBird, size: 56)

                    VStack(spacing: 6) {
                        Text("Level Complete!")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)

                        Text("\(completedLevel.name)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.birdyBird)
                    }

                    BirdyCell(
                        icon: LevelTheme.theme(forLevelId: completedLevel.id).icon,
                        iconColor: LevelTheme.theme(forLevelId: completedLevel.id).primaryColor,
                        title: "\(completedLevel.targetPipes) pipes cleared",
                        subtitle: "Great flying!",
                        style: .highlight
                    )

                    if hasNextLevel, let next = GameLevel.all.first(where: { $0.id == completedLevel.id + 1 }) {
                        BirdyCell(
                            icon: "lock.open.fill",
                            title: "Unlocked: \(next.name)",
                            subtitle: "Level \(next.id) is ready to play",
                            badge: "NEW",
                            style: .standard
                        )
                    }

                    VStack(spacing: 10) {
                        if hasNextLevel {
                            BirdyPrimaryButton("Next Level", icon: "arrow.right") {
                                viewModel.goToNextLevel()
                            }
                        }

                        BirdyPrimaryButton(
                            "Replay",
                            icon: "arrow.counterclockwise",
                            style: hasNextLevel ? .outlined : .filled
                        ) {
                            viewModel.replayCurrentLevel()
                        }

                        if hasNextLevel {
                            BirdyPrimaryButton("Main Menu", icon: "house.fill", style: .outlined) {
                                viewModel.returnToMenu()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
