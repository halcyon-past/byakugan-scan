import AVFoundation

/// Service for Text to Speech (TTS) playback using modern AVFoundation AVSpeechSynthesizer.
final class SpeechService {
    // MARK: - Singleton
    static let shared = SpeechService()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private init() {}
    
    /// Speaks the given text at the configured words-per-minute rate.
    func speak(_ text: String, rate: Double = 180.0) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        // Normalize 90-300 WPM scale to AVFoundation 0.25 - 0.75 range
        let normalizedRate = Float(max(0.2, min(0.8, (rate / 360.0))))
        utterance.rate = normalizedRate
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    /// Stops any ongoing speech synthesis immediately.
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    /// Returns true if speech synthesizer is currently speaking.
    var isSpeaking: Bool {
        synthesizer.isSpeaking
    }
}
