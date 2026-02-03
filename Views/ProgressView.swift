import SwiftUI

struct ProgressView: View {
    @StateObject private var scoring = ScoringManager.shared
    @StateObject private var theme = ThemeManager.shared
    var onBack: () -> Void
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme.currentTheme)
            ThemeAmbientView(theme: theme.currentTheme, isInteractive: false)
                .opacity(0.5)
            
            VStack(spacing: AppLayout.spacing16) {
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Total Points - Celebratory gradient card
                        VStack(spacing: 12) {
                            Text("Total Stars")
                                .font(.readBetter(size: 22, weight: .semibold))
                                .foregroundColor(theme.currentTheme.primaryButtonLabelColor.opacity(0.95))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "star.fill")
                                    .font(.readBetter(size: 44))
                                    .symbolEffect(.bounce, value: scoring.totalPoints)
                                Text("\(scoring.totalPoints)")
                                    .font(.readBetter(size: 60, weight: .bold))
                                    .foregroundColor(theme.currentTheme.primaryButtonLabelColor)
                                    .contentTransition(.numericText(value: Double(scoring.totalPoints)))
                            }
                        }
                        .padding(28)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            theme.currentTheme.accentColor,
                                            theme.currentTheme.primaryColor,
                                            theme.currentTheme.secondaryColor
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: theme.currentTheme.primaryColor.opacity(0.4), radius: 16, y: 8)
                        )
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                                .scaleEffect(phase.isIdentity ? 1 : 0.95)
                        }
                        
                        // Streaks - Colorful side-by-side cards
                        HStack(spacing: 16) {
                            VStack(spacing: 10) {
                                Image(systemName: "flame.fill")
                                    .font(.readBetter(size: 44))
                                    .foregroundStyle(theme.currentTheme.primaryColor)
                                Text("Session")
                                    .font(.readBetter(size: 15, weight: .semibold))
                                    .foregroundColor(theme.currentTheme.accentButtonLabelColor.opacity(0.95))
                                Text("\(scoring.sessionStreak)")
                                    .font(.readBetter(size: 36, weight: .bold))
                                    .foregroundColor(theme.currentTheme.accentButtonLabelColor)
                            }
                            .padding(22)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                theme.currentTheme.accentColor,
                                                theme.currentTheme.primaryColor
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: theme.currentTheme.primaryColor.opacity(0.2), radius: 8, y: 4)
                            )
                            
                            VStack(spacing: 10) {
                                Image(systemName: "calendar")
                                    .font(.readBetter(size: 44))
                                    .foregroundStyle(theme.currentTheme.primaryColor)
                                Text("Daily")
                                    .font(.readBetter(size: 15, weight: .semibold))
                                    .foregroundColor(theme.currentTheme.secondaryButtonLabelColor.opacity(0.95))
                                Text("\(scoring.dailyStreak)")
                                    .font(.readBetter(size: 36, weight: .bold))
                                    .foregroundColor(theme.currentTheme.secondaryButtonLabelColor)
                            }
                            .padding(22)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                theme.currentTheme.secondaryColor,
                                                theme.currentTheme.primaryColor
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: theme.currentTheme.secondaryColor.opacity(0.3), radius: 10, y: 5)
                            )
                        }
                        
                        // Badges - Colorful grid with theme accents
                        VStack(alignment: .leading, spacing: 18) {
                            Text("Badges Earned")
                                .font(.readBetter(size: 26, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                            
                            if scoring.badges.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "target")
                                        .font(.readBetter(size: 48))
                                        .foregroundStyle(theme.currentTheme.textSecondary)
                                        .opacity(0.6)
                                    Text("Keep practicing to earn badges!")
                                        .font(.readBetter(size: 17))
                                        .foregroundColor(theme.currentTheme.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(32)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(theme.currentTheme.primaryColor.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(theme.currentTheme.primaryColor.opacity(0.2), lineWidth: 2)
                                        )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                                        .foregroundColor(theme.currentTheme.primaryColor.opacity(0.15))
                                )
                            } else {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                                    ForEach(Array(scoring.badges.enumerated()), id: \.element.id) { index, badge in
                                        VStack(spacing: 10) {
                                            ZStack {
                                                Circle()
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [
                                                                theme.currentTheme.syllableColors[index % theme.currentTheme.syllableColors.count],
                                                                theme.currentTheme.syllableColors[index % theme.currentTheme.syllableColors.count].opacity(0.7)
                                                            ],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .frame(width: 64, height: 64)
                                                
                                                Image(systemName: badge.icon)
                                                    .font(.readBetter(size: 28, weight: .semibold))
                                                    .foregroundStyle(theme.currentTheme.textPrimary)
                                            }
                                            
                                            Text(badge.name)
                                                .font(.readBetter(size: 13, weight: .semibold))
                                                .foregroundColor(theme.currentTheme.textPrimary)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(2)
                                        }
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 18)
                                                .fill(theme.currentTheme.cardBackground)
                                                .shadow(color: theme.currentTheme.syllableColors[index % theme.currentTheme.syllableColors.count].opacity(0.2), radius: 8, y: 4)
                                        )
                                    }
                                }
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(theme.currentTheme.cardBackground)
                                .shadow(color: Color.black.opacity(0.08), radius: 12, y: 6)
                        )
                        
                        // Stats - Clean, organized with theme colors
                        VStack(alignment: .leading, spacing: 18) {
                            Text("Statistics")
                                .font(.readBetter(size: 26, weight: .bold))
                                .foregroundColor(theme.currentTheme.textPrimary)
                            
                            StatRow(icon: "book.fill", label: "Words Practiced", value: "\(scoring.totalPoints / 10)", color: theme.currentTheme.primaryColor)
                            StatRow(icon: "checkmark.circle.fill", label: "Success Rate", value: "85%", color: theme.currentTheme.successColor)
                            StatRow(icon: "flame.fill", label: "Longest Streak", value: "\(max(scoring.sessionStreak, scoring.dailyStreak))", color: theme.currentTheme.accentColor)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(theme.currentTheme.cardBackground)
                                .shadow(color: Color.black.opacity(0.08), radius: 12, y: 6)
                        )
                    }
                    .padding()
                }
            }
        }
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    var color: Color = ThemeManager.shared.currentTheme.primaryColor
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.readBetter(size: 22, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            Text(label)
                .font(.readBetter(size: 17, weight: .medium))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
            
            Spacer()
            
            Text(value)
                .font(.readBetter(size: 20, weight: .bold))
                .foregroundStyle(color)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
    }
}

#Preview {
    ProgressView(onBack: {})
}
