import SwiftUI

@MainActor
final class AvatarManager: ObservableObject {
    static let shared = AvatarManager()
    
    @Published var currentEmotion: AvatarEmotion = .neutral
    @Published var isAnimating = false
    @Published var message: String = ""
    
    enum AvatarEmotion {
        case neutral
        case happy
        case encouraging
        case celebrating
        case thinking
        
        var iconName: String {
            switch self {
            case .neutral: return "face.smiling"
            case .happy: return "face.smiling.fill"
            case .encouraging: return "hand.thumbsup.fill"
            case .celebrating: return "star.fill"
            case .thinking: return "lightbulb.fill"
            }
        }
    }
    
    func showEncouragement(_ message: String) {
        self.message = message
        currentEmotion = .encouraging
        isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isAnimating = false
            self.currentEmotion = .neutral
        }
    }
    
    func celebrate(_ message: String) {
        self.message = message
        currentEmotion = .celebrating
        isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isAnimating = false
            self.currentEmotion = .neutral
        }
    }
    
    func think(_ message: String) {
        self.message = message
        currentEmotion = .thinking
        isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isAnimating = false
            self.currentEmotion = .neutral
        }
    }
}

struct ReadingBuddyView: View {
    @ObservedObject var avatar = AvatarManager.shared
    @ObservedObject var theme = ThemeManager.shared

    var body: some View {
        VStack(spacing: AppLayout.spacing8) {
            Image(systemName: avatar.currentEmotion.iconName)
                .font(.readBetter(size: 44))
                .foregroundStyle(theme.currentTheme.primaryColor)
                .scaleEffect(avatar.isAnimating ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6).repeatCount(3, autoreverses: true), value: avatar.isAnimating)

            if !avatar.message.isEmpty {
                Text(avatar.message)
                    .font(.readBetter(size: AppFontSize.body, weight: .medium))
                    .foregroundColor(theme.currentTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, AppLayout.spacing8)
                    .background(theme.currentTheme.primaryColor.opacity(0.15), in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusButton))
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding()
    }
}
