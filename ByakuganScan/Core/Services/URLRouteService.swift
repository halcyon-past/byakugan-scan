import Foundation

/// Represents the action mode requested by a scan URL.
enum ScanRouteMode: String, Equatable, CaseIterable {
    case text = "text"
    case qr = "qr"
    case barcode = "barcode"
    case last = "last"
}

/// Parsed deep link route for the `byakugan://` URL scheme.
enum URLRoute: Equatable {
    case scan(mode: ScanRouteMode)
    case settings
    case history
    case unknown(String)
}

/// Service responsible for parsing and routing incoming `byakugan://` custom URL schemes.
/// Enables integration with Raycast, Alfred, Stream Deck, and macOS Shortcuts.app.
final class URLRouteService {
    // MARK: - Singleton
    static let shared = URLRouteService()
    
    // MARK: - Constants
    static let supportedScheme = "byakugan"
    
    // MARK: - Custom Handlers (Dependency Injection)
    var onScan: ((ScanRouteMode) -> Void)?
    var onSettings: (() -> Void)?
    var onHistory: (() -> Void)?
    
    private init() {}
    
    // MARK: - Route Parsing
    
    /// Parses an incoming URL into a strongly-typed `URLRoute`.
    /// - Parameter url: The incoming URL to evaluate.
    /// - Returns: The parsed `URLRoute`, or `nil` if the scheme is not `byakugan`.
    static func parse(url: URL) -> URLRoute? {
        guard let scheme = url.scheme?.lowercased(), scheme == supportedScheme else {
            return nil
        }
        
        // Host represents the primary command path in `byakugan://host?params`
        // Also handle fallback paths like `byakugan:///scan` or `byakugan:/scan`
        let action = (url.host ?? url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))).lowercased()
        
        switch action {
        case "scan":
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let modeParam = components?.queryItems?
                .first(where: { $0.name.lowercased() == "mode" })?
                .value?.lowercased()
            
            if let modeParam = modeParam, let mode = ScanRouteMode(rawValue: modeParam) {
                return .scan(mode: mode)
            } else if modeParam == nil || modeParam?.isEmpty == true {
                // Default to text scan when mode is omitted: `byakugan://scan`
                return .scan(mode: .text)
            } else {
                return .unknown("Unknown scan mode: \(modeParam ?? "")")
            }
            
        case "settings", "preferences":
            return .settings
            
        case "history", "recents":
            return .history
            
        default:
            return .unknown(url.absoluteString)
        }
    }
    
    // MARK: - Route Handling
    
    /// Dispatches an incoming URL route to the appropriate application handler.
    /// - Parameter url: The incoming URL to handle.
    /// - Returns: `true` if the route was successfully understood and dispatched; `false` otherwise.
    @discardableResult
    func handle(url: URL) -> Bool {
        guard let route = Self.parse(url: url) else {
            return false
        }
        
        switch route {
        case .scan(let mode):
            if let onScan = onScan {
                onScan(mode)
            } else {
                NotificationCenter.default.post(
                    name: NSNotification.Name("ByakuganRouteTriggerScan"),
                    object: mode.rawValue
                )
            }
            return true
            
        case .settings:
            if let onSettings = onSettings {
                onSettings()
            } else {
                NotificationCenter.default.post(
                    name: NSNotification.Name("ByakuganRouteOpenSettings"),
                    object: nil
                )
            }
            return true
            
        case .history:
            if let onHistory = onHistory {
                onHistory()
            } else {
                NotificationCenter.default.post(
                    name: NSNotification.Name("ByakuganRouteOpenHistory"),
                    object: nil
                )
            }
            return true
            
        case .unknown:
            return false
        }
    }
}
