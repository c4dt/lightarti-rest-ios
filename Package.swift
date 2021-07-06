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
            name: "arti-rest",
            targets: ["arti-rest"]),
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
            dependencies: ["arti-rest"]),
        .testTarget(
            name: "arti-iosTests",
            dependencies: ["arti-ios"]),
       .binaryTarget(
           name: "arti-rest",
           url: "https://github.com/c4dt/arti-rest/releases/download/0.0.4/arti-rest.xcframework.zip",
           checksum: "5766dec53c103ef80c0c0d68cff5d1acbf73e390a5c108e6089954b9d90a8f78"),
// This is for local testing
//         .binaryTarget(
//             name: "arti-rest",
//             path: "./arti-rest.xcframework"),
    ]
)
