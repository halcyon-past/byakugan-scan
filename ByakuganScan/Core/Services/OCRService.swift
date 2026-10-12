import Vision
import AppKit
import Combine

/// Errors that can occur during OCR processing.
enum OCRError: LocalizedError {
    case imageConversionFailed
    case noTextFound
    case recognitionFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed: return "Failed to process the captured image."
        case .noTextFound: return "No text was detected in the selected area."
        case .recognitionFailed(let reason): return "Text recognition failed: \(reason)"
        }
    }
}

/// Service responsible for extracting text from images using Apple's Vision framework.
final class OCRService {
    // MARK: - Singleton
    static let shared = OCRService()
    private init() {}
    
    // MARK: - Public API
    
    /// Extracts text from the given NSImage asynchronously.
    /// - Parameters:
    ///   - image: The source image to process.
    ///   - language: BCP-47 language tag for recognition (e.g. "en-US").
    ///   - accuracyLevel: Recognition accuracy vs. speed trade-off.
    ///   - preserveLineBreaks: Whether to preserve line breaks in output.
    ///   - trimWhitespace: Whether to trim leading/trailing whitespace from lines.
    /// - Returns: The extracted text string.
    func extractText(
        from image: NSImage,
        language: String = "en-US",
        accuracyLevel: OCRAccuracyLevel = .accurate,
        preserveLineBreaks: Bool = true,
        trimWhitespace: Bool = true
    ) async throws -> String {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw OCRError.imageConversionFailed
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: OCRError.recognitionFailed(error.localizedDescription))
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation],
                      !observations.isEmpty else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                var lines: [String] = []
                for observation in observations {
                    if let candidate = observation.topCandidates(1).first {
                        var line = candidate.string
                        if trimWhitespace {
                            line = line.trimmingCharacters(in: .whitespaces)
                        }
                        if !line.isEmpty {
                            lines.append(line)
                        }
                    }
                }
                
                if lines.isEmpty {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let separator = preserveLineBreaks ? "\n" : " "
                continuation.resume(returning: lines.joined(separator: separator))
            }
            
            // Configure recognition level
            request.recognitionLevel = accuracyLevel == .accurate ? .accurate : .fast
            request.recognitionLanguages = [language, "en-US"]
            request.usesLanguageCorrection = accuracyLevel == .accurate
            request.automaticallyDetectsLanguage = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: OCRError.recognitionFailed(error.localizedDescription))
            }
        }
    }
    
    /// Returns the list of supported recognition languages.
    var supportedLanguages: [String] {
        (try? VNRecognizeTextRequest.supportedRecognitionLanguages(
            for: .accurate,
            revision: VNRecognizeTextRequestRevision3
        )) ?? ["en-US"]
    }
}
