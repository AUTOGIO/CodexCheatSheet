# Repository Audit Report

## 1. Executive Summary

**CodexCheatSheet** is a small, offline native **SwiftUI macOS** application that presents OpenAI Codex prompting guidance and helps users assemble fill-in-the-blank prompts. It is implemented as a single Swift Package Manager executable with **no external dependencies**, **no network I/O**, **no persistence**, and **no shell/scripts/CI**.

The package **builds successfully** on this machine (`swift build` exit 0). There are **no automated tests** (`swift test` exits 1: no test target). Security posture for the shipped code is strong for a local reference tool: static content, pasteboard copy only, no secrets in tree.

Primary risks are **operational/maintainability**, not security: undocumented platform floor (macOS 14+), aspirational `AGENTS.md` layout vs. actual tree, duplicated prompt content across browse vs. builder, and zero test coverage of the only non-trivial logic (`BuilderTemplate.assemble`).

**Highest-priority next action:** add a minimal Swift test target covering `BuilderTemplate.assemble(with:)` and document macOS 14+ / Xcode prerequisites in the README — before adding folders, CI, or features.

## 2. Audit Scope and Limitations

| Item | Status |
|------|--------|
| Read-only audit of repository contents | Completed |
| Source, Package.swift, README, AGENTS.md, .gitignore | Completed |
| Safe toolchain / build validation | Completed (`swift --version`, `xcodebuild -version`, `swift build`, `swift test`) |
| GUI runtime / `swift run` interactive session | **Skipped** — would start a long-running app process |
| Dependency installation | Not performed (none declared) |
| Remediation | Not performed (per mandate) |
| Secret values in report | None found; none printed |

**Limitations:** Runtime UI behavior (sidebar selection under search, pasteboard feedback) was inferred from code, not exercised in a live window. Content fidelity to any external “Codex cheat sheet PDF” could not be verified — the PDF is not in the repository.

## 3. Initial Repository State

| Property | Value |
|----------|--------|
| Repository root | `/Users/eduardofgiovannini/Documents/GitHub/CodexCheatSheet` |
| Current branch | `master` (tracks `origin/master`) |
| HEAD | `2deb525` — *Document repo layout and tighten ignore rules.* |
| Remote | `https://github.com/AUTOGIO/CodexCheatSheet.git` |
| Submodules | None |
| Worktrees | Single worktree at repo root |
| Uncommitted / untracked | `?? CodexCheatSheet.code-workspace` only |
| Working tree size | ~87M (dominated by local `.build/`, ~86M; ignored) |
| Nested repos | None observed |

**Generated / ignored (present locally, not for commit):** `.build/`, `.swiftpm/`, `.DS_Store`

**Recent history (4 commits):** initial SwiftUI app → Hashable/selection fix → `.gitignore` / untrack build artifacts → layout docs / ignore rules.

## 4. Repository Purpose

| Aspect | Assessment |
|--------|------------|
| **Intended purpose** | Local macOS reference app for Codex prompting patterns; browse sections/templates; build prompts with blanks |
| **Likely user** | Developer using OpenAI Codex / coding agents on macOS |
| **Primary workflows** | (1) Search/browse cheat-sheet sections; (2) Copy static templates; (3) Fill builder fields and copy assembled prompt |
| **Expected inputs** | User search text; optional field values in Prompt Builder |
| **Expected outputs** | On-screen content; clipboard text via `NSPasteboard` |
| **Persistent data** | None in code (no `UserDefaults`, files, or DB) |
| **External services** | None |
| **Local services** | None |
| **Runtime dependencies** | macOS 14+, Swift toolchain / Xcode (SwiftUI) |
| **Deployment model** | Local `swift run` or Xcode Run; not packaged/signed as a distributed App Store app |

**Documented vs implemented vs inferred**

| Kind | Notes |
|------|--------|
| Documented | README: SwiftUI macOS app from Codex cheat sheet PDF; `swift build` / `swift run` / open `Package.swift` in Xcode |
| Implemented | Static in-memory content; two tabs (browser + builder); copy to pasteboard |
| Inferred | Content originated from an external PDF/guide not vendored in-repo |
| Unresolved | Whether content is kept current with OpenAI’s live docs; whether distribution beyond local SPM is intended |

