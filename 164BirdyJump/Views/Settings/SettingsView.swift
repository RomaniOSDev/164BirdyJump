import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: GameViewModel

    private var completedLevels: Int {
        viewModel.levelRecords.filter(\.isCompleted).count
    }

    private var unlockedLevels: Int {
        viewModel.levelRecords.filter(\.isUnlocked).count
    }

    var body: some View {
        BirdyScreenLayout(title: "Settings", icon: "gearshape.fill") {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    statsRow

                    BirdySectionHeader(title: "Gameplay")

                    BirdyGlassCard {
                        VStack(spacing: 12) {
                            BirdyToggleCell(
                                icon: "speaker.wave.2.fill",
                                title: "Sound",
                                subtitle: "Jump and game effects",
                                isOn: $viewModel.settings.soundEnabled
                            )

                            BirdyToggleCell(
                                icon: "iphone.radiowaves.left.and.right",
                                title: "Vibration",
                                subtitle: "Haptic feedback on tap",
                                isOn: $viewModel.settings.vibrationEnabled
                            )

                            BirdySliderCell(
                                icon: "hand.tap.fill",
                                title: "Tap Sensitivity",
                                subtitle: "How high the bird rises per tap",
                                value: tapLiftBinding,
                                range: GameSettings.minTapLiftPixels...GameSettings.maxTapLiftPixels,
                                step: 5,
                                valueLabel: { "\(Int($0)) px" }
                            )
                        }
                    }

                    BirdySectionHeader(title: "Progress")

                    BirdyProgressCard(
                        title: "Campaign Progress",
                        subtitle: "\(completedLevels) completed · \(unlockedLevels) unlocked",
                        progress: Double(completedLevels) / Double(max(GameLevel.all.count, 1)),
                        valueText: "\(completedLevels)/\(GameLevel.all.count)"
                    )

                    BirdyCell(
                        icon: "flag.checkered",
                        title: "Level Worlds",
                        subtitle: "Sunny (1–4), Sunset (5–8), Stars (9–12). Each world has unique visuals."
                    ) {
                        EmptyView()
                    }

                    BirdySectionHeader(title: "Legal")

                    BirdyGlassCard {
                        VStack(spacing: 12) {
                            BirdyCell(
                                icon: "star.fill",
                                title: "Rate Us",
                                subtitle: "Enjoying the game? Leave a review",
                                action: { AppActions.rateApp() }
                            ) {
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            BirdyCell(
                                icon: "hand.raised.fill",
                                title: "Privacy",
                                subtitle: "How we handle your data",
                                action: { AppActions.openPolicy(.privacyPolicy) }
                            ) {
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            BirdyCell(
                                icon: "doc.text.fill",
                                title: "Terms",
                                subtitle: "Terms of use",
                                action: { AppActions.openPolicy(.termsOfUse) }
                            ) {
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .scrollContentBackground(.hidden)
        }
        .onDisappear {
            viewModel.saveData()
        }
    }

    private var statsRow: some View {
        HStack(spacing: 10) {
            BirdyStatPill(icon: "crown.fill", value: "\(viewModel.highScore)", label: "Best Run")
            BirdyStatPill(icon: "star.fill", value: "\(viewModel.topScores.count)", label: "Records")
            BirdyStatPill(icon: "trophy.fill", value: "\(viewModel.achievements.filter(\.isUnlocked).count)", label: "Awards")
        }
    }

    private var tapLiftBinding: Binding<Double> {
        Binding(
            get: { viewModel.settings.tapLiftPixels },
            set: { viewModel.settings.tapLiftPixels = GameSettings.clampTapLift($0) }
        )
    }
}
