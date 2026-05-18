import SwiftUI

struct ThemedSkyBackground: View {
    let theme: LevelTheme
    var showGround: Bool = false
    var showAmbient: Bool = true

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [theme.skyTint.opacity(0.95), theme.skyTint, .birdySkyBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Image(theme.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()

                if showAmbient {
                    BirdyAmbientLayer(accent: theme.primaryColor)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }

                // Vignette — single gradient overlay for depth (no blur)
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.12),
                        Color.clear,
                        Color.clear,
                        Color.black.opacity(0.22)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                if showGround {
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [theme.primaryColor.opacity(0.5), theme.primaryColor.opacity(0.25)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 28)
                            .shadow(color: .black.opacity(0.2), radius: 6, y: -2)
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }
}
