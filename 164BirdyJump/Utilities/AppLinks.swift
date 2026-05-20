import Foundation

enum AppLinks {
    case privacyPolicy
    case termsOfUse

    var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://www.termsfeed.com/live/fc10664f-84e7-45d8-ba7d-b409f906db4e"
        case .termsOfUse:
            return "https://www.termsfeed.com/live/9148aafb-ae5a-4152-aa62-4edc0b6a62a3"
        }
    }
}
