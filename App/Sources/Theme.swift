import SwiftUI

/// Chalkboard look (version A in the earlier prototypes).
enum Theme {
    static let wall = Color(red: 0.914, green: 0.886, blue: 0.816)
    static let board = Color(red: 0.122, green: 0.231, blue: 0.188)
    static let frame = Color(red: 0.541, green: 0.353, blue: 0.169)
    static let chalk = Color(red: 0.949, green: 0.937, blue: 0.894)
    static let muted = Color(red: 0.725, green: 0.769, blue: 0.722)
    static let accent = Color(red: 0.957, green: 0.635, blue: 0.349)
    static let second = Color(red: 0.953, green: 0.890, blue: 0.604)
    static let ink = Color(red: 0.078, green: 0.129, blue: 0.239)
}

struct Board<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10) { content }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.board)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.frame, lineWidth: 8))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
