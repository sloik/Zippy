// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Zippy",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Zippy",
            type: .dynamic,
            targets: ["Zippy"]
        ),
    ],
    dependencies: [
        .package(
          url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
          from: "1.18.4"
        ),

        .package(
          url: "https://github.com/sloik/AliasWonderland.git",
          from: "4.0.1"
        ),

        .package(
          url: "https://github.com/sloik/EitherSwift.git",
          from: "1.2.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Zippy",
            dependencies: [
                "AliasWonderland",
                "EitherSwift"
            ]
        ),

        .testTarget(
            name: "ZippyTests",
            dependencies: [
                "Zippy",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "EitherSwift", package: "EitherSwift"),
            ]
        ),
    ]
)
