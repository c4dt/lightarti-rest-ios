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
        .library(
            name: "lightarti-rest",
            targets: ["lightarti-rest"]),
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
        .testTarget(
            name: "lightarti-rest-iosTests",
            dependencies: ["lightarti-rest-ios"]),
      .binaryTarget(
          name: "lightarti-rest",
          // The following two comments are needed for the automatic update to work!
          url: "https://github.com/c4dt/lightarti-rest/releases/download/0.3.3/lightarti-rest.xcframework.zip", // XCFramework URL
          checksum: "3bed6395f065f98a1520ed80b21a40d5767afd219efa7066d3f43a1233cff80f" // XCFramework checksum
	   ),
// This is for local testing

//         .binaryTarget(
//             name: "lightarti-rest",
//             path: "./lightarti-rest.xcframework"),
    ]
)
