# Claude Cowork + Skills content in Cheat Sheet browser

Date: 2026-07-30  
Status: approved in chat (Approach 1; placement A; best-practice curation)

## Goal

Incorporate two external Claude guides into the existing offline Cheat Sheet browser as copy-ready sections:

1. **40 Claude Cowork Commands, Workflows & Automations** — slash commands, file/connector/document workflows, scheduled automations, pro tips.
2. **The Complete Guide to Building Skills for Claude** — distilled fundamentals, authoring, testing, patterns, troubleshooting (not a chapter dump).

Users browse and copy prompts the same way they already use Codex and OpenClaw content.

## Non-goals

- New tabs or UI redesign
- Prompt Builder `{{token}}` templates in this pass
- Vendoring or committing the source PDFs
- API / enterprise distribution deep-dive beyond a short install note
- Redesigning Codex or OpenClaw sections

## Approach

**OpenClaw-style static content module** (Approach 1).

| Piece | Choice |
|-------|--------|
| File | `Sources/CodexCheatSheetCore/Models/ClaudeContent.swift` |
| Wiring | `CheatSheetContent.sections = codexSections + OpenClawContent.sections + ClaudeContent.sections` |
| UI | Unchanged — `CheatSheetBrowserView` search/filter already works on `CheatSection.searchableText` |
| Builder | Unchanged |
| Source PDFs | Stay outside the repo; content rewritten into Swift |
| Placeholders | Bracket form (`[Downloads]`, `[topic]`, `[competitor 1]`) — no personal absolute paths |

## Section map

Eight sections, titles prefixed `Claude · …`, ordered daily-use first then skill-building:

| Section | Shape | Source |
|---------|-------|--------|
| Claude · Slash Commands | Table (command / what / when) + tip bullets | Cowork 01–10 |
| Claude · File System Workflows | One `PromptTemplate` per workflow | Cowork 11–18 |
| Claude · Connector Workflows | Copy-ready templates | Cowork 19–26 |
| Claude · Document & Content | Copy-ready templates | Cowork 27–34 |
| Claude · Scheduled Automations | Templates for 35–40 + Pro Tips as bullets | Cowork 35–40 + tips |
| Claude · Skills Fundamentals | Table (principle / meaning / practice) + folder layout & Skills+MCP bullets | Skills Ch.1 |
| Claude · Skill Authoring | Frontmatter rules table + good/bad description examples + `SKILL.md` skeleton template + instruction best-practice bullets | Skills Ch.2 |
| Claude · Skills Testing & Patterns | Trigger/functional checklist table + five pattern rows/templates + troubleshooting table | Skills Ch.3–5 |

### Content conventions

- Match OpenClaw tone: short, paste-ready, outcome-oriented.
- Keywords include searchable terms (`/plan`, `SKILL.md`, `Cowork`, `frontmatter`, `progressive disclosure`, etc.).
- Distill Skills guide into actionable recipes; prefer progressive disclosure over verbatim chapter text.
- Include modern practices from the guide: description = what + when/triggers; exact `SKILL.md`; kebab-case names; trigger under/over-firing fixes; Skills + MCP as knowledge vs connectivity.

## Data flow

```
External Claude PDFs (not in repo)
        ↓ manual distill
ClaudeContent.sections: [CheatSection]
        ↓
CheatSheetContent.sections = codex + OpenClaw + Claude
        ↓
CheatSheetBrowserView (existing search)
```

## Testing

- `swift test` passes after wiring.
- Extend content smoke tests: at least one section title containing `Claude ·`; Claude workflow sections non-empty where templates are expected.
- No new UI tests (views unchanged).

## Docs

- README / AGENTS: note that browser content includes Codex + OpenClaw + Claude (`ClaudeContent`).

## Success criteria

- App builds and tests pass.
- Cheat Sheet browser lists all eight `Claude ·` sections and they are searchable.
- All 40 Cowork items appear as table rows and/or copy-ready templates.
- Skills material covers structure, frontmatter/description recipe, testing, patterns, and common troubleshooting without shipping the full PDF text.
- No PDFs or secrets committed.

## Out of scope / later

- Paired Prompt Builder templates for high-leverage Claude workflows
- Separate Claude tab
- Keeping content auto-synced from the external PDF folder
