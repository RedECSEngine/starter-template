// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "RedECS-starter-template",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "GameShared",
            targets: ["GameShared"]
        ),
        .executable(
            name: "GameMetal",
            targets: ["GameMetal"]
        ),
        .executable(
            name: "GameWeb",
            targets: ["GameWeb"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/RedECSEngine/RedECS.git", from: "0.0.5")
    ],
    targets: [
        .target(
            name: "GameShared",
            dependencies: [
                .product(name: "RedECSKit", package: "RedECS")
            ]
        ),
        
        .executableTarget(
            name: "GameMetal",
            dependencies: [
                "GameShared",
                .product(name: "RedECSAppleSupport", package: "RedECS")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        
        .executableTarget(
            name: "GameWeb",
            dependencies: [
                "GameShared",
                .product(name: "RedECSWebSupport", package: "RedECS")
            ],
            resources: [
                .copy("Resources")
            ]
        ),
    ]
)
