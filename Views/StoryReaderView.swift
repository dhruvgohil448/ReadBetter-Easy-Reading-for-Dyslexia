import SwiftUI

struct StoryReaderView: View {
    let story: Story
    var onBack: () -> Void
    var onWordSelected: (String) -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @State private var completedSentences: Set<String> = []
    @State private var selectedWord: String?
    @State private var showWordHelp = false
    @State private var currentReadingSentence = 0
    @State private var isReading = false
    @State private var readingTask: DispatchWorkItem?
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: AppLayout.spacing16) {
                HStack {
                    Spacer()

                    Button(action: {
                        if isReading { stopReading() } else { startReading() }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: isReading ? "stop.circle.fill" : "speaker.wave.2.fill")
                                .font(.readBetter(size: 18))
                            Text(isReading ? "Stop" : "Read Aloud")
                        }
                        .font(.readBetter(size: 17, weight: .semibold))
                        .foregroundColor(isReading ? .white : theme.currentTheme.primaryButtonLabelColor)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isReading ? theme.currentTheme.errorColor : theme.currentTheme.primaryColor)
                        )
                    }
                    .buttonStyle(KidButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Title on card for visibility on all themes
                Text(story.title)
                    .font(.readBetter(size: 36, weight: .bold))
                    .foregroundColor(theme.currentTheme.textPrimary)
                    .kerning(1.5)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppLayout.spacing16)
                    .padding(.horizontal, AppLayout.spacing16)
                    .background(
                        RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                            .fill(theme.currentTheme.cardBackground)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(Array(story.sentences.enumerated()), id: \.element.id) { index, sentence in
                            VStack(spacing: 15) {
                                // Animation placeholder
                                if let animName = story.animations[String(index)] {
                                    AnimationPlaceholder(
                                        name: animName,
                                        isActive: completedSentences.contains(sentence.id)
                                    )
                                }
                                
                                // Sentence with tappable words
                                TappableSentenceView(
                                    sentence: sentence,
                                    isCurrentReading: currentReadingSentence == index,
                                    onWordTapped: { word in
                                        selectedWord = word
                                        showWordHelp = true
                                        AudioManager.shared.speak(word)
                                    }
                                )
                                .padding(20)
                                .background(theme.currentTheme.cardBackground)
                                .cornerRadius(18)
                                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(currentReadingSentence == index ? theme.currentTheme.successColor : Color.clear, lineWidth: currentReadingSentence == index ? 2 : 0)
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // Word Help Overlay
            if showWordHelp, let word = selectedWord {
                WordHelpOverlay(
                    word: word,
                    onDismiss: { showWordHelp = false },
                    onPractice: {
                        showWordHelp = false
                        onWordSelected(word)
                    }
                )
            }
        }
    }
    
    func startReading() {
        isReading = true
        readNextSentence(index: 0)
    }
    
    func stopReading() {
        isReading = false
        currentReadingSentence = 0
        
        // Cancel any pending reading tasks
        readingTask?.cancel()
        readingTask = nil
        
        AudioManager.shared.stopSpeaking()
    }
    
    private func readNextSentence(index: Int) {
        guard isReading && index < story.sentences.count else {
            isReading = false
            currentReadingSentence = 0
            return
        }
        
        currentReadingSentence = index
        let sentence = story.sentences[index]
        
        // Mark sentence as completed
        completedSentences.insert(sentence.id)
        
        // Estimate duration: roughly 0.15 seconds per character, minimum 2 seconds
        // This accounts for pauses and natural speech rhythm
        let estimatedDuration = max(2.0, Double(sentence.text.count) * 0.15)
        
        AudioManager.shared.speak(sentence.text)
        
        // Create a task that can be cancelled
        let task = DispatchWorkItem {
            if self.isReading {
                self.readNextSentence(index: index + 1)
            }
        }
        readingTask = task
        
        // Wait for sentence to finish before reading next
        DispatchQueue.main.asyncAfter(deadline: .now() + estimatedDuration, execute: task)
    }
}

struct TappableSentenceView: View {
    let sentence: Sentence
    let isCurrentReading: Bool
    let onWordTapped: (String) -> Void
    
    @StateObject private var theme = ThemeManager.shared
    
    private var words: [String] {
        sentence.text.split(separator: " ").map(String.init)
    }
    
    var body: some View {
        FlowLayout(spacing: 10) {
            ForEach(Array(words.enumerated()), id: \.offset) { _, word in
                storyWordView(word: word)
            }
        }
    }
    
