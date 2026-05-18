import SwiftUI

struct BirdyAchievementCell: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: achievement.isUnlocked
                                ? [Color.birdyBird, Color(red: 1, green: 0.85, blue: 0.3)]
                                : [Color.white.opacity(0.3), Color.white.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 54, height: 54)
                    .shadow(
                        color: achievement.isUnlocked ? Color.birdyBird.opacity(0.35) : .clear,
                        radius: 6,
                        y: 2
                    )

                Image(systemName: achievement.isUnlocked ? "trophy.fill" : "lock.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(
                        achievement.isUnlocked
                            ? LinearGradient(colors: [.birdyBird, Color(red: 1, green: 0.9, blue: 0.4)], startPoint: .top, endPoint: .bottom)
                            : LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                    )
            }

            Text(achievement.name)
                .font(.subheadline.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)

            Text(achievement.description)
                .font(.caption2.weight(.medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text("\(achievement.requiredScore) pts")
                .font(.caption2.weight(.black))
                .foregroundColor(.birdySkyBottom)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(BirdyGradients.primaryButton)
                        .shadow(color: .birdyBird.opacity(0.3), radius: 2, y: 1)
                )

            if achievement.isUnlocked, let date = achievement.unlockedDate {
                Text(formattedShortDate(date))
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.birdyBird)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 168)
        .background(
            BirdySurfaceBackground(
                cornerRadius: 20,
                fill: BirdyGradients.achievement(unlocked: achievement.isUnlocked),
                strokeColor: achievement.isUnlocked ? Color.birdyBird.opacity(0.5) : Color.white.opacity(0.22),
                strokeWidth: 1,
                elevation: achievement.isUnlocked ? .medium : .low
            )
        )
        .opacity(achievement.isUnlocked ? 1 : 0.9)
    }
}
