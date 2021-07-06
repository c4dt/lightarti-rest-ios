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
           // The following two comments are needed for the automatic update to work!
           url: "https://github.com/c4dt/arti-rest/releases/download/0.2.0-2/arti-rest.xcframework.zip", // XCFramework URL
           checksum: "24acb5cb06de9d27943319108d5baad52bc84e14886141963309d079f17cd0b9" // XCFramework checksum
// This is for local testing
//         .binaryTarget(
//             name: "arti-rest",
//             path: "./arti-rest.xcframework"),
    ]
)
