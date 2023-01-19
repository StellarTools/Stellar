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
            name: "stellarenv",
            targets: ["stellarenv"]),
        .library(
            name: "Stellar",
            targets: ["Stellar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", .upToNextMajor(from: "2.3.0"))
    ],
    targets: [
        .executableTarget(
            name: "stellarenv",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "Stellar")
            ],
            path: "Sources/stellarenv"
        ),
        .executableTarget(
            name: "StellarCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "Stellar")],
            path: "Sources/CLI"),
        .target(
            name: "Stellar",
            dependencies: [
                .product(name: "ShellOut", package: "ShellOut"),
                .product(name: "StencilSwiftKit", package: "StencilSwiftKit")
            ],
            path: "Sources/Core"),
        .testTarget(
            name: "StellarTests",
            dependencies: ["Stellar"]),
    ]
)
