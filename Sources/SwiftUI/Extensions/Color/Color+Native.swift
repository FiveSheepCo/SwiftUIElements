// Additional colors covering both native UIKit and AppKit colors.
// In the case where no direct equivalent exists, a best-effort alternative has been chosen.
//
// Parts of this code are taken from SwiftUIX:
// https://github.com/SwiftUIX/SwiftUIX/blob/master/Sources/SwiftUIX/Intermodular/Extensions/SwiftUI/Color%2B%2B.swift
//
// Most of these have been modernized and improved, with better alternatives for macOS 14.0+.
//
// Original license:
// ```
// Copyright © 2020 Vatsal Manot
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”),
// to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// ```

#if canImport(SwiftUI)
import SwiftUI
#endif

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
typealias NativeColor = UIColor
#elseif os(macOS)
typealias NativeColor = NSColor
#endif

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || targetEnvironment(macCatalyst)

public extension Color {
    
    /// The color for text labels that contain primary content.
    static var label: Color {
        #if os(macOS)
        Color(.labelColor)
        #else
        Color(.label)
        #endif
    }
    
    /// The color for text labels that contain secondary content.
    static var secondaryLabel: Color {
        #if os(macOS)
        Color(.secondaryLabelColor)
        #else
        Color(.secondaryLabel)
        #endif
    }
    
    /// The color for text labels that contain tertiary content.
    static var tertiaryLabel: Color {
        #if os(macOS)
        Color(.tertiaryLabelColor)
        #else
        Color(.tertiaryLabel)
        #endif
    }
    
    /// The color for text labels that contain quaternary content.
    static var quaternaryLabel: Color {
        #if os(macOS)
        Color(.quaternaryLabelColor)
        #else
        Color(.quaternaryLabel)
        #endif
    }
}

#endif

#if os(iOS) || os(macOS) || os(tvOS) || targetEnvironment(macCatalyst)

@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Color {
    
    /// The color for the main background of your interface.
    static var systemBackground: Color {
        #if os(macOS)
        Color(NativeColor.windowBackgroundColor)
        #else
        Color(NativeColor.systemBackground)
        #endif
    }
    
    /// The color for content layered on top of the main background.
    static var secondarySystemBackground: Color {
        #if os(macOS)
        Color(NativeColor.controlBackgroundColor)
        #else
        Color(NativeColor.secondarySystemBackground)
        #endif
    }
    
    /// The color for content layered on top of secondary backgrounds.
    static var tertiarySystemBackground: Color {
        #if os(macOS)
        Color(NativeColor.textBackgroundColor)
        #else
        Color(NativeColor.tertiarySystemBackground)
        #endif
    }
}

#endif

#if os(iOS) || targetEnvironment(macCatalyst)

public extension Color {
    
    /// The color for the main background of your grouped interface.
    static var systemGroupedBackground: Color {
        Color(NativeColor.systemGroupedBackground)
    }
    
    /// The color for content layered on top of the main background of your grouped interface.
    static var secondarySystemGroupedBackground: Color {
        Color(NativeColor.secondarySystemGroupedBackground)
    }
    
    /// The color for content layered on top of secondary backgrounds of your grouped interface.
    static var tertiarySystemGroupedBackground: Color {
        Color(NativeColor.tertiarySystemGroupedBackground)
    }
}

#endif

#if os(iOS) || os(macOS) || os(visionOS) || targetEnvironment(macCatalyst)

public extension Color {
    
    /// A color appropriate for filling thin and small shapes.
    static var systemFill: Color {
        #if os(macOS)
        if #available(macOS 14.0, *) {
            Color(NativeColor.systemFill)
        } else {
            Color(NativeColor.textBackgroundColor)
        }
        #else
        Color(NativeColor.systemFill)
        #endif
    }
    
    /// A color appropriate for filling medium-size shapes.
    static var secondarySystemFill: Color {
        #if os(macOS)
        if #available(macOS 14.0, *) {
            Color(NativeColor.secondarySystemFill)
        } else {
            Color(NativeColor.windowBackgroundColor)
        }
        #else
        Color(NativeColor.secondarySystemFill)
        #endif
    }
        
    /// A color appropriate for filling large shapes.
    static var tertiarySystemFill: Color {
        #if os(macOS)
        if #available(macOS 14.0, *) {
            Color(NativeColor.tertiarySystemFill)
        } else {
            Color(NativeColor.underPageBackgroundColor)
        }
        #else
        Color(NativeColor.tertiarySystemFill)
        #endif
    }
    
    /// A color appropriate for filling large areas containing complex content.
    static var quaternarySystemFill: Color {
        #if os(macOS)
        if #available(macOS 14.0, *) {
            Color(NativeColor.quaternarySystemFill)
        } else {
            Color(NativeColor.scrubberTexturedBackground) // FIXME: This crashes for some reason.
        }
        #else
        Color(NativeColor.quaternarySystemFill)
        #endif
    }
}

#endif
