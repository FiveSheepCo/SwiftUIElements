import Foundation

@_spi(SwiftUIElements)
public extension Comparable where Self: ExpressibleByFloatLiteral & FloatingPoint {

    /// Linearly interpolate between `a` and `b` based on `t`.
    ///
    /// Example usage:
    /// ```
    /// Double.lerp(0, 100, 0.5) // 50.0
    /// ```
    @inline(__always)
    static func _lerp(a: Self, b: Self, t: Self) -> Self {
        (1.0 - t) * a + t * b
    }
}
