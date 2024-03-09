import Foundation
import FoundationPlus
import SwiftUI

extension PresentationStackAlert {
    /// A text field configuration to be used on alert prompts.
    public struct TextFieldConfiguration {
        internal let placeholder: LocalizedStringKey
        internal let initialValue: String
        internal let isPassword : Bool
        
        /**
         Initializes a new `PresentationStackAlert.TextFieldConfiguration`.
         
         - Parameters:
         - placeholder:The placeholder.
         - initialValue: The initial text value. Default is an empty string.
         - isPassword: Whether the configuration is for a text field in which a password will be entered.
         */
        public init(
            placeholder: LocalizedStringKey,
            initialValue: String = .empty,
            isPassword: Bool = false
        ) {
            self.placeholder = placeholder
            self.initialValue = initialValue
            self.isPassword = isPassword
        }
    }
}
