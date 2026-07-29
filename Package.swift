// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "CodexCheatSheet",
    platforms: [.macOS(.v14)],
    targets: [
        .target(
            name: "CodexCheatSheetCore",
            path: "Sources/CodexCheatSheetCore"
        ),
        .executableTarget(
            name: "CodexCheatSheet",
            dependencies: ["CodexCheatSheetCore"],
            path: "Sources/CodexCheatSheet"
        ),
        .testTarget(
            name: "CodexCheatSheetTests",
            dependencies: ["CodexCheatSheetCore"],
            path: "Tests/CodexCheatSheetTests"
        ),
    ]
)
