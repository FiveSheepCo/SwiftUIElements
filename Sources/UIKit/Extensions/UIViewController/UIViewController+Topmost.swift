#if canImport(UIKit) && !os(watchOS)

import UIKit

public extension UIViewController {
    
    #if os(iOS)
    
    /// Computes the topmost `UIViewController` in the view controller hierarchy.
    ///
    /// This computed property navigates through various types of view controllers
    /// (such as `UISplitViewController`, `UINavigationController`, and `UITabBarController`)
    /// to determine the topmost view controller. It handles different scenarios where
    /// a view controller might be presented modally, or is part of a navigation or tab bar controller.
    ///
    /// - Returns: The topmost `UIViewController` in the hierarchy. If the hierarchy does not contain
    ///   any other view controller, it returns `self`.
    ///
    /// Example usage:
    /// ```swift
    /// let topViewController = controller.topmostViewController
    /// ```
    var topmostViewController : UIViewController {
        let controller : UIViewController
        
        if let presentedViewController = presentedViewController {
            controller = presentedViewController
        } else if let split = self as? UISplitViewController {
            controller = split.viewControllers.last ?? split
        } else if let navigationController = self as? UINavigationController {
            controller = navigationController.viewControllers.last ?? navigationController
        } else if let tabBarController = self as? UITabBarController {
            controller = tabBarController.selectedViewController ?? tabBarController
        } else {
            let visible = self.navigationController?.visibleViewController
            if visible == self || visible == self.navigationController || visible == self.tabBarController {
                return self
            } else {
                return visible?.topmostViewController ?? self
            }
        }
        
        return (controller == self) ? self : controller.topmostViewController
    }
    
    #elseif os(tvOS)
    
    /// Computes the topmost `UIViewController` in the view controller hierarchy.
    ///
    /// This computed property navigates through various types of view controllers
    /// (such as `UISplitViewController`, `UINavigationController`, and `UITabBarController`)
    /// to determine the topmost view controller. It handles different scenarios where
    /// a view controller might be presented modally, or is part of a navigation or tab bar controller.
    ///
    /// - Returns: The topmost `UIViewController` in the hierarchy. If the hierarchy does not contain
    ///   any other view controller, it returns `self`.
    ///
    /// Example usage:
    /// ```swift
    /// let topViewController = controller.topmostViewController
    /// ```
    var topmostViewController: UIViewController {
        let controller: UIViewController
        
        if let presentedViewController = presentedViewController {
            controller = presentedViewController
        } else if let split = self as? UISplitViewController {
            controller = split.viewControllers.last ?? split
        } else if let navigationController = self as? UINavigationController {
            controller = navigationController.viewControllers.last ?? navigationController
        } else if let tabBarController = self as? UITabBarController {
            controller = tabBarController.selectedViewController ?? tabBarController
        } else {
            let visible = self.navigationController?.visibleViewController
            return ((visible != self) ? visible : nil)?.topmostViewController ?? self
        }
        
        return (controller == self) ? self : controller.topmostViewController
    }
    
    #endif
}

#endif
