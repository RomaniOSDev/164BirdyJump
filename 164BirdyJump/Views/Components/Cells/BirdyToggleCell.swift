import SwiftUI

struct BirdyToggleCell: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        BirdyCell(
            icon: icon,
            title: title,
            subtitle: subtitle,
            style: isOn ? .highlight : .standard
        ) {
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.birdyBird)
        }
    }
}
