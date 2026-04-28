import Foundation

final class JY3Engine: ObservableObject {
    @Published var content: GameContent
    @Published var session = GameSession()
    @Published var activeEvent: GameEvent?
    @Published var battle: BattleState?
    @Published var message: String = "The Jianghu is quiet. Choose a place to begin."

    init() {
        self.content = Self.makeDefaultContent()
    }

    var currentNode: WorldNode {
        content.world.first(where: { $0.id == session.currentNodeId }) ?? content.world[0]
    }

    var party: [Actor] {
        session.partyIds.compactMap { id in content.actors.first(where: { $0.id == id }) }
    }

    var knownSkills: [MartialSkill] {
        session.knownSkillIds.compactMap { id in content.skills.first(where: { $0.id == id }) }
    }

    func isUnlocked(_ node: WorldNode) -> Bool {
        node.unlockedByDefault || session.flags["unlock_\(node.id)"] == true
    }

    func travel(to node: WorldNode) {
        guard isUnlocked(node) else {
            message = "This place is still hidden. Listen for rumors or finish related events."
            return
        }
        session.currentNodeId = node.id
        spendAP(1)
        message = "Arrived at \(node.name). \(node.subtitle)"
    }

    func perform(_ action: LocationAction) {
        guard session.actionPoint >= action.costAP else {
            message = "Not enough action points. Rest at an inn or wait until tomorrow."
            return
        }
        if let flag = action.requirementFlag, session.flags[flag] != true {
            message = "The condition for this action is not met yet."
            return
        }
        spendAP(action.costAP)
        switch action.kind {
        case .story, .explore, .school:
            if let eventId = action.eventId, let event = content.events.first(where: { $0.id == eventId }) {
                activeEvent = event
            } else {
                message = "Nothing special happens."
            }
        case .rest:
            rest()
        case .train:
            train()
        case .shop:
            openShop()
        case .battle:
            if let eventId = action.eventId, let event = content.events.first(where: { $0.id == eventId }) {
                activeEvent = event
            } else if let battleTemplate = content.battles.first {
                startBattle(battleTemplate.id)
            }
        case .life:
            lifeSkill()
        }
    }

    func resolve(_ choice: EventChoice) {
        activeEvent = nil
        session.money += choice.moneyDelta
        session.reputation += choice.reputationDelta
        session.morality += choice.moralityDelta
        if let flag = choice.flagToSet { session.flags[flag] = true }
        if let item = choice.rewardItemId { session.inventory[item, default: 0] += 1 }
        if let actor = choice.recruitActorId, !session.partyIds.contains(actor) { session.partyIds.append(actor) }
        if let skill = choice.learnSkillId, !session.knownSkillIds.contains(skill) { session.knownSkillIds.append(skill) }
        message = choice.result
        if let battleId = choice.battleId { startBattle(battleId) }
    }

    func startBattle(_ battleId: String) {
        guard let template = content.battles.first(where: { $0.id == battleId }) else { return }
        let enemyHP = template.enemyIds.compactMap { id in content.actors.first(where: { $0.id == id })?.hp }.reduce(0, +)
        battle = BattleState(template: template, log: ["Battle started: \(template.name)"], enemyHP: max(enemyHP, 80))
    }

    func attackInBattle() {
        guard var b = battle else { return }
        let heroPower = party.map { $0.attack }.reduce(0, +) + knownSkills.map { $0.power }.max() ?? 10
        let damage = max(12, heroPower / 2 + Int.random(in: 5...18))
        b.enemyHP -= damage
        b.log.append("Your party deals \(damage) damage.")
        if b.enemyHP <= 0 {
            session.money += b.template.rewardMoney
            session.reputation += b.template.rewardReputation
            if let flag = b.template.winFlag { session.flags[flag] = true }
            message = "Victory: +\(b.template.rewardMoney) coins, +\(b.template.rewardReputation) reputation."
            battle = nil
        } else {
            b.log.append("Enemy counterattacks. You hold formation.")
            battle = b
        }
    }

    func fleeBattle() {
        battle = nil
        message = "You retreated and lost some reputation."
        session.reputation -= 1
    }

    private func spendAP(_ amount: Int) {
        session.actionPoint = max(0, session.actionPoint - amount)
        if session.actionPoint == 0 { nextDay() }
    }

    private func nextDay() {
        session.day += 1
        session.timeSlot = "Morning"
        session.actionPoint = 6
        message = "A new day begins. Rumors spread through the Jianghu."
    }

    private func rest() {
        session.actionPoint = 6
        session.day += 1
        message = "You rested for a night. Action points restored."
    }

    private func train() {
        let skill = session.knownSkillIds.first ?? "basic_fist"
        session.skillExp[skill, default: 0] += 15
        session.schoolContribution += session.schoolId == nil ? 0 : 2
        message = "Training complete. \(skill) gains experience."
    }

    private func openShop() {
        guard let shop = content.shops.first(where: { $0.nodeId == session.currentNodeId }) else {
            message = "No shop is open here."
            return
        }
        let first = shop.itemIds.first ?? "dry_food"
        if let item = content.items.first(where: { $0.id == first }), session.money >= item.price {
            session.money -= item.price
            session.inventory[item.id, default: 0] += 1
            message = "Bought \(item.name) from \(shop.name)."
        } else {
            message = "You cannot afford the goods here."
        }
    }

    private func lifeSkill() {
        let roll = Int.random(in: 1...3)
        if roll == 1 {
            session.inventory["herb", default: 0] += 1
            message = "You gathered a useful herb."
        } else if roll == 2 {
            session.money += 12
            message = "You earned 12 coins from a side activity."
        } else {
            session.flags["unlock_forest"] = true
            message = "You heard a rumor about a hidden forest path."
        }
    }
}