## 5. Repository Map

| Path | Purpose |
|------|---------|
| `Package.swift` | SPM package: executable target, macOS 14+ |
| `Sources/CodexCheatSheet/` | Application code |
| `Sources/.../CodexCheatSheetApp.swift` | `@main` SwiftUI app entry |
| `Sources/.../Models/` | Domain models + static content |
| `Sources/.../Views/` | UI (tabs, browser, builder, table, cards) |
| `README.md` | User-facing run instructions |
| `AGENTS.md` | Agent/repo layout rules (partly aspirational) |
| `.gitignore` | Ignores build, env, caches |
| `CodexCheatSheet.code-workspace` | Untracked Cursor/VS Code workspace (empty settings) |
| `.build/` | Local SPM/Xcode build output (ignored, ~86M+) |
| `.swiftpm/` | Local SPM/Xcode metadata (ignored) |

**Absent (documented in AGENTS.md but not present):** `scripts/`, `config/`, `data/`, `assets/`, `docs/`, `tests/`, `archive/`

**Also absent:** CI (`.github/`), tests, shell scripts, entitlements, app icons, PDF source, lockfile (N/A — no deps).

**Source inventory (~746 lines Swift across 11 files):**

- Models: `CheatSheetModels`, `CheatSheetContent`, `BuilderModels`, `BuilderContent`
- Views: `ContentView`, `CheatSheetBrowserView`, `SectionDetailView`, `PatternTableView`, `TemplateCardView`, `PromptBuilderView`
- Entry: `CodexCheatSheetApp`

## 6. Technology Stack

| Technology | Evidence |
|------------|----------|
| Swift 5.10+ tools version | `Package.swift` (`swift-tools-version: 5.10`) |
| SwiftUI | All view files; `@main` App |
| AppKit (pasteboard) | `TemplateCardView.swift` `#if canImport(AppKit)` |
| Swift Package Manager | `Package.swift`; no Xcode project committed |
| macOS 14+ | `platforms: [.macOS(.v14)]` |
| Apple Silicon binary produced locally | `.build/debug/CodexCheatSheet` — `Mach-O 64-bit executable arm64` |
| No third-party packages | Empty dependency list in `Package.swift` |
| No CI/CD | No `.github/workflows` or equivalent |
| No test framework wired | No `testTarget`; `swift test` → no tests found |

**Audit host toolchain (validation):** Apple Swift 6.4, Xcode 27.0, target `arm64-apple-macosx27.0.0`.

## 7. Architecture Overview

```text
CodexCheatSheetApp
  └─ ContentView (TabView)
       ├─ CheatSheetBrowserView
       │    ├─ NavigationSplitView + searchable sidebar
       │    └─ SectionDetailView → PatternTableView / TemplateCardView
       │         data ← CheatSheetContent.sections (static)
       └─ PromptBuilderView
            ├─ template list ← BuilderContent.templates (static)
            ├─ field editors → [String:String]
            └─ assemble() → preview + NSPasteboard
```

- **Boundaries:** Single process, single module, UI + static data only.
- **Data flow:** Compile-time/static enums → views → optional clipboard.
- **Shared state:** `@State` only; no globals beyond static content arrays.
- **Persistence / integrations / background jobs:** None.
- **Ambition–Capacity Mismatch:** `AGENTS.md` describes a multi-folder product layout (`scripts`, `config`, `data`, `docs`, `tests`, `archive`) for what is effectively an offline cheat-sheet utility of ~11 Swift files. That layout exceeds current capacity and need.

## 8. Build, Test, and Run Procedure

### Canonical (from README + Package.swift)

1. **Prepare:** Install Xcode (README). Implicit: macOS 14+ host matching package platform.
2. **Configure:** No environment variables or secrets required.
3. **Build:** `swift build` or open `Package.swift` in Xcode.
4. **Test:** No supported procedure documented; `swift test` currently fails (no tests).
5. **Run:** `swift run` or Xcode Cmd+R.
6. **Stop:** Quit the app window / stop Xcode Run.
7. **Recover:** Rebuild after clean optional (`rm -rf .build` is destructive — not run during audit); fix Swift/Xcode install if macros/toolchain missing.

