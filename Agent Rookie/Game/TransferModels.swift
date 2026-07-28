import Foundation

enum CardKind {
    case rookie
    case veteran
}

enum SwipeDirection {
    case left
    case right
}

struct SquadPlayer {
    let id: UUID
    let name: String
    let position: String
    let age: Int
    let ovr: Int

    init(name: String, position: String, age: Int, ovr: Int) {
        self.id = UUID()
        self.name = name
        self.position = position
        self.age = age
        self.ovr = ovr
    }
}

struct TransferCard {
    let id: UUID
    let name: String
    let position: String
    let age: Int
    let ovr: Int
    let price: Int
    let kind: CardKind
    let squadPlayerID: UUID?

    init(name: String, position: String, age: Int, ovr: Int, price: Int, kind: CardKind, squadPlayerID: UUID? = nil) {
        self.id = UUID()
        self.name = name
        self.position = position
        self.age = age
        self.ovr = ovr
        self.price = price
        self.kind = kind
        self.squadPlayerID = squadPlayerID
    }
}

struct GameResult {
    let score: Int
    let squadOVR: Int
    let squadSize: Int
    let budgetLeft: Int
    let signings: Int
    let sales: Int
    let spent: Int
    let earned: Int
    let levelIndex: Int
    let levelName: String
    let targetOVR: Int
    let passed: Bool
}

struct HighScoreEntry: Codable {
    let score: Int
    let squadOVR: Int
    let squadSize: Int
    let date: Date
    let levelIndex: Int?
}

enum PlayerFactory {
    private static let firstNames = [
        "Leo", "Marcus", "Diego", "Kai", "Luca", "Andre", "Bruno", "Theo",
        "Felix", "Ivan", "Mateo", "Noah", "Ravi", "Omar", "Sven", "Yuto",
        "Pablo", "Hugo", "Milan", "Nico", "Sergio", "Tariq", "Emre", "Jonas"
    ]

    private static let lastNames = [
        "Vega", "Costa", "Bauer", "Moreau", "Rossi", "Novak", "Haaland", "Silva",
        "Okafor", "Tanaka", "Larsson", "Mendez", "Petrov", "Diallo", "Werner", "Kane",
        "Fernandes", "Lukic", "Mbeki", "Soto", "Adeyemi", "Park", "Romero", "Eriksen"
    ]

    private static let positions = ["GK", "DEF", "MID", "FWD"]

    static func randomName() -> String {
        let first = firstNames.randomElement() ?? "Leo"
        let last = lastNames.randomElement() ?? "Vega"
        return "\(first) \(last)"
    }

    static func randomPosition() -> String {
        positions.randomElement() ?? "MID"
    }

    static func startingSquad(for level: GameLevel) -> [SquadPlayer] {
        var squad: [SquadPlayer] = []
        for _ in 0..<11 {
            let ovr = Int.random(in: level.startingOVRRange)
            let age = Int.random(in: 27...34)
            squad.append(SquadPlayer(name: randomName(), position: randomPosition(), age: age, ovr: ovr))
        }
        return squad
    }

    static func rookieCard(for level: GameLevel) -> TransferCard {
        let ovr = Int.random(in: level.rookieOVRRange)
        let age = Int.random(in: 17...23)
        let basePrice = Double(max(1, ovr - 45))
        let price = max(1, Int(basePrice * Double.random(in: 0.7...1.4)))
        return TransferCard(
            name: randomName(),
            position: randomPosition(),
            age: age,
            ovr: ovr,
            price: price,
            kind: .rookie
        )
    }

    static func veteranCard(from player: SquadPlayer) -> TransferCard {
        let basePrice = Double(max(1, player.ovr - 40))
        let price = max(1, Int(basePrice * Double.random(in: 0.5...1.1)))
        return TransferCard(
            name: player.name,
            position: player.position,
            age: player.age,
            ovr: player.ovr,
            price: price,
            kind: .veteran,
            squadPlayerID: player.id
        )
    }
}
