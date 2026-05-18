import SwiftUI

struct HighScoresView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var selectedTab: Int

    var body: some View {
        BirdyScreenLayout(title: "Records", icon: "list.number") {
            if viewModel.topScores.isEmpty {
                BirdyEmptyState(
                    icon: "flag.checkered",
                    title: "No Records Yet",
                    message: "Complete a run and your best scores will appear here.",
                    buttonTitle: "Go Play",
                    action: { selectedTab = 0 }
                )
                .frame(maxHeight: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        summaryCard

                        BirdySectionHeader(title: "Top Runs")

                        LazyVStack(spacing: 10) {
                            ForEach(Array(viewModel.topScores.enumerated()), id: \.element.id) { index, score in
                                BirdyScoreCell(rank: index + 1, score: score.score, date: score.date)
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

    private var summaryCard: some View {
        HStack(spacing: 10) {
            BirdyStatPill(
                icon: "crown.fill",
                value: "\(viewModel.topScores.first?.score ?? 0)",
                label: "Best"
            )
            BirdyStatPill(
                icon: "chart.bar.fill",
                value: "\(viewModel.topScores.count)",
                label: "Entries"
            )
            BirdyStatPill(
                icon: "flame.fill",
                value: "\(averageScore)",
                label: "Average"
            )
        }
    }

    private var averageScore: Int {
        guard !viewModel.topScores.isEmpty else { return 0 }
        let total = viewModel.topScores.reduce(0) { $0 + $1.score }
        return total / viewModel.topScores.count
    }
}
