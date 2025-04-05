// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SafariServicesUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SafariServicesUI",
            targets: ["SafariServicesUI"]
        ),
        .library(
            name: "AuthenticationServicesUI",
            targets: ["AuthenticationServicesUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/divadretlaw/URL-Extensions.git", from: "2.0.0"),
        .package(url: "https://github.com/divadretlaw/WindowReader.git", from: "3.0.0"),
        .package(url: "https://github.com/divadretlaw/WindowSceneReader.git", from: "3.2.0")
    ],
    targets: [
        .target(
            name: "SafariServicesUI",
            dependencies: [
                .product(name: "URLExtensions", package: "URL-Extensions"),
                .product(name: "WindowReader", package: "WindowReader"),
                .product(name: "WindowSceneReader", package: "WindowSceneReader")
            ]
        ),
        .target(
            name: "AuthenticationServicesUI",
            dependencies: ["SafariServicesUI"]
        )
    ]
)
