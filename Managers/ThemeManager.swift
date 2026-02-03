import SwiftUI

enum AppTheme: String, CaseIterable, Codable {
    case ocean = "Ocean Blue"
    case forest = "Forest Green"
    case sunset = "Sunset Orange"
    
    var primaryColor: Color {
        switch self {
        case .ocean:
            return Color(red: 0.25, green: 0.5, blue: 0.9)
        case .forest:
            return Color(red: 0.2, green: 0.65, blue: 0.45)
        case .sunset:
            return Color(red: 0.95, green: 0.55, blue: 0.25)
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .ocean:
            return Color(red: 0.45, green: 0.7, blue: 0.95)
        case .forest:
            return Color(red: 0.45, green: 0.75, blue: 0.55)
        case .sunset:
            return Color(red: 1.0, green: 0.65, blue: 0.35)
        }
    }
    
    var accentColor: Color {
        switch self {
        case .ocean:
            return Color(red: 0.15, green: 0.35, blue: 0.75)
        case .forest:
            return Color(red: 0.15, green: 0.55, blue: 0.35)
        case .sunset:
            return Color(red: 0.85, green: 0.45, blue: 0.2)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .ocean:
            return Color(red: 0.88, green: 0.95, blue: 1.0)
        case .forest:
            return Color(red: 0.88, green: 0.94, blue: 0.9)
        case .sunset:
            return Color(red: 0.98, green: 0.9, blue: 0.85)
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .ocean:
            return [
                Color(red: 0.55, green: 0.82, blue: 0.98),
                Color(red: 0.72, green: 0.9, blue: 1.0),
                Color(red: 0.88, green: 0.96, blue: 1.0),
                Color(red: 0.92, green: 0.97, blue: 1.0)
            ]
        case .forest:
            return [
                Color(red: 0.55, green: 0.78, blue: 0.62),
                Color(red: 0.72, green: 0.88, blue: 0.78),
                Color(red: 0.85, green: 0.94, blue: 0.88),
                Color(red: 0.92, green: 0.98, blue: 0.94)
            ]
        case .sunset:
            return [
                Color(red: 0.45, green: 0.38, blue: 0.58),
                Color(red: 0.85, green: 0.55, blue: 0.6),
                Color(red: 1.0, green: 0.75, blue: 0.55),
                Color(red: 1.0, green: 0.9, blue: 0.75),
                Color(red: 1.0, green: 0.96, blue: 0.88)
            ]
        }
    }
    
    var cardBackground: Color {
        .white
    }
    
    var textPrimary: Color {
        Color(red: 0.15, green: 0.18, blue: 0.35)
    }
    
    var textSecondary: Color {
        Color(red: 0.4, green: 0.42, blue: 0.55)
    }

    /// Placeholder text on card (white) background. Darker than textSecondary for WCAG contrast.
    var placeholderOnCardColor: Color {
        Color(red: 0.35, green: 0.37, blue: 0.5)
    }
    
    var syllableColors: [Color] {
        switch self {
        case .ocean:
            return [
                Color(red: 0.8, green: 0.9, blue: 1.0),   // Light Blue
                Color(red: 0.9, green: 0.95, blue: 1.0),  // Lighter Blue
                Color(red: 0.85, green: 0.92, blue: 0.98), // Sky Blue
                Color(red: 0.88, green: 0.94, blue: 1.0),  // Pale Blue
                Color(red: 0.82, green: 0.91, blue: 0.99)  // Soft Blue
            ]
        case .forest:
            return [
                Color(red: 0.85, green: 0.95, blue: 0.88), // Light Green
                Color(red: 0.9, green: 0.97, blue: 0.92),  // Mint
                Color(red: 0.88, green: 0.96, blue: 0.9),  // Pale Green
                Color(red: 0.86, green: 0.94, blue: 0.89), // Soft Green
                Color(red: 0.9, green: 0.98, blue: 0.93)   // Light Mint
            ]
        case .sunset:
            return [
                Color(red: 1.0, green: 0.93, blue: 0.85),  // Peach
                Color(red: 1.0, green: 0.95, blue: 0.88),  // Light Peach
                Color(red: 0.98, green: 0.92, blue: 0.84), // Soft Orange
                Color(red: 1.0, green: 0.94, blue: 0.86),  // Pale Orange
                Color(red: 0.99, green: 0.96, blue: 0.9)   // Cream
            ]
        }
    }
    
    /// SF Symbol name for theme (clean, minimal; Phosphor-style naming)
    var iconName: String {
        switch self {
        case .ocean: return "drop.fill"
        case .forest: return "leaf.fill"
        case .sunset: return "sun.max.fill"
        }
    }

    var emoji: String {
        switch self {
        case .ocean: return "🌊"
        case .forest: return "🌲"
        case .sunset: return "🌅"
        }
    }

    var description: String {
        switch self {
        case .ocean:
            return "Calm like the sea"
        case .forest:
            return "Cozy like a forest"
        case .sunset:
            return "Warm like sunset"
        }
    }
    
    /// SF Symbol for loader / empty states
    var loaderIconName: String {
        switch self {
        case .ocean: return "drop.fill"
        case .forest: return "leaf.fill"
        case .sunset: return "sun.max.fill"
        }
    }

    /// Semantic success color (reading highlights, correct answers)
    var successColor: Color {
        switch self {
        case .ocean: return Color(red: 0.2, green: 0.65, blue: 0.5)
        case .forest: return Color(red: 0.25, green: 0.7, blue: 0.45)
        case .sunset: return Color(red: 0.35, green: 0.7, blue: 0.4)
        }
    }

    /// Semantic error/warning (stop, incorrect)
    var errorColor: Color {
        switch self {
        case .ocean: return Color(red: 0.85, green: 0.35, blue: 0.35)
        case .forest: return Color(red: 0.8, green: 0.35, blue: 0.3)
        case .sunset: return Color(red: 0.9, green: 0.4, blue: 0.3)
        }
    }

    /// Semantic accent for help, highlight (not purple)
    var accentHighlightColor: Color {
        secondaryColor
    }

    /// Dark label color for use on light tinted backgrounds (ensures WCAG contrast in all themes).
    private static let buttonLabelDark = Color(red: 0.1, green: 0.12, blue: 0.18)

    /// Label color for buttons that use primaryColor as background. Ensures readable contrast in all themes.
    var primaryButtonLabelColor: Color {
        switch self {
        case .ocean:
            return .white
        case .forest, .sunset:
            return Self.buttonLabelDark
        }
    }

    /// Label color for buttons that use secondaryColor as background.
    var secondaryButtonLabelColor: Color {
        switch self {
        case .ocean:
            return .white
        case .forest, .sunset:
            return Self.buttonLabelDark
        }
    }

    /// Label color for buttons that use accentColor as background.
    var accentButtonLabelColor: Color {
        switch self {
        case .ocean, .forest, .sunset:
            return .white
        }
    }
}

@MainActor
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    static let calmModeKey = "calmMode"

    @Published var currentTheme: AppTheme {
        didSet {
            saveTheme()
        }
    }

    /// Calm Mode: reduces ambient animations, particles, motion for accessibility
    @Published var calmMode: Bool {
        didSet {
            UserDefaults.standard.set(calmMode, forKey: Self.calmModeKey)
        }
    }

    private let themeKey = "selectedTheme"

    init() {
        if let savedTheme = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: savedTheme) {
            currentTheme = theme
        } else {
            currentTheme = .ocean
        }
        calmMode = UserDefaults.standard.bool(forKey: Self.calmModeKey)
    }

    private func saveTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey)
    }
}
