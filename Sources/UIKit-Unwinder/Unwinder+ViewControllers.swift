import UIKit

// MARK: - UIViewController

extension UIViewController {
    private var isPresenting: Bool { viewIfLoaded?.window != nil && presentedViewController == nil }

    @objc public func childForUnwind(selector: Selector) -> UIViewController? {
        responds(to: selector) ? self : nil
    }

    @objc public func executeUnwind(
        forChild viewController: UIViewController,
        animated: Bool = true,
        completion: @escaping @MainActor () -> Void
    ) {
        var controller = self
        var isOnBackground = true
        while let parent = controller.parent {
            if parent.isPresenting {
                isOnBackground = false
                break
            }

            controller = parent
        }

        if isOnBackground {
            dismiss(animated: animated, completion: completion)
            return
        }
        completion()
    }
}

// MARK: - UINavigationController

extension UINavigationController {
    public override func childForUnwind(selector: Selector) -> UIViewController? {
        for viewController in viewControllers {
            if let child = viewController.childForUnwind(selector: selector) {
                return child
            }
        }

        return responds(to: selector) ? self : nil
    }

    public override func executeUnwind(
        forChild viewController: UIViewController,
        animated: Bool = true,
        completion: @escaping @MainActor () -> Void
    ) {
        if viewController == self {
            super.executeUnwind(forChild: viewController, animated: animated, completion: completion)
            return
        }

        popToViewController(viewController, animated: animated)
        DispatchQueue.main.async(execute: completion)
    }
}

// MARK: - UITabBarController

extension UITabBarController {
    public override func childForUnwind(selector: Selector) -> UIViewController? {
        guard let viewControllers = viewControllers else {
            return responds(to: selector) ? self : nil
        }

        for viewController in viewControllers {
            if let child = viewController.childForUnwind(selector: selector) {
                return child
            }
        }

        return responds(to: selector) ? self : nil
    }

    public override func executeUnwind(
        forChild viewController: UIViewController,
        animated: Bool = true,
        completion: @escaping @MainActor () -> Void
    ) {
        if viewController == self {
            super.executeUnwind(forChild: viewController, animated: animated, completion: completion)
            return
        }

        if animated {
            selectedViewController = viewController
        } else {
            UIView.performWithoutAnimation {
                selectedViewController = viewController
            }
        }
        DispatchQueue.main.async(execute: completion)
    }
}
