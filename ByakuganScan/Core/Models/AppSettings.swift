import Foundation
import AppKit

/// Central settings model persisted via UserDefaults.
final class AppSettings: ObservableObject {
    // MARK: - Singleton
    static let shared = AppSettings()
    
    // MARK: - Global Keyboard Shortcuts
    @Published var textScanShortcut: String {
        didSet { UserDefaults.standard.set(textScanShortcut, forKey: Keys.textScanShortcut) }
    }
    @Published var qrScanShortcut: String {
        didSet { UserDefaults.standard.set(qrScanShortcut, forKey: Keys.qrScanShortcut) }
    }
    @Published var barcodeScanShortcut: String {
        didSet { UserDefaults.standard.set(barcodeScanShortcut, forKey: Keys.barcodeScanShortcut) }
    }
    @Published var captureLastSelectionShortcut: String {
        didSet { UserDefaults.standard.set(captureLastSelectionShortcut, forKey: Keys.captureLastSelectionShortcut) }
    }
    @Published var captureWithoutLineBreaksShortcut: String {
        didSet { UserDefaults.standard.set(captureWithoutLineBreaksShortcut, forKey: Keys.captureWithoutLineBreaksShortcut) }
    }
    @Published var captureWithLineBreaksShortcut: String {
        didSet { UserDefaults.standard.set(captureWithLineBreaksShortcut, forKey: Keys.captureWithLineBreaksShortcut) }
    }
    @Published var captureWithTTSShortcut: String {
        didSet { UserDefaults.standard.set(captureWithTTSShortcut, forKey: Keys.captureWithTTSShortcut) }
    }
    @Published var stopSpeakingShortcut: String {
        didSet { UserDefaults.standard.set(stopSpeakingShortcut, forKey: Keys.stopSpeakingShortcut) }
    }
    @Published var toggleAdditiveClipboardShortcut: String {
        didSet { UserDefaults.standard.set(toggleAdditiveClipboardShortcut, forKey: Keys.toggleAdditiveClipboardShortcut) }
    }
    @Published var clearAdditiveClipboardShortcut: String {
        didSet { UserDefaults.standard.set(clearAdditiveClipboardShortcut, forKey: Keys.clearAdditiveClipboardShortcut) }
    }
    
    // MARK: - System & Notifications
    @Published var launchAtLogin: Bool {
        didSet { UserDefaults.standard.set(launchAtLogin, forKey: Keys.launchAtLogin) }
    }
    @Published var showInMenuBar: Bool {
        didSet { UserDefaults.standard.set(showInMenuBar, forKey: Keys.showInMenuBar) }
    }
    @Published var playSoundOnCapture: Bool {
        didSet { UserDefaults.standard.set(playSoundOnCapture, forKey: Keys.playSoundOnCapture) }
    }
    @Published var showNotificationOnCapture: Bool {
        didSet { UserDefaults.standard.set(showNotificationOnCapture, forKey: Keys.showNotificationOnCapture) }
    }
    @Published var automaticallyOpenLinks: Bool {
        didSet { UserDefaults.standard.set(automaticallyOpenLinks, forKey: Keys.automaticallyOpenLinks) }
    }
    
