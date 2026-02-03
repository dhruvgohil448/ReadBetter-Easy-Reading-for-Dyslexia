import SwiftUI

@main
struct MyApp: App {
    init() {
        ReadBetterFont.register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
