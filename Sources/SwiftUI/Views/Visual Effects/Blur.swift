import SwiftUI

/// A view that provides a blur effect.
public struct Blur: UIViewRepresentable {
    
    /// The style of the blur effect.
    private var style: UIBlurEffect.Style
    
    /// Initializes the `Blur` view with a specified blur effect style.
    /// - Parameter style: The style of the blur effect.
    public init(_ style: UIBlurEffect.Style = .regular) {
        self.style = style
    }
    
    /// Creates the view object and configures its initial state.
    /// - Parameter context: The context in which the view is being created.
    /// - Returns: A configured `UIVisualEffectView` with the specified blur effect.
    public func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    /// Updates the state of the specified view with new information from SwiftUI.
    /// - Parameters:
    ///   - uiView: The view object to update.
    ///   - context: The context containing the new information.
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
