import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: GameViewModel

    private var unlockedCount: Int {
        viewModel.achievements.filter(\.isUnlocked).count
    }

    var body: some View {
        BirdyScreenLayout(title: "Achievements", icon: "trophy.fill") {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    BirdyProgressCard(
                        title: "Trophy Collection",
                        subtitle: "Unlock awards by reaching score milestones",
                        progress: Double(unlockedCount) / Double(max(viewModel.achievements.count, 1)),
                        valueText: "\(unlockedCount)/\(viewModel.achievements.count)"
                    )

                    BirdySectionHeader(title: "All Awards")

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(viewModel.achievements) { achievement in
                            BirdyAchievementCell(achievement: achievement)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .scrollContentBackground(.hidden)
        }
    }
}
