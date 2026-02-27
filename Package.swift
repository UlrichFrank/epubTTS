// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "epubTTS",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "epubTTS", targets: ["epubTTSApp"]),
        .library(name: "epubTTSCore", targets: ["epubTTSCore"]),
        .library(name: "epubTTSReader", targets: ["epubTTSReader"]),
    ],
    dependencies: [
        // Add external dependencies here if needed
    ],
    targets: [
        .target(
            name: "epubTTSCore",
            dependencies: [],
            path: "Sources/Core"
        ),
        .target(
            name: "epubTTSReader",
            dependencies: ["epubTTSCore"],
            path: "Sources/Reader",
            linkerSettings: [
                .linkedFramework("CoreData"),
                .linkedFramework("SwiftUI")
            ]
        ),
        .executableTarget(
            name: "epubTTSApp",
            dependencies: ["epubTTSCore", "epubTTSReader"],
            path: "Sources/App",
            linkerSettings: [
                .linkedFramework("SwiftUI"),
                .linkedFramework("AVFoundation")
            ]
        ),
        .testTarget(
            name: "epubTTSTests",
            dependencies: ["epubTTSCore", "epubTTSReader"],
            path: "Tests/epubTTSTests"
        ),
    ]
)
