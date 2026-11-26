import Foundation

public struct StreakInfo: Equatable, Sendable {
    public let current: Int
    public let longest: Int
    public let studiedToday: Bool
}

/// Days are whole-day numbers (for example days since 1970 in the user's calendar).
/// The current streak counts back from today, or from yesterday if today has no study yet.
public func streak(studyDays: [Int], today: Int) -> StreakInfo {
    let days = Set(studyDays)
    var longest = 0, run = 0, prev = Int.min
    for d in days.sorted() {
        run = (d == prev + 1) ? run + 1 : 1
        longest = max(longest, run)
        prev = d
    }
    let studiedToday = days.contains(today)
    var current = 0, k = studiedToday ? today : today - 1
    while days.contains(k) { current += 1; k -= 1 }
    return StreakInfo(current: current, longest: longest, studiedToday: studiedToday)
}

public func dayNumber(_ date: Date, calendar: Calendar = .current) -> Int {
    let start = calendar.startOfDay(for: date)
    let c = calendar.dateComponents([.year, .month, .day], from: start)
    var utc = Calendar(identifier: .gregorian)
    utc.timeZone = TimeZone(identifier: "UTC")!
    let d = utc.date(from: c)!
    return Int((d.timeIntervalSince1970 / 86_400).rounded(.down))
}
