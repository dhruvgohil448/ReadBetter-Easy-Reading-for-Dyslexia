import Foundation
import SwiftUI

@MainActor
final class ScoringManager: ObservableObject {
    static let shared = ScoringManager()
    
    @Published var totalPoints: Int = 0
    @Published var sessionStreak: Int = 0
    @Published var dailyStreak: Int = 0
    @Published var badges: [Badge] = []
    
    private let defaults = UserDefaults.standard
    private let pointsKey = "totalPoints"
    private let dailyStreakKey = "dailyStreak"
    private let lastEarnedDateKey = "lastEarnedDate"
    private let badgesKey = "badges"
    
    init() {
        loadProgress()
    }
    
    func loadProgress() {
        totalPoints = defaults.integer(forKey: pointsKey)
        dailyStreak = defaults.integer(forKey: dailyStreakKey)
        
        if let badgesData = defaults.data(forKey: badgesKey),
           let decodedBadges = try? JSONDecoder().decode([Badge].self, from: badgesData) {
            badges = decodedBadges
        }
        
        updateDailyStreak()
    }
    
    func saveProgress() {
        defaults.set(totalPoints, forKey: pointsKey)
        defaults.set(dailyStreak, forKey: dailyStreakKey)
        
        if let encoded = try? JSONEncoder().encode(badges) {
            defaults.set(encoded, forKey: badgesKey)
        }
    }
    
    func calculatePoints(syllableCount: Int, isFirstTry: Bool) -> Int {
        let basePoints: Int
        switch syllableCount {
        case 1...2:
            basePoints = 10
        case 3:
            basePoints = 15
        default:
            basePoints = 20
        }
        
        let firstTryBonus = isFirstTry ? 5 : 0
        let streakMultiplier = 1.0 + min(Double(sessionStreak) * 0.05, 1.0)
        
        return Int(Double(basePoints + firstTryBonus) * streakMultiplier)
    }
    
    func awardPoints(for word: String, syllableCount: Int, isFirstTry: Bool) {
        let points = calculatePoints(syllableCount: syllableCount, isFirstTry: isFirstTry)
        totalPoints += points
        sessionStreak += 1
        
        // Check for badges
        checkBadges()
        
        // Update daily streak
        updateDailyStreak()
        
        saveProgress()
    }
    
    func resetSessionStreak() {
        sessionStreak = 0
    }
    
    private func updateDailyStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = defaults.object(forKey: lastEarnedDateKey) as? Date {
            let lastDay = calendar.startOfDay(for: lastDate)
            let daysDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if daysDiff == 0 {
                // Same day, no change
                return
            } else if daysDiff == 1 {
                // Consecutive day
                dailyStreak += 1
            } else {
                // Streak broken
                dailyStreak = 1
            }
        } else {
            // First time
            dailyStreak = 1
        }
        
        defaults.set(today, forKey: lastEarnedDateKey)
    }
    
    private func checkBadges() {
        // First word badge
        if totalPoints >= 10 && !badges.contains(where: { $0.id == "first_word" }) {
            badges.append(Badge(id: "first_word", name: "First Word", icon: "star.fill"))
        }
        
        // Streak badges
        if sessionStreak >= 5 && !badges.contains(where: { $0.id == "streak_5" }) {
            badges.append(Badge(id: "streak_5", name: "5 in a Row", icon: "flame.fill"))
        }
        
        if sessionStreak >= 10 && !badges.contains(where: { $0.id == "streak_10" }) {
            badges.append(Badge(id: "streak_10", name: "10 Streak", icon: "flame.fill"))
        }
        
        // Points milestones
        if totalPoints >= 100 && !badges.contains(where: { $0.id == "points_100" }) {
            badges.append(Badge(id: "points_100", name: "100 Points", icon: "trophy.fill"))
        }
        
        if totalPoints >= 500 && !badges.contains(where: { $0.id == "points_500" }) {
            badges.append(Badge(id: "points_500", name: "500 Points", icon: "trophy.fill"))
        }
    }
}

struct Badge: Codable, Identifiable {
    let id: String
    let name: String
    let icon: String
}
