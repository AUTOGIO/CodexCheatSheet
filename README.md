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

Or open `Package.swift` in Xcode and press Cmd+R.

## Test

```bash
swift test
```

## Where things live

- `Sources/CodexCheatSheetCore/` — models, static content, and SwiftUI views (library)
- `Sources/CodexCheatSheet/` — `@main` app entry (executable)
- `Tests/CodexCheatSheetTests/` — unit tests
- `Package.swift` — Swift package config
- `AGENTS.md` — folder rules for this repo
- `docs/` — audit and remediation reports

## Content ownership

- **Browser tab** (`CheatSheetContent`) owns copy-ready cheat-sheet wording (bracket placeholders).
- **Prompt Builder** (`BuilderContent`) owns parameterized `{{token}}` templates for fill-in assembly.
- Keep both sides in sync when updating shared use-cases (e.g. Bug Fixing, Feature Writing); do not treat either as a generated transform of the other.
