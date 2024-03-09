import Foundation

/// The mode a ``NavigationStackElement`` should be presented as.
public enum StackPresentationMode: Equatable {
    /// Presents this view as a sheet. Corresponds to ``View.sheet()``
    case sheet
    
    /// Presents this view as a fullScreenCover. Corresponds to ``View.fullScreenCover()``
    ///
    /// - note: fullScreenCover is not available in macOS and iOS < 14, thus an element with this presentationMode will be shown as a sheet instead.
    case fullScreenCover
    
    /// Presents this view as a popover. Corresponds to ``View.popover()``
    case popover
}
