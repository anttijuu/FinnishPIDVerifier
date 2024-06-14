// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FinnishPIDVerifier",
	 defaultLocalization: "en",
	 platforms: [.iOS(.v14),
					 .macOS(.v10_13),
					 .watchOS(.v7),
					 .tvOS(.v14),
					 .macCatalyst(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FinnishPIDVerifier",
            targets: ["FinnishPIDVerifier"]),
    ],
	 dependencies: [.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FinnishPIDVerifier",
				swiftSettings: [
					.enableExperimentalFeature("StrictConcurrency")
				]
		  ),
        .testTarget(
            name: "FinnishPIDVerifierTests",
            dependencies: ["FinnishPIDVerifier"]),
    ]
)
