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
    func startTextScan() {
        guard !isScanning else { return }
        Task { await performScan(type: .text) }
    }
    
    /// Captures a screen region and scans for QR codes.
    func startQRScan() {
        guard !isScanning else { return }
        Task { await performScan(type: .qrCode) }
    }
    
    /// Captures a screen region and scans for barcodes.
    func startBarcodeScan() {
        guard !isScanning else { return }
        Task { await performScan(type: .barcode) }
    }
    
    // MARK: - Core Pipeline
    
    private func performScan(type: ScanType) async {
        isScanning = true
        lastError = nil
        defer { isScanning = false }
        
        do {
            let image = try await ScreenCaptureService.shared.captureInteractiveRegion()
            let settings = AppSettings.shared
            
            let content: String
            switch type {
            case .text:
                content = try await OCRService.shared.extractText(
                    from: image,
                    language: settings.ocrLanguage,
                    accuracyLevel: settings.ocrAccuracyLevel,
                    preserveLineBreaks: settings.preserveLineBreaks,
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
            
            if settings.autoCopyToClipboard {
                ClipboardService.shared.copy(content)
            }
            
            if settings.playSoundOnCapture {
                NSSound(named: "Glass")?.play()
            }
            
            if settings.showNotificationOnCapture {
                sendNotification(for: result)
            }
            
        } catch ScreenCaptureError.selectionCancelled {
            // User cancelled – silently ignore
        } catch {
            lastError = error.localizedDescription
            sendErrorNotification(error.localizedDescription)
        }
    }
    
    // MARK: - Notifications
    
    private func sendNotification(for result: ScanResult) {
        let content = UNMutableNotificationContent()
        content.title = "\(result.type.displayName) Complete"
        content.body = result.content.prefix(100).description
        content.sound = nil
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
    
    private func sendErrorNotification(_ message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Scan Failed"
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
