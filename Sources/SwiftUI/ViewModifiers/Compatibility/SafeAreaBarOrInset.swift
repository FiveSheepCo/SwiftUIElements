import SwiftUI

@available(iOS 15, *)
private struct SafeAreaBarOrInsetViewModifier<InnerView: View>: ViewModifier {
    let edge: VerticalEdge
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let forceInset: Bool
    let innerView: () -> InnerView

    init(
        edge: VerticalEdge,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        forceInset: Bool = false,
        @ViewBuilder content: @escaping () -> InnerView
    ) {
        self.edge = edge
        self.alignment = alignment
        self.spacing = spacing
        self.forceInset = forceInset
        self.innerView = content
    }

    func body(content: Content) -> some View {
        if #available(iOS 26, *), !forceInset {
            content.safeAreaBar(edge: edge, alignment: alignment, spacing: spacing, content: self.innerView)
        } else {
            content.safeAreaInset(edge: edge, alignment: alignment, spacing: spacing, content: self.innerView)
        }
    }
}

@available(iOS 15, *)
extension View {

    /// Uses a `safeAreaBar` on iOS 26 and later, and `safeAreaInset` on earlier versions.
    ///
    /// - Parameters:
    ///   - edge: The edge of the safe area where the bar or inset should be added.
    ///   - alignment: The horizontal alignment of the content within the bar or inset.
    ///   - spacing: The spacing between the content and the edges of the bar or inset.
    ///   - forceInset: A Boolean value that, when set to `true`, forces the use of `safeAreaInset`.
    public func safeAreaBarOrInset<Content: View>(
        edge: VerticalEdge,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        forceInset: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(SafeAreaBarOrInsetViewModifier(
            edge: edge,
            alignment: alignment,
            spacing: spacing,
            forceInset: forceInset,
            content: content,
        ))
    }
}
