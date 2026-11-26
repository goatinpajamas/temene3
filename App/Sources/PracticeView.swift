import SwiftUI
import TemeneCore

struct PracticeView: View {
    let title: String
    let questions: [Question]
    var onAnswered: (Question, Attempt) -> Void = { _, _ in }

    @State private var index = 0
    @State private var attempts: [String: Attempt] = [:]

    private var q: Question { questions[index] }
    private var attempt: Attempt? { attempts[q.id] }
    private var answeredCount: Int { attempts.values.filter { !$0.picks.isEmpty }.count }
    private var firstTryCount: Int { questions.filter { attempts[$0.id]?.isFirstTry(for: $0) == true }.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title).font(.title.bold()).foregroundStyle(Theme.ink)
                Text("Question \(index + 1) of \(questions.count) · first try \(firstTryCount) of \(answeredCount)")
                    .font(.subheadline).foregroundStyle(.secondary)
                Board {
                    Text(q.stem).font(.headline).foregroundStyle(Theme.chalk)
                    ForEach(q.options.indices, id: \.self) { k in option(k) }
                    if let a = attempt, !a.correct {
                        Text("Not that one. Try again.").foregroundStyle(Theme.second)
                    }
                    if let a = attempt, a.correct {
                        Text(a.isFirstTry(for: q) ? "Right first try." : "Right.").bold().foregroundStyle(Theme.accent)
                        Text(q.explanation).foregroundStyle(Theme.chalk)
                    }
                }
                if attempt?.correct == true {
                    let last = index == questions.count - 1
                    Button(last ? "Back to the first question" : "Next question") { index = last ? 0 : index + 1 }
                        .font(.headline).frame(maxWidth: .infinity, minHeight: 48)
                        .background(Theme.ink).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(16)
        }
        .background(Theme.wall)
    }

    @ViewBuilder private func option(_ k: Int) -> some View {
        let picked = attempt?.picks.contains(k) ?? false
        let right = picked && k == q.answer
        let wrong = picked && k != q.answer
        Button {
            var a = attempts[q.id] ?? Attempt()
            let wasCorrect = a.correct
            a.pick(k, for: q)
            attempts[q.id] = a
            if a.correct && !wasCorrect { onAnswered(q, a) }
        } label: {
            Text((right ? "✓ " : wrong ? "✕ " : "") + q.options[k])
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .padding(.horizontal, 12)
                .foregroundStyle(wrong ? Theme.second : Theme.chalk)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(right ? Theme.accent : wrong ? Theme.second : Theme.chalk,
                                  style: StrokeStyle(lineWidth: right ? 3 : 2, dash: wrong ? [6, 4] : [])))
        }
        .disabled(picked || attempt?.correct == true)
        .accessibilityAddTraits(picked ? .isSelected : [])
    }
}
