import Foundation
import SwiftUI

struct PresentationStackAlert {
    let title: LocalizedStringKey
    let message: Text?
    let textFields: [PresentationStackAlert.TextFieldConfiguration]
    let actions: [PresentationStackAlert.Action]
    
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
