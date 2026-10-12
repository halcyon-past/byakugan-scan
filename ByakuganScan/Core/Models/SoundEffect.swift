import Foundation
import AppKit
import AudioToolbox

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
    public func play() {
        switch self {
        case .classicGlass:
            NSSound(named: "Glass")?.play()
        case .subtleClick:
            NSSound(named: "Tink")?.play()
        case .cameraShutter:
            AudioServicesPlaySystemSound(1108)
        case .hapticPop:
            NSSound(named: "Pop")?.play()
        case .none:
            break
        }
    }
}
