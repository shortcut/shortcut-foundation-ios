//
//  View+Fullscreen.swift
//  ShortcutFoundation
//
//  Created by Karl Söderberg on 2022-08-25.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI

public extension View {

    func fullScreenBackground<Content: View>(_ view: Content, edgesIgnoringSafeArea: Edge.Set = .all) -> some View {
        return self.modifier(FullScreenBackgroundModifier(background: AnyView(view),
                                                          edgesIgnoringSafeArea: edgesIgnoringSafeArea))
    }

    func fullScreenOverlay<Content: View>(_ view: Content, edgesIgnoringSafeArea: Edge.Set = .all) -> some View {
        return self.modifier(FullScreenOverlayModifier(overlay: AnyView(view),
                                                       edgesIgnoringSafeArea: edgesIgnoringSafeArea))
    }
}

private struct FullScreenOverlayModifier: ViewModifier {
    var overlay: AnyView
    var edgesIgnoringSafeArea: Edge.Set = .all

    func body(content: Content) -> some View {
        ZStack {
            content
            overlay.edgesIgnoringSafeArea(edgesIgnoringSafeArea)
        }
    }
}

private struct FullScreenBackgroundModifier: ViewModifier {
    var background: AnyView
    var edgesIgnoringSafeArea: Edge.Set = .all

    func body(content: Content) -> some View {
        ZStack {
            background.edgesIgnoringSafeArea(edgesIgnoringSafeArea)
            content
        }
    }
}
