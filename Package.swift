// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OtInternet",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "OtInternetCore", targets: ["OtInternetCore"])
    ],
    targets: [
        .target(name: "OtInternetCore", path: "OtInternet/Core"),
        .testTarget(name: "OtInternetCoreTests", dependencies: ["OtInternetCore"], path: "Tests/OtInternetCoreTests")
    ]
)
