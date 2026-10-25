import AppKit
import Carbon

/// Callback type for hotkey events.
typealias HotkeyCallback = () -> Void

/// Represents a registered global hotkey.
struct HotkeyRegistration {
    let id: EventHotKeyID
    let ref: EventHotKeyRef?
}

/// Service that registers and manages global hotkeys using Carbon event framework.
final class HotkeyService {
    // MARK: - Singleton
    static let shared = HotkeyService()
    private init() { installEventHandler() }
    
    // MARK: - Private State
    private let lock = NSLock()
    private var registrations: [UInt32: (ref: EventHotKeyRef?, callback: HotkeyCallback)] = [:]
    private var nextID: UInt32 = 1
    private var eventHandlerRef: EventHandlerRef?
    
    // MARK: - Public API
    
    /// Registers a global hotkey with a Carbon key code and modifier flags.
    /// - Parameters:
    ///   - keyCode: Carbon virtual key code.
    ///   - modifiers: Carbon modifier flags (cmdKey, shiftKey, optionKey, controlKey).
    ///   - callback: Closure to invoke when the hotkey fires.
    /// - Returns: The registration ID (use to unregister later), or 0 if registration failed.
    @discardableResult
    func register(keyCode: UInt32, modifiers: UInt32, callback: @escaping HotkeyCallback) -> UInt32 {
        guard modifiers != 0 else {
            return 0
        }
        
        lock.lock()
        let hotkeyID = nextID
        nextID += 1
        lock.unlock()
        
        var eventID = EventHotKeyID()
        eventID.signature = OSType(0x42594B47) // 'BYKG'
        eventID.id = hotkeyID
        
        var hotKeyRef: EventHotKeyRef?
        let status = RegisterEventHotKey(keyCode, modifiers, eventID, GetApplicationEventTarget(), 0, &hotKeyRef)
        guard status == noErr, let ref = hotKeyRef else {
            return 0
        }
        
        lock.lock()
        registrations[hotkeyID] = (ref: ref, callback: callback)
        lock.unlock()
        return hotkeyID
    }
    
    /// Unregisters a previously registered hotkey.
    /// - Parameter id: The registration ID returned by `register(...)`.
    func unregister(id: UInt32) {
        lock.lock()
        let reg = registrations.removeValue(forKey: id)
        lock.unlock()
        
        if let ref = reg?.ref {
            UnregisterEventHotKey(ref)
        }
    }
    
    /// Unregisters all active hotkeys.
    func unregisterAll() {
        lock.lock()
        let allRegistrations = registrations
        registrations.removeAll()
        lock.unlock()
        
        for (_, reg) in allRegistrations {
            if let ref = reg.ref {
                UnregisterEventHotKey(ref)
            }
        }
    }
    
    // MARK: - Carbon Event Handler
    
    private func installEventHandler() {
        var eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        InstallEventHandler(
            GetApplicationEventTarget(),
            { _, event, userData -> OSStatus in
                guard let userData = userData else { return OSStatus(eventNotHandledErr) }
                let service = Unmanaged<HotkeyService>.fromOpaque(userData).takeUnretainedValue()
                
                var hotkeyID = EventHotKeyID()
                GetEventParameter(
                    event,
                    UInt32(kEventParamDirectObject),
                    OSType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotkeyID
                )
                
                service.lock.lock()
                let callback = service.registrations[hotkeyID.id]?.callback
                service.lock.unlock()
                
                if let callback = callback {
                    DispatchQueue.main.async { callback() }
                }
                return noErr
            },
            1,
            &eventSpec,
            Unmanaged.passUnretained(self).toOpaque(),
            &eventHandlerRef
        )
    }
    
    // MARK: - Key Code Helpers
    
