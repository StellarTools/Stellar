// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestAction",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "TestActionCLI",
            targets: ["TestActionCLI"]),
        .library(
            name: "TestAction",
            targets: ["TestAction"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.1.4"),
        .package(url: "https://github.com/JohnSundell/ShellOut", exact: "2.3.0")
    ],
    targets: [
        .executableTarget(
            name: "TestActionCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "TestAction")
            ],
            path: "Sources/CLI"),
        .target(
            name: "TestAction",
            dependencies: [
                .product(name: "ShellOut", package: "ShellOut")
            ],
            path: "Sources/Action"),
        .testTarget(
            name: "TestActionTests",
            dependencies: ["TestAction"],
            path: "Tests"
        )
    ]
)
