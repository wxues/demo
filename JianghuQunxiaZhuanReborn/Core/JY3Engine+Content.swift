import Foundation

extension JY3Engine {
    static func makeDefaultContent() -> GameContent {
        GameContent(
            world: [
                WorldNode(id: "niu_village", name: "Niu Village", subtitle: "A quiet village where the journey begins.", region: "Central Plains", x: 0.22, y: 0.66, icon: "house.fill", unlockedByDefault: true, actions: [
                    LocationAction(id: "village_story", title: "Ask about rumors", kind: .story, eventId: "village_elder", costAP: 1, requirementFlag: nil),
                    LocationAction(id: "village_train", title: "Practice basic skills", kind: .train, eventId: nil, costAP: 1, requirementFlag: nil),
                    LocationAction(id: "village_shop", title: "Buy supplies", kind: .shop, eventId: nil, costAP: 1, requirementFlag: nil),
                    LocationAction(id: "village_rest", title: "Rest at inn", kind: .rest, eventId: nil, costAP: 0, requirementFlag: nil)
                ]),
                WorldNode(id: "shaolin", name: "Shaolin", subtitle: "A strict temple known for orthodox martial arts.", region: "Song Mountain", x: 0.52, y: 0.34, icon: "building.columns.fill", unlockedByDefault: true, actions: [
                    LocationAction(id: "shaolin_gate", title: "Visit the temple gate", kind: .school, eventId: "shaolin_gate", costAP: 1, requirementFlag: nil),
                    LocationAction(id: "shaolin_train", title: "Train body method", kind: .train, eventId: nil, costAP: 1, requirementFlag: nil)
                ]),
                WorldNode(id: "forest", name: "Hidden Forest", subtitle: "A misty path where strange encounters appear.", region: "Wilds", x: 0.76, y: 0.58, icon: "leaf.fill", unlockedByDefault: false, actions: [
                    LocationAction(id: "forest_explore", title: "Explore the forest", kind: .explore, eventId: "forest_rescue", costAP: 1, requirementFlag: nil),
                    LocationAction(id: "forest_life", title: "Gather herbs", kind: .life, eventId: nil, costAP: 1, requirementFlag: nil)
                ]),
                WorldNode(id: "black_tavern", name: "Black Tavern", subtitle: "A noisy tavern full of deals and danger.", region: "Border", x: 0.64, y: 0.78, icon: "wineglass.fill", unlockedByDefault: true, actions: [
                    LocationAction(id: "tavern_talk", title: "Talk to strangers", kind: .story, eventId: "tavern_stranger", costAP: 1, requirementFlag: nil),
                    LocationAction(id: "tavern_fight", title: "Challenge troublemakers", kind: .battle, eventId: "tavern_brawl", costAP: 1, requirementFlag: nil)
                ])
            ],
            actors: [
                Actor(id: "hero", name: "Young Wanderer", role: "Protagonist", portrait: "person.crop.circle", level: 1, hp: 120, mp: 45, attack: 28, defense: 18, speed: 22, affinity: 0, tags: ["hero"]),
                Actor(id: "a_qing", name: "A Qing", role: "Companion", portrait: "figure.archery", level: 1, hp: 95, mp: 55, attack: 24, defense: 14, speed: 30, affinity: 40, tags: ["companion", "agile"]),
                Actor(id: "bandit", name: "Bandit", role: "Enemy", portrait: "person.fill.questionmark", level: 1, hp: 80, mp: 10, attack: 20, defense: 10, speed: 16, affinity: 0, tags: ["enemy"]),
                Actor(id: "tavern_boss", name: "Tavern Boss", role: "Enemy", portrait: "flame.fill", level: 2, hp: 130, mp: 20, attack: 30, defense: 18, speed: 18, affinity: 0, tags: ["enemy"])
            ],
            skills: [
                MartialSkill(id: "basic_fist", name: "Basic Fist", school: nil, category: "Fist", power: 24, mpCost: 0, maxLevel: 10, effect: "Reliable close-range attack.", learnRequirement: nil),
                MartialSkill(id: "shaolin_palm", name: "Shaolin Palm", school: "shaolin", category: "Palm", power: 42, mpCost: 8, maxLevel: 10, effect: "Strong orthodox palm strike.", learnRequirement: "join_shaolin"),
                MartialSkill(id: "swift_steps", name: "Swift Steps", school: nil, category: "Lightness", power: 12, mpCost: 5, maxLevel: 10, effect: "Improves speed and dodge.", learnRequirement: nil)
            ],
            items: [
                GameItem(id: "dry_food", name: "Dry Food", kind: "Consumable", price: 8, description: "Simple travel ration.", effect: "restore_ap_small"),
                GameItem(id: "small_medicine", name: "Small Medicine", kind: "Consumable", price: 15, description: "Restores wounds after combat.", effect: "heal"),
                GameItem(id: "herb", name: "Wild Herb", kind: "Material", price: 5, description: "Used in medicine crafting.", effect: nil),
                GameItem(id: "iron_sword", name: "Iron Sword", kind: "Weapon", price: 80, description: "A basic sword for new wanderers.", effect: "attack_up")
            ],
            events: [
                GameEvent(id: "village_elder", title: "Village Rumor", speaker: "Village Elder", text: "The roads are no longer safe. Some say a hidden forest path leads to rare herbs and secret encounters.", choices: [
                    EventChoice(id: "listen", text: "Listen carefully", result: "You learned about the hidden forest path.", moneyDelta: 0, reputationDelta: 1, moralityDelta: 0, flagToSet: "unlock_forest", battleId: nil, rewardItemId: nil, recruitActorId: nil, learnSkillId: nil),
                    EventChoice(id: "help", text: "Offer help to the village", result: "The elder gives you medicine for the road.", moneyDelta: 0, reputationDelta: 2, moralityDelta: 1, flagToSet: "helped_village", battleId: nil, rewardItemId: "small_medicine", recruitActorId: nil, learnSkillId: nil)
                ]),
                GameEvent(id: "shaolin_gate", title: "Temple Gate", speaker: "Gate Monk", text: "The temple accepts sincere hearts, not reckless blades. Will you follow discipline?", choices: [
                    EventChoice(id: "join", text: "Request entry", result: "You are accepted as an outer disciple and learn Shaolin Palm.", moneyDelta: 0, reputationDelta: 3, moralityDelta: 2, flagToSet: "join_shaolin", battleId: nil, rewardItemId: nil, recruitActorId: nil, learnSkillId: "shaolin_palm"),
                    EventChoice(id: "leave", text: "Leave politely", result: "The monk nods. You may return later.", moneyDelta: 0, reputationDelta: 0, moralityDelta: 0, flagToSet: nil, battleId: nil, rewardItemId: nil, recruitActorId: nil, learnSkillId: nil)
                ]),
                GameEvent(id: "forest_rescue", title: "Forest Rescue", speaker: "A Qing", text: "A young fighter is surrounded by bandits. She asks for your help.", choices: [
                    EventChoice(id: "rescue", text: "Fight the bandits", result: "You step forward and draw attention from the bandits.", moneyDelta: 0, reputationDelta: 1, moralityDelta: 1, flagToSet: nil, battleId: "forest_bandits", rewardItemId: nil, recruitActorId: nil, learnSkillId: nil),
                    EventChoice(id: "avoid", text: "Avoid trouble", result: "You leave silently. The Jianghu remembers hesitation.", moneyDelta: 0, reputationDelta: -1, moralityDelta: -1, flagToSet: nil, battleId: nil, rewardItemId: nil, recruitActorId: nil, learnSkillId: nil)
                ]),
                GameEvent(id: "tavern_stranger", title: "Stranger in Tavern", speaker: "Masked Stranger", text: "Coins, rumors, and fists are all currencies here.", choices: [
                    EventChoice(id: "buy_rumor", text: "Buy a rumor", result: "The stranger reveals a forest route.", moneyDelta: -20, reputationDelta: 0, moralityDelta: 0, flagToSet: "unlock_forest", battleId: nil, rewardItemId: nil, recruitActorId: nil, learnSkillId: nil),
                    EventChoice(id: "walk_away", text: "Walk away", result: "You keep your coins and your doubts.", moneyDelta: 0, reputationDelta: 0, moralityDelta: 0, flagToSet: nil, battleId: nil, rewardItemId: nil, recruitActorId: nil, learnSkillId: nil)
                ]),
                GameEvent(id: "tavern_brawl", title: "Tavern Brawl", speaker: "Troublemaker", text: "Someone throws a cup at your table. The room goes silent.", choices: [
                    EventChoice(id: "fight", text: "Fight", result: "The brawl begins.", moneyDelta: 0, reputationDelta: 0, moralityDelta: 0, flagToSet: nil, battleId: "tavern_brawl", rewardItemId: nil, recruitActorId: nil, learnSkillId: nil)
                ])
            ],
            schools: [
                School(id: "shaolin", name: "Shaolin", alignment: "Orthodox", master: "Gate Monk", entryFlag: "join_shaolin", skills: ["shaolin_palm"], description: "Discipline, body training, and orthodox palm arts.")
            ],
            shops: [
                Shop(id: "village_shop", name: "Village Grocery", nodeId: "niu_village", itemIds: ["dry_food", "small_medicine", "iron_sword"])
            ],
            battles: [
                BattleTemplate(id: "forest_bandits", name: "Forest Bandits", enemyIds: ["bandit", "bandit"], winFlag: "saved_a_qing", rewardMoney: 35, rewardReputation: 3),
                BattleTemplate(id: "tavern_brawl", name: "Tavern Brawl", enemyIds: ["tavern_boss"], winFlag: "won_tavern_brawl", rewardMoney: 25, rewardReputation: 2)
            ]
        )
    }
}
