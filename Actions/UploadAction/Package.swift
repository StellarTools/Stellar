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
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .executableTarget(
            name: "UploadActionCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "UploadAction")
            ],
            path: "Sources/CLI"),
        .target(
            name: "UploadAction",
            path: "Sources/Action"),
        .testTarget(
            name: "UploadActionTests",
            dependencies: ["UploadAction"],
            path: "Tests"),
    ]
)
