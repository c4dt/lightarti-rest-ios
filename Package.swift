// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "lightarti-rest-ios",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "lightarti-rest-ios",
            targets: ["lightarti-rest-ios"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "lightarti-rest-ios",
            dependencies: ["lightarti-rest"]),
      .binaryTarget(
          name: "lightarti-rest",
          // The following two comments are needed for the automatic update to work!
          url: "https://github.com/c4dt/lightarti-rest/releases/download/0.4.9/lightarti-rest.xcframework.zip", // XCFramework URL
          checksum: "42d2ce6b80289824afbf870ed15e4bcb76720fa8be87ef6c704d1320f28063d0" // XCFramework checksum
	   ),
// This is for local testing

//         .binaryTarget(
//             name: "lightarti-rest",
//             path: "./lightarti-rest.xcframework"),
    ]
)
