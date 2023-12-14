#if canImport(UIKit) && !os(watchOS)

import UIKit

public extension UIViewController {
    
    /// Presents a given view controller using a private implementation.
    ///
    /// This private method provides a mechanism to present a view controller recursively.
    /// It checks if there is already a presented view controller. If so, it calls itself
    /// on the presented view controller, effectively chaining the presentation until a view
    /// controller with no currently presented view controller is found. Then, it presents
    /// the new view controller on this final view controller in the chain.
    ///
    /// - Parameter viewController: The `UIViewController` to be presented.
    ///
    /// Note: This function is unavailable in iOS application extensions and is meant for internal use only.
    ///
    /// Example usage (internal):
    /// ```swift
    /// self._present(anotherViewController)
    /// ```
    @available(iOSApplicationExtension, unavailable)
    internal func _present(_ viewController: UIViewController) {
        guard let presentedViewController = presentedViewController else {
            self.present(viewController)
            return
        }
        presentedViewController._present(viewController)
    }
    
    /// Presents a view controller animatedly.
    ///
    /// This convenience function presents a view controller with a default animation and no completion handler.
    /// It serves as a simplified way to present a view controller without specifying the animation and completion details.
    ///
    /// - Parameter viewController: The `UIViewController` to be presented.
    ///
    /// Example usage:
    /// ```swift
    /// someViewController.present(anotherViewController)
    /// ```
    func present(_ viewController: UIViewController){
        present(viewController, animated: true, completion: nil)
    }
    
    /// Presents the responder inside a `UINavigationController`.
    ///
    /// - Parameters:
    ///   - animated : Whether to animate the presentation.
    ///   - addingDoneButton : Whether to add a `UIBarButtonItem` with `UIBarButtonSystemItem.done` to the `rightBarButtonItems`.
    ///   - addingCancelButton : Whether to add a `UIBarButtonItem` with `UIBarButtonSystemItem.cancel` to the `leftBarButtonItems`.
    ///   - completion : Called after the presentation has completed.
    func presentWithNavigationController(
        viewControllerToPresent: UIViewController,
        animated: Bool = true,
        addingDoneButton: Bool = false,
        addingCancelButton: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        if addingDoneButton {
            viewControllerToPresent.navigationItem.rightBarButtonItems = (viewControllerToPresent.navigationItem.rightBarButtonItems ?? []) + [UIBarButtonItem(barButtonSystemItem: .done, target: viewControllerToPresent, action: #selector(dismiss(animated:completion:)))] // TODO: Look if this adds it to the right direction
        }
        if addingCancelButton {
            viewControllerToPresent.navigationItem.leftBarButtonItems = (viewControllerToPresent.navigationItem.leftBarButtonItems ?? []) + [UIBarButtonItem(barButtonSystemItem: .cancel, target: viewControllerToPresent, action: #selector(dismiss(animated:completion:)))] // TODO: Look if this adds it to the right direction
        }
        
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        present(navigationController, animated: animated, completion: completion)
    }
}

#endif
