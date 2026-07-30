# CodexCheatSheet — agent notes

SwiftUI macOS app (Swift Package). Prefer move over copy; do not redesign features.

## Folder layout

| Path | Purpose |
|------|---------|
| `Sources/CodexCheatSheetCore/` | Models, static content, SwiftUI views (library) |
| `Sources/CodexCheatSheet/` | `@main` app entry (executable) |
| `Tests/CodexCheatSheetTests/` | Unit tests (`swift test`) |
| `scripts/` | App launcher (`launch-cheatsheet.zsh`) and ChatGPT paired watcher (install/uninstall LaunchAgent) |
| `.github/workflows/` | CI (build + test on macOS) |
| `docs/` | Audit and remediation reports only |
| Root | `README.md`, `AGENTS.md`, `.gitignore`, `Package.swift` only |

Do **not** create speculative top-level folders (`config/`, `data/`, `assets/`, `archive/`) unless a concrete need is agreed. `scripts/` exists for the ChatGPT paired watcher.

## Content ownership

- Browser copy-ready text: `CheatSheetContent` (aggregates Codex + `OpenClawContent` + `ClaudeContent`)
- Builder `{{token}}` templates: `BuilderContent`
- Update paired use-cases in both places when wording changes.

Do not invent new top-level folders without asking. Do not commit secrets or personal machine inventory. Ignore local IDE workspace files (`*.code-workspace`).
