// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "semantique",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "semantique",
            targets: ["semantique"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/kyouko-taiga/anzen", .branch("master")),
        .package(url: "https://github.com/kyouko-taiga/LogicKit", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "semantique",
            dependencies: ["AnzenLib", "LogicKit"]),
        .testTarget(
            name: "semantiqueTests",
            dependencies: ["semantique", "AnzenLib", "LogicKit"]),
    ]
)
