// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "HTTPToast",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "HTTPToast",
            targets: ["HTTPToast"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HTTPToast"
        )
    ],
    swiftLanguageVersions: [.v5]
)
