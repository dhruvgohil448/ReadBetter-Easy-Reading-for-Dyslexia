import SwiftUI

struct WelcomeView: View {
    var onStart: () -> Void
    var onStories: () -> Void
    var onProgress: () -> Void
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    @StateObject private var avatar = AvatarManager.shared
    @StateObject private var scoring = ScoringManager.shared
    @StateObject private var theme = ThemeManager.shared
    @State private var showThemePicker = false
    @State private var titleVisible: Bool = false
    @State private var taglineVisible: Bool = false
    @AppStorage(ReadBetterFont.useDylexciaKey) private var useDylexciaFont = true

    private var isIPad: Bool { sizeClass == .regular }
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: true)
                .opacity(0.5)
            
            VStack(spacing: 0) {
                // Top bar: Dyslexia toggle (left) + Theme picker (right). Use theme textPrimary so labels are always visible on system background.
                HStack {
                    Button(action: {
                        useDylexciaFont.toggle()
                    }) {
                        HStack(spacing: AppLayout.spacing8) {
                            Image(systemName: useDylexciaFont ? "textformat" : "textformat.abc")
                                .font(.readBetter(size: AppFontSize.body, weight: .semibold))
                            Text("Dyslexia font")
                                .font(.readBetter(size: AppFontSize.body, weight: .semibold))
                            Text(useDylexciaFont ? "On" : "Off")
                                .font(.readBetter(size: AppFontSize.caption, weight: .medium))
                                .opacity(0.9)
                        }
                        .foregroundStyle(theme.currentTheme.textPrimary)
                        .padding(.horizontal, AppLayout.spacing16)
                        .padding(.vertical, AppLayout.spacing8)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton))
                    }
                    .buttonStyle(KidButtonStyle())
                    .accessibilityLabel(useDylexciaFont ? "Dyslexia-friendly font on" : "Dyslexia-friendly font off")
                    .accessibilityHint("Tap to turn dyslexia-friendly font on or off for the whole app")

                    Spacer()

                    Button(action: { showThemePicker = true }) {
                        Image(systemName: theme.currentTheme.iconName)
                            .font(.readBetter(size: AppFontSize.bodyLarge, weight: .medium))
                            .foregroundStyle(theme.currentTheme.textPrimary)
                            .padding(AppLayout.spacing8)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton))
                    }
                    .buttonStyle(KidButtonStyle())
                }
                .padding(.horizontal, AppLayout.horizontalPadding(isIPad: isIPad))
                .padding(.top, AppLayout.spacing16)
                
                // Center-top text. Use theme colors so title and tagline are always readable on the overlay.
                VStack(spacing: AppLayout.spacing16) {
                    Text("ReadBetter")
                        .font(.readBetter(size: isIPad ? 34 : 28, weight: .bold))
                        .foregroundStyle(theme.currentTheme.textPrimary)
                        .opacity(titleVisible ? 1 : 0)
                        .scaleEffect(titleVisible ? 1.0 : 0.98)
                        .accessibilityAddTraits(.isHeader)

                    Text("Words can be tricky…")
                        .font(.readBetter(size: AppFontSize.title3, weight: .semibold))
                        .foregroundStyle(theme.currentTheme.textPrimary)
                        .multilineTextAlignment(.center)
                        .opacity(taglineVisible ? 1 : 0)

                    Text("but we'll make them friendly")
                        .font(.readBetter(size: AppFontSize.bodyLarge, weight: .medium))
                        .foregroundStyle(theme.currentTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(AppLayout.spacing8)
                        .opacity(taglineVisible ? 1 : 0)
                }
                .padding(AppLayout.spacing24)
                .background(Color(.secondarySystemBackground).opacity(0.92), in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard))
                .padding(.horizontal, AppLayout.horizontalPadding(isIPad: isIPad))
                .padding(.top, AppLayout.spacing16)
                .padding(.bottom, AppLayout.spacing16)
                
                Spacer()
                
                // Primary action buttons
                VStack(spacing: AppLayout.spacing8) {
                    KidPrimaryButton(
                        title: "Word practice",
                        subtitle: "Practice words and earn stars",
                        iconName: "mic.fill",
                        color: theme.currentTheme.primaryColor,
                        labelColor: theme.currentTheme.primaryButtonLabelColor,
                        action: onStart
                    )
                    KidPrimaryButton(
                        title: "Story reader",
                        subtitle: "Read fun stories aloud",
                        iconName: "book.fill",
                        color: theme.currentTheme.secondaryColor,
                        labelColor: theme.currentTheme.secondaryButtonLabelColor,
                        action: onStories
                    )
                    KidPrimaryButton(
                        title: "My progress",
                        subtitle: "\(scoring.totalPoints) stars · \(scoring.dailyStreak) day streak",
                        iconName: "star.fill",
                        color: theme.currentTheme.accentColor,
                        labelColor: theme.currentTheme.accentButtonLabelColor,
                        action: onProgress
                    )
                }
                .padding(.horizontal, AppLayout.horizontalPadding(isIPad: isIPad))
                .padding(.bottom, AppLayout.spacing24)
            }
            .sheet(isPresented: $showThemePicker) {
                ThemePickerSheetView(onDismiss: { showThemePicker = false })
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                titleVisible = true
            }
            withAnimation(.easeOut(duration: 0.7).delay(0.25)) {
                taglineVisible = true
            }
        }
    }
}

#Preview {
    WelcomeView(
        onStart: {},
        onStories: {},
        onProgress: {}
    )
}
