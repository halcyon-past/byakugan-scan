import Foundation
import AppKit

/// Represents selectable audio feedback effects upon scan completion.
public enum SoundEffect: String, Codable, CaseIterable, Identifiable {
    case classicGlass = "classicGlass"
    case subtleClick = "subtleClick"
    case cameraShutter = "cameraShutter"
    case hapticPop = "hapticPop"
    case none = "none"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .classicGlass: return "Classic Glass"
        case .subtleClick: return "Subtle Click"
        case .cameraShutter: return "Camera Shutter"
        case .hapticPop: return "Haptic Pop"
        case .none: return "Mute / Silent"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .classicGlass: return "bell.fill"
        case .subtleClick: return "cursorarrow.click.2"
        case .cameraShutter: return "camera.fill"
        case .hapticPop: return "hand.tap.fill"
        case .none: return "speaker.slash.fill"
        }
    }
    
    /// Plays the configured sound effect on device.
    @discardableResult
    public func play() -> Bool {
        switch self {
        case .classicGlass:
            return playSound(named: "Glass", fallbackPaths: ["/System/Library/Sounds/Glass.aiff"])
        case .subtleClick:
            return playSound(named: "Tink", fallbackPaths: ["/System/Library/Sounds/Tink.aiff"])
        case .cameraShutter:
            return playSound(
                named: "Shutter",
                fallbackPaths: [
                    "/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/Shutter.aif",
                    "/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/Screen Capture.aif"
                ]
            )
        case .hapticPop:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
            return playSound(named: "Pop", fallbackPaths: ["/System/Library/Sounds/Pop.aiff"])
        case .none:
            return true
        }
    }
    
    @discardableResult
    private func playSound(named name: String, fallbackPaths: [String] = []) -> Bool {
        let sound: NSSound? = {
            if let namedSound = NSSound(named: name) {
                return namedSound
            }
            for ext in ["aif", "aiff", "wav"] {
                if let path = Bundle.main.path(forResource: name, ofType: ext),
                   let fileSound = NSSound(contentsOfFile: path, byReference: true) {
                    return fileSound
                }
            }
            for path in fallbackPaths {
                if FileManager.default.fileExists(atPath: path),
                   let fileSound = NSSound(contentsOfFile: path, byReference: true) {
                    return fileSound
                }
            }
            return nil
        }()
        
        guard let sound = sound else { return false }
        if sound.isPlaying {
            sound.stop()
        }
        sound.currentTime = 0
        return sound.play()
    }
}
