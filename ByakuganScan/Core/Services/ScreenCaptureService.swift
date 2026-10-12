import AppKit
import CoreGraphics

/// Errors that can occur during screen capture.
enum ScreenCaptureError: LocalizedError {
    case permissionDenied
    case captureFailed
    case selectionCancelled
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return "Screen recording permission is required. Please grant access in System Settings > Privacy & Security > Screen Recording."
        case .captureFailed: return "Failed to capture the selected screen area."
        case .selectionCancelled: return "Screen capture was cancelled."
        }
    }
}

/// Service that manages screen capture using the macOS screencapture CLI tool.
/// Uses the system's interactive region selection for user-driven capture.
final class ScreenCaptureService {
    // MARK: - Singleton
    static let shared = ScreenCaptureService()
    private init() {}
    
    // MARK: - Public API
    
    /// Launches an interactive screen region selector and returns the captured image.
    /// Uses the built-in macOS `screencapture` tool for reliable crosshair selection.
    /// - Returns: The captured NSImage from the selected region.
    func captureInteractiveRegion() async throws -> NSImage {
        let tmpURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("png")
        
        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
            // -s: interactive selection mode; -x: no sound; -t png: PNG format
            process.arguments = ["-s", "-x", "-t", "png", tmpURL.path]
            
            process.terminationHandler = { proc in
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
                
                continuation.resume(returning: image)
            }
            
            do {
                try process.run()
            } catch {
                continuation.resume(throwing: ScreenCaptureError.captureFailed)
            }
        }
    }
    
    /// Checks whether screen recording permission has been granted.
    var hasScreenRecordingPermission: Bool {
        // CGWindowListCreateImage returns nil or a 1x1 image if permission is denied
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
