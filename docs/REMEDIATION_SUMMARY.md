# Remediation Summary — CodexCheatSheet

**Date:** 2026-07-29  
**Basis:** [REPOSITORY_AUDIT.md](./REPOSITORY_AUDIT.md) Stages 1–4 + Quick Wins  
**Validation:** `swift build` exit 0; `swift test` — 8 tests, 0 failures

## Outcome

Audit findings that required code or repo changes are closed. Packaging for App Store distribution remains out of scope by design. Upstream PDF URL is still unknown (content provenance note added without a dead link).

## Changes by finding

| ID | Action taken |
|----|----------------|
| AUDIT-001 | Added `CodexCheatSheetCore` library + `Tests/CodexCheatSheetTests` with 5 `assemble(with:)` cases and 3 content smoke tests |
| AUDIT-002 | README Requirements: macOS 14+ and Xcode/SwiftUI |
| AUDIT-003 | Documented dual ownership (browser vs builder); pairing smoke test for shared use-case names |
| AUDIT-004 | Rewrote `AGENTS.md` to match the real tree; speculative folders marked do-not-create |
| AUDIT-005 | Browser search syncs `selectedSectionID` when the filter excludes the prior selection |
| AUDIT-006 | Prompt Builder uses optional `first` + `ContentUnavailableView` instead of `templates[0]` |
| AUDIT-007 | Gitignored `*.code-workspace` |
| AUDIT-008 | Added `.github/workflows/ci.yml` (`swift build` + `swift test` on `macos-latest`) |
| AUDIT-009 | Deferred — local SPM executable is intentional |
| AUDIT-010 | Restricted local `.swiftpm` permissions (`go-w`) on this machine |
| AUDIT-011 | README notes offline app + PDF not vendored (no inventing a URL) |

## Structural upgrade

Previously a single executable target. Now:

```text
CodexCheatSheet (executable, @main)
  └─ CodexCheatSheetCore (library: Models + Views)
Tests/CodexCheatSheetTests → depends on Core
```

This was required so SwiftPM can unit-test model logic (tests cannot depend on an executable target).

## Operator upgrades

- Offline / no-network clarity in README
- `swift test` documented as a first-class command
- CI on push/PR to `master`/`main`

## Still deferred (by audit design)

- Signed `.app` bundle, icons, notarization
- Content extraction to markdown/JSON
- Speculative `scripts/`, `config/`, `data/`, `assets/`, `archive/`
- UI automation
- Exact upstream guide URL/date (add when known)

## How to run

```bash
swift build
swift test
swift run
```

Requires macOS 14+ and Xcode with SwiftUI support.
