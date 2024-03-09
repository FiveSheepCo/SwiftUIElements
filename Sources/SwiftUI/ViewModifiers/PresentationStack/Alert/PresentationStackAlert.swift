import Foundation
import SwiftUI

/// An alert to be presented on top of all navigation hierarchy by a ``.navigationStack`` view modifier.
struct PresentationStackAlert {
    /// The title.
    let title: LocalizedStringKey
    /// The optional message.
    let message: Text?
    /// The text fields.
    let textFields: [PresentationStackAlert.TextFieldConfiguration]
    /// The actions to be shown.
    let actions: [PresentationStackAlert.Action]
    
    /// Initializes a new ``PresentationStackAlert``.
    /// - Parameters:
    ///   - title: The title.
    ///   - message: The optional message.
    ///   - textFields: The text fields.
    ///   - showOKAction: Whether to show a default OK action.
    ///   - showCancelAction: Whether to show a default cancel action.
    ///   - okBlock: The block to be executed when the user taps the default ok action.
    ///   - cancelBlock: The block to be executed when the user taps the default cancel action.
    ///   - additionalActions: Additional actions.
    init(
        title: LocalizedStringKey,
        message: Text? = nil,
        textFields: [PresentationStackAlert.TextFieldConfiguration] = [],
        showOKAction: Bool = true,
        showCancelAction: Bool = false,
        okBlock: PresentationStackAlert.Action.Block? = nil,
        cancelBlock: PresentationStackAlert.Action.Block? = nil,
        additionalActions: [PresentationStackAlert.Action] = []
    ) {
        self.title = title
        self.message = message
        self.textFields = textFields
        
        var actions: [PresentationStackAlert.Action] = additionalActions
        if showCancelAction {
            actions.insert(.constructCancelAction(handler: cancelBlock), at: 0)
        }
        if showOKAction {
            actions.insert(.constructOKAction(handler: okBlock), at: 0)
        }
        
        self.actions = actions
    }
}
