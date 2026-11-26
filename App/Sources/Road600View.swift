import SwiftUI
import TemeneCore

struct Road600View: View {
    let progress: Progress

    var body: some View {
        let est = progress.estimate
        let st = streak(studyDays: progress.studyDays, today: dayNumber(Date()))
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Road to 600").font(.title.bold()).foregroundStyle(Theme.ink)
                Board {
                    (Text("\(est.total)").font(.system(size: 48, weight: .heavy))
                        + Text(" / 600").font(.title3.weight(.semibold)).foregroundColor(Theme.muted))
                        .foregroundStyle(Theme.chalk)
                        .accessibilityLabel("Estimated \(est.total) out of 600")
                    Text("Likely range \(est.low)–\(est.high). It firms up as you practise.")
                        .font(.subheadline).foregroundStyle(Theme.muted)
                    ForEach(est.subjects, id: \.subject) { s in row(s) }
                    Text("Based on first-try answers. A study guide, not a prediction of your real exam.")
                        .font(.caption).foregroundStyle(Theme.muted)
                }
                Board {
                    Text("\(st.current) day streak" + (st.studiedToday ? "" : ", study today to keep it"))
                        .font(.headline).foregroundStyle(Theme.chalk)
                    Text("Longest: \(st.longest) \(st.longest == 1 ? "day" : "days")")
                        .font(.subheadline).foregroundStyle(Theme.muted)
                }
            }
            .padding(16)
        }
        .background(Theme.wall)
    }

    private func row(_ s: SubjectEstimate) -> some View {
        HStack(spacing: 8) {
            Text(s.subject.name).font(.subheadline).foregroundStyle(Theme.chalk).frame(width: 82, alignment: .leading)
            GeometryReader { g in
                let w = g.size.width
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.chalk.opacity(0.15)).frame(height: 10)
                    Capsule().fill(Theme.accent.opacity(0.45))
                        .frame(width: max(4, w * CGFloat(s.high - s.low) / 100), height: 10)
                        .offset(x: w * CGFloat(s.low) / 100)
                    RoundedRectangle(cornerRadius: 2).fill(Theme.accent)
                        .frame(width: 4, height: 16).offset(x: w * CGFloat(s.score) / 100 - 2)
                }
                .frame(height: 16)
                .frame(maxHeight: .infinity)
            }
            .frame(height: 20)
            .accessibilityElement()
            .accessibilityLabel("\(s.subject.name) about \(s.score) out of 100")
            Text("\(s.score)").bold().foregroundStyle(Theme.chalk).frame(width: 32, alignment: .trailing)
        }
    }
}
