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
        .product(name: "DeviceDNA", package: "DeviceDNA-iOS"),
        "TrustKit",
        .product(name: "ZappMerchantLib", package: "pbba-merchant-button-library-ios")
    ],
    targets: [
        .target(
            name: "JudoKit_iOSTarget",
            dependencies: [
                .product(name: "DeviceDNA", package: "DeviceDNA-iOS"),
                .target(name: "TrustKitTarget"),
                .target(name: "ZappMerchantLibTarget")
            ],
            path: "Source",
            resources: [
                .process("../Resources", localization: Resource.Localization.default)
            ])
    ])
