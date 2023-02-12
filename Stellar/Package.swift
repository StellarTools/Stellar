// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stellar",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "StellarCLI",
            targets: ["StellarCLI"]),
        .library(
            name: "StellarCore",
            targets: ["StellarCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", .upToNextMajor(from: "2.3.0"))
    ],
    targets: [
        .executableTarget(
            name: "StellarCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "StellarCore")],
            path: "Sources/CLI"),
        .target(
            name: "StellarCore",
            dependencies: [
                .product(name: "ShellOut", package: "ShellOut"),
                .product(name: "StencilSwiftKit", package: "StencilSwiftKit")
            ],
            path: "Sources/Core",
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "StellarCLITests",
            dependencies: ["StellarCLI"],
            path: "Tests/CLI"),
        .testTarget(
            name: "StellarCoreTests",
            dependencies: ["StellarCore"],
            path: "Tests/Core")
    ]
)
