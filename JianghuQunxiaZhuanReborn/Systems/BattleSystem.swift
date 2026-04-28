import Foundation

enum BattleSystem {
    static func makeBattle(template: BattleTemplate, actors: [Actor]) -> BattleState {
        let enemyHP = template.enemyIds
            .compactMap { id in actors.first(where: { $0.id == id })?.hp }
            .reduce(0, +)
        return BattleState(template: template, log: ["Battle started: \(template.name)"], enemyHP: max(enemyHP, 80))
    }

    static func playerDamage(party: [Actor], skills: [MartialSkill]) -> Int {
        let attack = party.map { $0.attack }.reduce(0, +)
        let skillPower = skills.map { $0.power }.max() ?? 10
        return max(12, (attack + skillPower) / 2 + Int.random(in: 5...18))
    }
}
