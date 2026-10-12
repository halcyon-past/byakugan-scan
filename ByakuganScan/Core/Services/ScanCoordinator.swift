import AppKit
import UserNotifications

/// Central coordinator that orchestrates screen capture + scanning pipeline.
/// Triggered by hotkeys or menu bar actions.
@MainActor
final class ScanCoordinator: ObservableObject {
    // MARK: - Singleton
    static let shared = ScanCoordinator()
    private init() {}
    
    // MARK: - Published State
    @Published var isScanning = false
    @Published var lastResult: ScanResult?
    @Published var lastError: String?
    
    // MARK: - Scan Pipelines
    
    /// Captures a screen region and extracts text via OCR.
    func startTextScan(overridePreserveLineBreaks: Bool? = nil, overrideTTS: Bool? = nil) {
        guard !isScanning else { return }
        Task { await performScan(type: .text, useLastSelection: false, overridePreserveLineBreaks: overridePreserveLineBreaks, overrideTTS: overrideTTS) }
    }
    
    /// Re-scans the previous selection area without dragging a new rectangle.
    func startLastSelectionScan() {
        guard !isScanning else { return }
        Task { await performScan(type: .text, useLastSelection: true) }
    }
    
    /// Captures a screen region and scans for QR codes.
    func startQRScan() {
        guard !isScanning else { return }
        Task { await performScan(type: .qrCode, useLastSelection: false) }
    }
    
    /// Captures a screen region and scans for barcodes.
    func startBarcodeScan() {
        guard !isScanning else { return }
        Task { await performScan(type: .barcode, useLastSelection: false) }
    }
    
    /// Stops any ongoing text-to-speech output.
    func stopSpeaking() {
        SpeechService.shared.stopSpeaking()
    }
    
    // MARK: - Core Pipeline
    
    private func performScan(
        type: ScanType,
        useLastSelection: Bool = false,
        overridePreserveLineBreaks: Bool? = nil,
        overrideTTS: Bool? = nil
    ) async {
        isScanning = true
        lastError = nil
        defer { isScanning = false }
        
        do {
            let image: NSImage
            if useLastSelection {
                image = try await ScreenCaptureService.shared.captureLastSelection()
            } else {
                image = try await ScreenCaptureService.shared.captureInteractiveRegion()
            }
            
            let settings = AppSettings.shared
            let preserveLineBreaks = overridePreserveLineBreaks ?? settings.preserveLineBreaks
            let shouldSpeak = overrideTTS ?? settings.textToSpeechEnabled
            
            let content: String
            switch type {
            case .text:
                content = try await OCRService.shared.extractText(
                    from: image,
                    language: settings.ocrLanguage,
                    autoDetectLanguage: settings.automaticallyDetectLanguage,
                    accuracyLevel: settings.ocrAccuracyLevel,
                    preserveLineBreaks: preserveLineBreaks,
                    trimWhitespace: settings.trimWhitespace
                )
            case .qrCode:
                let results = try await BarcodeService.shared.scanQRCodes(from: image)
                content = results.map { $0.value }.joined(separator: "\n")
            case .barcode:
                let results = try await BarcodeService.shared.scanBarcodes(from: image)
                content = results.map { "[\($0.symbologyName)] \($0.value)" }.joined(separator: "\n")
            }
            
            let result = ScanResult(type: type, content: content)
            lastResult = result
            HistoryService.shared.add(result)
            
            // Clipboard Handling (Standard or Additive)
            if settings.autoCopyToClipboard {
                ClipboardService.shared.copy(content, additive: settings.additiveClipboard)
            }
            
            // Audio Feedback
            if settings.playSoundOnCapture {
                NSSound(named: "Glass")?.play()
            }
            
            // Notification Feedback
            if settings.showNotificationOnCapture {
                sendNotification(for: result)
            }
            
            // Text to Speech
            if shouldSpeak {
                SpeechService.shared.speak(content, rate: settings.speechRate)
            }
            
            // Automatically Open Links (if detected and enabled)
            if settings.automaticallyOpenLinks && content.isURL, let url = URL(string: content.trimmingCharacters(in: .whitespacesAndNewlines)) {
                NSWorkspace.shared.open(url)
            }
            
        } catch ScreenCaptureError.selectionCancelled {
            // User cancelled interactive drag – gracefully ignore
        } catch {
            lastError = error.localizedDescription
            sendErrorNotification(error.localizedDescription)
        }
    }
    
    // MARK: - Notifications
    
    private func sendNotification(for result: ScanResult) {
        Task.detached(priority: .background) {
            let content = UNMutableNotificationContent()
            content.title = "\(result.type.displayName) Complete"
            content.body = result.content.prefix(100).description
            content.sound = nil
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: nil
            )
            try? await UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func sendErrorNotification(_ message: String) {
        Task.detached(priority: .background) {
            let content = UNMutableNotificationContent()
            content.title = "Scan Failed"
            content.body = message
            content.sound = .default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            try? await UNUserNotificationCenter.current().add(request)
        }
    }
}
