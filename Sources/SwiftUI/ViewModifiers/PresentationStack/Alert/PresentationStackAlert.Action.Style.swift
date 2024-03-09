import Foundation
import SwiftUI

extension PresentationStackAlert.Action {
    /// The style applied to a PresentationStackAlert.Action.
    public enum Style {
        /// The default style.
        case `default`
        
        /// A style that indicates the action cancels the operation and leaves things unchanged.
        case cancel
        
        /// A style that indicates the action might change or delete data.
        case destructive
        
        @available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
        var role: SwiftUI.ButtonRole? {
            switch self {
                case .default: nil
                case .cancel: .cancel
                case .destructive: .destructive
            }
        }
    }
}
