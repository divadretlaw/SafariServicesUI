// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SafariServicesUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SafariServicesUI",
            targets: ["SafariServicesUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/divadretlaw/URL-Extensions.git", from: "1.0.0"),
        .package(url: "https://github.com/divadretlaw/WindowSceneReader.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "SafariServicesUI",
            dependencies: [
                .product(name: "URLExtensions", package: "URL-Extensions"),
                .product(name: "WindowSceneReader", package: "WindowSceneReader")
            ]
        )
    ]
)