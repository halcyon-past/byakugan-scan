import Foundation
import AppKit

/// Central settings model persisted via UserDefaults using @AppStorage compatible keys.
final class AppSettings: ObservableObject {
    // MARK: - Singleton
    static let shared = AppSettings()
    
    // MARK: - Keyboard Shortcuts
    @Published var textScanShortcut: String {
        didSet { UserDefaults.standard.set(textScanShortcut, forKey: Keys.textScanShortcut) }
    }
    @Published var qrScanShortcut: String {
        didSet { UserDefaults.standard.set(qrScanShortcut, forKey: Keys.qrScanShortcut) }
    }
    @Published var barcodeScanShortcut: String {
        didSet { UserDefaults.standard.set(barcodeScanShortcut, forKey: Keys.barcodeScanShortcut) }
    }
    
    // MARK: - Clipboard Options
    @Published var autoCopyToClipboard: Bool {
        didSet { UserDefaults.standard.set(autoCopyToClipboard, forKey: Keys.autoCopyToClipboard) }
    }
    @Published var playSoundOnCapture: Bool {
        didSet { UserDefaults.standard.set(playSoundOnCapture, forKey: Keys.playSoundOnCapture) }
    }
    @Published var showNotificationOnCapture: Bool {
        didSet { UserDefaults.standard.set(showNotificationOnCapture, forKey: Keys.showNotificationOnCapture) }
    }
    
    // MARK: - Text Formatting
    @Published var trimWhitespace: Bool {
        didSet { UserDefaults.standard.set(trimWhitespace, forKey: Keys.trimWhitespace) }
    }
    @Published var preserveLineBreaks: Bool {
        didSet { UserDefaults.standard.set(preserveLineBreaks, forKey: Keys.preserveLineBreaks) }
    }
    @Published var joinLineBreaksWithSpace: Bool {
        didSet { UserDefaults.standard.set(joinLineBreaksWithSpace, forKey: Keys.joinLineBreaksWithSpace) }
    }
    
    // MARK: - OCR Options
    @Published var ocrLanguage: String {
        didSet { UserDefaults.standard.set(ocrLanguage, forKey: Keys.ocrLanguage) }
    }
    @Published var ocrAccuracyLevel: OCRAccuracyLevel {
        didSet { UserDefaults.standard.set(ocrAccuracyLevel.rawValue, forKey: Keys.ocrAccuracyLevel) }
    }
    
    // MARK: - App Behaviour
    @Published var launchAtLogin: Bool {
        didSet { UserDefaults.standard.set(launchAtLogin, forKey: Keys.launchAtLogin) }
    }
    @Published var showInMenuBar: Bool {
        didSet { UserDefaults.standard.set(showInMenuBar, forKey: Keys.showInMenuBar) }
    }
    @Published var historyEnabled: Bool {
        didSet { UserDefaults.standard.set(historyEnabled, forKey: Keys.historyEnabled) }
    }
    @Published var maxHistoryItems: Int {
        didSet { UserDefaults.standard.set(maxHistoryItems, forKey: Keys.maxHistoryItems) }
    }
    
    // MARK: - Appearance
    @Published var overlayOpacity: Double {
        didSet { UserDefaults.standard.set(overlayOpacity, forKey: Keys.overlayOpacity) }
    }
    @Published var overlayTintColor: String {
        didSet { UserDefaults.standard.set(overlayTintColor, forKey: Keys.overlayTintColor) }
    }
    
