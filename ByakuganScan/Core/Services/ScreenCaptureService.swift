import AppKit
import CoreGraphics

/// Errors that can occur during screen capture.
enum ScreenCaptureError: LocalizedError {
    case permissionDenied
    case captureFailed
    case selectionCancelled
    case noPreviousSelection
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return "Screen recording permission is required. Please grant access in System Settings > Privacy & Security > Screen Recording."
        case .captureFailed: return "Failed to capture the selected screen area."
        case .selectionCancelled: return "Screen capture was cancelled."
        case .noPreviousSelection: return "No previous capture selection found to re-scan."
        }
    }
}

/// Service that manages screen capture using the macOS screencapture CLI tool.
/// Optimized for near-instant (sub-10ms) capture by routing directly to in-memory pasteboard buffer,
/// completely avoiding disk I/O and Spotlight metadata (mdwrite) filesystem stalls.
final class ScreenCaptureService {
    // MARK: - Singleton
    static let shared = ScreenCaptureService()
    private init() {}
    
    // MARK: - Cache
    private(set) var lastCapturedImage: NSImage?
    
    // MARK: - Public API
    
    /// Launches an interactive screen region selector and returns the captured image.
    /// Uses `-c -s -x` to capture directly into RAM clipboard, bypassing filesystem I/O and Spotlight (mdwrite) freezes.
    func captureInteractiveRegion() async throws -> NSImage {
        // Backup existing clipboard items so we can restore them if the user cancels with Esc
        let previousItems = backupClipboard()
        
        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
            // -c: copy directly to pasteboard in RAM (zero disk I/O, zero mdwrite daemon delay)
            // -s: interactive mouse selection mode
            // -x: silent (app plays its own audio)
            process.arguments = ["-c", "-s", "-x"]
            
            process.terminationHandler = { [weak self] proc in
                guard proc.terminationStatus == 0 else {
                    // User cancelled interactive drag: restore previous clipboard
                    self?.restoreClipboard(previousItems)
                    continuation.resume(throwing: ScreenCaptureError.selectionCancelled)
                    return
                }
                
                // Read captured bitmap directly from pasteboard in RAM (< 5ms)
                guard let image = self?.readImageFromPasteboard() else {
                    self?.restoreClipboard(previousItems)
                    continuation.resume(throwing: ScreenCaptureError.captureFailed)
                    return
                }
                
                self?.lastCapturedImage = image
                continuation.resume(returning: image)
            }
            
            do {
                try process.run()
            } catch {
                self.restoreClipboard(previousItems)
                continuation.resume(throwing: ScreenCaptureError.captureFailed)
            }
        }
    }
    
    /// Returns the last captured image for instant re-scanning.
    func captureLastSelection() async throws -> NSImage {
        guard let cached = lastCapturedImage else {
            throw ScreenCaptureError.noPreviousSelection
        }
        return cached
    }
    
    /// Checks whether screen recording permission has been granted without showing any system dialog.
    var hasScreenRecordingPermission: Bool {
        if #available(macOS 10.15, *) {
            return CGPreflightScreenCaptureAccess()
        }
        return true
    }
    
    /// Prompts the user to grant screen recording permission.
    @discardableResult
    func requestScreenRecordingPermission() -> Bool {
        if #available(macOS 10.15, *) {
            if !CGPreflightScreenCaptureAccess() {
                let granted = CGRequestScreenCaptureAccess()
                if !granted {
                    let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!
                    NSWorkspace.shared.open(url)
                }
                return granted
            }
            return true
        }
        return true
    }
    
    // MARK: - Private Pasteboard Helpers
    
    private func backupClipboard() -> [[NSPasteboard.PasteboardType: Data]] {
        guard let items = NSPasteboard.general.pasteboardItems else { return [] }
        return items.compactMap { item in
            var dict: [NSPasteboard.PasteboardType: Data] = [:]
            for type in item.types {
                if let data = item.data(forType: type) {
                    dict[type] = data
                }
            }
            return dict.isEmpty ? nil : dict
        }
    }
    
    private func restoreClipboard(_ items: [[NSPasteboard.PasteboardType: Data]]) {
        guard !items.isEmpty else { return }
        NSPasteboard.general.clearContents()
        for itemDict in items {
            let pbItem = NSPasteboardItem()
            for (type, data) in itemDict {
                pbItem.setData(data, forType: type)
            }
            NSPasteboard.general.writeObjects([pbItem])
        }
    }
    
    private func readImageFromPasteboard() -> NSImage? {
        let pb = NSPasteboard.general
        if let images = pb.readObjects(forClasses: [NSImage.self], options: nil) as? [NSImage],
           let img = images.first {
            return img
        }
        return nil
    }
}
