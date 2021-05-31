// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "arti-ios",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "arti-ios",
            targets: ["arti-ios"]),
        .library(
            name: "arti_rest",
            targets: ["arti_rest"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "arti-ios",
            dependencies: ["arti_rest"]),
        .testTarget(
            name: "arti-iosTests",
            dependencies: ["arti-ios"]),
        .binaryTarget(
            name: "arti_rest",
            url: "https://github.com/c4dt/arti-rest/releases/download/0.0.2/arti-rest.xcframework.zip",
            checksum: "e0cf05cacacc66e8080f0ba06c56b119e884df31aa1f3735d2b59ff918f0abd1")
    ]
)
