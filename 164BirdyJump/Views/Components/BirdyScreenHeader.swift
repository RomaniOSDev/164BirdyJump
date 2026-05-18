import SwiftUI

struct BirdyScreenHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            BirdyIconBadge(systemName: icon, size: 48)

            Text(title)
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color.white.opacity(0.88)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .shadow(color: .black.opacity(0.25), radius: 2, y: 1)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(BirdyGradients.headerBar)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                .padding(.horizontal, 12)
        )
        .padding(.top, 4)
        .padding(.bottom, 4)
    }
}
