import SwiftUI

struct GameRootView: View {
    @EnvironmentObject private var engine: JY3Engine
    @State private var selectedTab: RootTab = .map

    var body: some View {
        ZStack {
            JianghuBackground()
            VStack(spacing: 12) {
                TopStatusBar()
                mainContent
                BottomNavBar(selectedTab: $selectedTab)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            if let event = engine.activeEvent {
                EventOverlay(event: event)
            }

            if let battle = engine.battle {
                BattleOverlay(battle: battle)
            }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var mainContent: some View {
        switch selectedTab {
        case .map:
            MapSceneView()
        case .hero:
            HeroPanel()
        case .skills:
            SkillPanel()
        case .party:
            PartyPanel()
        case .bag:
            InventoryPanel()
        case .schools:
            SchoolPanel()
        }
    }
}

enum RootTab: String, CaseIterable, Identifiable {
    case map = "Map"
    case hero = "Hero"
    case skills = "Skills"
    case party = "Party"
    case bag = "Bag"
    case schools = "Schools"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .map: return "map.fill"
        case .hero: return "person.fill"
        case .skills: return "sparkles"
        case .party: return "person.3.fill"
        case .bag: return "bag.fill"
        case .schools: return "building.columns.fill"
        }
    }
}

struct JianghuBackground: View {
    var body: some View {
        LinearGradient(colors: [Color(red: 0.08, green: 0.06, blue: 0.045), Color(red: 0.19, green: 0.12, blue: 0.07), Color(red: 0.05, green: 0.04, blue: 0.035)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .overlay(
                RadialGradient(colors: [Color.orange.opacity(0.22), Color.clear], center: .topTrailing, startRadius: 20, endRadius: 420)
                    .ignoresSafeArea()
            )
    }
}

struct JianghuPanel<Content: View>: View {
    var title: String?
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.orange)
            }
            content
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.28))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.orange.opacity(0.35), lineWidth: 1))
        )
    }
}

struct TopStatusBar: View {
    @EnvironmentObject private var engine: JY3Engine

    var body: some View {
        JianghuPanel(title: nil) {
            HStack(spacing: 10) {
                StatBadge(icon: "sun.max.fill", text: "Day \(engine.session.day)")
                StatBadge(icon: "bolt.fill", text: "AP \(engine.session.actionPoint)")
                StatBadge(icon: "creditcard.fill", text: "\(engine.session.money)")
                StatBadge(icon: "star.fill", text: "Rep \(engine.session.reputation)")
                Spacer(minLength: 0)
            }
            Text(engine.message)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.72))
                .lineLimit(2)
        }
    }
}

struct StatBadge: View {
    var icon: String
    var text: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.white.opacity(0.08)))
    }
}

struct MapSceneView: View {
    @EnvironmentObject private var engine: JY3Engine

    var body: some View {
        VStack(spacing: 12) {
            GeometryReader { proxy in
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(LinearGradient(colors: [Color(red: 0.12, green: 0.17, blue: 0.13), Color(red: 0.28, green: 0.21, blue: 0.12)], startPoint: .top, endPoint: .bottom))
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.orange.opacity(0.35), lineWidth: 1.2))

                    ForEach(engine.content.world) { node in
                        NodeButton(node: node)
                            .position(x: proxy.size.width * node.x, y: proxy.size.height * node.y)
                    }

                    VStack {
                        HStack {
                            Text("江湖图")
                                .font(.title2.weight(.black))
                                .foregroundStyle(.orange)
                            Spacer()
                            Text(engine.currentNode.region)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white.opacity(0.72))
                        }
                        Spacer()
                    }
                    .padding(18)
                }
            }
            .frame(minHeight: 280)

            JianghuPanel(title: engine.currentNode.name) {
                Text(engine.currentNode.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.72))
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(engine.currentNode.actions) { action in
                        Button {
                            engine.perform(action)
                        } label: {
                            HStack {
                                Image(systemName: icon(for: action.kind))
                                Text(action.title)
                                Spacer()
                                Text("AP\(action.costAP)")
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.55))
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.orange.opacity(0.16)))
                        }
                    }
                }
            }
        }
    }

    private func icon(for kind: ActionKind) -> String {
        switch kind {
        case .story: return "text.bubble.fill"
        case .explore: return "magnifyingglass"
        case .rest: return "moon.fill"
        case .train: return "figure.martial.arts"
        case .shop: return "cart.fill"
        case .battle: return "flame.fill"
        case .school: return "building.columns.fill"
        case .life: return "leaf.fill"
        }
    }
}

struct NodeButton: View {
    @EnvironmentObject private var engine: JY3Engine
    var node: WorldNode

    var body: some View {
        let unlocked = engine.isUnlocked(node)
        let current = engine.currentNode.id == node.id
        Button {
            engine.travel(to: node)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: unlocked ? node.icon : "lock.fill")
                    .font(.system(size: current ? 28 : 22, weight: .bold))
                    .foregroundStyle(current ? .orange : (unlocked ? .white : .gray))
                    .padding(10)
                    .background(Circle().fill(Color.black.opacity(0.45)))
                    .overlay(Circle().stroke(current ? Color.orange : Color.white.opacity(0.18), lineWidth: current ? 2 : 1))
                Text(node.name)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(unlocked ? .white.opacity(0.85) : .white.opacity(0.35))
            }
        }
        .buttonStyle(.plain)
    }
}

