import SwiftUI

// MARK: - App layout (8pt grid). Named AppLayout to avoid shadowing SwiftUI.Layout protocol.
enum AppLayout {
    /// Allowed spacing: 8, 16, 24, 32, 40, 48
    static let spacing8: CGFloat = 8
    static let spacing16: CGFloat = 16
    static let spacing24: CGFloat = 24
    static let spacing32: CGFloat = 32
    static let spacing40: CGFloat = 40
    static let spacing48: CGFloat = 48

    /// Horizontal padding: iPhone 20, iPad 24
    static func horizontalPadding(isIPad: Bool) -> CGFloat {
        isIPad ? 24 : 20
    }

    /// Corner radii
    static let cornerRadiusButton: CGFloat = 12
    static let cornerRadiusCard: CGFloat = 16
    static let cornerRadiusModal: CGFloat = 20
}

// MARK: - Typography (13, 15, 17, 22, 28, 34)
enum AppFontSize {
    static let caption: CGFloat = 13
    static let body: CGFloat = 15
    static let bodyLarge: CGFloat = 17
    static let title3: CGFloat = 22
    static let title2: CGFloat = 28
    static let title1: CGFloat = 34
}

// MARK: - BackButton (single consistent component)
struct BackButton: View {
    let label: String
    let action: () -> Void
    @Environment(\.horizontalSizeClass) private var sizeClass
    @ObservedObject private var theme = ThemeManager.shared

    init(label: String = "Back", action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppLayout.spacing8) {
                Image(systemName: "chevron.left")
                    .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
                Text(label)
                    .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
            }
            .foregroundColor(theme.currentTheme.textPrimary)
        }
        .buttonStyle(KidButtonStyle())
    }
}

// MARK: - PrimaryButton (standardized). Uses theme primaryButtonLabelColor when labelColor is nil for contrast (e.g. forest theme).
struct PrimaryButton: View {
    let title: String
    let iconName: String?
    let color: Color
    var labelColor: Color?
    let action: () -> Void

    @ObservedObject private var theme = ThemeManager.shared

    init(title: String, iconName: String? = nil, color: Color, labelColor: Color? = nil, action: @escaping () -> Void) {
        self.title = title
        self.iconName = iconName
        self.color = color
        self.labelColor = labelColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppLayout.spacing8) {
                if let icon = iconName {
                    Image(systemName: icon)
                        .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
                }
                Text(title)
                    .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
            }
            .foregroundColor(labelColor ?? theme.currentTheme.primaryButtonLabelColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppLayout.spacing16)
            .background(RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton).fill(color))
        }
        .buttonStyle(KidButtonStyle())
    }
}

// MARK: - Card (standardized)
struct Card<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppLayout.spacing16)
            .background(
                RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                    .fill(Color(.secondarySystemBackground))
            )
    }
}
