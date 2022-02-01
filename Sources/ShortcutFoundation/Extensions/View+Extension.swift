//
//  View+Extension.swift
//  ShortcutFoundation
//
//  Created by Darya Gurinovich on 05.01.22.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI
#if !os(macOS)
import UIKit
#endif

/// Fixes issues related to having multiple .sheet() or .fullScreenCover() functions in the same view hierarcy that SwiftUI cant handle

public extension View {
    func sheetWithoutConflicts<Item, Content>(item: Binding<Item?>,
                                              onDismiss: (() -> Void)? = nil,
                                              @ViewBuilder content: @escaping (Item) -> Content) -> some View
    where Item: Identifiable, Content: View {
        self.overlay(
            EmptyView().sheet(item: item, onDismiss: onDismiss, content: content)
        )
    }

    func sheetWithoutConflicts<Content>(isPresented: Binding<Bool>,
                                        onDismiss: (() -> Void)? = nil,
                                        @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View {
        self.overlay(
            EmptyView().sheet(isPresented: isPresented, onDismiss: onDismiss, content: content)
        )
    }

    #if !os(macOS)
    @ViewBuilder
    func fullScreenCoverWithoutConflicts<Item, Content>(item: Binding<Item?>,
                                                        onDismiss: (() -> Void)? = nil,
                                                        @ViewBuilder content: @escaping (Item) -> Content) -> some View
    where Item: Identifiable, Content: View {
        if #available(iOS 14.0, *) {
            self.overlay(
                EmptyView().fullScreenCover(item: item, onDismiss: onDismiss, content: content)
            )
        } else {
            self.sheetWithoutConflicts(item: item, onDismiss: onDismiss, content: content)
        }
    }

    @ViewBuilder
    func fullScreenCoverWithoutConflicts<Content>(isPresented: Binding<Bool>,
                                                  onDismiss: (() -> Void)? = nil,
                                                  @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View {
        if #available(iOS 14.0, *) {
            self.overlay(
                EmptyView().fullScreenCover(isPresented: isPresented, onDismiss: onDismiss, content: content)
            )
        } else {
            self.sheetWithoutConflicts(isPresented: isPresented, onDismiss: onDismiss, content: content)
        }
    }
    #endif
}

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }

#if !os(macOS)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
#endif
}

#if !os(macOS)
private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
