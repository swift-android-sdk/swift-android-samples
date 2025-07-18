// swift-tools-version: 5.10
import PackageDescription

let package = Package(name: "android-fetchurl",
    platforms: [.iOS(.v14), .macOS(.v12)],
    targets: [.executableTarget(name: "android-fetchurl")]
)
