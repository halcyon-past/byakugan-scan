import AppKit

/// Service for detecting and seamlessly switching between Byakugan Scan Production and Development builds.
enum AppSwitcher {
    /// True if Byakugan Scan Dev.app is installed or present on the system.
    static var isDevInstalled: Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Byakugan Scan Dev.app") {
            return true
        }
        if NSWorkspace.shared.urlForApplication(withBundleIdentifier: AppConstants.App.devBundleID) != nil {
            return true
        }
        return false
    }
    
    /// True if Byakugan Scan (production) is installed or present on the system.
    static var isProdInstalled: Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Byakugan Scan.app") {
            return true
        }
        if NSWorkspace.shared.urlForApplication(withBundleIdentifier: AppConstants.App.prodBundleID) != nil {
            return true
        }
        return false
    }
    
    /// Switches to the other version (Dev -> Prod or Prod -> Dev) and terminates the calling application.
    @MainActor
    static func switchToOtherApp() {
        let isDev = AppConstants.App.isDevelopment
        let targetBundleID = isDev ? AppConstants.App.prodBundleID : AppConstants.App.devBundleID
        let targetAppName = isDev ? "Byakugan Scan" : "Byakugan Scan Dev"
        
        var targetURL: URL? = nil
        let standardPath = "/Applications/\(targetAppName).app"
        if FileManager.default.fileExists(atPath: standardPath) {
            targetURL = URL(fileURLWithPath: standardPath)
        } else if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: targetBundleID) {
            targetURL = appURL
        }
        
        if let targetURL = targetURL {
            let config = NSWorkspace.OpenConfiguration()
            config.activates = true
            NSWorkspace.shared.openApplication(at: targetURL, configuration: config) { _, _ in
                DispatchQueue.main.async {
                    NSApp.terminate(nil)
                }
            }
        } else {
            // Fallback to open CLI command
            let proc = Process()
            proc.executableURL = URL(fileURLWithPath: "/usr/bin/open")
            proc.arguments = ["-a", targetAppName]
            try? proc.run()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                NSApp.terminate(nil)
            }
        }
    }
}
