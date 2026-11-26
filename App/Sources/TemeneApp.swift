import SwiftUI

@main
struct TemeneApp: App {
    var body: some Scene {
        WindowGroup {
            PracticeView(title: "Projectile motion", questions: DemoQuestions.projectiles)
        }
    }
}