### Conflicts / gaps

- README does not state **macOS 14+** (required by `Package.swift`).
- `AGENTS.md` says tests live under `tests/`; SwiftPM expects a declared `testTarget` (conventionally `Tests/`).
- Root rule in `AGENTS.md` allows only `README.md`, `AGENTS.md`, `.gitignore`, `Package.swift` — workspace file contradicts that if committed.

## 9. Commands Executed

| Command | Exit | Result |
|---------|------|--------|
| `pwd` | 0 | Repo root confirmed |
| `git status --short` | 0 | Untracked `CodexCheatSheet.code-workspace` |
| `git branch --show-current` | 0 | `master` |
| `git remote -v` | 0 | origin GitHub AUTOGIO/CodexCheatSheet |
| `git log -10 --oneline --decorate` | 0 | 4 commits on master |
| `git submodule status` | 0 | Empty (no submodules) |
| `du -sh .` | 0 | ~87M |
| `find` structure maps | 0 | Sources-only app tree |
| `git diff --check` | 0 | No whitespace errors |
| `swift --version` | 0 | Swift 6.4 / arm64 |
| `xcodebuild -version` | 0 | Xcode 27.0 |
| `swift build` | 0 | Build complete (~35s) |
| `swift test` | **1** | `error: no tests found; create a target in the 'Tests' directory` |
| `file .build/debug/CodexCheatSheet` | 0 | arm64 Mach-O executable |
| Secret-ish path scan | 0 | No `.env` / keys / pem in tracked tree |
| `swift run` | **Skipped** | Would launch long-running GUI |

## 10. Findings Summary

| ID | Severity | Priority | Category | Finding | Confidence |
|---|---|---|---|---|---|
| AUDIT-001 | Medium | P1 | Testing | No test target or automated tests | Confirmed |
| AUDIT-002 | Medium | P1 | Documentation | README omits macOS 14+ requirement | Confirmed |
| AUDIT-003 | Medium | P2 | Architecture | Dual sources of truth for prompt templates | Confirmed |
| AUDIT-004 | Medium | P2 | Documentation | AGENTS.md aspirational layout vs. real tree | Confirmed |
| AUDIT-005 | Low | P2 | Correctness | Search selection can desync from detail pane | High confidence |
| AUDIT-006 | Low | P3 | Correctness | Latent crash if builder templates empty (`[0]`) | Probable |
| AUDIT-007 | Low | P2 | Repository hygiene | Untracked workspace file; root policy drift | Confirmed |
| AUDIT-008 | Low | P3 | Reliability | No CI to catch build/regressions | Confirmed |
| AUDIT-009 | Informational | P3 | macOS | SPM executable only; no signing/bundle/icons | Confirmed |
| AUDIT-010 | Informational | P3 | Security | Local world-writable `.swiftpm` permissions | Confirmed |
| AUDIT-011 | Informational | P3 | Documentation | Source PDF / upstream content not vendored | Confirmed |

## 11. Critical Findings

None.

## 12. High Findings

None.

## 13. Medium Findings

### [AUDIT-001] No test target or automated tests

- Severity: Medium
- Priority: P1
- Confidence: Confirmed
- Category: Testing
- File: `Package.swift`
- Location: package `targets` array (executable only); no `Tests/` tree
- Evidence:
  - `Package.swift` defines a single `.executableTarget` named `CodexCheatSheet`.
  - `swift test` exited 1 with: `error: no tests found; create a target in the 'Tests' directory`.
  - Non-trivial logic exists in `BuilderTemplate.assemble(with:)` (`BuilderModels.swift`) with placeholder substitution rules that are easy to regress.
- Impact:
  - Regressions in prompt assembly or model identity/selection fixes (see history `5404ab2`) can ship unnoticed.
  - Contributors have no executable definition of “done” beyond manual UI clicks.
