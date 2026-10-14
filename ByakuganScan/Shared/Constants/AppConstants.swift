import Foundation

/// App-wide constants.
enum AppConstants {
    enum App {
        static let name = "Byakugan Scan"
        static let bundleID = "cloud.aritro.byakugan-scan"
        static let version = "1.0.9"
        static let build = "10"
        static let websiteURL = URL(string: "https://byakugan-scan.aritro.cloud")!
        static let supportURL = URL(string: "https://byakugan-scan.aritro.cloud/support")!
        static let privacyURL = URL(string: "https://byakugan-scan.aritro.cloud/privacy")!
        static let termsURL = URL(string: "https://byakugan-scan.aritro.cloud/terms")!
        static let appStoreURL = URL(string: "https://apps.apple.com/app/byakugan-scan")! // update after submission
    }
    
    enum Notifications {
        static let textScanCompleted = "textScanCompleted"
        static let qrScanCompleted = "qrScanCompleted"
        static let barcodeScanCompleted = "barcodeScanCompleted"
        static let settingsChanged = "settingsChanged"
    }
    
    enum UI {
        static let defaultWindowWidth: CGFloat = 900
        static let defaultWindowHeight: CGFloat = 600
        static let settingsWindowWidth: CGFloat = 680
        static let settingsWindowHeight: CGFloat = 540
        static let sidebarWidth: CGFloat = 200
    }
    
    enum Accessibility {
        static let minimumTargetSize: CGFloat = 44
    }
}
