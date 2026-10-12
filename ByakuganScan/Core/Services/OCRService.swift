import Vision
import VisionKit
import AppKit

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

/// Service responsible for extracting text from images using Apple's Vision and VisionKit frameworks.
/// Utilizes VisionKit's ImageAnalyzer on Apple Silicon Neural Engine for instant, sub-40ms OCR.
final class OCRService {
    // MARK: - Singleton
    static let shared = OCRService()
    private init() {}
    
    // Cached VisionKit analyzer
    private lazy var imageAnalyzer: ImageAnalyzer? = {
        if #available(macOS 13.0, *), ImageAnalyzer.isSupported {
            return ImageAnalyzer()
        }
        return nil
    }()
    
    // MARK: - Warm Up
    
    /// Pre-warms the Vision & Neural Engine models in the background on app launch
    /// eliminating cold-start latency on the user's first scan.
    func warmUp() {
        Task.detached(priority: .background) {
            let size = NSSize(width: 32, height: 32)
            let dummy = NSImage(size: size)
            dummy.lockFocus()
            NSColor.white.setFill()
            NSRect(origin: .zero, size: size).fill()
            let attrs: [NSAttributedString.Key: Any] = [.foregroundColor: NSColor.black, .font: NSFont.systemFont(ofSize: 12)]
            NSString(string: "A").draw(at: NSPoint(x: 10, y: 10), withAttributes: attrs)
            dummy.unlockFocus()
            
            _ = try? await self.extractText(from: dummy, autoDetectLanguage: false)
        }
    }
    
    // MARK: - Public API
    
    /// Extracts text from the given NSImage asynchronously.
    /// - Parameters:
    ///   - image: The source image to process.
    ///   - language: Primary BCP-47 language tag (e.g. "en-US").
    ///   - autoDetectLanguage: Whether to run deep multi-lingual detection (slower; defaults to false for instant speed).
    ///   - accuracyLevel: Fast vs. Accurate recognition trade-off.
    ///   - preserveLineBreaks: Whether to preserve line breaks in output.
    ///   - trimWhitespace: Whether to trim leading/trailing whitespace from lines.
    /// - Returns: The extracted text string.
    func extractText(
        from image: NSImage,
        language: String = "en-US",
        autoDetectLanguage: Bool = false,
        accuracyLevel: OCRAccuracyLevel = .accurate,
        preserveLineBreaks: Bool = true,
        trimWhitespace: Bool = true
    ) async throws -> String {
        // 1. Hardware-accelerated Neural Engine OCR via VisionKit (macOS 13+)
        if #available(macOS 13.0, *), let analyzer = self.imageAnalyzer {
            do {
                var config = ImageAnalyzer.Configuration([.text])
                if !autoDetectLanguage {
                    config.locales = [language]
                }
                let analysis = try await analyzer.analyze(image, orientation: .up, configuration: config)
                let transcript = analysis.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                if !transcript.isEmpty {
                    return formatResult(transcript, preserveLineBreaks: preserveLineBreaks, trimWhitespace: trimWhitespace)
                }
            } catch {
                // If VisionKit encounters an issue, gracefully fall back to VNRecognizeTextRequest
            }
        }
        
        // 2. Vision Framework Fallback
        return try await extractWithVisionRequest(
            from: image,
            language: language,
            autoDetectLanguage: autoDetectLanguage,
            accuracyLevel: accuracyLevel,
            preserveLineBreaks: preserveLineBreaks,
            trimWhitespace: trimWhitespace
        )
    }
    
    private func extractWithVisionRequest(
        from image: NSImage,
        language: String,
        autoDetectLanguage: Bool,
        accuracyLevel: OCRAccuracyLevel,
        preserveLineBreaks: Bool,
        trimWhitespace: Bool
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
            
            // Recognition Configuration:
            request.recognitionLevel = accuracyLevel == .accurate ? .accurate : .fast
            request.recognitionLanguages = [language, "en-US"]
            request.usesLanguageCorrection = accuracyLevel == .accurate
            request.automaticallyDetectsLanguage = autoDetectLanguage
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: OCRError.recognitionFailed(error.localizedDescription))
            }
        }
    }
    
    private func formatResult(_ text: String, preserveLineBreaks: Bool, trimWhitespace: Bool) -> String {
        var lines = text.components(separatedBy: .newlines)
        if trimWhitespace {
            lines = lines.map { $0.trimmingCharacters(in: .whitespaces) }
        }
        lines = lines.filter { !$0.isEmpty }
        
        let separator = preserveLineBreaks ? "\n" : " "
        return lines.joined(separator: separator)
    }
    
    /// Returns the list of supported recognition languages.
    var supportedLanguages: [String] {
        let request = VNRecognizeTextRequest()
        return (try? request.supportedRecognitionLanguages()) ?? ["en-US"]
    }
}
