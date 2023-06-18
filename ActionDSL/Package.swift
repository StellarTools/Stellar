// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ActionDSL",
    products: [
        .library(
            name: "ActionDSL",
            targets: ["ActionDSL"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "ActionDSL",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "ActionDSLTests",
            dependencies: ["ActionDSL"]),
    ]
)