- Recommendation:
  - Add a `testTarget` and unit tests for `assemble(with:)` (filled, blank→placeholder, empty placeholder→empty string, unknown keys ignored).
  - Optionally add a smoke test that `CheatSheetContent.sections` and `BuilderContent.templates` are non-empty.
- Validation:
  - `swift test` exits 0 and reports executed tests.

### [AUDIT-002] README omits macOS 14+ requirement

- Severity: Medium
- Priority: P1
- Confidence: Confirmed
- Category: Documentation
- File: `README.md` / `Package.swift`
- Location: README “Run” section; `Package.swift` `platforms: [.macOS(.v14)]`
- Evidence:
  - README states Xcode is required but does not mention the macOS 14 platform floor declared in `Package.swift`.
- Impact:
  - Users on older macOS may follow README steps and fail with opaque SPM platform errors.
- Recommendation:
  - Add one line: requires macOS 14+ and a current Xcode with SwiftUI support.
- Validation:
  - Fresh reader can match README prerequisites to `Package.swift` without inspecting source.

### [AUDIT-003] Dual sources of truth for prompt templates

- Severity: Medium
- Priority: P2
- Confidence: Confirmed
- Category: Architecture
- File: `Sources/CodexCheatSheet/Models/CheatSheetContent.swift`, `Sources/CodexCheatSheet/Models/BuilderContent.swift`
- Location: Use-case / master prompt bodies vs. `BuilderContent.templates` `rawTemplate` strings
- Evidence:
  - Browser tab stores copy-ready templates in `CheatSheetContent` (e.g. Bug Fixing, Feature Writing, Master Prompt).
  - Prompt Builder stores parallel parameterized templates in `BuilderContent` with `{{tokens}}`.
  - Wording is intentionally related but separately maintained; drift is already structural (builder uses tokens; cheat sheet uses bracket placeholders).
- Impact:
  - Content updates require two edits; users may see inconsistent guidance between tabs.
- Recommendation:
  - Keep dual presentation if UX needs differ, but document a single “canonical” wording owner, or generate one from the other with a small shared constant table — without a large rewrite.
- Validation:
  - Diff checklist or test asserting key phrases match across paired templates.

### [AUDIT-004] AGENTS.md aspirational layout vs. real tree

- Severity: Medium
- Priority: P2
- Confidence: Confirmed
- Category: Documentation
- File: `AGENTS.md`
- Location: Folder layout table; root-only rule
- Evidence:
  - Documents `scripts/`, `config/`, `data/`, `assets/`, `docs/`, `tests/`, `archive/` — none exist on disk.
  - States root may contain only `README.md`, `AGENTS.md`, `.gitignore`, `Package.swift`, yet `CodexCheatSheet.code-workspace` exists untracked.
  - Contradicts SwiftPM test convention (`Tests/` + `testTarget`) by naming `tests/`.
- Impact:
  - Agents and humans may create unused scaffolding or look for missing paths; Ambition–Capacity Mismatch for a static cheat-sheet app.
- Recommendation:
  - Narrow `AGENTS.md` to folders that exist today; mark future folders as optional/do-not-create; align test path naming with SPM when tests are added.
- Validation:
  - Every path in `AGENTS.md` either exists or is explicitly marked “not created yet.”

## 14. Low and Informational Findings

### [AUDIT-005] Search selection can desync from detail pane

- Severity: Low
- Priority: P2
- Confidence: High confidence
- Category: Correctness
- File: `Sources/CodexCheatSheet/Views/CheatSheetBrowserView.swift`
- Location: `selectedSection` computed property; `List(..., selection: $selectedSectionID)`
- Evidence:
  - Detail uses `filteredSections.first { $0.id == selectedSectionID } ?? filteredSections.first`.
  - When the current `selectedSectionID` is filtered out, detail falls back to another section while selection binding may still hold the stale ID.
- Impact:
  - Sidebar highlight and detail content can disagree during search; confusing but not data-corrupting.
- Recommendation:
  - On `searchText` / `filteredSections` change, if selection ∉ filtered set, set `selectedSectionID` to `filteredSections.first?.id`.
