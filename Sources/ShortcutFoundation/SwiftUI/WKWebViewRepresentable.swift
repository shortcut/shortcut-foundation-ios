import SwiftUI
import WebKit

struct WKWebViewRepresentable: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct Web_Previews: PreviewProvider {
    static var previews: some View {
        WKWebViewRepresentable(url: URL(string: "www.google.com")!)
    }
}
