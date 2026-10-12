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
    private var registrations: [UInt32: (ref: EventHotKeyRef?, callback: HotkeyCallback)] = [:]
    private var nextID: UInt32 = 1
    private var eventHandlerRef: EventHandlerRef?
    
    // MARK: - Public API
    
    /// Registers a global hotkey with a Carbon key code and modifier flags.
    /// - Parameters:
    ///   - keyCode: Carbon virtual key code.
    ///   - modifiers: Carbon modifier flags (cmdKey, shiftKey, optionKey, controlKey).
    ///   - callback: Closure to invoke when the hotkey fires.
    /// - Returns: The registration ID (use to unregister later).
    @discardableResult
    func register(keyCode: UInt32, modifiers: UInt32, callback: @escaping HotkeyCallback) -> UInt32 {
        let hotkeyID = nextID
        nextID += 1
        
        var eventID = EventHotKeyID()
        eventID.signature = OSType(0x42594B47) // 'BYKG'
        eventID.id = hotkeyID
        
        var hotKeyRef: EventHotKeyRef?
        RegisterEventHotKey(keyCode, modifiers, eventID, GetApplicationEventTarget(), 0, &hotKeyRef)
        registrations[hotkeyID] = (ref: hotKeyRef, callback: callback)
        return hotkeyID
    }
    
    /// Unregisters a previously registered hotkey.
    /// - Parameter id: The registration ID returned by `register(...)`.
    func unregister(id: UInt32) {
        if let reg = registrations[id], let ref = reg.ref {
            UnregisterEventHotKey(ref)
        }
        registrations.removeValue(forKey: id)
    }
    
    /// Unregisters all active hotkeys.
    func unregisterAll() {
        for (id, _) in registrations {
            unregister(id: id)
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
                
                if let registration = service.registrations[hotkeyID.id] {
                    DispatchQueue.main.async { registration.callback() }
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
    
    /// Converts a display shortcut string like '⌘⇧2' to Carbon key code + modifiers.
    static func parseShortcut(_ shortcut: String) -> (keyCode: UInt32, modifiers: UInt32)? {
        // Simple parser for common modifier+key combos
        var mods: UInt32 = 0
        var keyStr = shortcut
        
        if keyStr.contains("⌘") { mods |= UInt32(cmdKey); keyStr = keyStr.replacingOccurrences(of: "⌘", with: "") }
        if keyStr.contains("⇧") { mods |= UInt32(shiftKey); keyStr = keyStr.replacingOccurrences(of: "⇧", with: "") }
        if keyStr.contains("⌥") { mods |= UInt32(optionKey); keyStr = keyStr.replacingOccurrences(of: "⌥", with: "") }
        if keyStr.contains("⌃") { mods |= UInt32(controlKey); keyStr = keyStr.replacingOccurrences(of: "⌃", with: "") }
        
        guard let char = keyStr.first else { return nil }
        guard let keyCode = carbonKeyCode(for: char) else { return nil }
        return (keyCode: keyCode, modifiers: mods)
    }
    
    /// Maps common characters to Carbon virtual key codes.
    private static func carbonKeyCode(for char: Character) -> UInt32? {
        let map: [Character: UInt32] = [
            "a": 0, "s": 1, "d": 2, "f": 3, "h": 4, "g": 5, "z": 6,
            "x": 7, "c": 8, "v": 9, "b": 11, "q": 12, "w": 13, "e": 14,
            "r": 15, "y": 16, "t": 17, "1": 18, "2": 19, "3": 20, "4": 21,
            "6": 22, "5": 23, "=": 24, "9": 25, "7": 26, "-": 27, "8": 28,
            "0": 29, "]": 30, "o": 31, "u": 32, "[": 33, "i": 34, "p": 35,
            "l": 37, "j": 38, "'": 39, "k": 40, ";": 41, "\\": 42, ",": 43,
            "/": 44, "n": 45, "m": 46, ".": 47
        ]
        return map[char]
    }
}
