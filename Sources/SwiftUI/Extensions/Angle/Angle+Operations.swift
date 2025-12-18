import SwiftUI

public extension Angle {

    /// Linearly interpolate between `a` and `b` based on `t`.
    static func lerp(a: Self, b: Self, t: Double) -> Self {
        Angle(degrees: Double._lerp(a: a.degrees, b: b.degrees, t: t))
    }

    /// Clamp the `Angle` into the [0, 2π] range (in radians)
    func clamp360() -> Self {
        let twoPi: Double = 2.0 * Double.pi
        let modAngle: Double = self.radians.truncatingRemainder(dividingBy: twoPi)
        let positiveAngle: Double = modAngle >= 0 ? modAngle : modAngle + twoPi
        return Angle(radians: positiveAngle)
    }
}
