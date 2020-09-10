// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "uplink-swift",
    products: [
        .library(
            name: "uplink-swift",
            targets: ["uplink-swift"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "uplink-swift",
            dependencies: ["libuplink"]),
        .target(
        name: "libuplink",
        dependencies: []),
        .testTarget(
            name: "uplink-swiftTests",
            dependencies: ["uplink-swift"],
            path: "test/uplink-swiftTests")
    ]
)
