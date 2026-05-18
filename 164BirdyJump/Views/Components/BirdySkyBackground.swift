import SwiftUI

struct BirdySkyBackground: View {
    var showClouds: Bool = true
    var showGround: Bool = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [.birdySkyTop, .birdySky, .birdySkyBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )

                if showClouds {
                    CloudLayer()
                }

                if showGround {
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.birdyObstacle.opacity(0.35))
                            .frame(height: 28)
                            .padding(.horizontal, -20)
                            .padding(.bottom, 8)
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
        }
        .ignoresSafeArea()
    }
}

private struct CloudLayer: View {
    var body: some View {
        ZStack {
            cloud(width: 90, height: 36)
                .offset(x: -120, y: -280)
            cloud(width: 70, height: 28)
                .offset(x: 130, y: -220)
            cloud(width: 110, height: 40)
                .offset(x: 40, y: -120)
            cloud(width: 60, height: 24)
                .offset(x: -80, y: 60)
            cloud(width: 80, height: 32)
                .offset(x: 100, y: 140)
        }
        .allowsHitTesting(false)
    }

    private func cloud(width: CGFloat, height: CGFloat) -> some View {
        Capsule()
            .fill(Color.white.opacity(0.22))
            .frame(width: width, height: height)
            .overlay(
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: width * 0.55, height: height * 0.7)
                    .offset(x: -width * 0.12, y: -height * 0.1)
            )
    }
}
