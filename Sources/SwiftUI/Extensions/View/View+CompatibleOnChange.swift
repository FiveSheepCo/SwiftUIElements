import SwiftUI

@available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *)
public struct CompatibleOnChangeModifier<V: Equatable>: ViewModifier {
    var value: V
    var callback: (V) -> Void
    
    public func body(content: Content) -> some View {
        if #available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *) {
            content
                .onChange(of: value) { _ , newValue in
                    callback(newValue)
                }
        } else {
            content
                .onChange(of: value, perform: { newValue in
                    callback(newValue)
                })
        }
    }
}

@available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *)
public extension View {
    
    /// Adds a modifier for this view that fires an action when a specific value changes.
    ///
    /// Defaults to the deprecated `onChange` signature:
    /// ```swift
    /// onChange(of: _, perform: (Equatable) -> Void)
    /// ```
    /// Uses the new signature if available (`iOS 17.0, macOS 14.0, *`):
    /// ```swift
    /// onChange(of: _, action: (Equatable, Equatable) -> Void)
    /// ```
    ///
    /// - NOTE: Only supports the `newValue` parameter in the callback.
    func compatibleOnChange<V: Equatable>(of value: V, callback: @escaping (V) -> Void) -> some View {
        modifier(CompatibleOnChangeModifier(value: value, callback: callback))
    }
}
