import Foundation
import SwiftUI

extension PresentationStackAlert {
    /// An action to be used on alert prompts across iOS, tvOS, watchOS and macOS.
    public struct Action {
        let title : LocalizedStringKey
        let style : Style
        let handler : Block?
        
        /// Initializes a new action.
        public init(
            title : LocalizedStringKey,
            style : Style = .default,
            handler : Block? = nil
        ) {
            self.title = title
            self.style = style
            self.handler = handler
        }
        
        internal static func constructOKAction(handler : Block?) -> Action {
            return Action(title: "ok", handler: handler)
        }
        
        internal static func constructCancelAction(handler : Block?) -> Action {
            return Action(title: "cancel", style: .cancel, handler: handler)
        }
        
        var compatabilityButton: Alert.Button {
            switch style {
                case .default: .default(Text(title), action: { handler?([]) })
                case .cancel: .cancel(Text(title), action: { handler?([]) })
                case .destructive: .destructive(Text(title), action: { handler?([]) })
            }
        }
    }
}
