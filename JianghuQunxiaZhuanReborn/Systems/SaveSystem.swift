import Foundation

struct SaveSlot: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var savedAt: Date
    var session: GameSession
}

enum SaveSystem {
    private static let key = "JianghuQunxiaZhuanReborn.SaveSlots"

    static func loadSlots() -> [SaveSlot] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([SaveSlot].self, from: data)) ?? []
    }

    static func save(session: GameSession, name: String = "Manual Save") {
        var slots = loadSlots()
        let slot = SaveSlot(id: UUID().uuidString, name: name, savedAt: Date(), session: session)
        slots.insert(slot, at: 0)
        if slots.count > 8 { slots = Array(slots.prefix(8)) }
        if let data = try? JSONEncoder().encode(slots) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
