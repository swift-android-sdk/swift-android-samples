// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ATMProject",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ATMPackage", targets: ["ATMPackage"]),
        .executable(name: "ATMCLI", targets: ["ATMCLI"])
    ],
    targets: [
        // C++ library target
        .target(
            name: "ATMWithdrawCpp",
            path: "Sources/ATMWithdrawCpp",
            publicHeadersPath: "include",
            cxxSettings: [
                .headerSearchPath("include"),
                .define("SWIFT_PACKAGE")
            ]
        ),
        // Swift wrapper target
        .target(
            name: "ATMPackage",
            dependencies: ["ATMWithdrawCpp"],
            path: "Sources/ATMPackage",
            swiftSettings: [
                // enable C++ interop
                .interoperabilityMode(.Cxx)
            ]
        ),
        // CLI executable target
        .executableTarget(
            name: "ATMCLI",
            dependencies: ["ATMPackage"],
            path: "Sources/ATMCLI",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        )
    ]
)