    // MARK: - Recognition Language
    @Published var ocrLanguage: String {
        didSet { UserDefaults.standard.set(ocrLanguage, forKey: Keys.ocrLanguage) }
    }
    @Published var automaticallyDetectLanguage: Bool {
        didSet { UserDefaults.standard.set(automaticallyDetectLanguage, forKey: Keys.automaticallyDetectLanguage) }
    }
    @Published var ocrAccuracyLevel: OCRAccuracyLevel {
        didSet { UserDefaults.standard.set(ocrAccuracyLevel.rawValue, forKey: Keys.ocrAccuracyLevel) }
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
    
    // MARK: - Additive Clipboard
    @Published var autoCopyToClipboard: Bool {
        didSet { UserDefaults.standard.set(autoCopyToClipboard, forKey: Keys.autoCopyToClipboard) }
    }
    @Published var additiveClipboard: Bool {
        didSet { UserDefaults.standard.set(additiveClipboard, forKey: Keys.additiveClipboard) }
    }
    @Published var clearAdditiveClipboardAutomatically: Bool {
        didSet { UserDefaults.standard.set(clearAdditiveClipboardAutomatically, forKey: Keys.clearAdditiveClipboardAutomatically) }
    }
    
    // MARK: - Text to Speech
    @Published var textToSpeechEnabled: Bool {
        didSet { UserDefaults.standard.set(textToSpeechEnabled, forKey: Keys.textToSpeechEnabled) }
    }
    @Published var speechRate: Double {
        didSet { UserDefaults.standard.set(speechRate, forKey: Keys.speechRate) }
    }
    
    // MARK: - History
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
        self.captureLastSelectionShortcut = ud.string(forKey: Keys.captureLastSelectionShortcut) ?? ""
        self.captureWithoutLineBreaksShortcut = ud.string(forKey: Keys.captureWithoutLineBreaksShortcut) ?? ""
        self.captureWithLineBreaksShortcut = ud.string(forKey: Keys.captureWithLineBreaksShortcut) ?? ""
        self.captureWithTTSShortcut = ud.string(forKey: Keys.captureWithTTSShortcut) ?? ""
        self.stopSpeakingShortcut = ud.string(forKey: Keys.stopSpeakingShortcut) ?? ""
        self.toggleAdditiveClipboardShortcut = ud.string(forKey: Keys.toggleAdditiveClipboardShortcut) ?? ""
        self.clearAdditiveClipboardShortcut = ud.string(forKey: Keys.clearAdditiveClipboardShortcut) ?? ""
        
        self.launchAtLogin = ud.object(forKey: Keys.launchAtLogin) as? Bool ?? false
        self.showInMenuBar = ud.object(forKey: Keys.showInMenuBar) as? Bool ?? true
        self.playSoundOnCapture = ud.object(forKey: Keys.playSoundOnCapture) as? Bool ?? true
        self.showNotificationOnCapture = ud.object(forKey: Keys.showNotificationOnCapture) as? Bool ?? true
        self.automaticallyOpenLinks = ud.object(forKey: Keys.automaticallyOpenLinks) as? Bool ?? false
        
        self.ocrLanguage = ud.string(forKey: Keys.ocrLanguage) ?? "en-US"
        // Default to FALSE for ultra-fast instant OCR (no multi-lingual detector stall)
        self.automaticallyDetectLanguage = ud.object(forKey: Keys.automaticallyDetectLanguage) as? Bool ?? false
        let accuracyRaw = ud.string(forKey: Keys.ocrAccuracyLevel) ?? OCRAccuracyLevel.accurate.rawValue
        self.ocrAccuracyLevel = OCRAccuracyLevel(rawValue: accuracyRaw) ?? .accurate
        
        self.trimWhitespace = ud.object(forKey: Keys.trimWhitespace) as? Bool ?? true
        self.preserveLineBreaks = ud.object(forKey: Keys.preserveLineBreaks) as? Bool ?? true
        self.joinLineBreaksWithSpace = ud.object(forKey: Keys.joinLineBreaksWithSpace) as? Bool ?? false
        
        self.autoCopyToClipboard = ud.object(forKey: Keys.autoCopyToClipboard) as? Bool ?? true
        self.additiveClipboard = ud.object(forKey: Keys.additiveClipboard) as? Bool ?? false
        self.clearAdditiveClipboardAutomatically = ud.object(forKey: Keys.clearAdditiveClipboardAutomatically) as? Bool ?? false
        
        self.textToSpeechEnabled = ud.object(forKey: Keys.textToSpeechEnabled) as? Bool ?? false
        self.speechRate = ud.object(forKey: Keys.speechRate) as? Double ?? 180.0
        
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
        static let captureLastSelectionShortcut = "captureLastSelectionShortcut"
        static let captureWithoutLineBreaksShortcut = "captureWithoutLineBreaksShortcut"
        static let captureWithLineBreaksShortcut = "captureWithLineBreaksShortcut"
        static let captureWithTTSShortcut = "captureWithTTSShortcut"
        static let stopSpeakingShortcut = "stopSpeakingShortcut"
        static let toggleAdditiveClipboardShortcut = "toggleAdditiveClipboardShortcut"
        static let clearAdditiveClipboardShortcut = "clearAdditiveClipboardShortcut"
        
        static let launchAtLogin = "launchAtLogin"
        static let showInMenuBar = "showInMenuBar"
        static let playSoundOnCapture = "playSoundOnCapture"
        static let showNotificationOnCapture = "showNotificationOnCapture"
        static let automaticallyOpenLinks = "automaticallyOpenLinks"
        
        static let ocrLanguage = "ocrLanguage"
        static let automaticallyDetectLanguage = "automaticallyDetectLanguage"
        static let ocrAccuracyLevel = "ocrAccuracyLevel"
        
        static let trimWhitespace = "trimWhitespace"
        static let preserveLineBreaks = "preserveLineBreaks"
        static let joinLineBreaksWithSpace = "joinLineBreaksWithSpace"
        
        static let autoCopyToClipboard = "autoCopyToClipboard"
        static let additiveClipboard = "additiveClipboard"
        static let clearAdditiveClipboardAutomatically = "clearAdditiveClipboardAutomatically"
        
        static let textToSpeechEnabled = "textToSpeechEnabled"
        static let speechRate = "speechRate"
        
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
        captureLastSelectionShortcut = ""
        captureWithoutLineBreaksShortcut = ""
        captureWithLineBreaksShortcut = ""
        captureWithTTSShortcut = ""
        stopSpeakingShortcut = ""
        toggleAdditiveClipboardShortcut = ""
        clearAdditiveClipboardShortcut = ""
        
        launchAtLogin = false
        showInMenuBar = true
        playSoundOnCapture = true
        showNotificationOnCapture = true
        automaticallyOpenLinks = false
        
        ocrLanguage = "en-US"
        automaticallyDetectLanguage = false
        ocrAccuracyLevel = .accurate
        
        trimWhitespace = true
        preserveLineBreaks = true
        joinLineBreaksWithSpace = false
        
        autoCopyToClipboard = true
        additiveClipboard = false
        clearAdditiveClipboardAutomatically = false
        
        textToSpeechEnabled = false
        speechRate = 180.0
        
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
        case .fast: return "Fast (Instant < 10ms)"
        case .accurate: return "Accurate (Standard)"
        }
    }
}
