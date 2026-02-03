import SwiftUI

// MARK: - Challenge Selection Screen
struct ChallengesSelectionView: View {
    var onChallengeSelected: (ContentView.ChallengeType, String) -> Void
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var scoring = ScoringManager.shared
    @State private var selectedWord: String = ""
    
    private let demoWords = [
        // Simple words
        "fantastic", "butterfly", "momentum", "school", "computer", "dinosaur", "elephant",
        // Challenging words
        "Psychology", "Responsibility", "Unnecessary", "Miscellaneous", "Pronunciation",
        "Accommodation", "Conscientious", "Rhythm", "Environment", "Entrepreneur",
        "Pharmaceutical", "Architecture", "Subconscious", "Hypothesis", "Indistinguishable",
        "Parallel", "Colonel", "Hierarchy", "Questionnaire", "Approximately"
    ]
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: AppLayout.spacing24) {
                        // Header on card for visibility on all themes
                        VStack(spacing: AppLayout.spacing8) {
                            Text("Mini challenges")
                                .font(.readBetter(size: AppFontSize.title1, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                            Text("Fun ways to practice reading")
                                .font(.readBetter(size: AppFontSize.bodyLarge, weight: .medium))
                                .foregroundColor(theme.currentTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .fill(theme.currentTheme.cardBackground)
                        )
                        .padding(.horizontal, AppLayout.horizontalPadding(isIPad: false))
                        .padding(.top, AppLayout.spacing16)

                        // Choose a word + grid on card for visibility
                        VStack(alignment: .leading, spacing: AppLayout.spacing16) {
                            Text("Choose a word")
                                .font(.readBetter(size: AppFontSize.title3, weight: .semibold))
                                .foregroundColor(theme.currentTheme.textPrimary)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: AppLayout.spacing8) {
                                ForEach(demoWords, id: \.self) { word in
                                    Button(action: {
                                        selectedWord = word
                                        AudioManager.shared.speak(word)
                                    }) {
                                        Text(word)
                                            .font(.readBetter(size: 16, weight: .semibold))
                                            .foregroundColor(selectedWord == word ? theme.currentTheme.primaryButtonLabelColor : theme.currentTheme.textPrimary)
                                        .padding(.horizontal, AppLayout.spacing16)
                                        .padding(.vertical, AppLayout.spacing8)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton)
                                                .fill(selectedWord == word ? theme.currentTheme.primaryColor : theme.currentTheme.cardBackground)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton)
                                                .stroke(selectedWord == word ? Color.clear : theme.currentTheme.primaryColor.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                    .buttonStyle(KidButtonStyle())
                                }
                            }
                        }
                        .padding(AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .fill(theme.currentTheme.cardBackground)
                        )
                        .padding(.horizontal, AppLayout.horizontalPadding(isIPad: false))
                        
                        if !selectedWord.isEmpty {
                            VStack(alignment: .leading, spacing: AppLayout.spacing16) {
                                Text("Pick a challenge")
                                    .font(.readBetter(size: AppFontSize.title3, weight: .semibold))
                                    .foregroundColor(theme.currentTheme.textPrimary)

                                VStack(spacing: AppLayout.spacing16) {
                                    ChallengeOptionCard(
                                        iconName: "waveform",
                                        title: "Tap the sounds",
                                        description: "Listen and tap the matching syllable",
                                        color: theme.currentTheme.primaryColor,
                                        action: { onChallengeSelected(.tapSounds, selectedWord) }
                                    )
                                    ChallengeOptionCard(
                                        iconName: "square.stack.3d.up",
                                        title: "Build the word",
                                        description: "Put syllables in the right order",
                                        color: theme.currentTheme.secondaryColor,
                                        action: { onChallengeSelected(.buildWord, selectedWord) }
                                    )
                                    ChallengeOptionCard(
                                        iconName: "tortoise.fill",
                                        title: "Slow read mode",
                                        description: "Read at your own pace",
                                        color: theme.currentTheme.accentColor,
                                        action: { onChallengeSelected(.slowRead, selectedWord) }
                                    )
                                    ChallengeOptionCard(
                                        iconName: "ear.fill",
                                        title: "Find matching sound",
                                        description: "Match the sound you hear",
                                        color: theme.currentTheme.primaryColor,
                                        action: { onChallengeSelected(.findMatch, selectedWord) }
                                    )
                                    ChallengeOptionCard(
                                        iconName: "sparkles",
                                        title: "Read and glow",
                                        description: "Tap syllables to light them up",
                                        color: theme.currentTheme.secondaryColor,
                                        action: { onChallengeSelected(.readGlow, selectedWord) }
                                    )
                                    ChallengeOptionCard(
                                        iconName: "star.fill",
                                        title: "Daily tiny challenge",
                                        description: "Today's friendly word",
                                        color: theme.currentTheme.accentColor,
                                        action: { onChallengeSelected(.dailyTiny, selectedWord) }
                                    )
                                }
                            }
                            .padding(AppLayout.spacing16)
                            .background(
                                RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                    .fill(theme.currentTheme.cardBackground)
                            )
                            .padding(.horizontal, AppLayout.horizontalPadding(isIPad: false))
                            .padding(.top, AppLayout.spacing8)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
        }
    }
}

struct ChallengeOptionCard: View {
    let iconName: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void

    @ObservedObject private var theme = ThemeManager.shared

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppLayout.spacing16) {
                Image(systemName: iconName)
                    .font(.readBetter(size: 22, weight: .semibold))
                    .foregroundStyle(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
                        .foregroundColor(theme.currentTheme.textPrimary)
                    Text(description)
                        .font(.readBetter(size: AppFontSize.caption))
                        .foregroundColor(theme.currentTheme.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.readBetter(size: AppFontSize.body, weight: .semibold))
                    .foregroundColor(theme.currentTheme.textSecondary)
            }
            .padding(AppLayout.spacing16)
            .background(
                RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                    .fill(theme.currentTheme.cardBackground)
            )
        }
        .buttonStyle(KidButtonStyle())
    }
}

