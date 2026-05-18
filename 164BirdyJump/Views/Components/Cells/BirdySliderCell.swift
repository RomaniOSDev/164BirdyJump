import SwiftUI

struct BirdySliderCell: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let valueLabel: (Double) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                BirdyIconBadge(systemName: icon, size: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                Text(valueLabel(value))
                    .font(.headline.weight(.black))
                    .foregroundColor(.birdyBird)
            }

            Slider(value: $value, in: range, step: step)
                .tint(.birdyBird)

            HStack {
                Text("Low")
                Spacer()
                Text("High")
            }
            .font(.caption2.weight(.semibold))
            .foregroundColor(.white.opacity(0.85))
        }
        .padding(14)
        .birdyCellSurface(style: .standard)
    }
}
