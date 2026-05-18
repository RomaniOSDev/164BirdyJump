import SwiftUI

struct BirdyLevelCell: View {
    let level: GameLevel
    let record: LevelRecord
    let theme: LevelTheme
    var isSelected: Bool
    var layout: Layout
    var onTap: (() -> Void)?

    enum Layout {
        case list
        case compact
    }

    var body: some View {
        switch layout {
        case .list:
            listCell
        case .compact:
            compactCell
        }
    }

    private var listCell: some View {
        BirdyCell(
            icon: theme.icon,
            iconColor: theme.primaryColor,
            title: "Level \(level.id): \(level.name)",
            subtitle: "\(level.subtitle) · Goal \(level.targetPipes) pipes · Gap \(Int(level.gapSize))pt",
            badge: record.isCompleted ? "DONE" : nil,
            style: cellStyle,
            action: record.isUnlocked ? onTap : nil
        ) {
            trailingContent
        }
    }

    private var compactCell: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("\(level.id)")
                        .font(.caption.weight(.black))
                        .foregroundColor(isSelected ? .birdySkyBottom : .birdyBird)
                        .frame(width: 28, height: 28)
                        .background(
                            Circle()
                                .fill(
                                    isSelected
                                        ? BirdyGradients.primaryButton
                                        : LinearGradient(
                                            colors: [Color.birdyBird.opacity(0.35), Color.birdyBird.opacity(0.15)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                )
                                .shadow(color: .birdyBird.opacity(isSelected ? 0.4 : 0.2), radius: 3, y: 1)
                        )

                    Spacer()

                    statusIcon
                }

                Text(level.name)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text("\(level.targetPipes) pipes")
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.birdyBird)

                if record.bestScore > 0 {
                    Text("Best \(min(record.bestScore, level.targetPipes))/\(level.targetPipes)")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(.white)
                }
            }
            .padding(12)
            .frame(width: 132)
            .background(
                BirdySurfaceBackground(
                    cornerRadius: 16,
                    fill: BirdyGradients.compactLevel(selected: isSelected),
                    strokeColor: isSelected ? .birdyBird : Color.white.opacity(0.20),
                    strokeWidth: isSelected ? 2 : 1,
                    elevation: isSelected ? .medium : .low
                )
            )
        }
        .buttonStyle(BirdyCellButtonStyle())
        .disabled(!record.isUnlocked)
        .opacity(record.isUnlocked ? 1 : 0.6)
    }

    @ViewBuilder
    private var trailingContent: some View {
        if !record.isUnlocked {
            Image(systemName: "lock.fill")
                .font(.body.weight(.bold))
                .foregroundColor(.white.opacity(0.8))
        } else if record.bestScore > 0 {
            VStack(spacing: 2) {
                Text("\(min(record.bestScore, level.targetPipes))")
                    .font(.title3.weight(.heavy))
                    .foregroundColor(.birdyBird)
                Text("/ \(level.targetPipes)")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.white)
            }
        } else if isSelected {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundColor(.birdyBird)
        }
    }

    @ViewBuilder
    private var statusIcon: some View {
        if record.isCompleted {
            Image(systemName: "checkmark.seal.fill")
                .font(.caption)
                .foregroundColor(.birdyBird)
        } else if !record.isUnlocked {
            Image(systemName: "lock.fill")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }

    private var cellStyle: BirdyCellStyle {
        if !record.isUnlocked { return .disabled }
        if isSelected { return .selected }
        if record.isCompleted { return .highlight }
        return .standard
    }
}
