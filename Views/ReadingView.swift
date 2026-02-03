import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ReadingView: View {
    let word: String
    var onBack: () -> Void
    
    @StateObject private var theme = ThemeManager.shared
    @State private var syllables: [String] = []
    @State private var isSplit: Bool = false
    @State private var tappedSyllables: Set<Int> = []
    @State private var showSuccess: Bool = false
    
    // Dyslexia-friendly settings
    let letterSpacing: CGFloat = 3.0
    let lineSpacing: CGFloat = 8.0
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack {
                Spacer()
                
                // Main Word Display
                VStack(spacing: 40) {
                    if !isSplit {
                        // Whole Word View
                        VStack(spacing: 20) {
                            Text(word)
                                .font(.readBetter(size: 64, weight: .bold))
                                .kerning(letterSpacing) // Increased letter spacing
                                .foregroundColor(theme.currentTheme.textPrimary)
                                .lineSpacing(lineSpacing)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(theme.currentTheme.cardBackground)
                                        .shadow(color: Color.black.opacity(0.1), radius: 12, y: 6)
                                )
                                .onTapGesture {
                                    // Pronounce the word first, then split
                                    AudioManager.shared.speak(word)
                                    
                                    // Split after a short delay to let pronunciation start
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        splitWord()
                                    }
                                }
                                .accessibilityLabel("Word: \(word)")
                                .accessibilityHint("Double tap to hear pronunciation and break into syllables")
                            
                            VStack(spacing: 8) {
                                Text("Tap to hear pronunciation")
                                    .font(.readBetter(size: 18, weight: .medium))
                                    .foregroundColor(theme.currentTheme.textSecondary)
                                Text("Word will split into syllables")
                                    .font(.readBetter(size: 14, weight: .regular))
                                    .foregroundColor(theme.currentTheme.textSecondary)
                                    .opacity(0.9)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppLayout.spacing16)
                            .padding(.horizontal, AppLayout.spacing16)
                            .background(
                                RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                    .fill(theme.currentTheme.cardBackground)
                            )
                            .padding(.horizontal, 20)
                        }
                    } else {
                        // Syllables View
                        VStack(spacing: 25) {
                            HStack(spacing: 16) {
                                ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                                    VStack(spacing: 8) {
                                        Text(syllable)
                                            .font(.readBetter(size: 56, weight: .bold))
                                            .kerning(letterSpacing)
                                            .foregroundColor(theme.currentTheme.textPrimary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 18)
                                                        .fill(theme.currentTheme.syllableColors[index % theme.currentTheme.syllableColors.count])
                                                        .opacity(tappedSyllables.contains(index) ? 0.7 : 0.5)
                                                    
                                                    RoundedRectangle(cornerRadius: 18)
                                                        .fill(.ultraThinMaterial)
                                                        .opacity(0.5)
                                                    
                                                    RoundedRectangle(cornerRadius: 18)
                                                        .strokeBorder(
                                                            tappedSyllables.contains(index) 
                                                            ? theme.currentTheme.successColor
                                                            : theme.currentTheme.cardBackground.opacity(0.6),
                                                            lineWidth: tappedSyllables.contains(index) ? 4 : 1.5
                                                        )
                                                }
                                            )
                                            .scaleEffect(tappedSyllables.contains(index) ? 1.15 : 1.0)
                                            .shadow(color: tappedSyllables.contains(index) ? theme.currentTheme.successColor.opacity(0.3) : Color.black.opacity(0.08), radius: tappedSyllables.contains(index) ? 8 : 4, y: tappedSyllables.contains(index) ? 4 : 2)
                                            .onTapGesture {
                                                playSyllable(syllable, index: index)
                                            }
                                            .accessibilityElement(children: .ignore)
                                            .accessibilityLabel("Syllable \(syllable)")
                                            .accessibilityHint("Double tap to hear pronunciation")
                                            .accessibilityAddTraits(.isButton)
                                        
                                        // Syllable number indicator
                                        if !tappedSyllables.contains(index) {
                                            Text("\(index + 1)")
                                                .font(.readBetter(size: 14, weight: .semibold))
                                                .foregroundColor(theme.currentTheme.textSecondary)
                                                .opacity(0.6)
                                        } else {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.readBetter(size: 20))
                                                .foregroundColor(theme.currentTheme.successColor)
                                        }
                                    }
                                }
                            }
                            .transition(.scale.combined(with: .opacity))
                            
                            Text("Tap each part to hear it")
                                .font(.readBetter(size: 18, weight: .medium))
                                .foregroundColor(theme.currentTheme.textSecondary)
                                .opacity(0.8)
                            
                            // Progress indicator
                            if !syllables.isEmpty {
                                HStack(spacing: 8) {
                                    ForEach(0..<syllables.count, id: \.self) { index in
                                        Circle()
                                            .fill(tappedSyllables.contains(index) ? theme.currentTheme.successColor : theme.currentTheme.textSecondary.opacity(0.3))
                                            .frame(width: 12, height: 12)
                                            .scaleEffect(tappedSyllables.contains(index) ? 1.2 : 1.0)
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Success Message
                if showSuccess {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.readBetter(size: 48))
                            .foregroundStyle(theme.currentTheme.successColor)

                        Text("You did it!")
                            .font(.readBetter(size: AppFontSize.title1, weight: .bold))
                            .foregroundColor(theme.currentTheme.textPrimary)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        
                        Text("Great job reading \(word)!")
                            .font(.readBetter(size: 20, weight: .medium))
                            .foregroundColor(theme.currentTheme.textSecondary)
                        
                        HStack(spacing: 15) {
                            Button(action: {
                                // Reset for same word
                                withAnimation {
                                    isSplit = false
                                    tappedSyllables.removeAll()
                                    showSuccess = false
                                }
                            }) {
                                Text("Read Again")
                                    .font(.readBetter(size: 18, weight: .semibold))
                                    .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(theme.currentTheme.primaryColor)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: onBack) {
                                Text("New Word")
                                    .font(.readBetter(size: 18, weight: .semibold))
                                    .foregroundColor(theme.currentTheme.primaryColor)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(theme.currentTheme.primaryColor.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.1), radius: 20, y: 10)
                    .padding(.bottom, 50)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            // Pre-calculate syllables but don't show yet
            syllables = SyllableEngine.getSyllables(for: word)
        }
    }
    
    func splitWord() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            isSplit = true
        }
        // Optional: Haptic feedback here
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
    
    func playSyllable(_ syllable: String, index: Int) {
        // Pronounce the syllable
        AudioManager.shared.speak(syllable)
        
        // Haptic feedback
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
        
        _ = withAnimation(.spring()) {
            tappedSyllables.insert(index)
        }
        
        // Check for success
        if tappedSyllables.count == syllables.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showSuccess = true
                }
                // Success sound or haptic
                #if canImport(UIKit)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                #endif
            }
        }
    }
}

#Preview {
    ReadingView(
        word: "fantastic",
        onBack: {}
    )
}
