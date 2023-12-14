import SwiftUI

public extension Binding where Value: ExpressibleByNilLiteral {
    
    /// Provides a custom nil-coalescing operator for `Binding` types where the bound value is optional and can be
    /// expressed by a nil literal. This operator allows specifying a default value to use when the bound value is nil.
    ///
    /// - Parameters:
    ///   - binding: A `Binding` instance of an optional type `Wrapped?`.
    ///   - defaultValue: The default value of type `Wrapped` to be used when the `binding`'s value is nil.
    /// - Returns: A `Binding<Wrapped>` instance. When getting the value, if the original binding's value is nil,
    ///            it returns `defaultValue`; otherwise, it returns the non-nil value. When setting the value, it updates
    ///            the original binding's value.
    ///
    /// Example:
    /// ```
    /// @State private var optionalText: String? = nil
    /// let nonOptionalBinding = optionalText ?? "Default"
    /// ```
    /// Now `nonOptionalBinding` will use "Default" when `optionalText` is nil.
    static func ??<Wrapped>(binding: Binding<Wrapped?>, defaultValue: Wrapped) -> Binding<Wrapped> where Wrapped? == Value {
        Binding<Wrapped>(
            get: { binding.wrappedValue ?? defaultValue },
            set: { binding.wrappedValue = $0 }
        )
    }
}
