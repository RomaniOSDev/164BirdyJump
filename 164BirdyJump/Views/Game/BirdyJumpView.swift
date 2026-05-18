import SwiftUI

struct BirdyJumpView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            ThemedSkyBackground(
                theme: viewModel.activeTheme,
                showGround: viewModel.gameState == .playing,
                showAmbient: viewModel.gameState == .menu
            )

            if viewModel.gameState != .menu {
                GameView(viewModel: viewModel)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.gameState == .playing && !viewModel.isPaused {
                            viewModel.birdJump()
                        }
                    }
            }

            if viewModel.gameState == .menu {
                MainMenuView(viewModel: viewModel)
            }

            if viewModel.gameState == .gameOver {
                GameOverOverlay(viewModel: viewModel)
            }

            if viewModel.gameState == .levelComplete, let completed = viewModel.completedLevel {
                LevelCompleteOverlay(
                    viewModel: viewModel,
                    completedLevel: completed,
                    hasNextLevel: GameLevel.all.contains { $0.id == completed.id + 1 }
                )
            }

            if viewModel.gameState == .playing {
                gameHUD
            }
        }
        .ignoresSafeArea()
    }

    private var gameHUD: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    BirdyHUDChip {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Level \(viewModel.activeLevel.id)")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.white)
                            Text(viewModel.activeLevel.name)
                                .font(.caption.weight(.bold))
                                .foregroundColor(.birdyBird)
                                .lineLimit(1)
                        }
                    }

                    BirdyHUDChip {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.birdyBird)
                            Text("\(viewModel.score)/\(viewModel.activeLevel.targetPipes)")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.birdyBird)
                        }
                    }
                }
                .allowsHitTesting(false)

                Spacer(minLength: 0)
                    .allowsHitTesting(false)

                Button(action: { viewModel.togglePause() }) {
                    BirdyHUDChip {
                        Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.horizontal, 16)

            levelProgressBar
                .padding(.horizontal, 16)
                .allowsHitTesting(false)

            if viewModel.isPaused {
                Text("Paused")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.black.opacity(0.35)))
                    .allowsHitTesting(false)
            }

            Spacer(minLength: 0)
                .allowsHitTesting(false)
        }
        .padding(.top, 4)
    }

    private var levelProgressBar: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(viewModel.pipesRemaining) pipes left")
                .font(.caption2.weight(.bold))
                .foregroundColor(.white)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.30))
                        .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                    Capsule()
                        .fill(BirdyGradients.progress)
                        .frame(width: max(0, geo.size.width * viewModel.levelProgress))
                        .shadow(color: .birdyBird.opacity(0.3), radius: 2, y: 1)
                }
            }
            .frame(height: 6)
        }
    }
}
