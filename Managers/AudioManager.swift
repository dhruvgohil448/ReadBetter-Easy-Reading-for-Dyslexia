import AVFoundation

@MainActor
final class AudioManager: NSObject, AVSpeechSynthesizerDelegate {
    static let shared = AudioManager()
    private let synthesizer = AVSpeechSynthesizer()
    
    private var lastSpokenText: String = ""
    private var lastSpokenTime: CFAbsoluteTime = 0
    private let debounceInterval: CFAbsoluteTime = 0.6
    
    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("AudioManager: Failed to set audio session: \(error)")
        }
    }
    
    /// Stops current speech without speaking. Use this instead of speak("").
    func stopSpeaking() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
        lastSpokenText = ""
    }
    
    func speak(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            stopSpeaking()
            return
        }
        
        let now = CFAbsoluteTimeGetCurrent()
        if trimmed == lastSpokenText, (now - lastSpokenTime) < debounceInterval {
            return
        }
        lastSpokenText = trimmed
        lastSpokenTime = now
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            configureAudioSession()
        }
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.speakImmediately(trimmed)
            }
            return
        }
        
        speakImmediately(trimmed)
    }
    
    private func speakImmediately(_ text: String) {
        guard !text.isEmpty else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = voice
        } else if let fallback = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first ?? "en") {
            utterance.voice = fallback
        }
        utterance.rate = 0.4
        utterance.pitchMultiplier = 1.1
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
    }
}
