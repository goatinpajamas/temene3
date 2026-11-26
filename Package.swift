// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TemeneCore",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [.library(name: "TemeneCore", targets: ["TemeneCore"])],
    targets: [
        .target(name: "TemeneCore"),
        .testTarget(name: "TemeneCoreTests", dependencies: ["TemeneCore"]),
    ]
)
