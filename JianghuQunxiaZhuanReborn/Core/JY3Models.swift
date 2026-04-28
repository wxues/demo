import Foundation

struct GameContent: Codable {
    var world: [WorldNode]
    var actors: [Actor]
    var skills: [MartialSkill]
    var items: [GameItem]
    var events: [GameEvent]
    var schools: [School]
    var shops: [Shop]
    var battles: [BattleTemplate]
}

struct GameSession: Codable {
    var day: Int = 1
    var timeSlot: String = "Morning"
    var money: Int = 120
    var reputation: Int = 0
    var morality: Int = 0
    var actionPoint: Int = 6
    var currentNodeId: String = "niu_village"
    var partyIds: [String] = ["hero"]
    var inventory: [String: Int] = ["dry_food": 3, "small_medicine": 2]
    var flags: [String: Bool] = [:]
    var questIds: [String] = []
    var schoolId: String? = nil
    var schoolContribution: Int = 0
    var knownSkillIds: [String] = ["basic_fist"]
    var skillExp: [String: Int] = ["basic_fist": 20]
}

struct WorldNode: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var subtitle: String
    var region: String
    var x: Double
    var y: Double
    var icon: String
    var unlockedByDefault: Bool
    var actions: [LocationAction]
}

struct LocationAction: Codable, Identifiable, Hashable {
    var id: String
    var title: String
    var kind: ActionKind
    var eventId: String?
    var costAP: Int
    var requirementFlag: String?
}

enum ActionKind: String, Codable {
    case story, explore, rest, train, shop, battle, school, life
}

struct Actor: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var role: String
    var portrait: String
    var level: Int
    var hp: Int
    var mp: Int
    var attack: Int
    var defense: Int
    var speed: Int
    var affinity: Int
    var tags: [String]
}

struct MartialSkill: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var school: String?
    var category: String
    var power: Int
    var mpCost: Int
    var maxLevel: Int
    var effect: String
    var learnRequirement: String?
}

struct GameItem: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var kind: String
    var price: Int
    var description: String
    var effect: String?
}

struct GameEvent: Codable, Identifiable, Hashable {
    var id: String
    var title: String
    var speaker: String
    var text: String
    var choices: [EventChoice]
}

struct EventChoice: Codable, Identifiable, Hashable {
    var id: String
    var text: String
    var result: String
    var moneyDelta: Int
    var reputationDelta: Int
    var moralityDelta: Int
    var flagToSet: String?
    var battleId: String?
    var rewardItemId: String?
    var recruitActorId: String?
    var learnSkillId: String?
}

struct School: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var alignment: String
    var master: String
    var entryFlag: String?
    var skills: [String]
    var description: String
}

struct Shop: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var nodeId: String
    var itemIds: [String]
}

struct BattleTemplate: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var enemyIds: [String]
    var winFlag: String?
    var rewardMoney: Int
    var rewardReputation: Int
}

struct BattleState: Identifiable, Hashable {
    let id = UUID()
    var template: BattleTemplate
    var log: [String]
    var enemyHP: Int
}
