import AppKit

/// Service for managing clipboard (pasteboard) operations.
final class ClipboardService {
    // MARK: - Singleton
    static let shared = ClipboardService()
    private init() {}
    
    // MARK: - Public API
    
    /// Copies the given string to the system clipboard.
    /// - Parameter text: The string to copy.
    func copy(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    /// Returns the current clipboard string content, if any.
    var currentContent: String? {
        NSPasteboard.general.string(forType: .string)
    }
    
    /// Clears the system clipboard.
    func clear() {
        NSPasteboard.general.clearContents()
    }
}
