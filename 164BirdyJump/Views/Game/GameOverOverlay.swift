import SwiftUI

struct GameOverOverlay: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            BirdyGlassCard {
                VStack(spacing: 18) {
                    BirdyIconBadge(systemName: "xmark.circle.fill", color: .birdyBird, size: 56)

                    VStack(spacing: 6) {
                        Text("Game Over")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)

                        Text("Level \(viewModel.activeLevel.id)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.birdyBird)
                    }

                    HStack(spacing: 12) {
                        resultPill(title: "Score", value: "\(viewModel.score)")
                        resultPill(title: "Goal", value: "\(viewModel.activeLevel.targetPipes)")
                        resultPill(title: "Left", value: "\(viewModel.pipesRemaining)")
                    }

                    if viewModel.pipesRemaining > 0 {
                        BirdyProgressCard(
                            title: "Level Progress",
                            subtitle: "You were close — try again!",
                            progress: viewModel.levelProgress,
                            valueText: "\(Int(viewModel.levelProgress * 100))%"
                        )
                    }

                    VStack(spacing: 10) {
                        BirdyPrimaryButton("Try Again", icon: "arrow.counterclockwise") {
                            viewModel.replayCurrentLevel()
                        }

                        BirdyPrimaryButton("Main Menu", icon: "house.fill", style: .outlined) {
                            viewModel.returnToMenu()
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func resultPill(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.weight(.heavy))
                .foregroundColor(.birdyBird)
            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .birdyPillSurface(cornerRadius: 12)
    }
}
