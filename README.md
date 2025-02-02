# UIKit-Unwinder

A little bit late invention to do unwind operations for UIKit developers that does not use storyboards. With this library, now you are able to unwind operations even with programmatic UI development approach(with `UIKit`).

Supported Containers

- [x] `UINavigationController`
- [x] `UITabbarController`
- [ ] `UIPageViewController`
- [ ] `UISplitViewController`
- [x] `Your Custom Containers`

## Usage

In your target view controller create an unwind point method. Your unwind method must be ```@objc``` method.

```swift
class MyCustomViewController: UIViewController {
    // Content of your ViewController...

    @objc func unnwindToMe() {
        // Your unwind logic
    }
}

```

and call Unwinder from your unwind source

```swift
Unwinder.unwind(from: myCurrentViewController, target: #selector(MyCustomViewController.unwindToMe))
```

## Passing parameter

You can also pass one parameter via this unwind operation

Just add your parameter to your unwind point method

```swift
    @objc func unnwindToMe(_ parameter: Any) {
        // You may need binding here
        guard let parameter = parameter as? MyCustomType else { return }
        // Your unwind logic
    }

```

and send corresponding value for your parameter

```swift
Unwinder.unwind(
    from: myCurrentViewController,
    target: #selector(MyCustomViewController.unwindToMe),
    parameter: MyCustomType()
)
```

## Usage for custom containers

If you use a custom container mechanism to present your ```ViewController```s inside (like ```UINavigationController``` or ```UITabbarController```) you must implement these two methods to manage unwind operation in your container

### ```childForUnwind(selector:)```

You should finds the target ```ViewController``` of unwind operation in its child ```ViewController```(s) and return. Maybe your container can be the target, so it can return itself when needed

### ```executeUnwind(forChild)```

You should manage transition operation from current presenting ```ViewController``` to target ```ViewController``` in here. All the transitions between these screens in your container is managed here