// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftReq",
    products: [
        .library(
            name: "SwiftReq",
            targets: ["SwiftReq"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1"))
    ],
    targets: [
        .target(
            name: "SwiftReq",
            dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "SwiftReqTests",
            dependencies: ["SwiftReq"]
        ),
    ]
)
