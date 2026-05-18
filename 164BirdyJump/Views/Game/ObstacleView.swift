import SwiftUI

struct ObstacleView: View {
    let obstacle: Obstacle
    let gapSize: CGFloat
    let screenHeight: CGFloat
    let theme: LevelTheme

    var body: some View {
        let gapHalf = gapSize / 2
        let topHeight = max(0, obstacle.gapCenterY - gapHalf)
        let bottomY = obstacle.gapCenterY + gapHalf
        let bottomHeight = max(0, screenHeight - bottomY)
        let centerX = obstacle.x + obstacle.width / 2

        ZStack {
            themedSegment(height: topHeight, centerX: centerX, centerY: topHeight / 2, capOnBottom: true)
            themedSegment(height: bottomHeight, centerX: centerX, centerY: bottomY + bottomHeight / 2, capOnBottom: false)
        }
    }

    private func themedSegment(height: CGFloat, centerX: CGFloat, centerY: CGFloat, capOnBottom: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [theme.primaryColor, theme.secondaryColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Image(theme.obstacleImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.92)

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.2), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 10)

            if height > 20 {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(theme.primaryColor)
                    .frame(width: obstacle.width + 14, height: 18)
                    .overlay(
                        Image(theme.obstacleImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(theme.secondaryColor.opacity(0.6), lineWidth: 1)
                    )
                    .offset(y: capOnBottom ? height / 2 - 4 : -height / 2 + 4)
            }
        }
        .frame(width: obstacle.width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .position(x: centerX, y: centerY)
    }
}
