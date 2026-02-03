import Foundation
import Speech
import AVFoundation

@MainActor
final class PronunciationChecker: NSObject, ObservableObject {
    static let shared = PronunciationChecker()
    
    @Published var isRecording = false
    @Published var recognizedText = ""
    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isTapInstalled = false
    
    override init() {
        super.init()
        requestAuthorization()
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
            }
        }
    }
    
    func startRecording(completion: @escaping (String) -> Void) {
        guard authorizationStatus == .authorized else {
            print("PronunciationChecker: Speech recognition not authorized")
            completion("")
            return
        }
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("PronunciationChecker: Speech recognizer unavailable")
            completion("")
            return
        }
        
        // Cancel any ongoing task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("PronunciationChecker: Audio session error: \(error)")
            try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
            completion("")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let request = recognitionRequest else {
            print("PronunciationChecker: Unable to create recognition request")
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            completion("")
            return
        }
        
        request.shouldReportPartialResults = true
        
        final class CompletedFlag { var value = false }
        let completed = CompletedFlag()
        let completeOnce: (String) -> Void = { [weak self] text in
            DispatchQueue.main.async {
                guard !completed.value else { return }
                completed.value = true
                self?.removeTapAndStopEngine(inputNode: inputNode)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
                self?.isRecording = false
                completion(text)
            }
        }
        
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            var isFinal = false
            if let result = result {
                self?.recognizedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            if error != nil || isFinal {
                let text = self?.recognizedText ?? ""
                completeOnce(text)
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        guard recordingFormat.sampleRate > 0, recordingFormat.channelCount > 0 else {
            print("PronunciationChecker: Invalid recording format")
            recognitionTask?.cancel()
            recognitionTask = nil
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            completeOnce("")
            return
        }
        let bufferSize: AVAudioFrameCount = 4096
        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: recordingFormat) { [weak self] buffer, _ in
            guard buffer.frameLength > 0, let req = self?.recognitionRequest else { return }
            req.append(buffer)
        }
        isTapInstalled = true
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("PronunciationChecker: Audio engine error: \(error)")
            removeTapAndStopEngine(inputNode: inputNode)
            recognitionTask?.cancel()
            recognitionTask = nil
            isTapInstalled = false
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            completeOnce("")
        }
    }
    
    func stopRecording() {
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        removeTapAndStopEngine(inputNode: audioEngine.inputNode)
        isRecording = false
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("PronunciationChecker: Failed to deactivate session: \(error)")
        }
    }
    
    private func removeTapAndStopEngine(inputNode: AVAudioInputNode) {
        guard isTapInstalled else {
            audioEngine.stop()
            return
        }
        isTapInstalled = false
        inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    // Phonetic similarity check
    func checkPronunciation(recognized: String, target: String) -> (isCorrect: Bool, similarity: Double) {
        let normalizedRecognized = recognized.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedTarget = target.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Exact match
        if normalizedRecognized == normalizedTarget {
            return (true, 1.0)
        }
        
        // Check if target is contained in recognized (handles extra words)
        if normalizedRecognized.contains(normalizedTarget) {
            return (true, 0.95)
        }
        
        // Levenshtein distance-based similarity
        let similarity = calculateSimilarity(normalizedRecognized, normalizedTarget)
        let isCorrect = similarity >= 0.80
        
        return (isCorrect, similarity)
    }
    
    private func calculateSimilarity(_ str1: String, _ str2: String) -> Double {
        let distance = levenshteinDistance(str1, str2)
        let maxLength = max(str1.count, str2.count)
        guard maxLength > 0 else { return 1.0 }
        return 1.0 - (Double(distance) / Double(maxLength))
    }
    
    private func levenshteinDistance(_ str1: String, _ str2: String) -> Int {
        let arr1 = Array(str1)
        let arr2 = Array(str2)
        
        // Fast paths (also avoids constructing invalid ranges like `1...0` which can trap).
        if arr1.isEmpty { return arr2.count }
        if arr2.isEmpty { return arr1.count }
        
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: arr2.count + 1), count: arr1.count + 1)
        
        for i in 0...arr1.count {
            matrix[i][0] = i
        }
        for j in 0...arr2.count {
            matrix[0][j] = j
        }
        
        for i in 1...arr1.count {
            for j in 1...arr2.count {
                let cost = arr1[i-1] == arr2[j-1] ? 0 : 1
                matrix[i][j] = min(
                    matrix[i-1][j] + 1,
                    matrix[i][j-1] + 1,
                    matrix[i-1][j-1] + cost
                )
            }
        }
        
        return matrix[arr1.count][arr2.count]
    }
}
