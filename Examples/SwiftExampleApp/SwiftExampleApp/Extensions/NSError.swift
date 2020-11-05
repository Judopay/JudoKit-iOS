import Foundation
import JudoKit_iOS

extension NSError {

    var userDidCancelOperation: Bool {
        return domain == JudoErrorDomain && code == JudoError.JudoUserDidCancelError.rawValue
    }

    var judoMessage: String {
        let fallback = "Unknown error"
        let keys = userInfo.keys

        if keys.contains("message") {
            return userInfo["message"] as? String ?? fallback
        }

        if keys.contains(NSLocalizedDescriptionKey) {
            return userInfo[NSLocalizedDescriptionKey] as? String ?? fallback
        }

        return fallback
    }
}
