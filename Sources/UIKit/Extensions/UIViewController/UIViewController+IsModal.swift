#if canImport(UIKit) && !os(watchOS)

import UIKit

public extension UIViewController {
    
    /// Indicates whether the view controller is presented modally.
    ///
    /// This property checks various aspects of the view controller's presentation and its relationship
    /// with its parent controllers (like navigation controller or tab bar controller) to determine
    /// if it was presented modally.
    ///
    /// - Returns: `true` if the view controller is presented modally; otherwise, `false`.
    ///
    /// The determination is based on the following conditions:
    /// - The view controller is the `presentingViewController` of another view controller.
    /// - The view controller's navigation controller is the `presentedViewController` of its `presentingViewController`.
    /// - The view controller's tab bar controller's `presentingViewController` is a `UITabBarController`.
    ///
    /// Example usage:
    /// ```swift
    /// if myViewController.isModal {
    ///     // Perform actions knowing the view controller is presented modally.
    /// }
    /// ```
    var isModal: Bool {
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}

#endif
