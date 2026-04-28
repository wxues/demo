import SwiftUI

@main
struct JianghuQunxiaZhuanRebornApp: App {
    @StateObject private var engine = JY3Engine()

    var body: some Scene {
        WindowGroup {
            GameRootView()
                .environmentObject(engine)
        }
    }
}
