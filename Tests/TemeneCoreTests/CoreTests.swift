import XCTest
@testable import TemeneCore

final class CoreTests: XCTestCase {
    let q = Question(id: "q1", subject: .physics, topic: "p", stem: "x", options: ["a", "b", "c", "d"], answer: 1, explanation: "")

    func testFirstTry() {
        var a = Attempt()
        a.pick(1, for: q)
        XCTAssertTrue(a.correct)
        XCTAssertTrue(a.isFirstTry(for: q))
    }

    func testWrongThenRight() {
        var a = Attempt()
        a.pick(0, for: q); a.pick(0, for: q); a.pick(1, for: q); a.pick(2, for: q)
        XCTAssertEqual(a.picks, [0, 1])
        XCTAssertTrue(a.correct)
        XCTAssertFalse(a.isFirstTry(for: q))
    }

    func testStreak() {
        XCTAssertEqual(streak(studyDays: [1, 2, 3], today: 3), StreakInfo(current: 3, longest: 3, studiedToday: true))
        XCTAssertEqual(streak(studyDays: [1, 2], today: 3), StreakInfo(current: 2, longest: 2, studiedToday: false))
        let s = streak(studyDays: [1, 2, 3, 5, 5], today: 5)
        XCTAssertEqual(s.current, 1); XCTAssertEqual(s.longest, 3)
        XCTAssertEqual(streak(studyDays: [], today: 9).current, 0)
    }

    func testEstimateMatchesTypeScriptModel() {
        let none = estimate(Stream.natural.subjects.map { ($0, Tally()) })
        XCTAssertEqual(none.total, 240)
        let few = estimate([(.maths, Tally(firstTry: 5, answered: 5))]).subjects[0]
        let many = estimate([(.maths, Tally(firstTry: 400, answered: 500))]).subjects[0]
        XCTAssertLessThan(few.score, 60)
        XCTAssertTrue((78...80).contains(many.score))
        XCTAssertLessThan(many.high - many.low, few.high - few.low)
    }
}
