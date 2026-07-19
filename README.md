# Codex Cheat Sheet

Native SwiftUI macOS app built from `openai-codex-prompting-cheat-sheet.pdf`.

## Structure
- **Cheat Sheet tab** — 8 sections, searchable, every table + prompt template from the source PDF, one-click copy per template.
- **Prompt Builder tab** — pick a use case (bug fix, feature, exploration, refactor, AGENTS.md update, or the one-page master prompt), fill in the blanks, copy the assembled prompt.

## Build
Requires **Xcode** (not just Command Line Tools) — SwiftUI's `@State`/`@Binding` macros need Xcode's macro plugin.

```bash
swift build   # or: open Package.swift in Xcode, then Cmd+R
swift run
```

## Layout
```
Sources/CodexCheatSheet/
  CodexCheatSheetApp.swift       entry point
  Models/                        CheatSection, PromptTemplate, BuilderTemplate + content
  Views/                         browser (sidebar/search/detail) + prompt builder (form/preview)
```
