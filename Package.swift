// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JudoKit_iOS",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "JudoKit_iOS",
            targets: ["JudoKit_iOS"])
    ],
    dependencies: [
        .package(url: "https://github.com/Judopay/DeviceDNA-iOS", from: "2.0.0"),
        .package(url: "https://github.com/Judopay/Judo3DS2-iOS", from: "1.1.4"),
        .package(url: "https://github.com/datatheorem/TrustKit", exact: "1.7.0")
    ],
    targets: [
        .target(
            name: "JudoKit_iOS",
            dependencies: [
                .product(name: "DeviceDNA", package: "DeviceDNA-iOS"),
                .product(name: "Judo3DS2_iOS", package: "Judo3DS2-iOS"),
                .product(name: "TrustKit", package: "TrustKit")
            ],
            path: "Source",
            resources: [
                .process("Resources")
            ])
    ])
