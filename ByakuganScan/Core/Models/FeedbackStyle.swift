import Foundation

/// Defines how the user receives visual feedback after a capture completes.
public enum FeedbackStyle: String, Codable, CaseIterable, Identifiable {
    case floatingHUD = "floatingHUD"
    case systemNotification = "systemNotification"
    case none = "none"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .floatingHUD: return "Floating HUD Pill (Recommended)"
        case .systemNotification: return "System Notification"
        case .none: return "Silent / Off"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .floatingHUD: return "sparkles.rectangle.stack"
        case .systemNotification: return "bell.badge"
        case .none: return "bell.slash"
        }
    }
    
    public var showsHUD: Bool {
        self == .floatingHUD
    }
    
    public var showsSystemNotification: Bool {
        self == .systemNotification
    }
}