    // MARK: - Init
    private init() {
        let ud = UserDefaults.standard
        self.textScanShortcut = ud.string(forKey: Keys.textScanShortcut) ?? "⌘⇧2"
        self.qrScanShortcut = ud.string(forKey: Keys.qrScanShortcut) ?? "⌘⇧3"
        self.barcodeScanShortcut = ud.string(forKey: Keys.barcodeScanShortcut) ?? "⌘⇧4"
        
        self.autoCopyToClipboard = ud.object(forKey: Keys.autoCopyToClipboard) as? Bool ?? true
        self.playSoundOnCapture = ud.object(forKey: Keys.playSoundOnCapture) as? Bool ?? true
        self.showNotificationOnCapture = ud.object(forKey: Keys.showNotificationOnCapture) as? Bool ?? true
        
        self.trimWhitespace = ud.object(forKey: Keys.trimWhitespace) as? Bool ?? true
        self.preserveLineBreaks = ud.object(forKey: Keys.preserveLineBreaks) as? Bool ?? true
        self.joinLineBreaksWithSpace = ud.object(forKey: Keys.joinLineBreaksWithSpace) as? Bool ?? false
        
        self.ocrLanguage = ud.string(forKey: Keys.ocrLanguage) ?? "en-US"
        let accuracyRaw = ud.string(forKey: Keys.ocrAccuracyLevel) ?? OCRAccuracyLevel.accurate.rawValue
        self.ocrAccuracyLevel = OCRAccuracyLevel(rawValue: accuracyRaw) ?? .accurate
        
        self.launchAtLogin = ud.object(forKey: Keys.launchAtLogin) as? Bool ?? false
        self.showInMenuBar = ud.object(forKey: Keys.showInMenuBar) as? Bool ?? true
        self.historyEnabled = ud.object(forKey: Keys.historyEnabled) as? Bool ?? true
        self.maxHistoryItems = ud.object(forKey: Keys.maxHistoryItems) as? Int ?? 50
        
        self.overlayOpacity = ud.object(forKey: Keys.overlayOpacity) as? Double ?? 0.3
        self.overlayTintColor = ud.string(forKey: Keys.overlayTintColor) ?? "#5B4EFF"
    }
    
    // MARK: - UserDefaults Keys
    enum Keys {
        static let textScanShortcut = "textScanShortcut"
        static let qrScanShortcut = "qrScanShortcut"
        static let barcodeScanShortcut = "barcodeScanShortcut"
        static let autoCopyToClipboard = "autoCopyToClipboard"
        static let playSoundOnCapture = "playSoundOnCapture"
        static let showNotificationOnCapture = "showNotificationOnCapture"
        static let trimWhitespace = "trimWhitespace"
        static let preserveLineBreaks = "preserveLineBreaks"
        static let joinLineBreaksWithSpace = "joinLineBreaksWithSpace"
        static let ocrLanguage = "ocrLanguage"
        static let ocrAccuracyLevel = "ocrAccuracyLevel"
        static let launchAtLogin = "launchAtLogin"
        static let showInMenuBar = "showInMenuBar"
        static let historyEnabled = "historyEnabled"
        static let maxHistoryItems = "maxHistoryItems"
        static let overlayOpacity = "overlayOpacity"
        static let overlayTintColor = "overlayTintColor"
    }
    
    /// Resets all settings to factory defaults.
    func resetToDefaults() {
        textScanShortcut = "⌘⇧2"
        qrScanShortcut = "⌘⇧3"
        barcodeScanShortcut = "⌘⇧4"
        autoCopyToClipboard = true
        playSoundOnCapture = true
        showNotificationOnCapture = true
        trimWhitespace = true
        preserveLineBreaks = true
        joinLineBreaksWithSpace = false
        ocrLanguage = "en-US"
        ocrAccuracyLevel = .accurate
        launchAtLogin = false
        showInMenuBar = true
        historyEnabled = true
        maxHistoryItems = 50
        overlayOpacity = 0.3
        overlayTintColor = "#5B4EFF"
    }
}

/// OCR accuracy/speed trade-off selection.
enum OCRAccuracyLevel: String, CaseIterable {
    case fast = "fast"
    case accurate = "accurate"
    
    var displayName: String {
        switch self {
        case .fast: return "Fast"
        case .accurate: return "Accurate"
        }
    }
}
