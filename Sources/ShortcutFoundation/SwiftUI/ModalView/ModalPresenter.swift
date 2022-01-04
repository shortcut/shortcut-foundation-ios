import Foundation
import SwiftUI

public protocol ModalPresentationState: Identifiable {
    associatedtype Content: View

    @ViewBuilder func view() -> Content
}

public enum ModalPresentationType {
    case sheet
    case fullscreen
}

protocol ModalPresenter {
    associatedtype S: ModalPresentationState

    func setModal(state: S, type: ModalPresentationType)
    func setModal(state: S, type: ModalPresentationType, onDismiss: @escaping() -> Void)
    func closeModal()
}

public class ModalViewRouter<S: ModalPresentationState>: ObservableObject, ModalPresenter {
    @Published var sheetPresentationState: S?
    @Published var fullScreenModalPresentationState: S?

    public init() {}

    public func setModal(state: S, type: ModalPresentationType) {
        modal(state: state, type: type, onDismiss: nil)
    }

    public func setModal(state: S, type: ModalPresentationType, onDismiss: @escaping() -> Void) {
        modal(state: state, type: type, onDismiss: onDismiss)
    }

    public func closeModal() {
        sheetPresentationState = nil
        fullScreenModalPresentationState = nil
    }

    private func modal(state: S, type: ModalPresentationType, onDismiss: (() -> Void)? = nil) {
        if sheetPresentationState == nil, fullScreenModalPresentationState == nil {
            switch type {
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
            // This delay is fixing and issue where exchanging modals would create an issue where
            // they were presented in the previous views modal window
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(300))) {
                self.modal(state: state, type: type, onDismiss: onDismiss ?? nil)
            }
        }
    }

}
