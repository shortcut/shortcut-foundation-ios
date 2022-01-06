//
//  ModalViewPresenterViewModifier.swift
//  ShortcutFoundation
//
//  Created by Darya Gurinovich on 05.01.22.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI

struct ModalViewPresenterViewModifier<PresentationState: ModalPresentationState>: ViewModifier {
    @EnvironmentObject var modalViewRouter: ModalViewRouter<PresentationState>

    private let options: [BottomSheet.Options]

    init(options: [BottomSheet.Options] = []) {
        self.options = options
    }

    public func body(content: Content) -> some View {
        content
            .fullScreenCoverWithoutConflicts(item: $modalViewRouter.fullScreenModalPresentationState,
                                             content: getContentView)
            .sheetWithoutConflicts(item: $modalViewRouter.sheetPresentationState,
                                   content: getContentView)
            .bottomSheet(item: $modalViewRouter.customSheetPresentationState,
                         options: options,
                         content: getContentView)
    }

    private func getContentView(for modalPresentationState: PresentationState) -> some View {
        modalPresentationState.view(dismissAction: {
            withAnimation(options.animation) {
                modalViewRouter.closeModal()
            }
        })
    }
}

public extension View {
    /// A view modifier to present modal views from any view.
    ///
    /// Works with the implementation of the `ModalPresentationState` protocol that represents all modals that can be shown with this presenter.
    /// Need to set an environmentObject of `ModalViewRouter<S: ModalPresentationState>` before using this modifier otherwise an error will occur.
    ///
    func modalViewPresenter<PresentationState: ModalPresentationState>(presentationStateType: PresentationState.Type,
                                                                       options: [BottomSheet.Options]) -> some View {
        self.modifier(ModalViewPresenterViewModifier<PresentationState>(options: options))
    }
}
