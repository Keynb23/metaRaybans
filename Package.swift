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
        // The Meta Wearables SDK - Using version 0.3.0 as found in latest tags
        .package(url: "https://github.com/facebook/meta-wearables-dat-ios.git", from: "0.3.0")
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
