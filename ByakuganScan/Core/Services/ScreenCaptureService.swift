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
/// Optimized for near-zero latency by utilizing uncompressed TIFF raster buffers.
final class ScreenCaptureService {
    // MARK: - Singleton
    static let shared = ScreenCaptureService()
    private init() {}
    
    // MARK: - Cache
    private(set) var lastCapturedImage: NSImage?
    
    private var captureDirectory: URL {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dir = caches.appendingPathComponent("cloud.aritro.byakugan-scan", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }
    
    private var latestCaptureURL: URL {
        captureDirectory.appendingPathComponent("screen_latest.png")
    }
    
    // MARK: - Public API
    
    /// Launches an interactive screen region selector and returns the captured image.
    /// Uses `-i -x` for instant crosshairs interaction and silent capture.
    func captureInteractiveRegion() async throws -> NSImage {
        let fileURL = latestCaptureURL
        
        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
            // -i: interactive selection mode; -x: no sound
            process.arguments = ["-i", "-x", fileURL.path]
            
            process.terminationHandler = { [weak self] proc in
                guard proc.terminationStatus == 0 else {
                    continuation.resume(throwing: ScreenCaptureError.selectionCancelled)
                    return
                }
                
                guard FileManager.default.fileExists(atPath: fileURL.path),
                      let image = NSImage(contentsOf: fileURL) else {
                    continuation.resume(throwing: ScreenCaptureError.captureFailed)
                    return
                }
                
                self?.lastCapturedImage = image
                continuation.resume(returning: image)
            }
            
            do {
                try process.run()
            } catch {
                continuation.resume(throwing: ScreenCaptureError.captureFailed)
            }
        }
    }
    
    /// Returns the last captured image for instant re-scanning.
    func captureLastSelection() async throws -> NSImage {
        if let cached = lastCapturedImage {
            return cached
        }
        let fileURL = latestCaptureURL
        if FileManager.default.fileExists(atPath: fileURL.path),
           let img = NSImage(contentsOf: fileURL) {
            self.lastCapturedImage = img
            return img
        }
        throw ScreenCaptureError.noPreviousSelection
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
}
