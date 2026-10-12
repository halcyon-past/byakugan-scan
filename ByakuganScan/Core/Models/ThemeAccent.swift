import Foundation
import SwiftUI
import AppKit

/// Curated anime and macOS color accents for selection boxes, HUD highlights, and badge accents.
public enum ThemeAccent: String, Codable, CaseIterable, Identifiable {
    case byakuganChakra = "byakuganChakra"
    case neonCyan = "neonCyan"
    case electricPurple = "electricPurple"
    case emerald = "emerald"
    case systemAccent = "systemAccent"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .byakuganChakra: return "Byakugan Chakra (Lotus Pink)"
        case .neonCyan: return "Neon Cyan"
        case .electricPurple: return "Electric Purple"
        case .emerald: return "Terminal Emerald"
        case .systemAccent: return "System Accent"
        }
    }
    
    public var hexString: String {
        switch self {
        case .byakuganChakra: return "#D946EF"
        case .neonCyan: return "#06B6D4"
        case .electricPurple: return "#8B5CF6"
        case .emerald: return "#10B981"
        case .systemAccent: return "system"
        }
    }
    
    public var color: Color {
        switch self {
        case .byakuganChakra:
            return Color(red: 217/255, green: 70/255, blue: 239/255)
        case .neonCyan:
            return Color(red: 6/255, green: 182/255, blue: 212/255)
        case .electricPurple:
            return Color(red: 139/255, green: 92/255, blue: 246/255)
        case .emerald:
            return Color(red: 16/255, green: 185/255, blue: 129/255)
        case .systemAccent:
            return Color.accentColor
        }
    }
    
    public static func from(hexOrId: String) -> ThemeAccent {
        if let match = ThemeAccent(rawValue: hexOrId) {
            return match
        }
        for accent in ThemeAccent.allCases {
            if accent.hexString.lowercased() == hexOrId.lowercased() {
                return accent
            }
        }
        return .byakuganChakra
    }
}
