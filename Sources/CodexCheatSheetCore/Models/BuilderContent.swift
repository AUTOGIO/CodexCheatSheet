import Foundation

enum BuilderContent {
    static let templates: [BuilderTemplate] = [
        BuilderTemplate(
            name: "Bug Fixing",
            icon: "ladybug",
            rawTemplate: """
Goal: Fix {{bug}}.
Context: {{errorLog}}, {{repro}}, {{files}}, {{recentChanges}}.
Constraints: preserve public behavior except the bug; no broad try/catch or silent fallback.
Process: reproduce or explain why not; identify root cause; implement minimal coherent fix; add regression test.
Done when: repro passes, targeted tests pass, diff reviewed for unrelated edits.
""",
            fields: [
                BuilderField(key: "bug", label: "Bug", placeholder: "bug"),
                BuilderField(key: "errorLog", label: "Error log", placeholder: "error log"),
                BuilderField(key: "repro", label: "Steps to reproduce", placeholder: "steps to reproduce"),
                BuilderField(key: "files", label: "Suspected files", placeholder: "suspected files"),
                BuilderField(key: "recentChanges", label: "Recent changes", placeholder: "recent changes"),
            ]
        ),
        BuilderTemplate(
            name: "Feature Writing",
            icon: "sparkles",
            rawTemplate: """
Goal: Add {{feature}} for {{userJob}}.
Context: {{existingSurface}}, {{examples}}, {{acceptanceCriteria}}.
Constraints: follow existing patterns; avoid new dependencies unless necessary; keep type safety.
Process: search for prior art, implement across all relevant surfaces, update docs/tests.
Done when: feature works through the intended entry point and lint/type/tests pass.
""",
            fields: [
                BuilderField(key: "feature", label: "Feature", placeholder: "feature"),
                BuilderField(key: "userJob", label: "User / job", placeholder: "user/job"),
                BuilderField(key: "existingSurface", label: "Existing command/API/page", placeholder: "existing command/API/page"),
                BuilderField(key: "examples", label: "Examples", placeholder: "examples"),
                BuilderField(key: "acceptanceCriteria", label: "Acceptance criteria", placeholder: "acceptance criteria"),
            ]
        ),
        BuilderTemplate(
            name: "Codebase Exploration",
            icon: "map",
            rawTemplate: """
Goal: Explain how {{moduleFlow}} works.
Context: start from {{entryPoint}}.
Constraints: read only; do not edit files.
Output: concise map of key files, control flow, data contracts, extension points, and uncertainties.
Done when: answer cites concrete files/functions and separates facts from hypotheses.
""",
            fields: [
                BuilderField(key: "moduleFlow", label: "Module / flow", placeholder: "module/flow"),
                BuilderField(key: "entryPoint", label: "Entry file, route, or command", placeholder: "entry file, route, or command"),
            ]
        ),
        BuilderTemplate(
            name: "Refactor",
            icon: "arrow.triangle.2.circlepath",
            rawTemplate: """
Goal: Refactor {{area}} to {{targetDesign}}.
Context: {{painPoint}}, {{currentTests}}, {{compatConstraints}}.
Constraints: preserve behavior; keep public APIs stable unless requested; batch logical edits.
Process: characterize behavior, search for duplicate helpers, change one boundary at a time.
Done when: existing tests pass and diff shows no unrelated rewrites.
""",
            fields: [
                BuilderField(key: "area", label: "Area", placeholder: "area"),
                BuilderField(key: "targetDesign", label: "Target design", placeholder: "target design"),
                BuilderField(key: "painPoint", label: "Pain point", placeholder: "pain point"),
                BuilderField(key: "currentTests", label: "Current tests", placeholder: "current tests"),
                BuilderField(key: "compatConstraints", label: "Compatibility constraints", placeholder: "compatibility constraints"),
            ]
        ),
        BuilderTemplate(
            name: "AGENTS.md Update",
            icon: "doc.badge.gearshape",
            rawTemplate: """
Goal: Improve durable Codex guidance for this repo.
Context: recurring mistake: {{mistake}}.
Constraints: keep AGENTS.md short, practical, and repo-specific.
Process: inspect existing AGENTS.md, add the smallest rule that prevents recurrence, include verification commands.
Done when: Codex can summarize the active instruction sources and the new rule.
""",
            fields: [
                BuilderField(key: "mistake", label: "Recurring mistake", placeholder: "describe mistake"),
            ]
        ),
        BuilderTemplate(
            name: "One-Page Master Prompt",
            icon: "doc.richtext",
            rawTemplate: """
You are Codex working in this repository.

Goal:
{{goal}}

Context:
- Relevant files/docs/logs: {{contextFiles}}
- Current behavior: {{currentBehavior}}
- Desired behavior: {{desiredBehavior}}

Constraints:
- Follow existing repo conventions and AGENTS.md.
- Reuse existing helpers before adding new ones.
- Preserve unrelated user changes and avoid destructive git commands.
- Do not add dependencies or change public behavior unless required.
{{extraConstraints}}

Autonomy:
Act as an autonomous senior engineer. Gather context, make reasonable assumptions, implement, test, and refine. Ask only if blocked by a decision with real product/security risk.

Verification:
- Reproduce or define the smallest acceptance check.
- Add/update tests if behavior changes.
- Run targeted tests plus lint/type/build when relevant.
- Review the final diff for regressions, unrelated edits, broad catches, and silent failures.

Done when:
{{doneWhen}}

Final response:
Summarize what changed, files touched, checks run, results, and any residual risk.
""",
            fields: [
                BuilderField(key: "goal", label: "Goal (one sentence)", placeholder: "one sentence describing the concrete outcome"),
                BuilderField(key: "contextFiles", label: "Relevant files/docs/logs", placeholder: "paths or pasted excerpts"),
                BuilderField(key: "currentBehavior", label: "Current behavior", placeholder: "what happens now"),
                BuilderField(key: "desiredBehavior", label: "Desired behavior", placeholder: "what should happen"),
                BuilderField(key: "extraConstraints", label: "Extra constraints (optional)", placeholder: ""),
                BuilderField(key: "doneWhen", label: "Done when", placeholder: "specific measurable completion criteria"),
            ]
        ),
    ]
}
