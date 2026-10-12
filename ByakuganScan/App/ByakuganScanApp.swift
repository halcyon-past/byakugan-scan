import SwiftUI

/// Main entry point for Byakugan Scan.
/// Configures the app as a menu bar utility with an optional main window.
@main
struct ByakuganScanApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var settings = AppSettings.shared
    @StateObject private var history = HistoryService.shared
    
    var body: some Scene {
        // Settings window accessible from the menu bar
        Settings {
            SettingsView()
                .environmentObject(settings)
                .frame(
                    minWidth: AppConstants.UI.settingsWindowWidth,
                    minHeight: AppConstants.UI.settingsWindowHeight
                )
        }
    }
}