struct BottomNavBar: View {
    @Binding var selectedTab: RootTab

    var body: some View {
        HStack(spacing: 8) {
            ForEach(RootTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .foregroundStyle(selectedTab == tab ? .orange : .white.opacity(0.62))
                    .background(RoundedRectangle(cornerRadius: 13).fill(selectedTab == tab ? Color.orange.opacity(0.18) : Color.white.opacity(0.05)))
                }
            }
        }
    }
}

struct EventOverlay: View {
    @EnvironmentObject private var engine: JY3Engine
    var event: GameEvent

    var body: some View {
        Color.black.opacity(0.66)
            .ignoresSafeArea()
            .overlay(
                JianghuPanel(title: event.title) {
                    Text(event.speaker)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.orange.opacity(0.85))
                    Text(event.text)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.88))
                    ForEach(event.choices) { choice in
                        Button {
                            engine.resolve(choice)
                        } label: {
                            Text(choice.text)
                                .font(.subheadline.weight(.bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.orange.opacity(0.18)))
                        }
                        .foregroundStyle(.white)
                    }
                }
                .padding(22)
            )
    }
}

struct BattleOverlay: View {
    @EnvironmentObject private var engine: JY3Engine
    var battle: BattleState

    var body: some View {
        Color.black.opacity(0.72)
            .ignoresSafeArea()
            .overlay(
                JianghuPanel(title: battle.template.name) {
                    Text("Enemy HP: \(max(0, battle.enemyHP))")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.red.opacity(0.9))
                    ScrollView {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(battle.log.suffix(6), id: \.self) { line in
                                Text(line).font(.caption).foregroundStyle(.white.opacity(0.76))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        Button("Attack") { engine.attackInBattle() }
                            .buttonStyle(.borderedProminent)
                        Button("Retreat") { engine.fleeBattle() }
                            .buttonStyle(.bordered)
                    }
                }
                .padding(22)
            )
    }
}

struct HeroPanel: View {
    @EnvironmentObject private var engine: JY3Engine
    var body: some View {
        JianghuPanel(title: "Hero") {
            ForEach(engine.party.prefix(1)) { actor in
                CharacterRow(actor: actor)
            }
            Text("Morality: \(engine.session.morality)  School Contribution: \(engine.session.schoolContribution)")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
    }
}

struct SkillPanel: View {
    @EnvironmentObject private var engine: JY3Engine
    var body: some View {
        JianghuPanel(title: "Martial Arts") {
            ForEach(engine.knownSkills) { skill in
                VStack(alignment: .leading, spacing: 4) {
                    Text(skill.name).font(.headline).foregroundStyle(.white)
                    Text("\(skill.category) / Power \(skill.power) / EXP \(engine.session.skillExp[skill.id, default: 0])")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.65))
                    Text(skill.effect).font(.caption).foregroundStyle(.white.opacity(0.55))
                }
                Divider().background(Color.white.opacity(0.15))
            }
        }
    }
}

struct PartyPanel: View {
    @EnvironmentObject private var engine: JY3Engine
    var body: some View {
        JianghuPanel(title: "Party") {
            ForEach(engine.party) { actor in
                CharacterRow(actor: actor)
            }
        }
    }
}

struct CharacterRow: View {
    var actor: Actor
    var body: some View {
        HStack {
            Image(systemName: actor.portrait)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 42, height: 42)
                .background(Circle().fill(Color.white.opacity(0.08)))
            VStack(alignment: .leading) {
                Text(actor.name).font(.headline).foregroundStyle(.white)
                Text("Lv\(actor.level) HP\(actor.hp) MP\(actor.mp) ATK\(actor.attack) DEF\(actor.defense)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.62))
            }
            Spacer()
        }
    }
}

struct InventoryPanel: View {
    @EnvironmentObject private var engine: JY3Engine
    var body: some View {
        JianghuPanel(title: "Inventory") {
            ForEach(engine.session.inventory.sorted(by: { $0.key < $1.key }), id: \.key) { key, count in
                let item = engine.content.items.first(where: { $0.id == key })
                HStack {
                    Text(item?.name ?? key).foregroundStyle(.white)
                    Spacer()
                    Text("x\(count)").foregroundStyle(.white.opacity(0.65))
                }
            }
        }
    }
}

struct SchoolPanel: View {
    @EnvironmentObject private var engine: JY3Engine
    var body: some View {
        JianghuPanel(title: "Schools") {
            ForEach(engine.content.schools) { school in
                VStack(alignment: .leading, spacing: 6) {
                    Text(school.name).font(.headline).foregroundStyle(.orange)
                    Text(school.description).font(.caption).foregroundStyle(.white.opacity(0.7))
                    Text(engine.session.flags[school.entryFlag ?? ""] == true ? "Joined" : "Not joined")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(engine.session.flags[school.entryFlag ?? ""] == true ? .green : .gray)
                }
            }
        }
    }
}