// MARK: - Main Challenge View Router
struct ChallengeView: View {
    let challengeType: ContentView.ChallengeType
    let word: String
    var onBack: () -> Void
    
    var body: some View {
        switch challengeType {
        case .tapSounds:
            TapSoundsChallengeView(word: word, onBack: onBack)
        case .buildWord:
            BuildWordChallengeView(word: word, onBack: onBack)
        case .slowRead:
            SlowReadChallengeView(word: word, onBack: onBack)
        case .findMatch:
            FindMatchChallengeView(word: word, onBack: onBack)
        case .readGlow:
            ReadGlowChallengeView(word: word, onBack: onBack)
        case .dailyTiny:
            DailyTinyChallengeView(word: word, onBack: onBack)
        }
    }
}

// MARK: - Challenge 1: Tap the Sounds
struct TapSoundsChallengeView: View {
    let word: String
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var scoring = ScoringManager.shared
    @State private var syllables: [String] = []
    @State private var currentSoundIndex: Int = 0
    @State private var selectedIndex: Int? = nil
    @State private var correctCount: Int = 0
    @State private var showSuccess: Bool = false
    @State private var isPlaying: Bool = false
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
                    VStack(spacing: AppLayout.spacing24) {
                Spacer()
                
                if showSuccess {
                    VStack(spacing: AppLayout.spacing16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.readBetter(size: 48))
                            .foregroundStyle(theme.currentTheme.successColor)
                        Text("Perfect!")
                            .font(.readBetter(size: AppFontSize.title1, weight: .bold))
                            .foregroundColor(theme.currentTheme.textPrimary)
                        Text("You got \(correctCount) out of \(syllables.count) correct!")
                            .font(.readBetter(size: 20))
                            .foregroundColor(theme.currentTheme.textSecondary)
                        
                        Button(action: onBack) {
                            Text("Done")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(theme.currentTheme.primaryColor, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(KidButtonStyle())
                    }
                    .padding(40)
                    .background(theme.currentTheme.cardBackground, in: RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
                } else {
                    VStack(spacing: 30) {
                        VStack(spacing: 12) {
                            Text("Tap the sounds")
                                .font(.readBetter(size: 32, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                            Text("Listen to the sound, then tap the matching syllable")
                                .font(.readBetter(size: 18))
                                .foregroundColor(theme.currentTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppLayout.spacing16)
                        .padding(.horizontal, AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .fill(theme.currentTheme.cardBackground)
                        )
                        .padding(.horizontal, 20)
                        
                        // Play sound button
                        Button(action: playCurrentSound) {
                            VStack(spacing: 12) {
                                Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.wave.2")
                                    .font(.readBetter(size: 50))
                                    .foregroundColor(theme.currentTheme.primaryColor)
                                Text("Play Sound")
                                    .font(.readBetter(size: 18, weight: .semibold))
                                    .foregroundColor(theme.currentTheme.textPrimary)
                            }
                            .padding(30)
                            // Stronger contrast so the speaker is always visible on busy wallpapers.
                            .background(
                                Circle()
                                    .fill(theme.currentTheme.cardBackground.opacity(0.92))
                                    .shadow(color: Color.black.opacity(0.12), radius: 10, y: 5)
                            )
                            .overlay(
                                Circle()
                                    .stroke(theme.currentTheme.primaryColor.opacity(0.25), lineWidth: 2)
                            )
                        }
                        .buttonStyle(KidButtonStyle())
                        .disabled(isPlaying)
                        
                        // Syllable options
                        HStack(spacing: 16) {
                            ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                                Button(action: {
                                    checkAnswer(index)
                                }) {
                                    Text(syllable)
                                        .font(.readBetter(size: 24, weight: .bold))
                                        .foregroundColor(selectedIndex == index ? theme.currentTheme.primaryButtonLabelColor : theme.currentTheme.textPrimary)
                                        .frame(width: 80, height: 80)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(selectedIndex == index ? theme.currentTheme.primaryColor : theme.currentTheme.cardBackground)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(theme.currentTheme.primaryColor.opacity(0.3), lineWidth: 2)
                                        )
                                        .scaleEffect(selectedIndex == index ? 1.1 : 1.0)
                                }
                                .buttonStyle(KidButtonStyle())
                                .disabled(selectedIndex != nil)
                            }
                        }
                        
                        // Progress
                        HStack(spacing: 8) {
                            ForEach(0..<syllables.count, id: \.self) { i in
                                Circle()
                                    .fill(i < correctCount ? theme.currentTheme.successColor : theme.currentTheme.textSecondary.opacity(0.3))
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            syllables = SyllableEngine.getSyllables(for: word)
        }
    }
    
    private func playCurrentSound() {
        guard currentSoundIndex < syllables.count else { return }
        isPlaying = true
        AudioManager.shared.speak(syllables[currentSoundIndex])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isPlaying = false
        }
    }
    
    private func checkAnswer(_ index: Int) {
        selectedIndex = index
        let isCorrect = index == currentSoundIndex
        
        #if canImport(UIKit)
        if isCorrect {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        #endif
        
        if isCorrect {
            correctCount += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                selectedIndex = nil
                currentSoundIndex += 1
                if currentSoundIndex >= syllables.count {
                    showSuccess = true
                    scoring.awardPoints(for: word, syllableCount: syllables.count, isFirstTry: true)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                selectedIndex = nil
            }
        }
    }
}

// MARK: - Challenge 2: Build the Word Puzzle
struct BuildWordChallengeView: View {
    let word: String
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var scoring = ScoringManager.shared
    @State private var syllables: [String] = []
    @State private var shuffledSyllables: [String] = []
    @State private var selectedOrder: [String] = []
    @State private var showSuccess: Bool = false
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: 30) {
                Spacer()

                if showSuccess {
                    VStack(spacing: AppLayout.spacing16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.readBetter(size: 48))
                            .foregroundStyle(theme.currentTheme.successColor)
                        Text("Perfect!")
                            .font(.readBetter(size: AppFontSize.title1, weight: .bold))
                            .foregroundColor(theme.currentTheme.textPrimary)
                        Button(action: onBack) {
                            Text("Done")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(theme.currentTheme.primaryColor, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(KidButtonStyle())
                    }
                    .padding(40)
                    .background(theme.currentTheme.cardBackground, in: RoundedRectangle(cornerRadius: 28))
                } else {
                    VStack(spacing: 30) {
                        VStack(spacing: 12) {
                            Text("Build the word")
                                .font(.readBetter(size: 32, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                            Text("Tap syllables in the correct order")
                                .font(.readBetter(size: 18))
                                .foregroundColor(theme.currentTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppLayout.spacing16)
                        .padding(.horizontal, AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .fill(theme.currentTheme.cardBackground)
                        )
                        .padding(.horizontal, 20)
                        
                        // Selected order
                        HStack(spacing: 12) {
                            ForEach(selectedOrder, id: \.self) { syllable in
                                Text(syllable)
                                    .font(.readBetter(size: 28, weight: .bold))
                                    .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(theme.currentTheme.primaryColor, in: RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .frame(minHeight: 80)
                        
                        // Available syllables
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 16) {
                            ForEach(shuffledSyllables, id: \.self) { syllable in
                                Button(action: {
                                    selectSyllable(syllable)
                                }) {
                                    Text(syllable)
                                        .font(.readBetter(size: 22, weight: .bold))
                                        .foregroundColor(theme.currentTheme.textPrimary)
                                        .frame(width: 90, height: 70)
                                        .background(theme.currentTheme.cardBackground, in: RoundedRectangle(cornerRadius: 14))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(theme.currentTheme.primaryColor.opacity(0.3), lineWidth: 2)
                                        )
                                }
                                .buttonStyle(KidButtonStyle())
                                .disabled(selectedOrder.contains(syllable))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            syllables = SyllableEngine.getSyllables(for: word)
            shuffledSyllables = syllables.shuffled()
        }
    }
    
    private func selectSyllable(_ syllable: String) {
        selectedOrder.append(syllable)
        AudioManager.shared.speak(syllable)
        
        if selectedOrder.count == syllables.count {
            let isCorrect = selectedOrder == syllables
            if isCorrect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSuccess = true
                    scoring.awardPoints(for: word, syllableCount: syllables.count, isFirstTry: true)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    selectedOrder = []
                    shuffledSyllables = syllables.shuffled()
                }
            }
        }
    }
}

// MARK: - Challenge 3: Slow Read Mode
struct SlowReadChallengeView: View {
    let word: String
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var scoring = ScoringManager.shared
    @State private var syllables: [String] = []
    @State private var currentIndex: Int = 0
    @State private var isHighlighted: Bool = false
    @State private var showComplete: Bool = false
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: 30) {
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.readBetter(size: 17, weight: .semibold))
                        .foregroundColor(theme.currentTheme.textPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(theme.currentTheme.textPrimary.opacity(0.1), in: Capsule())
                    }
                    .buttonStyle(KidButtonStyle())
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                Spacer()
                
                if showComplete {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.readBetter(size: 48))
                            .foregroundStyle(theme.currentTheme.successColor)
                        Text("Great reading!")
                            .font(.readBetter(size: 36, weight: .bold))
                            .foregroundColor(theme.currentTheme.textPrimary)
                        Button(action: onBack) {
                            Text("Done")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(theme.currentTheme.primaryColor, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(KidButtonStyle())
                    }
                    .padding(40)
                    .background(theme.currentTheme.cardBackground, in: RoundedRectangle(cornerRadius: 28))
                } else {
                    VStack(spacing: 30) {
                        VStack(spacing: 12) {
                            Text("Slow read mode")
                                .font(.readBetter(size: 32, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                            Text("Tap when the syllable lights up")
                                .font(.readBetter(size: 18))
                                .foregroundColor(theme.currentTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppLayout.spacing16)
                        .padding(.horizontal, AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .fill(theme.currentTheme.cardBackground)
                        )
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 16) {
                            ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                                Text(syllable)
                                    .font(.readBetter(size: 32, weight: .bold))
                                    .foregroundColor(index == currentIndex && isHighlighted ? theme.currentTheme.primaryButtonLabelColor : theme.currentTheme.textPrimary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(index == currentIndex && isHighlighted ? theme.currentTheme.primaryColor : theme.currentTheme.cardBackground)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(theme.currentTheme.primaryColor.opacity(0.3), lineWidth: 2)
                                    )
                            }
                        }
                        
                        Button(action: nextSyllable) {
                            Text(currentIndex < syllables.count ? "Tap to Continue" : "Complete!")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(theme.currentTheme.primaryColor, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(KidButtonStyle())
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            syllables = SyllableEngine.getSyllables(for: word)
        }
    }
    
    private func nextSyllable() {
        if currentIndex < syllables.count {
            isHighlighted = true
            AudioManager.shared.speak(syllables[currentIndex])
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isHighlighted = false
                currentIndex += 1
                if currentIndex >= syllables.count {
                    showComplete = true
                    scoring.awardPoints(for: word, syllableCount: syllables.count, isFirstTry: true)
                }
            }
        }
    }
}

// MARK: - Challenge 4: Find Matching Sound
struct FindMatchChallengeView: View {
    let word: String
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var scoring = ScoringManager.shared
    @State private var syllables: [String] = []
    @State private var currentSound: String = ""
    @State private var options: [String] = []
    @State private var selectedIndex: Int? = nil
    @State private var correctCount: Int = 0
    @State private var round: Int = 0
    @State private var showSuccess: Bool = false
    
    private let fallbackSounds: [String] = [
        "ba", "be", "bi", "bo", "bu",
        "la", "le", "li", "lo", "lu",
        "ma", "me", "mi", "mo", "mu",
        "ta", "te", "ti", "to", "tu",
        "sh", "ch", "th", "oo", "ee", "ay"
    ]
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: 30) {
                Spacer()

                if showSuccess {
                    VStack(spacing: AppLayout.spacing16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.readBetter(size: 48))
                            .foregroundStyle(theme.currentTheme.successColor)
                        Text("Perfect!")
                            .font(.readBetter(size: AppFontSize.title1, weight: .bold))
                            .foregroundColor(theme.currentTheme.textPrimary)
                        Button(action: onBack) {
                            Text("Done")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(theme.currentTheme.primaryColor, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(KidButtonStyle())
                    }
                    .padding(40)
                    .background(theme.currentTheme.cardBackground, in: RoundedRectangle(cornerRadius: 28))
                } else {
                    VStack(spacing: 30) {
                        Text("Find matching sound")
                            .font(.readBetter(size: 32, weight: .bold))
                            .foregroundColor(theme.currentTheme.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppLayout.spacing16)
                            .padding(.horizontal, AppLayout.spacing16)
                            .background(
                                RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                    .fill(theme.currentTheme.cardBackground)
                            )
                            .padding(.horizontal, 20)
                        
                        Button(action: playSound) {
                            VStack(spacing: 12) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.readBetter(size: 50))
                                    .foregroundColor(theme.currentTheme.primaryColor)
                                Text("Play Sound")
                                    .font(.readBetter(size: 18, weight: .semibold))
                                    .foregroundColor(theme.currentTheme.textPrimary)
                            }
                            .padding(30)
                            // Stronger contrast so the speaker is always visible on busy wallpapers.
                            .background(
                                Circle()
                                    .fill(theme.currentTheme.cardBackground.opacity(0.92))
                                    .shadow(color: Color.black.opacity(0.12), radius: 10, y: 5)
                            )
                            .overlay(
                                Circle()
                                    .stroke(theme.currentTheme.primaryColor.opacity(0.25), lineWidth: 2)
                            )
                        }
                        .buttonStyle(KidButtonStyle())
                        
                        HStack(spacing: 20) {
                            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                                Button(action: {
                                    checkMatch(index, option)
                                }) {
                                    Text(option)
                                        .font(.readBetter(size: 24, weight: .bold))
                                        .foregroundColor(selectedIndex == index ? theme.currentTheme.primaryButtonLabelColor : theme.currentTheme.textPrimary)
                                        .frame(width: 100, height: 100)
                                        .background(
                                            RoundedRectangle(cornerRadius: 18)
                                                .fill(selectedIndex == index ? theme.currentTheme.primaryColor : theme.currentTheme.cardBackground)
                                        )
                                }
                                .buttonStyle(KidButtonStyle())
                                .disabled(selectedIndex != nil)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            // Normalize syllables to avoid empty values / crashes / infinite loops.
            syllables = SyllableEngine.getSyllables(for: word)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            round = 0
            correctCount = 0
            showSuccess = false
            startRound()
        }
    }
    
    private func startRound() {
        guard !syllables.isEmpty else {
            // Nothing to match; exit gracefully instead of crashing.
            currentSound = ""
            options = []
            showSuccess = true
            return
        }
        guard round < syllables.count else {
            showSuccess = true
            scoring.awardPoints(for: word, syllableCount: syllables.count, isFirstTry: true)
            return
        }
        currentSound = syllables[round]
        options = makeOptions(current: currentSound)
        selectedIndex = nil
    }
    
    private func makeOptions(current: String) -> [String] {
        let currentTrimmed = current.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !currentTrimmed.isEmpty else {
            // If current sound is empty, show two safe fallbacks.
            let a = fallbackSounds.first ?? "ba"
            let b = fallbackSounds.dropFirst().first ?? "la"
            return [a, b]
        }
        
        // Prefer a distractor from other syllables; fall back to common syllables.
        let unique = Array(Set(syllables))
        let candidates = unique.filter { $0 != currentTrimmed && !$0.isEmpty }
        let fallbackCandidates = fallbackSounds.filter { $0 != currentTrimmed }
        
        let distractor = (candidates.randomElement() ?? fallbackCandidates.randomElement()) ?? "la"
        return [currentTrimmed, distractor].shuffled()
    }
    
    private func playSound() {
        AudioManager.shared.speak(currentSound)
    }
    
    private func checkMatch(_ index: Int, _ option: String) {
        selectedIndex = index
        let isCorrect = option == currentSound
        
        #if canImport(UIKit)
        if isCorrect {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        #endif
        
        if isCorrect {
            correctCount += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                round += 1
                startRound()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                selectedIndex = nil
            }
        }
    }
}

// MARK: - Challenge 5: Read & Glow (Confidence Builder)
struct ReadGlowChallengeView: View {
    let word: String
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var scoring = ScoringManager.shared
    @State private var syllables: [String] = []
    @State private var litSyllables: Set<Int> = []
    @State private var showComplete: Bool = false
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: 30) {
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.readBetter(size: 17, weight: .semibold))
                        .foregroundColor(theme.currentTheme.textPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(theme.currentTheme.textPrimary.opacity(0.1), in: Capsule())
                    }
                    .buttonStyle(KidButtonStyle())
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                Spacer()
                
                if showComplete {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.readBetter(size: 48))
                            .foregroundStyle(theme.currentTheme.successColor)
                            .symbolEffect(.bounce, value: showComplete)
                        Text("Great reading!")
                            .font(.readBetter(size: 36, weight: .bold))
                            .foregroundColor(theme.currentTheme.textPrimary)
                        Text("You did amazing!")
                            .font(.readBetter(size: 20))
                            .foregroundColor(theme.currentTheme.textSecondary)
                        Button(action: onBack) {
                            Text("Done")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(theme.currentTheme.primaryColor, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(KidButtonStyle())
                    }
                    .padding(40)
                    .background(theme.currentTheme.cardBackground, in: RoundedRectangle(cornerRadius: 28))
                } else {
                    VStack(spacing: 30) {
                        VStack(spacing: 12) {
                            Text("Read and glow")
                                .font(.readBetter(size: 32, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                            Text("Tap each syllable at your own pace")
                                .font(.readBetter(size: 18))
                                .foregroundColor(theme.currentTheme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppLayout.spacing16)
                        .padding(.horizontal, AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .fill(theme.currentTheme.cardBackground)
                        )
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 16) {
                            ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                                Button(action: {
                                    lightUpSyllable(index)
                                }) {
                                    Text(syllable)
                                        .font(.readBetter(size: 28, weight: .bold))
                                        .foregroundColor(litSyllables.contains(index) ? theme.currentTheme.primaryButtonLabelColor : theme.currentTheme.textPrimary)
                                        .frame(width: 90, height: 90)
                                        .background(
                                            RoundedRectangle(cornerRadius: 18)
                                                .fill(
                                                    litSyllables.contains(index) ?
                                                    LinearGradient(
                                                        colors: [theme.currentTheme.primaryColor, theme.currentTheme.secondaryColor],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ) :
                                                    LinearGradient(
                                                        colors: [theme.currentTheme.cardBackground, theme.currentTheme.cardBackground],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(theme.currentTheme.primaryColor.opacity(0.3), lineWidth: 2)
                                        )
                                        .shadow(
                                            color: litSyllables.contains(index) ? theme.currentTheme.primaryColor.opacity(0.5) : .clear,
                                            radius: litSyllables.contains(index) ? 12 : 0
                                        )
                                }
                                .buttonStyle(KidButtonStyle())
                                .disabled(litSyllables.contains(index))
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            syllables = SyllableEngine.getSyllables(for: word)
        }
    }
    
    private func lightUpSyllable(_ index: Int) {
        litSyllables.insert(index)
        AudioManager.shared.speak(syllables[index])
        
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
        
        if litSyllables.count == syllables.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showComplete = true
                scoring.awardPoints(for: word, syllableCount: syllables.count, isFirstTry: true)
            }
        }
    }
}

// MARK: - Challenge 6: Daily Tiny Challenge
struct DailyTinyChallengeView: View {
    let word: String
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var scoring = ScoringManager.shared
    @State private var syllables: [String] = []
    @State private var currentIndex: Int = 0
    @State private var showComplete: Bool = false
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: 30) {
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.readBetter(size: 17, weight: .semibold))
                        .foregroundColor(theme.currentTheme.textPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(theme.currentTheme.textPrimary.opacity(0.1), in: Capsule())
                    }
                    .buttonStyle(KidButtonStyle())
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                Spacer()
                
                if showComplete {
                    VStack(spacing: 20) {
                        Image(systemName: "star.fill")
                            .font(.readBetter(size: 48))
                            .foregroundStyle(theme.currentTheme.primaryColor)
                        Text("Today's Challenge Complete!")
                            .font(.readBetter(size: 28, weight: .bold))
                            .foregroundColor(theme.currentTheme.textPrimary)
                            .multilineTextAlignment(.center)
                        Button(action: onBack) {
                            Text("Done")
                                .font(.readBetter(size: 20, weight: .semibold))
                                .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(theme.currentTheme.primaryColor, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(KidButtonStyle())
                    }
                    .padding(40)
                    .background(theme.currentTheme.cardBackground, in: RoundedRectangle(cornerRadius: 28))
                } else {
                    VStack(spacing: 30) {
                        VStack(spacing: 12) {
                            Text("Today's friendly word")
                                .font(.readBetter(size: 32, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                            Text("Tap each syllable as you read")
                                .font(.readBetter(size: 18))
                                .foregroundColor(theme.currentTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppLayout.spacing16)
                        .padding(.horizontal, AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .fill(theme.currentTheme.cardBackground)
                        )
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Text(word)
                                .font(.readBetter(size: 48, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                                .kerning(1.5)
                                .lineLimit(1)
                                .minimumScaleFactor(0.65)
                            
                            // Speaker button (the word is playable anytime).
                            Button(action: { AudioManager.shared.speak(word) }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.readBetter(size: 18, weight: .semibold))
                                    Text("Hear Word")
                                        .font(.readBetter(size: 18, weight: .semibold))
                                }
                                .foregroundColor(theme.currentTheme.textPrimary)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(theme.currentTheme.cardBackground.opacity(0.92))
                                        .shadow(color: Color.black.opacity(0.10), radius: 10, y: 5)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(theme.currentTheme.primaryColor.opacity(0.22), lineWidth: 2)
                                )
                            }
                            .buttonStyle(KidButtonStyle())
                        }
                        
                        HStack(spacing: 16) {
                            ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                                Button(action: {
                                    tapSyllable(index)
                                }) {
                                    Text(syllable)
                                        .font(.readBetter(size: 24, weight: .bold))
                                        .foregroundColor(currentIndex > index ? theme.currentTheme.primaryButtonLabelColor : theme.currentTheme.textPrimary)
                                        .frame(width: 80, height: 80)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(currentIndex > index ? theme.currentTheme.primaryColor : theme.currentTheme.cardBackground)
                                        )
                                }
                                .buttonStyle(KidButtonStyle())
                                .disabled(currentIndex > index)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            syllables = SyllableEngine.getSyllables(for: word)
            AudioManager.shared.speak(word)
        }
    }
    
    private func tapSyllable(_ index: Int) {
        if index == currentIndex {
            AudioManager.shared.speak(syllables[index])
            currentIndex += 1
            
            #if canImport(UIKit)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            #endif
            
            if currentIndex >= syllables.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showComplete = true
                    scoring.awardPoints(for: word, syllableCount: syllables.count, isFirstTry: true)
                }
            }
        }
    }
}
