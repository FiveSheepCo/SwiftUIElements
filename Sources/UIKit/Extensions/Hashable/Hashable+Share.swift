#if canImport(UIKit)

import Foundation
import UIKit

public extension Hashable {
    
    #if !os(tvOS) && !os(watchOS)
    
    /// Shares the responder using a `UIActivityViewController`.
    @available(iOSApplicationExtension, unavailable)
    func share(applicationActivities: [UIActivity]? = nil) {
        let controller = UIActivityViewController(activityItems: [self], applicationActivities: applicationActivities)
        controller.show(type: .present)
    }
    
    #endif
}

#endif
