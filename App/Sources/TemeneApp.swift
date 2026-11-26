import SwiftUI
import TemeneCore

@main
struct TemeneApp: App {
    @StateObject private var store = ProgressStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Projectile motion").font(.title.bold()).foregroundStyle(Theme.ink).padding(16)
                    LessonView(resource: "projectile") { first in store.answered(.physics, firstTry: first) }
                }
                .background(Theme.wall)
                .tabItem { Label("Lesson", systemImage: "play.circle") }
                PracticeView(title: "Projectile motion", questions: DemoQuestions.projectiles) { q, a in
                    store.answered(q.subject, firstTry: a.isFirstTry(for: q))
                }
                .tabItem { Label("Practice", systemImage: "checklist") }
                Road600View(progress: store.progress)
                    .tabItem { Label("Road to 600", systemImage: "chart.bar") }
            }
            .tint(Theme.ink)
        }
    }
}
