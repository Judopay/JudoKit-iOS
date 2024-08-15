// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JudoKit_iOS",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "JudoKit_iOS",
            targets: ["JudoKit_iOS"])
    ],
    dependencies: [
        .package(url: "https://github.com/Judopay/DeviceDNA-iOS", exact: "2.1.2"),
        .package(url: "https://github.com/Judopay/Judo3DS2-iOS", exact: "1.2.2"),
        .package(url: "https://github.com/datatheorem/TrustKit", from: "3.0.4"),
        .package(url: "https://github.com/unravelin/ravelin-encrypt-ios-xcframework-distribution", exact: "1.1.2")
    ],
    targets: [
        .target(
            name: "JudoKit_iOS",
            dependencies: [
                .product(name: "DeviceDNA", package: "DeviceDNA-iOS"),
                .product(name: "Judo3DS2_iOS", package: "Judo3DS2-iOS"),
                .product(name: "TrustKit", package: "TrustKit"),
                .product(name: "RavelinEncrypt", package: "ravelin-encrypt-ios-xcframework-distribution")
            ],
            path: "Source",
            resources: [
                .process("Resources")
            ])
    ])
