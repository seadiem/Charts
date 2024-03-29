// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChartsTGCmacOS",
    targets: [
        .target(
            name: "Charts",
            dependencies: []),
        .target(
            name: "ChartsApp",
            dependencies: ["Charts"],
            path: "Sources/macOS")
    ]
)
