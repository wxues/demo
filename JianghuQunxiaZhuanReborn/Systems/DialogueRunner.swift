import Foundation

enum DialogueRunner {
    static func summarize(_ event: GameEvent) -> String {
        "[\(event.speaker)] \(event.text)"
    }
}
