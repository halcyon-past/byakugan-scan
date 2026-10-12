import Vision
import AppKit

/// Errors that can occur during barcode/QR code scanning.
enum BarcodeError: LocalizedError {
    case imageConversionFailed
    case noBarcodesFound
    case scanFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed: return "Failed to process the captured image."
        case .noBarcodesFound: return "No barcode or QR code was detected in the selected area."
        case .scanFailed(let reason): return "Scan failed: \(reason)"
        }
    }
}

/// Represents a detected barcode with its symbology and value.
struct BarcodeResult {
    let value: String
    let symbology: VNBarcodeSymbology
    
    var isQRCode: Bool { symbology == .qr }
    
    var symbologyName: String {
        switch symbology {
        case .qr: return "QR Code"
        case .aztec: return "Aztec"
        case .code39: return "Code 39"
        case .code39Checksum: return "Code 39 (Checksum)"
        case .code39FullASCII: return "Code 39 Full ASCII"
        case .code39FullASCIIChecksum: return "Code 39 Full ASCII (Checksum)"
        case .code93: return "Code 93"
        case .code93i: return "Code 93i"
        case .code128: return "Code 128"
        case .dataMatrix: return "Data Matrix"
        case .ean8: return "EAN-8"
        case .ean13: return "EAN-13"
        case .i2of5: return "Interleaved 2 of 5"
        case .i2of5Checksum: return "Interleaved 2 of 5 (Checksum)"
        case .itf14: return "ITF-14"
        case .pdf417: return "PDF417"
        case .upce: return "UPC-E"
        case .microPDF417: return "Micro PDF417"
        case .microQR: return "Micro QR"
        default: return "Unknown"
        }
    }
}

/// Service for detecting and decoding QR codes and barcodes from images.
final class BarcodeService {
    // MARK: - Singleton
    static let shared = BarcodeService()
    private init() {}
    
    // MARK: - Public API
    
    /// Scans the given image for all detectable barcodes and QR codes.
    /// - Parameter image: The source image to scan.
    /// - Returns: An array of detected BarcodeResult objects.
    func scanBarcodes(from image: NSImage) async throws -> [BarcodeResult] {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw BarcodeError.imageConversionFailed
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNDetectBarcodesRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: BarcodeError.scanFailed(error.localizedDescription))
                    return
                }
                
                guard let observations = request.results as? [VNBarcodeObservation],
                      !observations.isEmpty else {
                    continuation.resume(throwing: BarcodeError.noBarcodesFound)
                    return
                }
                
                let results: [BarcodeResult] = observations.compactMap { obs in
                    guard let payload = obs.payloadStringValue else { return nil }
                    return BarcodeResult(value: payload, symbology: obs.symbology)
                }
                
                if results.isEmpty {
                    continuation.resume(throwing: BarcodeError.noBarcodesFound)
                } else {
                    continuation.resume(returning: results)
                }
            }
            
            // Scan for all major symbologies
            request.symbologies = [
                .qr, .aztec, .code39, .code93, .code128,
                .dataMatrix, .ean8, .ean13, .itf14, .pdf417, .upce,
                .microQR, .microPDF417
            ]
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: BarcodeError.scanFailed(error.localizedDescription))
            }
        }
    }
    
    /// Scans specifically for QR codes only.
    func scanQRCodes(from image: NSImage) async throws -> [BarcodeResult] {
        let all = try await scanBarcodes(from: image)
        let qrs = all.filter { $0.isQRCode }
        if qrs.isEmpty { throw BarcodeError.noBarcodesFound }
        return qrs
    }
}
