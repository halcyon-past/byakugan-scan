import AppKit

/// Service for managing clipboard (pasteboard) operations.
final class ClipboardService {
    // MARK: - Singleton
    static let shared = ClipboardService()
    private init() {}
    
    // MARK: - Public API
    
    /// Copies the given string to the system clipboard, optionally appending if additive mode is enabled.
    /// - Parameters:
    ///   - text: The string to copy.
    ///   - additive: Whether to append to existing clipboard contents.
    func copy(_ text: String, additive: Bool = false) {
        let pasteboard = NSPasteboard.general
        if additive, let existing = pasteboard.string(forType: .string), !existing.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            pasteboard.clearContents()
            pasteboard.setString(existing + "\n\n" + text, forType: .string)
        } else {
            pasteboard.clearContents()
            pasteboard.setString(text, forType: .string)
        }
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
