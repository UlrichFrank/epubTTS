// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "epubTTS",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .executable(name: "epubTTS", targets: ["epubTTSApp"]),
        .library(name: "epubTTSCore", targets: ["epubTTSCore"]),
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
        .executableTarget(
            name: "epubTTSApp",
            dependencies: ["epubTTSCore"],
            path: "Sources/App",
            linkerSettings: [
                .linkedFramework("SwiftUI"),
                .linkedFramework("AVFoundation")
            ]
        ),
        .testTarget(
            name: "epubTTSTests",
            dependencies: ["epubTTSCore"],
            path: "Tests/epubTTSTests"
        ),
    ]
)
