# CodexCheatSheet — agent notes

SwiftUI macOS app (Swift Package). Prefer move over copy; do not redesign features.

## Folder layout

| Path | Purpose |
|------|---------|
| `Sources/` | Application code (Swift SPM equivalent of `src/`) |
| `scripts/` | Runnable helpers (if added later) |
| `config/` | Non-secret settings |
| `data/` | CSV, Excel, exports, raw inputs |
| `assets/` | Images, icons, logos |
| `docs/` | Guides, design notes; `docs/prompts/` for AI prompts |
| `tests/` | Tests only |
| `archive/` | Obsolete files kept but not deleted |
| Root | `README.md`, `AGENTS.md`, `.gitignore`, `Package.swift` only |

Do not invent new top-level folders without asking. Do not commit secrets or personal machine inventory.
