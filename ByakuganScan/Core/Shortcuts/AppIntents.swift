import Foundation
import AppIntents

/// App Intent to trigger an interactive text OCR scan.
struct CaptureTextIntent: AppIntent {
    static var title: LocalizedStringResource = "Capture Text"
    static var description = IntentDescription("Captures an interactive screen region and copies recognized text to the clipboard.")
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ScanCoordinator.shared.startTextScan()
        return .result()
    }
}

/// App Intent to trigger an interactive QR code scan.
struct ScanQRCodeIntent: AppIntent {
    static var title: LocalizedStringResource = "Scan QR Code"
    static var description = IntentDescription("Captures an interactive screen region and decodes QR codes.")
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ScanCoordinator.shared.startQRScan()
        return .result()
    }
}

/// App Intent to trigger an interactive barcode scan.
struct ScanBarcodeIntent: AppIntent {
    static var title: LocalizedStringResource = "Scan Barcode"
    static var description = IntentDescription("Captures an interactive screen region and decodes commercial barcodes.")
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ScanCoordinator.shared.startBarcodeScan()
        return .result()
    }
}

/// App Intent to re-capture the last selected region.
struct CaptureLastSelectionIntent: AppIntent {
    static var title: LocalizedStringResource = "Capture Last Selection"
    static var description = IntentDescription("Re-scans the most recently selected rectangular screen region.")
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ScanCoordinator.shared.startLastSelectionScan()
        return .result()
    }
}

/// App Intent to open Byakugan Scan Settings.
struct OpenSettingsIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Settings"
    static var description = IntentDescription("Opens the Byakugan Scan preferences window.")
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        AppDelegate.shared?.openSettings()
        return .result()
    }
}

/// Provides App Shortcuts directly discoverable in macOS Shortcuts app and Spotlight.
struct ByakuganShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CaptureTextIntent(),
            phrases: [
                "Capture text with \(.applicationName)",
                "Extract text with \(.applicationName)",
                "Snipe text with \(.applicationName)"
            ],
            shortTitle: "Capture Text",
            systemImageName: "text.viewfinder"
        )
        AppShortcut(
            intent: ScanQRCodeIntent(),
            phrases: [
                "Scan QR code with \(.applicationName)",
                "Read QR with \(.applicationName)"
            ],
            shortTitle: "Scan QR Code",
            systemImageName: "qrcode.viewfinder"
        )
        AppShortcut(
            intent: ScanBarcodeIntent(),
            phrases: [
                "Scan barcode with \(.applicationName)"
            ],
            shortTitle: "Scan Barcode",
            systemImageName: "barcode.viewfinder"
        )
    }
}
