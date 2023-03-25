// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScanAction",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "ScanActionCLI",
            targets: ["ScanActionCLI"]),
        .library(
            name: "ScanAction",
            targets: ["ScanAction"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/StellarTools/Stellar.git", branch: "scan-action")
    ],
    targets: [
        .executableTarget(
            name: "ScanActionCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "StellarCore", package: "Stellar")
            ],
            path: "Sources/CLI"),
        .target(
            name: "ScanAction",
            path: "Sources/Action"),
        .testTarget(
            name: "ScanActionTests",
            dependencies: ["ScanAction"],
            path: "Tests"),
    ]
)
