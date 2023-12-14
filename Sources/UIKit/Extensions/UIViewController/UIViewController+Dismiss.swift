#if canImport(UIKit) && !os(watchOS)

import UIKit

public extension UIViewController {
    
    /// Dismisses the responder animatedly.
    @objc func dismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    /// Dismisses the responder animatedly.
    @objc func dismissWithoutAmbiguity(){
        dismiss()
    }
}

#endif
