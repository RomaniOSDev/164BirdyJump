import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    private let birdSize: CGFloat = 64

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(viewModel.obstacles) { obstacle in
                    ObstacleView(
                        obstacle: obstacle,
                        gapSize: viewModel.activeLevel.gapSize,
                        screenHeight: geometry.size.height,
                        theme: viewModel.activeTheme
                    )
                }

                AnimatedBirdView(
                    size: birdSize,
                    rotation: viewModel.birdRotation,
                    flapTrigger: viewModel.wingFlapTrigger,
                    isPlaying: viewModel.gameState == .playing && !viewModel.isPaused
                )
                .position(x: viewModel.birdDisplayX, y: viewModel.birdY)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .onAppear {
                viewModel.updateScreenSize(geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                viewModel.updateScreenSize(newSize)
            }
        }
    }
}
