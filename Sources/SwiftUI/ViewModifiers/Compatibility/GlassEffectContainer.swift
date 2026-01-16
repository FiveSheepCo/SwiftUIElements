import SwiftUI

private struct GlassEffectContainerViewModifier: ViewModifier {
    let spacing: CGFloat?

    func body(content: Content) -> some View {
        if #available(iOS 26, macOS 26, *) {
            GlassEffectContainer(spacing: spacing) {
                content
            }
        } else {
            content
        }
    }
}

extension View {

    /// Wraps the view in a `GlassEffectContainer` on iOS 26 and later.
    ///
    /// - Parameters:
    ///   - spacing: The spacing between elements inside the container.
    public func glassEffectContainer(spacing: CGFloat? = nil) -> some View {
        modifier(GlassEffectContainerViewModifier(spacing: spacing))
    }
}
