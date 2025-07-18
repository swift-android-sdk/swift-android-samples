// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "LibraryDemo",
    products: [
        .library(
            name: "LibraryDemo",
            targets: ["LibraryDemo"]
        ),
    ],
    targets: [
        .target(
            name: "LibraryDemo"
        ),
        .testTarget(
            name: "LibraryDemoTests",
            dependencies: ["LibraryDemo"]
        ),
    ]
)
