// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Executor",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "Executor",
            targets: ["Executor"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(path: "../../../Actions/SampleAction")
    ],
    targets: [
        .executableTarget(
            name: "Executor",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SampleAction", package: "SampleAction")
            ],
            path: "Sources"),
        .testTarget(
            name: "ExecutorTests",
            dependencies: ["Executor"]),
    ]
)
