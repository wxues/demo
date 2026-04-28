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
