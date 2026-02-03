import SwiftUI
#if canImport(VisionKit)
import VisionKit
#endif

struct WordInputView: View {
    var onWordSelected: (String) -> Void
    var onScanRequested: (() -> Void)?
    var onPronunciationMode: ((String) -> Void)?
    var onStoriesRequested: (() -> Void)?
    var onChallengesRequested: (() -> Void)?
    var onBack: (() -> Void)?
    @State private var customWord: String = ""
    
    let demoWords = [
        "fantastic", "butterfly", "momentum", "school", "computer", "dinosaur", "elephant",
        "Psychology", "Responsibility", "Unnecessary", "Miscellaneous", "Pronunciation",
        "Accommodation", "Conscientious", "Rhythm", "Environment", "Entrepreneur",
        "Pharmaceutical", "Architecture", "Subconscious", "Hypothesis", "Indistinguishable",
        "Parallel", "Colonel", "Hierarchy", "Questionnaire", "Approximately"
    ]
    
    @StateObject private var theme = ThemeManager.shared
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    private var isIPad: Bool { sizeClass == .regular }
    
    /// Dark enough on white field to be clearly visible in all themes
    private var placeholderColor: Color { theme.currentTheme.textPrimary.opacity(0.7) }
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.25)
            
            VStack(spacing: 0) {
                // Title on opaque card with shadow so it's always readable on any theme background
                Text("Choose a word")
                    .font(.readBetter(size: AppFontSize.title3, weight: .bold))
                    .foregroundColor(theme.currentTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppLayout.spacing16)
                    .background(
                        RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                    )
                    .padding(.horizontal, AppLayout.horizontalPadding(isIPad: isIPad))
                    .padding(.top, AppLayout.spacing16)
                    .padding(.bottom, AppLayout.spacing8)

                // Word grid - primary selection
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 260))], spacing: AppLayout.spacing16) {
                        ForEach(demoWords, id: \.self) { word in
                            Button(action: {
                                AudioManager.shared.speak(word)
                                onWordSelected(word)
                            }) {
                                HStack(spacing: 14) {
                                    Image(systemName: "book.fill")
                                        .font(.readBetter(size: 20))
                                        .foregroundColor(theme.currentTheme.primaryColor.opacity(0.9))
                                    Text(word)
                                        .font(.readBetter(size: AppFontSize.title2, weight: .semibold))
                                        .foregroundColor(theme.currentTheme.textPrimary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                        .truncationMode(.tail)
                                        .lineSpacing(2)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, AppLayout.spacing16)
                                .padding(.vertical, AppLayout.spacing16)
                                .background(
                                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                        .fill(theme.currentTheme.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                        .stroke(theme.currentTheme.textPrimary.opacity(0.08), lineWidth: 1)
                                )
                            }
                            .buttonStyle(KidButtonStyle())
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.5)
                                    .onEnded { _ in onPronunciationMode?(word) }
                            )
                            .accessibilityLabel("Word: \(word)")
                            .accessibilityHint("Double tap to read, long press for pronunciation")
                        }
                    }
                    .padding(.horizontal, AppLayout.horizontalPadding(isIPad: isIPad))
                    .padding(.bottom, AppLayout.spacing16)
                }

                // "or" on opaque pill with shadow so visible on any background
                Text("or")
                    .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
                    .foregroundColor(theme.currentTheme.textPrimary)
                    .padding(.horizontal, AppLayout.spacing24)
                    .padding(.vertical, AppLayout.spacing8)
                    .background(
                        Capsule().fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                    )
                    .overlay(
                        Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1)
                    )
                    .padding(.top, AppLayout.spacing8)

                // Type a word — opaque white field so placeholder is readable
                HStack(spacing: AppLayout.spacing16) {
                    TextField("Type a word", text: $customWord, prompt: Text("Type a word…").foregroundStyle(placeholderColor))
                        .font(.readBetter(size: AppFontSize.title3, weight: .medium))
                        .foregroundColor(theme.currentTheme.textPrimary)
                        .padding(.horizontal, AppLayout.spacing16)
                        .padding(.vertical, AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                                .stroke(customWord.isEmpty ? theme.currentTheme.textSecondary.opacity(0.4) : theme.currentTheme.primaryColor.opacity(0.5), lineWidth: 1)
                        )
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    Button(action: submitCustomWord) {
                        Image(systemName: "arrow.right")
                            .font(.readBetter(size: AppFontSize.bodyLarge, weight: .bold))
                            .foregroundColor(customWord.isEmpty ? .secondary : theme.currentTheme.primaryButtonLabelColor)
                            .frame(width: 48, height: 48)
                            .background(Circle().fill(customWord.isEmpty ? theme.currentTheme.textSecondary.opacity(0.4) : theme.currentTheme.primaryColor))
                    }
                    .disabled(customWord.isEmpty)
                    .opacity(customWord.isEmpty ? 0.6 : 1)
                    .buttonStyle(KidButtonStyle())
                }
                .padding(.horizontal, AppLayout.horizontalPadding(isIPad: isIPad))
                .padding(.top, AppLayout.spacing8)

                #if canImport(VisionKit)
                if onScanRequested != nil {
                    PrimaryButton(title: "Scan from a book", iconName: "doc.viewfinder", color: theme.currentTheme.primaryColor) {
                        onScanRequested?()
                    }
                    .padding(.horizontal, AppLayout.horizontalPadding(isIPad: isIPad))
                    .padding(.top, AppLayout.spacing16)
                }
                #endif

                PrimaryButton(title: "Practice", iconName: "mic.fill", color: theme.currentTheme.primaryColor) {
                    onChallengesRequested?()
                }
                .padding(.horizontal, AppLayout.horizontalPadding(isIPad: isIPad))
                .padding(.top, AppLayout.spacing16)
                .padding(.bottom, AppLayout.spacing24)
            }
        }
    }
    
    private func submitCustomWord() {
        guard !customWord.isEmpty else { return }
        let trimmed = customWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            customWord = ""
            return
        }
        AudioManager.shared.speak(trimmed)
        onWordSelected(trimmed)
        customWord = ""
    }
}

#Preview {
    WordInputView(
        onWordSelected: { _ in },
        onScanRequested: nil,
        onPronunciationMode: { _ in },
        onStoriesRequested: nil,
        onChallengesRequested: nil,
        onBack: nil
    )
}
