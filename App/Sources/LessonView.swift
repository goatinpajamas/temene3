import SwiftUI
import WebKit

/// Shows a bundled HTML lesson. The lesson can only send one kind of message:
/// {type: "answered", firstTry: Bool}. Links that leave the page are blocked.
struct LessonView: UIViewRepresentable {
    let resource: String
    var onAnswered: (Bool) -> Void = { _ in }

    func makeCoordinator() -> Coordinator { Coordinator(onAnswered: onAnswered) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let bridge = """
        window.ReactNativeWebView = { postMessage: function (s) { window.webkit.messageHandlers.lesson.postMessage(s); } };
        """
        config.userContentController.addUserScript(WKUserScript(source: bridge, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        config.userContentController.add(context.coordinator, name: "lesson")
        let web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = context.coordinator
        web.isOpaque = false
        web.backgroundColor = .clear
        if let url = Bundle.main.url(forResource: resource, withExtension: "html") {
            web.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return web
    }

    func updateUIView(_ web: WKWebView, context: Context) {}

    static func dismantleUIView(_ web: WKWebView, coordinator: Coordinator) {
        web.configuration.userContentController.removeScriptMessageHandler(forName: "lesson")
    }

    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        let onAnswered: (Bool) -> Void
        init(onAnswered: @escaping (Bool) -> Void) { self.onAnswered = onAnswered }

        func userContentController(_ c: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let s = message.body as? String, let data = s.data(using: .utf8),
                  let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  obj["type"] as? String == "answered", let first = obj["firstTry"] as? Bool else { return }
            onAnswered(first)
        }

        func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(action.request.url?.isFileURL == true ? .allow : .cancel)
        }
    }
}
