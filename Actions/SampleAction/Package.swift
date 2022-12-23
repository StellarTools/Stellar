// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SampleAction",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "SampleActionCLI",
            targets: ["SampleActionCLI"]),
        .library(
            name: "SampleAction",
            targets: ["SampleAction"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .executableTarget(
            name: "SampleActionCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "SampleAction")
            ],
            path: "Sources/CLI"),
        .target(
            name: "SampleAction",
            path: "Sources/Action"),
        .testTarget(
            name: "SampleActionTests",
            dependencies: ["SampleAction"],
            path: "Tests"),
    ]
)
