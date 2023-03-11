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
        .executable(
            name: "StellarEnv",
            targets: ["StellarEnv"]),
        .library(
            name: "StellarCore",
            targets: ["StellarCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .upToNextMajor(from: "0.5.2")),
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
                .product(name: "StencilSwiftKit", package: "StencilSwiftKit"),
                .product(name: "TSCBasic", package: "swift-tools-support-core")
            ],
            path: "Sources/Core",
            resources: [.copy("Resources")]),
        .executableTarget(
            name: "StellarEnv",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "StellarCore")],
            path: "Sources/Env"),
        .testTarget(
            name: "StellarCLITests",
            dependencies: ["StellarCLI"],
            path: "Tests/CLI"),
        .testTarget(
            name: "StellarCoreTests",
            dependencies: ["StellarCore"],
            path: "Tests/Core",
            resources: [.copy("Resources")]),
        .testTarget(
            name: "StellarEnvTests",
            dependencies: ["StellarEnv"],
            path: "Tests/Env")
    ]
)
