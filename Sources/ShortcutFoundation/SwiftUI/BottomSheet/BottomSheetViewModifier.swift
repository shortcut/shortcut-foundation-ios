//
//  BottomSheetViewModifier.swift
//  ShortcutFoundation
//
//  Created by Darya Gurinovich on 07.01.22.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

#if !os(macOS)
import SwiftUI

struct BottomSheetViewModifier<Body: View, Item: Identifiable>: ViewModifier {
    @Binding var item: Item?

    let options: [BottomSheet.Options]
    let sheetBody: (Item) -> Body

    func body(content: Content) -> some View {
        ZStack {
            content
                .zIndex(0)

            if let item = item {
                let sheetOpened = Binding(get: {
                    return self.item != nil
                }, set: {
                    if !$0 {
                        self.item = nil
                    }
                })

                SheetView(content: sheetBody(item),
                          options: options,
                          isOpened: sheetOpened)
                    .zIndex(1)
            }
        }
    }
}

public extension View {
    /// A custom bottom sheet view with the passed parameters that's shown when item isn't nil
    func bottomSheet<Item, Content>(item: Binding<Item?>,
                                    options: [BottomSheet.Options],
                                    @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item: Identifiable, Content: View {
        self.modifier(BottomSheetViewModifier(item: item,
                                              options: options,
                                              sheetBody: content))
    }
}
#endif
