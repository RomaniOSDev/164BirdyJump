import SwiftUI

struct LevelSelectStrip: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            BirdySectionHeader(
                title: "Select Level",
                actionTitle: viewModel.selectedLevel.name,
                action: nil
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(GameLevel.all) { level in
                        BirdyLevelCell(
                            level: level,
                            record: viewModel.record(for: level.id),
                            theme: LevelTheme.theme(forLevelId: level.id),
                            isSelected: viewModel.selectedLevel.id == level.id,
                            layout: .compact,
                            onTap: { viewModel.selectLevel(level) }
                        )
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}
