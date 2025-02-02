// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "UIKit-Unwinder",
    products: [
        .library(
            name: "UIKit-Unwinder",
            targets: ["UIKit-Unwinder"]
        ),
    ],
    targets: [
        .target(
            name: "UIKit-Unwinder"
        ),
    ]
)
