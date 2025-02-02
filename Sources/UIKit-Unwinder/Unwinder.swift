import UIKit

@MainActor
public enum Unwinder {

    public static func unwind(
        from source: UIViewController,
        target selector: Selector,
        animated: Bool = true,
        parameter: Any? = nil
    ) {
        var current: UIResponder? = source
        while let responder = current {
            guard let vc = responder as? UIViewController,
                let child = vc.childForUnwind(selector: selector)
                else {
                current = responder.next
                continue
            }

            DispatchQueue.main.async {
                executeUnwind(for: child, parent: child, animated: animated) {
                    child.performSelector(onMainThread: selector, with: parameter, waitUntilDone: false)
                }
            }
            return
        }
    }

    private static func executeUnwind(
        for viewController: UIViewController,
        parent: UIViewController,
        animated: Bool = true,
        completion: @escaping @MainActor () -> Void
    ) {
        if let highParent = parent.parent {
            executeUnwind(for: parent, parent: highParent, animated: animated) {
                parent.executeUnwind(
                    forChild: viewController,
                    animated: animated,
                    completion: completion
                )
            }

            return
        }

        parent.executeUnwind(
            forChild: viewController,
            animated: animated,
            completion: completion
        )
    }
}
