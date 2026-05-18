import Foundation

enum DebugConfig {
    /// Set to `true` to unlock every level (Debug builds only by default).
    #if DEBUG
    static let unlockAllLevels = true
    #else
    static let unlockAllLevels = false
    #endif
}
