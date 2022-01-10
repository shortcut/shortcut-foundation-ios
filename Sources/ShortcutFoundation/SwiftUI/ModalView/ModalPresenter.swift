//
//  ModalPresenter.swift
//  ShortcutFoundation
//
//  Created by Darya Gurinovich on 05.01.22.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import SwiftUI

/// A protocol describing all modals that can be shown
///
/// An example of the ModalPresentationState implementaion
/// ```
/// enum ModalViewPresentationState: ModalPresentationState {
///     case error(String)
///
///     var id: String {
///         switch self {
///         case .error(let description):
///             return "error-\(description)"
///         }
///     }
///
///     func view(dismissAction: @escaping () -> Void) -> some View {
///         switch self {
///         case .error(let description):
///             return Text(description)
///         }
///     }
/// }
/// ```
public protocol ModalPresentationState: Identifiable {
    associatedtype Content: View

    @ViewBuilder func view(dismissAction: @escaping () -> Void) -> Content
}

public enum ModalPresentationType {
    case customSheet
    case fullscreen
    case sheet
}

protocol ModalPresenter {
    associatedtype PresentationState: ModalPresentationState

    func setModal(state: PresentationState, type: ModalPresentationType)
    func setModal(state: PresentationState, type: ModalPresentationType, onDismiss: @escaping() -> Void)
    func closeModal()
}

public class ModalViewRouter<PresentationState: ModalPresentationState>: ObservableObject, ModalPresenter {
    @Published var customSheetPresentationState: PresentationState?
    @Published var fullScreenModalPresentationState: PresentationState?
    @Published var sheetPresentationState: PresentationState?

    public init() {}

    public func setModal(state: PresentationState, type: ModalPresentationType) {
        modal(state: state, type: type, onDismiss: nil)
    }

    public func setModal(state: PresentationState, type: ModalPresentationType, onDismiss: @escaping() -> Void) {
        modal(state: state, type: type, onDismiss: onDismiss)
    }

    public func closeModal() {
        customSheetPresentationState = nil
        fullScreenModalPresentationState = nil
        sheetPresentationState = nil
    }

    private func modal(state: PresentationState, type: ModalPresentationType, onDismiss: (() -> Void)? = nil) {
        if customSheetPresentationState == nil, fullScreenModalPresentationState == nil, sheetPresentationState == nil {
            switch type {
            case .customSheet:
                customSheetPresentationState = state
            case .fullscreen:
                fullScreenModalPresentationState = state
            case .sheet:
                sheetPresentationState = state
            }
        } else {
            closeModal()

            if let onDismiss = onDismiss {
                onDismiss()
            }
            // This delay is fixing an issue where exchanging modals would create an issue where
            // they were presented in the previous views modal window
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(300))) {
                self.modal(state: state, type: type, onDismiss: onDismiss ?? nil)
            }
        }
    }

}
