// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MangaScraper",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MangaScraper",
            targets: ["MangaScraper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", branch: "master"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", branch: "master"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MangaScraper",
            dependencies: [
                "SwiftyJSON",
                "SwiftSoup",
            ]),
        .testTarget(
            name: "MangaScraperTests",
            dependencies: ["MangaScraper"]),
    ]
)
