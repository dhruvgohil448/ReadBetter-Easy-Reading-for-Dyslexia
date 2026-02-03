import SwiftUI

/// Sheet wrapper for theme picker: system detents, drag indicator, swipe-to-dismiss.
struct ThemePickerSheetView: View {
    var onDismiss: () -> Void

    var body: some View {
        ThemePickerView(onDismiss: onDismiss)
            .presentationDetents([.fraction(0.5), .large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(AppLayout.cornerRadiusModal)
    }
}

struct ThemePickerView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    var onDismiss: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppLayout.spacing16) {
                Text("Theme")
                    .font(.readBetter(size: AppFontSize.title3, weight: .bold))
                    .foregroundColor(.primary)

                Text("Pick a theme")
                    .font(.readBetter(size: AppFontSize.body))
                    .foregroundColor(.secondary)

                VStack(spacing: AppLayout.spacing8) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        ThemeCard(
                            theme: theme,
                            isSelected: themeManager.currentTheme == theme,
                            onSelect: { themeManager.currentTheme = theme }
                        )
                    }
                }

                Toggle(isOn: Binding(
                    get: { themeManager.calmMode },
                    set: { themeManager.calmMode = $0 }
                )) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calm mode")
                            .font(.readBetter(size: AppFontSize.body, weight: .medium))
                        Text("Reduce motion and animations")
                            .font(.readBetter(size: AppFontSize.caption))
                            .foregroundColor(.secondary)
                    }
                }
                .tint(themeManager.currentTheme.primaryColor)
                .accessibilityHint("Reduces background animations")

                Button(action: onDismiss) {
                    Text("Done")
                        .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
                        .foregroundColor(themeManager.currentTheme.primaryButtonLabelColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppLayout.spacing16)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton)
                                .fill(themeManager.currentTheme.primaryColor)
                        )
                }
                .buttonStyle(KidButtonStyle())
            }
            .padding(AppLayout.spacing16)
            .padding(.bottom, AppLayout.spacing24)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(Color(.systemBackground))
    }
}

struct ThemeCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: AppLayout.spacing16) {
                Image(systemName: theme.iconName)
                    .font(.readBetter(size: AppFontSize.bodyLarge, weight: .medium))
                    .foregroundStyle(theme.primaryColor)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton)
                            .fill(theme.primaryColor.opacity(0.2))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.rawValue)
                        .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(theme.description)
                        .font(.readBetter(size: AppFontSize.caption))
                        .foregroundColor(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.readBetter(size: 20))
                        .foregroundStyle(theme.primaryColor)
                }
            }
            .padding(AppLayout.spacing16)
            .background(
                RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                            .strokeBorder(isSelected ? theme.primaryColor : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(KidButtonStyle())
    }
}
