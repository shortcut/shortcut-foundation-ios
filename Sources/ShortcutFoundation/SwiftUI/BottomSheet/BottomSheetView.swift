//
//  BottomSheetView.swift
//  ShortcutFoundation
//
//  Created by Darya Gurinovich on 06.01.22.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI

#if !os(macOS)
struct SheetView<Content: View>: View {
    let content: Content
    let options: [BottomSheet.Options]

    @GestureState private var translation: CGFloat = 0
    @Binding private var isOpened: Bool

    init(content: Content,
         options: [BottomSheet.Options] = [],
         isOpened: Binding<Bool>) {
        self.content = content
        self.options = options

        self._isOpened = isOpened
    }

    var body: some View {
        Group {
            options.contentBackground
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: closeOnTap)
                .transition(.opacity)

            GeometryReader { proxy in
                VStack {
                    if !options.noDragIndicator {
                        indicator
                    }

                    content
                }
                .padding(options.elementsPadding)
                .background(
                    options.background
                        .cornerRadius(options.cornerRadius, corners: [.topLeft, .topRight])
                        .edgesIgnoringSafeArea(.bottom)
                )
                .frame(maxHeight: options.maxHeight)
                .padding(.top, options.topPadding)
                .offset(y: max(self.translation, 0))
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }.onEnded { value in
                        let snapDistance = proxy.size.height * .sheetSnapRatio
                        guard abs(value.translation.height) > snapDistance else {
                            return
                        }

                        changeSheetOpenedStatus(value.translation.height < 0)
                    }
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .transition(.move(edge: .bottom))
        }
        .animation(options.animation)
    }

    private var indicator: some View {
        Capsule()
            .fill(options.dragIndicatorColor)
            .frame(width: .indicatorSize.width, height: .indicatorSize.height)
    }

    private func closeOnTap() {
        guard options.tapToDismiss else { return }

        changeSheetOpenedStatus(false)
    }

    private func changeSheetOpenedStatus(_ opened: Bool) {
        withAnimation(options.animation) {
            self.isOpened = opened
        }
    }
}

private extension CGFloat {
    static var indicatorSize = CGSize(width: 70, height: 4)
    static var sheetSnapRatio = 0.2
}

#endif
