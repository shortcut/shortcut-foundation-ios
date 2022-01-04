import SwiftUI

struct ModalViewPresenterViewModifier<S: ModalPresentationState>: ViewModifier {
    @EnvironmentObject var modalViewRouter: ModalViewRouter<S>

    func body(content: Content) -> some View {
        content
            .fullScreenCoverWithoutConflicts(item: $modalViewRouter.fullScreenModalPresentationState,
                                             content: { $0.view() })
            .sheetWithoutConflicts(item: $modalViewRouter.sheetPresentationState,
                                   content: { $0.view() })
    }
}
