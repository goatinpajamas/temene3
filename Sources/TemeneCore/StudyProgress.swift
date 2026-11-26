import Foundation

/// Everything the app remembers about a student's practice.
public struct StudyProgress: Codable, Equatable, Sendable {
    public var version = 1
    public var stream: Stream = .natural
    public var studyDays: [Int] = []
    public var tallies: [Subject: Tally] = [:]

    public init(stream: Stream = .natural) { self.stream = stream }

    public mutating func recordAnswer(subject: Subject, firstTry: Bool, today: Int) {
        if !studyDays.contains(today) { studyDays.append(today) }
        var t = tallies[subject] ?? Tally()
        t.answered += 1
        if firstTry { t.firstTry += 1 }
        tallies[subject] = t
    }

    public var estimate: Estimate { TemeneCore.estimate(stream.subjects.map { ($0, tallies[$0] ?? Tally()) }) }

    /// Decodes stored data; anything malformed or impossible starts fresh.
    public static func decode(_ data: Data?) -> StudyProgress {
        guard let data, var p = try? JSONDecoder().decode(StudyProgress.self, from: data), p.version == 1 else { return StudyProgress() }
        p.tallies = p.tallies.filter { $0.value.firstTry >= 0 && $0.value.firstTry <= $0.value.answered }
        return p
    }
}
