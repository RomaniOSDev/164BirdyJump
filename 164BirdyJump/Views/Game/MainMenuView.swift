import SwiftUI

struct MainMenuView: View {
    @ObservedObject var viewModel: GameViewModel

    @State private var birdFloat = false
    @State private var showContent = false

    private var unlockedCount: Int {
        viewModel.levelRecords.filter(\.isUnlocked).count
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                heroBlock

                statsRow

                LevelSelectStrip(viewModel: viewModel)

                playButton
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .opacity(showContent ? 1 : 0)
        .onAppear {
            birdFloat = true
            withAnimation(.easeOut(duration: 0.35)) { showContent = true }
        }
    }

    private var heroBlock: some View {
        BirdyGlassCard {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.birdyBird.opacity(0.45), Color.birdyBird.opacity(0.08)],
                                center: .center,
                                startRadius: 4,
                                endRadius: 48
                            )
                        )
                        .frame(width: 88, height: 88)
                        .shadow(color: .birdyBird.opacity(0.35), radius: 12, y: 4)

                    VectorBirdShape(wingAngle: birdFloat ? -12 : 8)
                        .frame(width: 64, height: 64)
                        .offset(y: birdFloat ? -5 : 3)
                        .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: birdFloat)
                }

                VStack(spacing: 4) {
                    Text("Ready to Fly?")
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color.white.opacity(0.85)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 2, y: 1)

                    HStack(spacing: 6) {
                        Image(systemName: viewModel.activeTheme.icon)
                            .foregroundColor(viewModel.activeTheme.primaryColor)
                        Text(viewModel.activeTheme.title)
                            .foregroundColor(.birdyBird)
                    }
                    .font(.caption.weight(.bold))

                    Text("Tap to rise · Dodge obstacles · Clear the goal")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }

    private var statsRow: some View {
        let level = viewModel.selectedLevel
        let record = viewModel.record(for: level.id)

        return HStack(spacing: 8) {
            BirdyStatPill(icon: "target", value: "\(level.targetPipes)", label: "Goal")
            BirdyStatPill(icon: "wind", value: speedLabel(level.obstacleSpeed), label: "Speed")
            BirdyStatPill(
                icon: record.isCompleted ? "checkmark.seal.fill" : "lock.open.fill",
                value: record.isCompleted ? "Yes" : "Go",
                label: record.isCompleted ? "Done" : "Open"
            )
        }
    }

    private var playButton: some View {
        VStack(spacing: 8) {
            BirdyPrimaryButton("Play Level \(viewModel.selectedLevel.id)", icon: "play.fill") {
                viewModel.startGame()
            }

            Text("\(unlockedCount) of \(GameLevel.all.count) levels unlocked")
                .font(.caption.weight(.semibold))
                .foregroundColor(.birdyBird)
        }
    }

    private func speedLabel(_ speed: CGFloat) -> String {
        switch speed {
        case ..<4: return "Slow"
        case ..<6: return "Med"
        case ..<7.5: return "Fast"
        default: return "Max"
        }
    }
}
