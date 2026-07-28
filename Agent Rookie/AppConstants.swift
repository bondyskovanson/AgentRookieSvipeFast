import Foundation

enum AppConstants {
    static let appsFlyerDevKey = "cesc23jbQnGB57ojnqYaPb"
    static let appsFlyerAppleAppID = "6790715242"

    static var bundleID: String {
        Bundle.main.bundleIdentifier ?? "com.AgentRookieSvipeFast"
    }
    static var storeID: String {
        "id\(appsFlyerAppleAppID)"
    }

    static let configEndpoint = "https://agentrookieswipefast.com/config.php"

    static let privacyPolicyAddress = "https://agentrookieswipefast.com/privacy-policy.html"

    static let osName = "IOS"
    static let pushTokenPlaceholder = "00000000000000000000"
    static let firebaseProjectID = "176931441374"

    static let gcdRetryDelay: TimeInterval = 1.0
    static let mergeWaitInterval: TimeInterval = 3.0
    static let launchLoaderDuration: TimeInterval = 15.0

    static let pushPermissionRetryDelay: TimeInterval = 60 * 60 * 24 * 3

    static let pushDataAddressKey = "url"
}
