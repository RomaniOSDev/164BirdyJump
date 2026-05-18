import SwiftUI

struct LevelsView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        BirdyScreenLayout(title: "All Levels", icon: "square.grid.2x2.fill", theme: viewModel.activeTheme) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    themeLegend

                    LazyVStack(spacing: 10) {
                        ForEach(GameLevel.all) { level in
                            BirdyLevelCell(
                                level: level,
                                record: viewModel.record(for: level.id),
                                theme: LevelTheme.theme(forLevelId: level.id),
                                isSelected: viewModel.selectedLevel.id == level.id,
                                layout: .list,
                                onTap: {
                                    viewModel.selectLevel(level)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .scrollContentBackground(.hidden)
        }
    }

    private var themeLegend: some View {
        HStack(spacing: 8) {
            ForEach(LevelTheme.allCases, id: \.rawValue) { theme in
                HStack(spacing: 4) {
                    Image(systemName: theme.icon)
                        .font(.caption2.weight(.bold))
                        .foregroundColor(theme.primaryColor)
                    Text(theme.title)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [theme.primaryColor.opacity(0.35), Color.black.opacity(0.25)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(Capsule().stroke(theme.primaryColor.opacity(0.4), lineWidth: 1))
                        .shadow(color: .black.opacity(0.15), radius: 3, y: 1)
                )
            }
        }
    }
}
