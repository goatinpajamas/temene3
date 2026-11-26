import Foundation

public struct Tally: Codable, Equatable, Sendable {
    public var firstTry: Int
    public var answered: Int
    public init(firstTry: Int = 0, answered: Int = 0) { self.firstTry = firstTry; self.answered = answered }
}

public struct SubjectEstimate: Equatable, Sendable {
    public let subject: Subject
    public let score: Int
    public let low: Int
    public let high: Int
}

public struct Estimate: Equatable, Sendable {
    public let total: Int
    public let low: Int
    public let high: Int
    public let subjects: [SubjectEstimate]
}

/// Same model as the TypeScript experiments: first-try accuracy pulled toward a prior
/// of 40 out of 100 until there is enough practice, with a ~90% range.
public func estimate(_ tallies: [(Subject, Tally)], prior: Double = 40, priorWeight: Double = 20) -> Estimate {
    func clamp(_ x: Double) -> Int { max(0, min(100, Int((x * 100).rounded()))) }
    let subjects = tallies.map { subject, t -> SubjectEstimate in
        precondition(t.firstTry >= 0 && t.answered >= t.firstTry, "bad tally")
        let p = (Double(t.firstTry) + prior / 100 * priorWeight) / (Double(t.answered) + priorWeight)
        let margin = 1.64 * ((p * (1 - p)) / (Double(t.answered) + priorWeight)).squareRoot()
        return SubjectEstimate(subject: subject, score: clamp(p), low: clamp(p - margin), high: clamp(p + margin))
    }
    return Estimate(
        total: subjects.reduce(0) { $0 + $1.score },
        low: subjects.reduce(0) { $0 + $1.low },
        high: subjects.reduce(0) { $0 + $1.high },
        subjects: subjects)
}
