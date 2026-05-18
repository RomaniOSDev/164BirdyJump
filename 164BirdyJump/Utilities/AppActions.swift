import StoreKit
import UIKit

enum AppActions {
    static func openPolicy(_ link: AppLinks) {
        if let url = URL(string: link.urlString) {
            UIApplication.shared.open(url)
        }
    }

    static func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
