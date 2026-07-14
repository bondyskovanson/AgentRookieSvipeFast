import UIKit

struct GameLevel {
    let index: Int
    let name: String
    let tagline: String
    let budget: Int
    let duration: Double
    let targetOVR: Int
    let startingOVRRange: ClosedRange<Int>
    let rookieOVRRange: ClosedRange<Int>
    let veteranChance: Double
    let accent: UIColor
    let accentDark: UIColor

    var displayNumber: Int { index + 1 }
}

enum LevelCatalog {
    static let levels: [GameLevel] = [
        GameLevel(
            index: 0,
            name: "Sunday League",
            tagline: "Scout the local talent and learn the ropes.",
            budget: 65,
            duration: 80,
            targetOVR: 67,
            startingOVRRange: 58...64,
            rookieOVRRange: 60...86,
            veteranChance: 0.5,
            accent: UIColor(red: 0.36, green: 0.78, blue: 0.52, alpha: 1.0),
            accentDark: UIColor(red: 0.10, green: 0.34, blue: 0.24, alpha: 1.0)
        ),
        GameLevel(
            index: 1,
            name: "League Two",
            tagline: "Tighter clock, smarter deals.",
            budget: 70,
            duration: 74,
            targetOVR: 70,
            startingOVRRange: 60...66,
            rookieOVRRange: 62...88,
            veteranChance: 0.5,
            accent: UIColor(red: 0.27, green: 0.78, blue: 0.74, alpha: 1.0),
            accentDark: UIColor(red: 0.06, green: 0.30, blue: 0.30, alpha: 1.0)
        ),
        GameLevel(
            index: 2,
            name: "Championship",
            tagline: "Real money, real pressure.",
            budget: 78,
            duration: 68,
            targetOVR: 73,
            startingOVRRange: 63...69,
            rookieOVRRange: 64...90,
            veteranChance: 0.5,
            accent: UIColor(red: 0.32, green: 0.62, blue: 0.97, alpha: 1.0),
            accentDark: UIColor(red: 0.08, green: 0.20, blue: 0.42, alpha: 1.0)
        ),
        GameLevel(
            index: 3,
            name: "Premier League",
            tagline: "Elite squads, brutal deadlines.",
            budget: 90,
            duration: 62,
            targetOVR: 76,
            startingOVRRange: 66...72,
            rookieOVRRange: 66...93,
            veteranChance: 0.5,
            accent: UIColor(red: 0.65, green: 0.45, blue: 0.98, alpha: 1.0),
            accentDark: UIColor(red: 0.24, green: 0.14, blue: 0.44, alpha: 1.0)
        ),
        GameLevel(
            index: 4,
            name: "Champions Elite",
            tagline: "Only the sharpest agents survive.",
            budget: 105,
            duration: 58,
            targetOVR: 79,
            startingOVRRange: 68...74,
            rookieOVRRange: 68...95,
            veteranChance: 0.5,
            accent: UIColor(red: 0.97, green: 0.80, blue: 0.30, alpha: 1.0),
            accentDark: UIColor(red: 0.42, green: 0.30, blue: 0.05, alpha: 1.0)
        )
    ]

    static var count: Int { levels.count }

    static func level(at index: Int) -> GameLevel {
        let clamped = max(0, min(levels.count - 1, index))
        return levels[clamped]
    }
}

struct CareerStats: Codable {
    var gamesPlayed: Int = 0
    var totalSignings: Int = 0
    var totalSales: Int = 0
    var totalSpent: Int = 0
    var totalEarned: Int = 0
    var bestSquadOVR: Int = 0
    var bestScore: Int = 0
    var highestLevelCompleted: Int = -1
    var levelBestScores: [Int: Int] = [:]

    var unlockedLevelCount: Int {
        min(LevelCatalog.count, highestLevelCompleted + 2)
    }

    func isUnlocked(_ levelIndex: Int) -> Bool {
        levelIndex <= highestLevelCompleted + 1
    }

    func isCompleted(_ levelIndex: Int) -> Bool {
        levelIndex <= highestLevelCompleted
    }
}
