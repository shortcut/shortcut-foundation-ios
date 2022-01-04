import SwiftUI
import WebKit

#if canImport(UIKit)

import UIKit

public struct WKWebViewRepresentable: UIViewRepresentable {
    public typealias Context = UIViewRepresentableContext<Self>
    
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct Web_Previews: PreviewProvider {
    static var previews: some View {
        WKWebViewRepresentable(url: URL(string: "www.google.com")!)
    }
}

#endif

