import XCTest
@testable import TemeneCore

final class ProgressTests: XCTestCase {
    func testRecordAndEstimate() {
        var p = StudyProgress()
        p.recordAnswer(subject: .physics, firstTry: true, today: 10)
        p.recordAnswer(subject: .physics, firstTry: false, today: 10)
        p.recordAnswer(subject: .maths, firstTry: true, today: 11)
        XCTAssertEqual(p.tallies[.physics], Tally(firstTry: 1, answered: 2))
        XCTAssertEqual(p.studyDays, [10, 11])
        XCTAssertEqual(p.estimate.subjects.count, 6)
    }

    func testRoundTripAndBadData() throws {
        var p = StudyProgress()
        p.recordAnswer(subject: .physics, firstTry: true, today: 3)
        XCTAssertEqual(StudyProgress.decode(try JSONEncoder().encode(p)), p)
        XCTAssertEqual(StudyProgress.decode(nil), StudyProgress())
        XCTAssertEqual(StudyProgress.decode(Data("{oops".utf8)), StudyProgress())
        var bad = p
        bad.tallies[.maths] = Tally(firstTry: 5, answered: 2)
        XCTAssertNil(StudyProgress.decode(try JSONEncoder().encode(bad)).tallies[.maths])
    }
}
