// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UploadAction",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "UploadActionCLI",
            targets: ["UploadActionCLI"]),
        .library(
            name: "UploadAction",
            targets: ["UploadAction"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        // This is just a temporary solution
        .package(path: "../../Stellar")
    ],
    targets: [
        .executableTarget(
            name: "UploadActionCLI",
            dependencies: [
                "UploadAction",
                .product(name: "StellarCore", package: "Stellar"),
                .product(name: "StellarActionCore", package: "Stellar")
            ],
            path: "Sources/CLI"),
        .target(
            name: "UploadAction",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "StellarCore", package: "Stellar"),
                .product(name: "StellarActionCore", package: "Stellar")
            ],
            path: "Sources/Action"),
        .testTarget(
            name: "UploadActionTests",
            dependencies: ["UploadAction"],
            path: "Tests"),
    ]
)
