# Codex Cheat Sheet

Native SwiftUI macOS app from OpenAI Codex prompting cheat sheet guidance: browse sections/templates and build prompts with fill-in blanks. Runs fully offline — no network I/O.

Content is hardcoded in Swift (the original PDF/guide is not vendored in this repo).

## Requirements

- **macOS 14+**
- **Xcode** with SwiftUI support (Swift macros)

## Run

```bash
swift build
swift run
```

Or from zsh:

```bash
./scripts/launch-cheatsheet.zsh
```

Or open `Package.swift` in Xcode and press Cmd+R.

## Test

```bash
swift test
```

## Where things live

- `Sources/CodexCheatSheetCore/` — models, static content (Codex + OpenClaw + Claude), and SwiftUI views (library)
- `Sources/CodexCheatSheet/` — `@main` app entry (executable)
- `Tests/CodexCheatSheetTests/` — unit tests
- `scripts/` — launch helper (`launch-cheatsheet.zsh`) and ChatGPT paired watcher (install/uninstall LaunchAgent)
- `Package.swift` — Swift package config
- `AGENTS.md` — folder rules for this repo
- `docs/` — audit and remediation reports

## Content ownership

- **Browser tab** (`CheatSheetContent`) owns copy-ready cheat-sheet wording (bracket placeholders).
- Claude Cowork/Skills browser copy lives in `ClaudeContent` (same browser list as Codex/OpenClaw).
- **Prompt Builder** (`BuilderContent`) owns parameterized `{{token}}` templates for fill-in assembly.
- Keep both sides in sync when updating shared use-cases (e.g. Bug Fixing, Feature Writing); do not treat either as a generated transform of the other.

## Auto-launch with ChatGPT (Codex)

Paired with `/Applications/ChatGPT.app`: open ChatGPT → Cheat Sheet opens; quit ChatGPT → Cheat Sheet quits. Starts at login.

1. Double-click `scripts/install-watcher.command`
2. To stop: double-click `scripts/uninstall-watcher.command`
3. Log: `logs/watcher.log`
