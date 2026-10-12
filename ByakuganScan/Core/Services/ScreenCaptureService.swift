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
    
    // MARK: - Public API
    
    /// Launches an interactive screen region selector and returns the captured image.
    /// Uses `-t tiff` for instant raster encoding without CPU-intensive PNG compression.
    func captureInteractiveRegion() async throws -> NSImage {
        let tmpURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("tiff")
        
        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
            // -s: interactive selection mode; -x: no sound; -t tiff: instantaneous uncompressed raster
            process.arguments = ["-s", "-x", "-t", "tiff", tmpURL.path]
            
            process.terminationHandler = { [weak self] proc in
                defer { try? FileManager.default.removeItem(at: tmpURL) }
                
                guard proc.terminationStatus == 0 else {
                    continuation.resume(throwing: ScreenCaptureError.selectionCancelled)
                    return
                }
                
                guard FileManager.default.fileExists(atPath: tmpURL.path),
                      let image = NSImage(contentsOf: tmpURL) else {
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
        guard let cached = lastCapturedImage else {
            throw ScreenCaptureError.noPreviousSelection
        }
        return cached
    }
    
    /// Checks whether screen recording permission has been granted.
    var hasScreenRecordingPermission: Bool {
        let image = CGWindowListCreateImage(
            CGRect(x: 0, y: 0, width: 1, height: 1),
            .optionOnScreenOnly,
            kCGNullWindowID,
            .bestResolution
        )
        return image != nil
    }
    
    /// Prompts the user to grant screen recording permission.
    func requestScreenRecordingPermission() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!
        NSWorkspace.shared.open(url)
    }
}
