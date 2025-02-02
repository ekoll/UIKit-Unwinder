import UIKit

@MainActor
public enum Unwinder {

    public static func unwind(
        from source: UIViewController,
        target selector: Selector,
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
                executeUnwind(for: child, parent: child) {
                    child.performSelector(onMainThread: selector, with: parameter, waitUntilDone: false)
                }
            }
            return
        }
    }

    private static func executeUnwind(
        for viewController: UIViewController,
        parent: UIViewController,
        completion: @escaping @MainActor () -> Void
    ) {
        if let highParent = parent.parent {
            executeUnwind(for: parent, parent: highParent) {
                parent.executeUnwind(forChild: viewController, completion: completion)
            }

            return
        }

        parent.executeUnwind(forChild: viewController, completion: completion)
    }
}
