import SwiftUI

struct AnimatedBirdView: View {
    let size: CGFloat
    let rotation: Double
    let flapTrigger: Int
    let isPlaying: Bool

    private let flapFrameDuration: TimeInterval = 0.07

    @State private var wingAngle: Double = 0
    @State private var flapTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.birdyBird.opacity(0.22))
                .frame(width: size * 1.15, height: size * 1.15)
                .blur(radius: 5)

            VectorBirdShape(wingAngle: wingAngle)
                .frame(width: size, height: size)
                .shadow(color: .birdyBird.opacity(0.45), radius: 4, y: 2)
        }
        .rotationEffect(.degrees(rotation), anchor: UnitPoint(x: 0.38, y: 0.5))
        .onChange(of: flapTrigger) { _ in
            playFlapAnimation()
        }
        .onAppear {
            wingAngle = 0
            startIdleAnimationIfNeeded()
        }
        .onChange(of: isPlaying) { playing in
            if playing {
                startIdleAnimationIfNeeded()
            } else {
                stopAnimations()
                wingAngle = 0
            }
        }
        .onDisappear {
            stopAnimations()
        }
    }

    private func playFlapAnimation() {
        let sequence: [Double] = [-35, -10, 30, -8, 0]
        flapTask?.cancel()
        flapTask = Task { @MainActor in
            for angle in sequence {
                guard !Task.isCancelled else { return }
                withAnimation(.easeOut(duration: flapFrameDuration)) {
                    wingAngle = angle
                }
                try? await Task.sleep(nanoseconds: UInt64(flapFrameDuration * 1_000_000_000))
            }
            startIdleAnimationIfNeeded()
        }
    }

    private func startIdleAnimationIfNeeded() {
        guard isPlaying else { return }
        flapTask?.cancel()
        flapTask = Task { @MainActor in
            while !Task.isCancelled && isPlaying {
                try? await Task.sleep(nanoseconds: 500_000_000)
                guard !Task.isCancelled, isPlaying else { return }
                withAnimation(.easeInOut(duration: 0.22)) {
                    wingAngle = wingAngle < -5 ? 8 : -12
                }
            }
        }
    }

    private func stopAnimations() {
        flapTask?.cancel()
        flapTask = nil
    }
}

// MARK: - Vector bird facing right (no background)

struct VectorBirdShape: View {
    let wingAngle: Double

    private let bodyDark = Color(red: 1, green: 0.72, blue: 0)
    private let beakColor = Color(red: 1, green: 0.55, blue: 0.1)

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                Ellipse()
                    .fill(bodyDark.opacity(0.85))
                    .frame(width: w * 0.34, height: h * 0.2)
                    .position(x: w * 0.35, y: h * 0.5)

                Ellipse()
                    .fill(Color.birdyBird)
                    .frame(width: w * 0.52, height: h * 0.44)
                    .position(x: w * 0.48, y: h * 0.52)

                Ellipse()
                    .fill(Color.white.opacity(0.22))
                    .frame(width: w * 0.28, height: h * 0.2)
                    .position(x: w * 0.44, y: h * 0.56)

                Ellipse()
                    .fill(bodyDark)
                    .frame(width: w * 0.38, height: h * 0.24)
                    .position(x: w * 0.36, y: h * 0.5)
                    .rotationEffect(.degrees(wingAngle), anchor: .trailing)

                Ellipse()
                    .fill(Color.birdyBird)
                    .frame(width: w * 0.3, height: h * 0.3)
                    .position(x: w * 0.72, y: h * 0.38)

                Circle()
                    .fill(Color.white)
                    .frame(width: w * 0.12, height: w * 0.12)
                    .position(x: w * 0.78, y: h * 0.36)

                Circle()
                    .fill(Color.black)
                    .frame(width: w * 0.06, height: w * 0.06)
                    .position(x: w * 0.8, y: h * 0.37)

                BirdBeak()
                    .fill(beakColor)
                    .frame(width: w * 0.16, height: h * 0.1)
                    .position(x: w * 0.9, y: h * 0.44)
            }
        }
    }
}

struct BirdBeak: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY - rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + rect.height * 0.4))
        path.closeSubpath()
        return path
    }
}