- Validation:
  - Manual: select a section, search a term that excludes it, confirm sidebar and detail agree.

### [AUDIT-006] Latent crash if builder templates empty

- Severity: Low
- Priority: P3
- Confidence: Probable
- Category: Correctness
- File: `Sources/CodexCheatSheet/Views/PromptBuilderView.swift`
- Location: `selectedTemplate` — `BuilderContent.templates[0]`
- Evidence:
  - Fallback uses force-index `[0]` rather than optional handling.
  - Current `BuilderContent.templates` is a non-empty static array, so production crash is unlikely today.
- Impact:
  - Future empty-array edit would crash on appear.
- Recommendation:
  - Use `first` and show `ContentUnavailableView` if empty (mirror browser pattern).
- Validation:
  - Temporary empty array in a test double / preview does not crash.

### [AUDIT-007] Untracked workspace file; root policy drift

- Severity: Low
- Priority: P2
- Confidence: Confirmed
- Category: Repository hygiene
- File: `CodexCheatSheet.code-workspace`
- Location: repo root (untracked)
- Evidence:
  - `git status --short` shows `?? CodexCheatSheet.code-workspace`.
  - File contains only `{ "folders": [{ "path": "." }], "settings": {} }`.
  - `AGENTS.md` root allowlist excludes it.
- Impact:
  - Accidental commit noise or confusion about whether IDE workspace is part of the product.
- Recommendation:
  - Either gitignore `*.code-workspace` or commit deliberately and update `AGENTS.md` allowlist.
- Validation:
  - `git status` clean regarding workspace policy choice.

### [AUDIT-008] No CI to catch build/regressions

- Severity: Low
- Priority: P3
- Confidence: Confirmed
- Category: Reliability
- File: (missing) `.github/workflows/*`
- Location: N/A
- Evidence:
  - No workflow files in repository; validation is local-only.
- Impact:
  - Breakages on other Xcode versions may go unnoticed until someone builds.
- Recommendation:
  - Defer until after local `swift test` exists; then add a minimal `macos-latest` workflow running `swift build` and `swift test` only.
- Validation:
  - PR/push shows green build on GitHub Actions (when added).

### [AUDIT-009] SPM executable only; no signing/bundle/icons

- Severity: Informational
- Priority: P3
- Confidence: Confirmed
- Category: macOS
- File: `Package.swift`
- Location: `.executableTarget` only
- Evidence:
  - No `.app` bundle, entitlements, hardened runtime, or asset catalog in repo.
  - Appropriate for a personal/local cheat sheet launched via `swift run`.
- Impact:
  - Not distributable as a normal signed Mac app without extra packaging work.
- Recommendation:
  - Do nothing unless distribution is a stated goal.
- Validation:
  - N/A unless packaging is requested.

### [AUDIT-010] Local world-writable `.swiftpm` permissions

- Severity: Informational
- Priority: P3
- Confidence: Confirmed
- Category: Security
- File: `.swiftpm/` (ignored, local)
- Location: directory mode `drwxrwxrwx` observed during audit
- Evidence:
  - `ls -la` showed `.swiftpm` as world-writable on the audit host.
- Impact:
  - On multi-user machines, other local users could alter SPM/Xcode metadata; not a committed-repo vulnerability.
- Recommendation:
  - Optionally `chmod -R go-w .swiftpm` locally; no repo change required.
- Validation:
  - `ls -ld .swiftpm` shows non-world-writable mode.

### [AUDIT-011] Source PDF / upstream content not vendored

- Severity: Informational
- Priority: P3
- Confidence: Confirmed
- Category: Documentation
- File: `README.md`
- Location: opening sentence claiming origin from Codex cheat sheet PDF
- Evidence:
  - No PDF or content provenance file under `data/`, `docs/`, or `assets/`.
  - All guidance is hardcoded Swift string literals.
- Impact:
  - Cannot verify accuracy against claimed source; updates require manual rewrite.
- Recommendation:
  - Add a short provenance note (URL/date of guide) in README or `docs/` when/if docs folder is intentionally created.
