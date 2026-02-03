import SwiftUI

struct PronunciationView: View {
    let word: String
    var onBack: () -> Void
    
    @StateObject private var checker = PronunciationChecker.shared
    @StateObject private var scoring = ScoringManager.shared
    @StateObject private var avatar = AvatarManager.shared
    @StateObject private var theme = ThemeManager.shared
    
    @State private var syllables: [String] = []
    @State private var attempts = 0
    @State private var maxAttempts = 3
    @State private var showHelp = false
    @State private var showSuccess = false
    @State private var showFail = false
    @State private var earnedPoints = 0
    @State private var recognizedText = ""
    @State private var similarityScore: Double = 0.0
    @State private var feedbackMessage = ""
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: AppLayout.spacing24) {
                HStack {
                    Spacer()
                    
                    HStack(spacing: 15) {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.readBetter(size: 18))
                            Text("\(scoring.totalPoints)")
                                .font(.readBetter(size: 17, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                        }
                        if scoring.sessionStreak > 0 {
                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill")
                                    .font(.readBetter(size: 14))
                                    .foregroundStyle(theme.currentTheme.accentColor)
                                Text("\(scoring.sessionStreak)")
                                    .font(.readBetter(size: 17, weight: .bold))
                                    .foregroundColor(theme.currentTheme.textPrimary)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(theme.currentTheme.cardBackground, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Reading Buddy
                if avatar.isAnimating {
                    ReadingBuddyView()
                        .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Pronounce this word:")
                        .font(.readBetter(size: 21, weight: .medium))
                        .foregroundColor(theme.currentTheme.textSecondary)
                    
                    Text(word)
                        .font(.readBetter(size: 58, weight: .bold))
                        .kerning(2.0)
                        .foregroundColor(theme.currentTheme.textPrimary)
                    
                    // Syllable breakdown
                    HStack(spacing: 8) {
                        ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                            Text(syllable)
                                .font(.readBetter(size: 24, weight: .semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(theme.currentTheme.syllableColors[index % theme.currentTheme.syllableColors.count].opacity(0.3))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Attempts indicator
                    HStack(spacing: 8) {
                        ForEach(0..<maxAttempts, id: \.self) { index in
                            Circle()
                                .fill(index < attempts ? theme.currentTheme.errorColor.opacity(0.4) : theme.currentTheme.successColor.opacity(0.4))
                                .frame(width: 12, height: 12)
                        }
                    }
                    .padding(.top, 10)
                    
                    // Feedback message
                    if !feedbackMessage.isEmpty {
                        Text(feedbackMessage)
                            .font(.readBetter(size: 16, weight: .medium))
                            .foregroundColor(similarityScore >= 0.80 ? theme.currentTheme.successColor : theme.currentTheme.accentColor)
                            .padding()
                            .background(theme.currentTheme.cardBackground.opacity(0.95))
                            .cornerRadius(12)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                Spacer()
                
                // Recording Button
                VStack(spacing: 15) {
                    Button(action: {
                        if checker.isRecording {
                            checker.stopRecording()
                        } else {
                            startRecording()
                        }
                    }) {
                        VStack(spacing: 10) {
                            Image(systemName: checker.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .font(.readBetter(size: 70))
                                .foregroundColor(checker.isRecording ? theme.currentTheme.errorColor : theme.currentTheme.primaryColor)
                                .symbolEffect(.bounce, value: checker.isRecording)
                                .symbolEffect(.pulse, options: .repeating, isActive: checker.isRecording)
                            
                            Text(checker.isRecording ? "Stop" : "Tap to Speak")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(checker.isRecording ? theme.currentTheme.errorColor : theme.currentTheme.primaryColor)
                                .contentTransition(.interpolate)
                        }
                        .padding()
                        .background(
                            Circle()
                                .fill(checker.isRecording ? theme.currentTheme.errorColor.opacity(0.15) : theme.currentTheme.primaryColor.opacity(0.1))
                                .scaleEffect(checker.isRecording ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: checker.isRecording)
                        )
                    }
                    .disabled(attempts >= maxAttempts)
                    .sensoryFeedback(.impact, trigger: checker.isRecording)
                    
                    if !recognizedText.isEmpty {
                        VStack(spacing: 8) {
                            Text("You said: \"\(recognizedText)\"")
                                .font(.readBetter(size: 16))
                                .foregroundColor(.secondary)
                            
                            if similarityScore > 0 {
                                HStack(spacing: 4) {
                                    Text("Match:")
                                    Text("\(Int(similarityScore * 100))%")
                                        .fontWeight(.bold)
                                        .foregroundColor(similarityScore >= 0.80 ? theme.currentTheme.successColor : theme.currentTheme.accentColor)
                                }
                                .font(.readBetter(size: 14))
                            }
                        }
                        .padding()
                        .background(theme.currentTheme.cardBackground.opacity(0.95))
                        .cornerRadius(12)
                    }
                    
                    // Help button
                    if attempts > 0 && attempts < maxAttempts {
                        Button(action: { showHelp = true }) {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                Text("Help me pronounce")
                            }
                            .font(.readBetter(size: 18, weight: .medium))
                            .foregroundColor(theme.currentTheme.accentButtonLabelColor)
                            .padding()
                            .background(theme.currentTheme.accentColor)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            
            // Success overlay
            if showSuccess {
                SuccessOverlay(points: earnedPoints, onDismiss: {
                    showSuccess = false
                    onBack()
                })
            }
            
            // Help overlay
            if showHelp {
                HelpPronounceOverlay(
                    word: word,
                    syllables: syllables,
                    onDismiss: { showHelp = false }
                )
            }
        }
        .onAppear {
            syllables = SyllableEngine.getSyllables(for: word)
        }
    }
    
    func startRecording() {
        AudioManager.shared.stopSpeaking()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            checker.startRecording { recognized in
                recognizedText = recognized
                checkPronunciation(recognized)
            }
        }
    }
    
    func checkPronunciation(_ recognized: String) {
        // Don't process empty recognition (error case)
        guard !recognized.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            feedbackMessage = "Couldn't hear clearly. Try again!"
            return
        }
        
        attempts += 1
        
        // Clear previous feedback
        feedbackMessage = ""
        
        // Check pronunciation
        let result = checker.checkPronunciation(recognized: recognized, target: word)
        similarityScore = result.similarity
        
        // Debug logging
        #if DEBUG
        print("=== Pronunciation Check ===")
        print("Target: \(word)")
        print("Recognized: \(recognized)")
        print("Similarity: \(Int(result.similarity * 100))%")
        print("Is Correct: \(result.isCorrect)")
        print("========================")
        #endif
        
        if result.isCorrect {
            // Success!
            let isFirstTry = attempts == 1
            earnedPoints = scoring.calculatePoints(syllableCount: syllables.count, isFirstTry: isFirstTry)
            scoring.awardPoints(for: word, syllableCount: syllables.count, isFirstTry: isFirstTry)
            
            // Reading buddy celebrates
            let messages = [
                "Great! You said '\(word)' perfectly!",
                "Perfect pronunciation! You're amazing!",
                "Wow! You nailed it! Keep going!"
            ]
            avatar.celebrate(messages.randomElement() ?? "Perfect!")
            
            feedbackMessage = "Perfect! \(Int(result.similarity * 100))% match!"
            
#if canImport(UIKit)
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
#endif
            
            // Show success after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showSuccess = true
                }
            }
        } else {
            // Failed
            if result.similarity >= 0.60 {
                feedbackMessage = "Close! \(Int(result.similarity * 100))% match. Try again!"
                avatar.showEncouragement("So close! Try again - you've got this!")
            } else {
                feedbackMessage = "Not quite. Listen and try again!"
                avatar.showEncouragement("Let's practice together!")
            }
            
#if canImport(UIKit)
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
#endif
            
            if attempts >= maxAttempts {
                scoring.resetSessionStreak()
                avatar.think("Let's practice this word together next time!")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showHelp = true
                }
            }
        }
    }
}

struct SuccessOverlay: View {
            let points: Int
            let onDismiss: () -> Void
            
            @State private var isAnimating = false
            
            var body: some View {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.readBetter(size: 48))
                            .foregroundStyle(ThemeManager.shared.currentTheme.successColor)
                            .keyframeAnimator(initialValue: AnimationValues(), trigger: isAnimating) { content, value in
                                content
                                    .scaleEffect(value.scale)
                                    .rotationEffect(value.rotation)
                            } keyframes: { _ in
                                KeyframeTrack(\.scale) {
                                    SpringKeyframe(1.2, duration: 0.3)
                                    SpringKeyframe(1.0, duration: 0.3)
                                }
                                KeyframeTrack(\.rotation) {
                                    CubicKeyframe(.degrees(0), duration: 0.0)
                                    CubicKeyframe(.degrees(10), duration: 0.15)
                                    CubicKeyframe(.degrees(-10), duration: 0.15)
                                    CubicKeyframe(.degrees(0), duration: 0.15)
                                }
                            }
                        
                        Text("Perfect!")
                            .font(.readBetter(size: AppFontSize.title1, weight: .bold))
                            .foregroundColor(ThemeManager.shared.currentTheme.successColor)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .symbolEffect(.bounce, value: isAnimating)
                            Text("+\(points)")
                                .contentTransition(.numericText(value: Double(points)))
                            Text("points")
                        }
                        .font(.readBetter(size: 32, weight: .semibold))
                        .foregroundColor(ThemeManager.shared.currentTheme.primaryColor)
                        
                        Button(action: onDismiss) {
                            Text("Continue")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(ThemeManager.shared.currentTheme.primaryButtonLabelColor)
                                .padding()
                                .frame(maxWidth: 200)
                                .background(ThemeManager.shared.currentTheme.primaryColor)
                                .cornerRadius(12)
                        }
                        .padding(.top, 20)
                    }
                    .padding(40)
                    .liquidGlass(cornerRadius: 24, shadowRadius: 25, material: .regularMaterial)
                }
                .onAppear {
                    isAnimating = true
                }
            }
            
            struct AnimationValues {
                var scale: Double = 1.0
                var rotation: Angle = .degrees(0)
            }
        }

struct HelpPronounceOverlay: View {
    let word: String
    let syllables: [String]
    let onDismiss: () -> Void

    @StateObject private var theme = ThemeManager.shared
    @State private var currentSyllable = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.readBetter(size: 32))
                            .foregroundColor(.gray)
                    }
                }
                
                Text("Let's break it down")
                    .font(.readBetter(size: 28, weight: .bold))
                
                // Syllables with highlighting
                HStack(spacing: 12) {
                    ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                        Text(syllable)
                            .font(.readBetter(size: 40, weight: .bold))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(index == currentSyllable ? theme.currentTheme.accentHighlightColor.opacity(0.4) : theme.currentTheme.textSecondary.opacity(0.15))
                            )
                            .onTapGesture {
                                currentSyllable = index
                                AudioManager.shared.speak(syllable)
                            }
                    }
                }
                
                Button(action: {
                    AudioManager.shared.speak(word)
                }) {
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                        Text("Hear full word (slow)")
                    }
                    .font(.readBetter(size: 18, weight: .semibold))
                    .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                    .padding()
                    .background(theme.currentTheme.primaryColor)
                    .cornerRadius(12)
                }
                
                Text("Tap each syllable to hear it")
                    .font(.readBetter(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(30)
            .liquidGlass(cornerRadius: 24, shadowRadius: 25, material: .regularMaterial)
            .padding(40)
        }
    }
}