    /// Converts a display shortcut string like '⌘⇧2' or '⌘⇧Space' to Carbon key code + modifiers.
    static func parseShortcut(_ shortcut: String) -> (keyCode: UInt32, modifiers: UInt32)? {
        var mods: UInt32 = 0
        var keyStr = shortcut.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if keyStr.contains("⌘") { mods |= UInt32(cmdKey); keyStr = keyStr.replacingOccurrences(of: "⌘", with: "") }
        if keyStr.contains("⇧") { mods |= UInt32(shiftKey); keyStr = keyStr.replacingOccurrences(of: "⇧", with: "") }
        if keyStr.contains("⌥") { mods |= UInt32(optionKey); keyStr = keyStr.replacingOccurrences(of: "⌥", with: "") }
        if keyStr.contains("⌃") { mods |= UInt32(controlKey); keyStr = keyStr.replacingOccurrences(of: "⌃", with: "") }
        
        keyStr = keyStr.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keyStr.isEmpty else { return nil }
        
        let keyCode: UInt32
        if keyStr.lowercased() == "space" {
            keyCode = 49
        } else if let char = keyStr.first, let code = carbonKeyCode(for: char) {
            keyCode = code
        } else {
            return nil
        }
        
        // Guard against zero-modifier registrations which can hijack global keyboard input
        guard mods != 0 else { return nil }
        
        return (keyCode: keyCode, modifiers: mods)
    }
    
    /// Maps common characters to Carbon virtual key codes (case-insensitive).
    static func carbonKeyCode(for char: Character) -> UInt32? {
        let lower = Character(char.lowercased())
        let map: [Character: UInt32] = [
            "a": 0, "s": 1, "d": 2, "f": 3, "h": 4, "g": 5, "z": 6,
            "x": 7, "c": 8, "v": 9, "b": 11, "q": 12, "w": 13, "e": 14,
            "r": 15, "y": 16, "t": 17, "1": 18, "2": 19, "3": 20, "4": 21,
            "6": 22, "5": 23, "=": 24, "9": 25, "7": 26, "-": 27, "8": 28,
            "0": 29, "]": 30, "o": 31, "u": 32, "[": 33, "i": 34, "p": 35,
            "l": 37, "j": 38, "'": 39, "k": 40, ";": 41, "\\": 42, ",": 43,
            "/": 44, "n": 45, "m": 46, ".": 47, "`": 50, " ": 49
        ]
        return map[lower]
    }
    
    /// Maps Carbon virtual key codes to display string representation.
    static func keyString(for keyCode: UInt16) -> String? {
        switch keyCode {
        case 0: return "A"
        case 1: return "S"
        case 2: return "D"
        case 3: return "F"
        case 4: return "H"
        case 5: return "G"
        case 6: return "Z"
        case 7: return "X"
        case 8: return "C"
        case 9: return "V"
        case 11: return "B"
        case 12: return "Q"
        case 13: return "W"
        case 14: return "E"
        case 15: return "R"
        case 16: return "Y"
        case 17: return "T"
        case 18: return "1"
        case 19: return "2"
        case 20: return "3"
        case 21: return "4"
        case 22: return "6"
        case 23: return "5"
        case 24: return "="
        case 25: return "9"
        case 26: return "7"
        case 27: return "-"
        case 28: return "8"
        case 29: return "0"
        case 30: return "]"
        case 31: return "O"
        case 32: return "U"
        case 33: return "["
        case 34: return "I"
        case 35: return "P"
        case 37: return "L"
        case 38: return "J"
        case 39: return "'"
        case 40: return "K"
        case 41: return ";"
        case 42: return "\\"
        case 43: return ","
        case 44: return "/"
        case 45: return "N"
        case 46: return "M"
        case 47: return "."
        case 49: return "Space"
        case 50: return "`"
        default: return nil
        }
    }
    
    /// Formats modifier flags and key code into display string like "⌘⇧2".
    /// Requires at least one modifier key (Command, Option, or Control) to ensure
    /// valid macOS global hotkey registration without hijacking single-character typing.
    static func formatShortcut(keyCode: UInt16, modifierFlags: NSEvent.ModifierFlags) -> String? {
        // Resolve key character from key code
        let resolvedKey: String
        if let name = keyString(for: keyCode) {
            resolvedKey = name
        } else {
            return nil
        }
        
        let flags = modifierFlags.intersection(.deviceIndependentFlagsMask)
        let relevantFlags: NSEvent.ModifierFlags = [.command, .shift, .option, .control]
        let active = flags.intersection(relevantFlags)
        
        // Ensure at least one primary modifier (⌘, ⌥, ⌃) is present
        guard active.contains(.command) || active.contains(.option) || active.contains(.control) else {
            return nil
        }
        
        var str = ""
        if active.contains(.command) { str += "⌘" }
        if active.contains(.shift) { str += "⇧" }
        if active.contains(.option) { str += "⌥" }
        if active.contains(.control) { str += "⌃" }
        str += resolvedKey
        return str
    }
}
