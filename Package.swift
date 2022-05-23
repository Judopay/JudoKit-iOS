// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JudoKit_iOS",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "JudoKit_iOS",
            targets: ["JudoKit_iOSTarget"])
    ],
    dependencies: [
        .package(url: "https://github.com/Judopay/DeviceDNA-iOS", from: "2.0.0"),
        .package(url: "https://github.com/datatheorem/TrustKit", .exact("1.7.0")),
        .package(url: "https://github.com/Judopay/pbba-merchant-button-library-ios", from: "3.1.3")
    ],
    targets: [
        .target(
            name: "JudoKit_iOSTarget",
            dependencies: ["DeviceDNA-iOS", "TrustKit", "pbba-merchant-button-library-ios"],
            path: "Source",
            resources: [
                .process("../Resources", localization: Resource.Localization.default)
            ])
    ])
