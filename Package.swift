// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "CodexCheatSheet",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "CodexCheatSheet",
            path: "Sources/CodexCheatSheet"
        )
    ]
)
