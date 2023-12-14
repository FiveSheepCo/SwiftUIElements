#if canImport(UIKit) && !os(watchOS)

import UIKit

public extension UIViewController {
    
    /// Enumerates the methods for displaying a `UIViewController`.
    ///
    /// `ShowType` defines how a view controller should be presented in the user interface.
    /// It is utilized in conjunction with methods that require specifying the presentation style,
    /// such as transitioning between view controllers.
    enum ShowType {
        
        /// Represents a modal presentation style for view controllers.
        /// In this mode, the view controller is presented over the current context,
        /// usually with an animation that slides the new view controller into view.
        case present
        
        /// Represents a push presentation style within a navigation stack.
        /// This style is used to push the view controller onto an existing navigation stack,
        /// resulting in a horizontal slide animation from the right.
        case push
    }
    
    /// Enumerates possible container types for `UIViewController`.
    ///
    /// `Container` represents different kinds of container view controllers that can be used to
    /// manage a hierarchy of view controllers. This enumeration provides a way to specify the type of container
    /// that should encapsulate a given view controller. It currently supports navigation controller containers,
    /// but can be expanded to include other types like tab bar controllers or custom container view controllers.
    enum Container {
        
        /// Represents a `UINavigationController` container.
        /// Use this case to encapsulate a view controller in a `UINavigationController`.
        case navigationController

        /// Wraps a `UIViewController` in the specified container type.
        ///
        /// This method creates a new instance of a container view controller and embeds the specified
        /// view controller in it, based on the container type defined by the enum case.
        /// Currently, it supports creating a `UINavigationController` with the given view controller as the root.
        ///
        /// - Parameter controller: The `UIViewController` to be encapsulated in the container.
        /// - Returns: A `UIViewController` instance, which is the provided controller encapsulated in the
        ///   specified container type. For `navigationController`, it returns an instance of `UINavigationController`
        ///   with the `controller` as its root view controller.
        ///
        /// Example usage:
        /// ```swift
        /// let navController = Container.navigationController.wrap(myViewController)
        /// // `navController` is a `UINavigationController` with `myViewController` as the root.
        /// ```
        func wrap(_ controller: UIViewController) -> UIViewController {
            switch self {
            case .navigationController:
                UINavigationController(rootViewController: controller)
            }
        }
    }

    
    /// Displays the responder within a specified container and using a defined show type.
    ///
    /// This function manages the presentation of the responder (typically a view controller) in the application's
    /// window. It leverages the `topmostViewController` property to ensure that the responder is shown on top of
    /// the current view controller hierarchy. The presentation can be either a push onto a navigation stack or a modal presentation,
    /// depending on the `type` parameter.
    ///
    /// - Parameters:
    ///   - container: An optional `Container` in which the responder should be shown. If `nil`, the responder itself is used.
    ///   - type: The `ShowType` enum value indicating whether to push the responder onto a navigation stack
    ///     or present it modally.
    ///
    /// Note: This function is unavailable in iOS application extensions.
    ///
    /// Usage:
    /// ```swift
    /// responder.show(in: someContainer, type: .push) // Push the responder onto the navigation stack.
    /// responder.show(in: someContainer, type: .present) // Present the responder modally.
    /// ```
    @available(iOSApplicationExtension, unavailable)
    func show(in container: Container? = nil, type: ShowType) {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        let actualController = container?.wrap(self) ?? self
        
        switch type {
        case .push:
            rootViewController.topmostViewController.navigationController?.pushViewController(actualController, animated: true)
        case .present:
            rootViewController._present(actualController)
        }
    }
        
    /// Shows the responder modally within a specified container.
    ///
    /// This convenience function calls the `show(in:type:)` method with the `type` parameter set to `.present`,
    /// resulting in a modal presentation of the responder. It is useful when you don't need to specify the type of presentation
    /// and want to present modally by default.
    ///
    /// - Parameter container: An optional `Container` in which to show the responder. If `nil`, the responder itself is used.
    ///
    /// Note: This function is unavailable in iOS application extensions.
    ///
    /// Usage:
    /// ```swift
    /// responder.show(in: someContainer) // Present the responder modally.
    /// ```
    @available(iOSApplicationExtension, unavailable)
    func show(in container: Container? = nil) {
        show(in: container, type: .present)
    }
}

#endif
