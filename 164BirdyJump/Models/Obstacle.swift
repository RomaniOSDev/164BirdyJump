import CoreGraphics
import Foundation

struct Obstacle: Identifiable, Equatable {
    let id: UUID
    var x: CGFloat
    var gapCenterY: CGFloat
    let width: CGFloat
    var isPassed: Bool
}
