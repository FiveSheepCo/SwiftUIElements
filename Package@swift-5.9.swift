// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIElements",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "SwiftUIElements",
            targets: ["SwiftUIElements"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/FiveSheepCo/FoundationPlus", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "SwiftUIElements",
            dependencies: ["FoundationPlus"],
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "SwiftUIElementsTests",
            dependencies: ["SwiftUIElements"],
            linkerSettings: [
                .linkedFramework(
                    "XCTest",
                    .when(platforms: [.macOS, .iOS, .tvOS, .watchOS])
                )
            ]
        ),
    ]
)
