import SwiftUI

public extension Binding where Value == Bool {
    
    /// A computed property creating a negated binding from the original boolean binding.
    ///
    /// Usage:
    /// ```swift
    /// @State private var isOn: Bool = true
    ///
    /// // This toggle will represent `!isOn`
    /// Toggle(isOn: $isOn.negated)
    /// ```
    ///
    /// - Returns: A `Binding<Bool>` where the `get` and `set` operations are negated.
    var negated: Binding<Bool> {
        Binding(
            get: { !self.wrappedValue },
            set: { newValue in self.wrappedValue = !newValue }
        )
    }
}
