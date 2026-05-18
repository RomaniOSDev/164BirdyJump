import SwiftUI

struct BirdyGlassCard<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(20)
            .frame(maxWidth: .infinity)
            .birdyGlassSurface(cornerRadius: 24, elevation: .high)
    }
}