    @ViewBuilder
    private func storyWordView(word: String) -> some View {
        let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
        let isTappable = sentence.tappableWords.contains(cleanWord.lowercased())
        
        let fontWeight: Font.Weight = isTappable ? .semibold : .regular
        let kerning: CGFloat = isTappable ? 1.5 : 1.0
        let textColor = isTappable ? theme.currentTheme.primaryColor : theme.currentTheme.textPrimary
        let hPad: CGFloat = isTappable ? 10 : 4
        let vPad: CGFloat = isTappable ? 6 : 2
        let bgColor = isTappable ? theme.currentTheme.primaryColor.opacity(0.15) : Color.clear
        let strokeColor = isTappable ? theme.currentTheme.primaryColor.opacity(0.3) : Color.clear
        let strokeWidth: CGFloat = isTappable ? 1.5 : 0
        
        wordLabel(word: word, isTappable: isTappable,
                  fontWeight: fontWeight, kerning: kerning, textColor: textColor,
                  hPad: hPad, vPad: vPad, bgColor: bgColor,
                  strokeColor: strokeColor, strokeWidth: strokeWidth)
        .onTapGesture {
            if isTappable {
                #if canImport(UIKit)
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                #endif
                onWordTapped(cleanWord)
            }
        }
        .accessibilityLabel(isTappable ? "Tappable word: \(cleanWord)" : word)
        .accessibilityHint(isTappable ? "Double tap to hear pronunciation and get help" : "")
        .accessibilityAddTraits(isTappable ? .isButton : [])
    }
    
