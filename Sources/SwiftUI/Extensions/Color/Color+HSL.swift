import Foundation
import SwiftUI

public extension Color {
    
    /// Creates a constant color from hue, saturation, and lightness values.
    ///
    /// This initializer creates a constant color that doesn't change based
    /// on context. For example, it doesn't have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that
    /// you load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// - Parameters:
    ///   - hue: A value in the range `0` to `1` that maps to an angle
    ///     from 0° to 360° to represent a shade on the color wheel.
    ///   - saturation: A value in the range `0` to `1` that indicates
    ///     how strongly the hue affects the color. A value of `0` removes the
    ///     effect of the hue, resulting in gray. As the value increases,
    ///     the hue becomes more prominent.
    ///   - lightness: A value in the range `0` to `1` that indicates
    ///     how bright a color is. A value of `0` results in black, regardless
    ///     of the other components. The color lightens as you increase this
    ///     component.
    ///   - opacity: An optional degree of opacity, given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`
    ///     means 100% opacity. The default is `1`.
    ///
    /// - Note: This initializer defines the color using HSL, not HSB/HSV.
    init(hue: Double, saturation: Double, lightness: Double, opacity: Double = 1) {
        let brightness = lightness + saturation * min(lightness, 1 - lightness)
        let hslSaturation = brightness == 0 ? 0 : 2 * (1 - lightness / brightness)
        self.init(hue: hue, saturation: hslSaturation, brightness: brightness, opacity: opacity)
    }

    /// Creates a constant color from hue, saturation, and lightness values.
    ///
    /// This initializer creates a constant color that doesn't change based
    /// on context. For example, it doesn't have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that
    /// you load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// - Parameters:
    ///   - hue360: A value in the range `0` to `360` that maps to an angle
    ///     from 0° to 360° to represent a shade on the color wheel.
    ///   - saturation: A value in the range `0` to `1` that indicates
    ///     how strongly the hue affects the color. A value of `0` removes the
    ///     effect of the hue, resulting in gray. As the value increases,
    ///     the hue becomes more prominent.
    ///   - lightness: A value in the range `0` to `1` that indicates
    ///     how bright a color is. A value of `0` results in black, regardless
    ///     of the other components. The color lightens as you increase this
    ///     component.
    ///   - opacity: An optional degree of opacity, given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`
    ///     means 100% opacity. The default is `1`.
    ///
    /// - Note: This initializer defines the color using HSL, not HSB/HSV.
    init(hue360 hue: Double, saturation: Double, lightness: Double, opacity: Double = 1) {
        self.init(hue: hue / 360.0, saturation: saturation, lightness: lightness, opacity: opacity)
    }
}
