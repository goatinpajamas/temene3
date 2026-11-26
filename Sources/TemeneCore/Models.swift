import Foundation

public enum Subject: String, Codable, CaseIterable, Sendable {
    case english, maths, aptitude, physics, chemistry, biology, geography, history, economics

    public var name: String { rawValue.prefix(1).uppercased() + rawValue.dropFirst() }
}

public enum Stream: String, Codable, Sendable {
    case natural, social

    public var subjects: [Subject] {
        switch self {
        case .natural: return [.english, .maths, .aptitude, .physics, .chemistry, .biology]
        case .social: return [.english, .maths, .aptitude, .geography, .history, .economics]
        }
    }
}

public struct Question: Identifiable, Hashable, Sendable {
    public let id: String
    public let subject: Subject
    public let topic: String
    public let stem: String
    public let options: [String]
    /// Index into `options`.
    public let answer: Int
    public let explanation: String

    public init(id: String, subject: Subject, topic: String, stem: String, options: [String], answer: Int, explanation: String) {
        self.id = id; self.subject = subject; self.topic = topic; self.stem = stem
        self.options = options; self.answer = answer; self.explanation = explanation
    }
}

public struct Attempt: Hashable, Sendable {
    public private(set) var picks: [Int] = []
    public private(set) var correct = false

    public init() {}

    /// Records a pick. Repeats and picks after the right answer are ignored.
    public mutating func pick(_ index: Int, for q: Question) {
        precondition(q.options.indices.contains(index), "option out of range")
        guard !correct, !picks.contains(index) else { return }
        picks.append(index)
        correct = index == q.answer
    }

    public func isFirstTry(for q: Question) -> Bool { picks.first == q.answer }
}