    private func wordLabel(
        word: String, isTappable: Bool,
        fontWeight: Font.Weight, kerning: CGFloat, textColor: Color,
        hPad: CGFloat, vPad: CGFloat, bgColor: Color,
        strokeColor: Color, strokeWidth: CGFloat
    ) -> some View {
        Text(word)
            .font(.readBetter(size: 24, weight: fontWeight))
            .kerning(kerning)
            .foregroundColor(textColor)
            .padding(.horizontal, hPad)
            .padding(.vertical, vPad)
            .background(bgColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                                    .stroke(theme.currentTheme.successColor, lineWidth: 2)
                                    .opacity(isCurrentReading ? 1 : 0)
            )
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

struct AnimationPlaceholder: View {
    let name: String
    let isActive: Bool
    
    @StateObject private var theme = ThemeManager.shared
    @State private var animationPhase = 0.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(theme.currentTheme.primaryColor.opacity(0.2))
                .frame(height: 160)
                .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
            
            VStack {
                if name.contains("rabbit") {
                    Image(systemName: "hare.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .offset(y: isActive ? sin(animationPhase) * 10 : 0)
                } else if name.contains("turtle") {
                    Image(systemName: "tortoise.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .offset(x: isActive ? sin(animationPhase) * 12 : 0)
                } else if name.contains("star") {
                    Image(systemName: "star.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isActive ? sin(animationPhase) * 12 : 0))
                } else if name.contains("cloud") {
                    Image(systemName: "cloud.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .offset(y: isActive ? sin(animationPhase) * 8 : 0)
                } else if name.contains("rain") {
                    Image(systemName: "cloud.rain.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .opacity(isActive ? 0.65 + sin(animationPhase) * 0.35 : 1.0)
                } else if name.contains("flowers") || name.contains("flower") {
                    Image(systemName: "camera.macro")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .scaleEffect(isActive ? 1.0 + sin(animationPhase) * 0.08 : 1.0)
                } else if name.contains("bird") {
                    Image(systemName: "bird.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .offset(x: isActive ? sin(animationPhase) * 18 : 0)
                } else if name.contains("girl") || name.contains("boy") {
                    Image(systemName: "person.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .offset(y: isActive ? sin(animationPhase) * 6 : 0)
                } else if name.contains("race") {
                    Image(systemName: "flag.checkered")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isActive ? sin(animationPhase) * 6 : 0))
                } else if name.contains("pond") {
                    Image(systemName: "drop.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .opacity(isActive ? 0.5 + sin(animationPhase) * 0.5 : 1.0)
                } else if name.contains("tree") {
                    Image(systemName: "leaf.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isActive ? sin(animationPhase) * 5 : 0))
                } else if name.contains("butterfly") {
                    Image(systemName: "leaf.circle.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .offset(x: isActive ? sin(animationPhase) * 20 : 0)
                } else if name.contains("rose") {
                    Image(systemName: "leaf.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .scaleEffect(isActive ? 1.0 + sin(animationPhase) * 0.1 : 1.0)
                } else {
                    Image(systemName: "sun.max.fill")
                        .font(.readBetter(size: 48))
                        .foregroundStyle(.secondary)
                        .opacity(isActive ? 0.7 + sin(animationPhase) * 0.3 : 1.0)
                }
            }
        }
        .onAppear {
            if isActive {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    animationPhase = .pi * 2
                }
            }
        }
    }
}

struct WordHelpOverlay: View {
    let word: String
    let onDismiss: () -> Void
    let onPractice: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @State private var syllables: [String] = []
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 25) {
                HStack {
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.readBetter(size: 32))
                            .foregroundColor(theme.currentTheme.textSecondary)
                    }
                }
                
                Image(systemName: "book.fill")
                    .font(.readBetter(size: 56))
                    .symbolEffect(.bounce, value: syllables.count)
                
                Text(word)
                    .font(.readBetter(size: 52, weight: .bold))
                    .kerning(2.5)
                    .foregroundColor(theme.currentTheme.textPrimary)
                    .padding(.horizontal)
                
                // Syllables
                HStack(spacing: 10) {
                    ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                        Text(syllable)
                            .font(.readBetter(size: 26, weight: .semibold))
                            .kerning(1.5)
                            .foregroundColor(theme.currentTheme.textPrimary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(theme.currentTheme.syllableColors[index % theme.currentTheme.syllableColors.count].opacity(0.4))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(theme.currentTheme.primaryColor.opacity(0.3), lineWidth: 1.5)
                            )
                            .onTapGesture {
                                AudioManager.shared.speak(syllable)
                                #if canImport(UIKit)
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                #endif
                            }
                    }
                }
                .padding(.horizontal)
                
                Text("Tap syllables to hear them")
                    .font(.readBetter(size: 15))
                    .foregroundColor(theme.currentTheme.textSecondary)
                
                // Buttons
                HStack(spacing: 15) {
                    Button(action: {
                        AudioManager.shared.speak(word)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "speaker.wave.2.fill")
                            Text("Hear Word")
                        }
                        .font(.readBetter(size: 17, weight: .semibold))
                        .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(theme.currentTheme.primaryColor)
                        .cornerRadius(14)
                        .shadow(color: theme.currentTheme.primaryColor.opacity(0.3), radius: 4, y: 2)
                    }
                    
                    Button(action: onPractice) {
                        HStack(spacing: 8) {
                            Image(systemName: "mic.fill")
                            Text("Practice")
                        }
                        .font(.readBetter(size: 17, weight: .semibold))
                        .foregroundColor(theme.currentTheme.secondaryButtonLabelColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(theme.currentTheme.secondaryColor)
                        .cornerRadius(14)
                        .shadow(color: theme.currentTheme.secondaryColor.opacity(0.3), radius: 4, y: 2)
                    }
                }
            }
            .padding(30)
            .background(theme.currentTheme.cardBackground)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
            .padding(40)
        }
        .onAppear {
            syllables = SyllableEngine.getSyllables(for: word)
            // Pronounce word when overlay appears
            AudioManager.shared.speak(word)
        }
    }
}

struct StoryLibraryView: View {
    var onStorySelected: (Story) -> Void
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: AppLayout.spacing16) {
                Text("Story library")
                    .font(.readBetter(size: 36, weight: .bold))
                    .foregroundColor(theme.currentTheme.textPrimary)
                    .kerning(1.5)
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(StoryLibrary.stories) { story in
                            Button(action: {
                                // Pronounce story title when selected
                                AudioManager.shared.speak(story.title)
                                onStorySelected(story)
                            }) {
                                HStack(spacing: 15) {
                                    // Story icon
                                    ZStack {
                                        Circle()
                                            .fill(theme.currentTheme.primaryColor)
                                            .frame(width: 48, height: 48)
                                        Image(systemName: "book.fill")
                                            .font(.readBetter(size: 22))
                                            .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(story.title)
                                            .font(.readBetter(size: 24, weight: .bold))
                                            .foregroundColor(theme.currentTheme.textPrimary)
                                            .kerning(1.0)
                                        
                                        HStack(spacing: 8) {
                                            Image(systemName: "text.bubble.fill")
                                                .font(.readBetter(size: 14))
                                            Text("\(story.sentences.count) sentences")
                                                .font(.readBetter(size: 16))
                                        }
                                        .foregroundColor(theme.currentTheme.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.readBetter(size: 16, weight: .semibold))
                                        .foregroundColor(theme.currentTheme.primaryColor)
                                }
                                .padding(20)
                                .background(theme.currentTheme.cardBackground)
                                .cornerRadius(18)
                                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(theme.currentTheme.primaryColor.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .buttonStyle(KidButtonStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                }
            }
        }
    }
}
