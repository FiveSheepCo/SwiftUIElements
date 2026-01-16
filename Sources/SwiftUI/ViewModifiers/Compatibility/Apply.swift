import SwiftUI

extension View {

    /// Applies a modification to the view using a closure.
    ///
    /// - Warning: Use sparingly, as this can mess with view identity and performance optimizations.
    public func apply(
        @ViewBuilder _ modifyContent: (Self) -> some View
    ) -> some View {
        modifyContent(self)
    }
}

@available(iOS 14, macOS 11, *)
extension ToolbarContent {

    /// Applies a modification to the toolbar content using a closure.
    ///
    /// - Warning: Use sparingly, as this can mess with view identity and performance optimizations.
    public func apply(
        @ToolbarContentBuilder _ modifyContent: (Self) -> some ToolbarContent
    ) -> some ToolbarContent {
        modifyContent(self)
    }
}

@available(iOS 14, macOS 11, *)
extension CustomizableToolbarContent {

    /// Applies a modification to the toolbar content using a closure.
    ///
    /// - Warning: Use sparingly, as this can mess with view identity and performance optimizations.
    public func apply(
        @ToolbarContentBuilder _ modifyContent: (Self) -> some CustomizableToolbarContent
    ) -> some CustomizableToolbarContent {
        modifyContent(self)
    }
}