- Validation:
  - README cites a checkable upstream reference.

## 15. Security Assessment

- **Committed secrets:** None found (no `.env`, keys, PEM, or credential files in the tracked tree).
- **Network / injection / subprocess:** None in application code.
- **Sensitive operations:** Clipboard write via `NSPasteboard` only; user-initiated.
- **Supply chain:** No third-party packages → minimal dependency risk.
- **Attack surface:** Local offline UI; risk limited to malicious local modification of the binary or source.
- **Verdict:** No confirmed vulnerabilities. Residual items are local filesystem hygiene (AUDIT-010) only.

## 16. Correctness Assessment

- Prior Hashable crash for `CheatSection` (tuple `tableHeaders`) was fixed by selecting sidebar rows by ID (`5404ab2`); current models match that approach.
- `swift build` succeeds; generated binary is arm64 Mach-O.
- Remaining correctness concerns: search/selection desync (AUDIT-005), latent `[0]` crash (AUDIT-006), content drift between tabs (AUDIT-003).
- No TODO/FIXME markers in Swift sources.
- `copyToPasteboard` is a no-op without AppKit; acceptable given macOS-only package.

## 17. Reliability and Operational Stability

- **Startup/shutdown:** Standard SwiftUI window lifecycle; `.windowResizability(.contentSize)` with `minWidth/Height` 900×600.
- **State:** Ephemeral `@State`; restart loses field values (expected).
- **Logging/monitoring/health:** None (not required for this class of app).
- **Failure modes:** Build/toolchain issues only; no retries, ports, queues, or locks in app code.
- **Machine-specific paths:** None hard-coded under `/Users/...` in source.
- **Operational verdict:** Stable for local personal use once Xcode/macOS 14+ are present. Weakest link is lack of automated verification (AUDIT-001, AUDIT-008).

## 18. Architecture and Complexity Assessment

- Architecture is appropriately simple: static content + SwiftUI views.
- Coupling is low; dependency direction is Models ← Views.
- **Ambition–Capacity Mismatch:** `AGENTS.md` multi-folder product skeleton and implied future `scripts/config/data/docs` exceed what this app needs. Prefer not creating empty folders “for later.”
- Complexity to **remove or defer:** CI packaging, sandbox entitlements, multi-module split, content CMS, and speculative top-level directories.
- Complexity worth keeping: two-tab UX; ID-based selection; `assemble` helper.

## 19. Dependency Assessment

- **External dependencies:** None declared.
- **Lock file:** Not applicable / not present.
- **Recommendation:** Do not add packages unless a concrete feature requires them. Prefer Foundation/AppKit/SwiftUI.

## 20. Testing Assessment

- **Suites:** None.
- **Command:** `swift test` → fail (no tests).
- **Critical untested paths:** `BuilderTemplate.assemble`; non-empty content invariants; (UI) search filter + selection.
- **Side-effecting tests:** N/A.
- **Priority:** Establish unit tests before UI or CI expansion.

## 21. Documentation Assessment

| Claim | Reality |
|-------|---------|
| `swift build` / `swift run` | Build verified; run skipped but matches SPM executable |
| Requires Xcode | Reasonable for SwiftUI; Swift CLI present on audit host |
| macOS version | Undocumented; code requires 14+ |
| Layout in AGENTS.md | Mostly future/aspirational |
| From Codex PDF | Content present; PDF absent |

No contribution guide, troubleshooting, or recovery docs — acceptable for a tiny personal tool, but platform floor should be stated.

## 22. macOS and Apple-Specific Assessment

- Targets macOS 14+ via SPM; Apple Silicon binary produced locally.
- SwiftUI + conditional AppKit pasteboard — correct for Mac.
- No sandbox entitlements, Keychain, LaunchAgents, AppleScript, or hard-coded user paths in source.
- Not an App Store–ready bundle (AUDIT-009).
- Intel-only binaries: not observed in current debug product (arm64 only on this host).

## 23. Shell Script Assessment

- No `.sh` / `.zsh` project scripts found.
- No `curl | sh`, `sudo`, or `rm -rf` automation in-repo.
- **N/A — no shell surface to harden.**

