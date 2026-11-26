import Foundation
import TemeneCore

/// Saves progress on the phone (UserDefaults) after every answer.
@MainActor
final class ProgressStore: ObservableObject {
    private let key = "temene.progress.v1"
    @Published private(set) var progress: StudyProgress

    init() { progress = StudyProgress.decode(UserDefaults.standard.data(forKey: key)) }

    func answered(_ subject: Subject, firstTry: Bool) {
        progress.recordAnswer(subject: subject, firstTry: firstTry, today: dayNumber(Date()))
        if let data = try? JSONEncoder().encode(progress) { UserDefaults.standard.set(data, forKey: key) }
    }
}
