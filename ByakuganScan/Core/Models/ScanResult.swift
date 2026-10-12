import Foundation

/// Represents the type of scan performed.
enum ScanType: String, Codable, CaseIterable {
    case text = "text"
    case qrCode = "qrCode"
    case barcode = "barcode"
    
    var displayName: String {
        switch self {
        case .text: return "Text Scan"
        case .qrCode: return "QR Code"
        case .barcode: return "Barcode"
        }
    }
    
    var systemImage: String {
        switch self {
        case .text: return "text.viewfinder"
        case .qrCode: return "qrcode.viewfinder"
        case .barcode: return "barcode.viewfinder"
        }
    }
}

/// Represents a single scan result with metadata.
struct ScanResult: Identifiable, Codable {
    let id: UUID
    let type: ScanType
    let content: String
    let timestamp: Date
    var isFavourite: Bool
    
    init(id: UUID = UUID(), type: ScanType, content: String, timestamp: Date = Date(), isFavourite: Bool = false) {
        self.id = id
        self.type = type
        self.content = content
        self.timestamp = timestamp
        self.isFavourite = isFavourite
    }
}

extension ScanResult: Equatable {
    static func == (lhs: ScanResult, rhs: ScanResult) -> Bool {
        lhs.id == rhs.id
    }
}
