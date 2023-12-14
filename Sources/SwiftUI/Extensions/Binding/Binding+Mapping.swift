import SwiftUI

public extension Binding {
    
    /// Transforms the current `Binding` value to a new type, creating a new `Binding` instance.
    ///
    /// The `map` function allows the conversion of a `Binding` instance of one type (`Value`) to another
    /// type (`Target`) and vice versa. This is particularly useful in SwiftUI when the data model type
    /// does not directly match the type expected by a view. The function provides a mechanism to
    /// translate between these types seamlessly.
    ///
    /// - Parameters:
    ///   - forward: A closure that defines the conversion from the original `Value` type to the `Target` type.
    ///              This closure is called when the SwiftUI view reads the value. \
    ///              - Parameter value: The current value of type `Value`. \
    ///              - Returns: The converted value of type `Target`.
    ///
    ///   - reverse: A closure that defines the conversion from the `Target` type back to the `Value` type.
    ///              This closure is called when the SwiftUI view updates the value. \
    ///              - Parameter target: The new value of type `Target`. \
    ///              - Returns: The converted value of type `Value`.
    ///
    /// - Returns: A `Binding<Target>` instance, which binds to the same underlying data as the original
    ///            `Binding<Value>`, but presents and accepts values of type `Target`.
    ///
    /// Example:
    ///
    /// Assuming you have a `Binding<String>` representing an integer value as a string, and you want
    /// to bind it to a `Slider` that expects a `Binding<Double>`, you can use `map` to create the
    /// required `Binding<Double>`:
    ///
    /// ```swift
    /// let stringBinding: Binding<String> = ...
    /// let doubleBinding: Binding<Double> = stringBinding.map(
    ///     forward: { Double($0) ?? 0.0 },
    ///     reverse: { String($0) }
    /// )
    /// ```
    func map<Target>(forward: @escaping (Value) -> Target, reverse: @escaping (Target) -> Value) -> Binding<Target> {
        Binding<Target>(
            get: {
                forward(self.wrappedValue)
            },
            set: { newValue in
                self.wrappedValue = reverse(newValue)
            }
        )
    }
}