## 24. Repository Hygiene

| Item | Assessment |
|------|------------|
| `.gitignore` | Covers `.build/`, `.swiftpm/`, `.DS_Store`, `.env*`, common caches |
| Build artifacts | Present locally, correctly ignored |
| Untracked | `CodexCheatSheet.code-workspace` |
| Large files in git | None observed in tracked set |
| Fresh clone viability | Yes: clone → Xcode/Swift on macOS 14+ → `swift build` / `swift run` |
| Secrets | Not committed |

## 25. Prioritized Remediation Plan

### Stage 0 — Preserve and Validate

- Keep working tree as-is; do not delete `.build` unless disk pressure requires it.
- Re-run `swift build` after any change.
- **Validation:** clean build on developer machine.
- **Rollback:** revert commit; no data stores to restore.

### Stage 1 — Critical Stabilization

- No Critical/High security or crash defects open.
- Treat documentation platform floor (AUDIT-002) and first tests (AUDIT-001) as the stabilization bar before features.
- **Validation:** `swift build` + `swift test` green; README prerequisites accurate.
- **Do not attempt yet:** App Store packaging, multi-folder scaffolding, dependency adoption.

### Stage 2 — Reliability Improvements

- Fix search selection sync (AUDIT-005).
- Soften `templates[0]` fallback (AUDIT-006).
- Resolve workspace file policy (AUDIT-007).
- Align `AGENTS.md` with reality (AUDIT-004).
- **Validation:** manual search UX check; `git status` policy clear; AGENTS paths accurate.

### Stage 3 — Simplification

- Reduce content duplication or document a single owner (AUDIT-003).
- Avoid creating empty `scripts/config/data/docs/archive` folders.
- **Validation:** fewer divergent template strings or an explicit sync rule.

### Stage 4 — Maintainability

- Optional minimal CI after tests exist (AUDIT-008).
- Optional provenance note for upstream cheat sheet (AUDIT-011).
- **Validation:** CI green; README provenance link resolves.
- **Rollback:** remove workflow file; docs-only revert.

## 26. Quick Wins

1. Document macOS 14+ in README (AUDIT-002).
2. Add `testTarget` + 3–5 `assemble` unit tests (AUDIT-001).
3. Sync `selectedSectionID` when filter excludes it (AUDIT-005).
4. Replace `templates[0]` with safe empty state (AUDIT-006).
5. Gitignore or commit `CodexCheatSheet.code-workspace` deliberately (AUDIT-007).
6. Trim `AGENTS.md` folder table to existing paths (AUDIT-004).
7. Add one-line “no network / offline” note to README for operator clarity.
8. Add smoke assert that section and template arrays are non-empty.
9. Record upstream guide URL/date when known (AUDIT-011).
10. Locally restrict `.swiftpm` permissions if on a shared Mac (AUDIT-010).

## 27. Deferred Improvements

- GitHub Actions CI (after tests).
- Signed `.app` bundling, icons, notarization.
- Content extraction to markdown/JSON under `data/` (only if editing non-dev content becomes frequent).
- Creating speculative `scripts/`, `config/`, `archive/` directories.
- UI test automation (high cost relative to app size).

## 28. Unresolved Questions

1. Is distribution beyond local `swift run` / Xcode intended?
2. Should cheat-sheet wording track a specific OpenAI doc revision, and who owns updates?
3. Should `CodexCheatSheet.code-workspace` be shared with collaborators?
4. Is the `AGENTS.md` multi-folder layout intentional for future expansion of *this* repo, or copy-paste from a template?

## 29. Final Recommendation

Treat this repository as a **healthy, minimal, offline SwiftUI reference tool**. It builds, has a clear purpose, and presents negligible security risk. Do **not** remediate by adding infrastructure.

**Fix first:** automated tests for prompt assembly + accurate README prerequisites.  
**Remove/defer:** aspirational folder sprawl, packaging, and CI until those basics exist.  
**Do not start remediation in this audit pass** — use Stage 0–1 above when work is explicitly requested.
