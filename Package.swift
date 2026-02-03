// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MetaRaybansApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "MetaRaybansApp", targets: ["MetaRaybansApp"]),
    ],
    dependencies: [
        // The Meta Wearables SDK
        .package(url: "https://github.com/facebook/meta-wearables-dat-ios", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MetaRaybansApp",
            dependencies: [
                .product(name: "Wearables", package: "meta-wearables-dat-ios")
            ],
            path: "MetaRaybansApp/Sources"
        ),
        .testTarget(
            name: "MetaRaybansAppTests",
            dependencies: ["MetaRaybansApp"],
            path: "MetaRaybansApp/Tests"
        ),
    ]
)
