// swift-tools-version: 6.1
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "MacrosDemo",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "MacrosDemo",
            targets: ["MacrosDemo"]
        ),
        .executable(
            name: "MacrosDemoClient",
            targets: ["MacrosDemoClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "MacrosDemoMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "MacrosDemo", dependencies: ["MacrosDemoMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "MacrosDemoClient", dependencies: ["MacrosDemo"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "MacrosDemoTests",
            dependencies: [
                "MacrosDemoMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
