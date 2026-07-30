import Foundation

enum CheatSheetContent {
    static let sections: [CheatSection] = codexSections + OpenClawContent.sections + ClaudeContent.sections

    private static let codexSections: [CheatSection] = [
        CheatSection(
            title: "Overview",
            icon: "star.fill",
            summary: "Best default: prompt Codex like an autonomous senior engineer, give it the right repo context, tell it what \"done\" means, and require verification before final handoff.",
            tableHeaders: ("Use case", "Prompting pattern", "Verification anchor"),
            rows: [
                PatternRow(left: "Bug fixing", middle: "Repro → suspected area → constraints → tests", right: "Bug no longer reproduces; regression test passes"),
                PatternRow(left: "Feature writing", middle: "Goal → context → constraints → done when", right: "Behavior visible; lint/type/tests pass"),
                PatternRow(left: "Codebase exploration", middle: "Ask for map, call graph, conventions, risky files", right: "Summary references files and uncertainty"),
                PatternRow(left: "Refactor", middle: "Preserve behavior → search prior art → minimal coherent edits", right: "Existing tests plus targeted behavior checks"),
                PatternRow(left: "Agent setup", middle: "Move recurring rules into AGENTS.md", right: "Codex echoes active guidance in precedence order"),
            ],
            bullets: [],
            templates: [],
            keywords: ["autonomy", "persistence", "AGENTS.md", "standard prompt", "verification", "done when"]
        ),
        CheatSection(
            title: "Standard Prompt Structure",
            icon: "list.bullet.rectangle",
            summary: "OpenAI recommends starting from the standard Codex-Max prompt and making tactical additions, especially around autonomy, persistence, codebase exploration, tool use, and frontend quality.",
            tableHeaders: ("Section", "What it controls", "Cheat-sheet version"),
            rows: [
                PatternRow(left: "Role", middle: "Identity and execution environment", right: "\"You are Codex, a coding agent running on the user's machine.\""),
                PatternRow(left: "General", middle: "Search, tools, parallelism, line-number handling", right: "Prefer rg; use dedicated tools; parallelize independent reads; deliver working code."),
                PatternRow(left: "Autonomy and persistence", middle: "How much to proceed without user hand-holding", right: "Gather context, plan, implement, test, refine; ask only when blocked."),
                PatternRow(left: "Code implementation", middle: "Engineering quality bar", right: "Root cause, conventions, type safety, error handling, reuse, complete wiring."),
                PatternRow(left: "Editing constraints", middle: "Safe mutation behavior", right: "Respect dirty worktrees; avoid destructive git; use patches; do not revert user work."),
                PatternRow(left: "Exploration", middle: "Context-gathering workflow", right: "Think first; batch reads; only sequence when later reads depend on earlier output."),
                PatternRow(left: "Plan tool", middle: "Task planning hygiene", right: "Use for non-trivial tasks; update statuses; close all items before final."),
                PatternRow(left: "Presentation", middle: "Final answer style", right: "Concise coding-teammate summary with changes, tests, and next steps."),
            ],
            bullets: [
                "Keep prompts outcome-oriented but include enough execution rules to prevent common agent failures: premature stopping, unverified changes, unsafe edits, and repeated file-reading loops."
            ],
            templates: [
                PromptTemplate(title: "Standard Structure Template", body: """
You are Codex, running as a coding agent in this repo.
Goal: [what to build/fix]
Context: [files, error logs, screenshots, docs, commands]
Constraints: [architecture, style, safety, dependencies, compatibility]
Autonomy: act as a senior engineer; gather context, implement, test, and refine without stopping for approval unless blocked.
Done when: [tests/checks pass, behavior verified, diff reviewed]
Final response: summarize changes, tests run, and any residual risk.
""")
            ],
            keywords: ["standard prompt", "role", "autonomy", "persistence", "exploration", "plan mode"]
        ),
        CheatSection(
            title: "Autonomy Instructions",
            icon: "gearshape.2",
            summary: "The Codex Prompting Guide emphasizes autonomy and persistence: once a user gives direction, Codex should gather context, plan, implement, test, and refine rather than stopping at analysis or asking for repeated confirmations.",
            tableHeaders: ("Instruction", "Why it works", "Use it when"),
            rows: [
                PatternRow(left: "\"Default expectation: deliver working code, not just a plan.\"", middle: "Prevents answer-only or planning-only failure modes.", right: "Implementation, bug fix, test creation"),
                PatternRow(left: "\"Make reasonable assumptions unless truly blocked.\"", middle: "Reduces clarification loops for details that can be inferred safely.", right: "Routine product or infrastructure changes"),
                PatternRow(left: "\"Persist until handled end-to-end.\"", middle: "Pushes the agent through implementation, verification, and explanation.", right: "Tasks where build/test access exists"),
                PatternRow(left: "\"Stop if looping without progress.\"", middle: "Adds a safety brake against endless rereading or patch thrashing.", right: "Ambiguous failures or flaky test debugging"),
                PatternRow(left: "\"Do not communicate upfront plans during rollout\" (older harnesses)", middle: "OpenAI warns that prompting for plans/preambles can cause abrupt stopping in some setups.", right: "API/harness tuning and evals"),
            ],
            bullets: [],
            templates: [
                PromptTemplate(title: "Autonomy Block", body: """
Autonomy:
- Treat this as a non-interactive implementation task.
- Make reasonable assumptions and proceed.
- If a choice has meaningful product or security risk, stop and ask one targeted question.
- Finish with code changes, verification results, and residual risks.
""")
            ],
            keywords: ["autonomy", "persistence", "confirmation", "looping"]
        ),
        CheatSection(
            title: "AGENTS.md Usage",
            icon: "doc.text",
            summary: "OpenAI describes AGENTS.md as durable project guidance that Codex reads before doing work; useful for repo layout, setup, build/test commands, conventions, constraints, PR expectations, and the definition of done. Discovery chain: Codex checks the Codex home directory, then walks from project root to the current working directory, including at most one instruction file per directory; files closer to the current directory appear later and override broader guidance.",
            tableHeaders: ("Layer", "Location", "Best content"),
            rows: [
                PatternRow(left: "Global defaults", middle: "~/.codex/AGENTS.md", right: "Personal style, preferred package manager, confirmation thresholds, review verbosity."),
                PatternRow(left: "Temporary global override", middle: "~/.codex/AGENTS.override.md", right: "Short-lived override without deleting the base file."),
                PatternRow(left: "Repository rules", middle: "repo-root/AGENTS.md", right: "Project setup, commands, architecture, test strategy, PR checklist."),
                PatternRow(left: "Directory-specific rules", middle: "subdir/AGENTS.md or AGENTS.override.md", right: "Service-specific commands, local constraints, ownership rules."),
                PatternRow(left: "Fallback names", middle: "TEAM_GUIDE.md, .agents.md via config", right: "Existing team docs that should be treated as instructions."),
            ],
            bullets: [
                "Keep AGENTS.md short and practical. OpenAI recommends adding rules after repeated mistakes, recurring PR feedback, or observed routing problems, rather than front-loading a long vague policy document."
            ],
            templates: [
                PromptTemplate(title: "AGENTS.md Skeleton", body: """
# AGENTS.md
## Repository expectations
- Use pnpm for dependency commands.
- Run `pnpm lint`, `pnpm typecheck`, and targeted tests before final response.
- Reuse existing helpers before adding new utilities.
- Do not add production dependencies without confirmation.
- Done means: implementation complete, tests/checks run, diff reviewed, risks reported.
""")
            ],
            keywords: ["AGENTS.md", "durable instructions", "precedence", "discovery chain"]
        ),
        CheatSection(
            title: "Verification Steps",
            icon: "checkmark.seal",
            summary: "OpenAI's Codex prompting docs state that Codex produces higher-quality outputs when it can verify its work, and recommend including reproduction steps, validation steps, linting, and pre-commit checks.",
            tableHeaders: ("Task", "Ask Codex to verify", "Example done-when clause"),
            rows: [
                PatternRow(left: "Bug fix", middle: "Reproduce first if possible; add or update regression test; rerun focused test.", right: "\"Done when the original repro fails before the fix, passes after, and the targeted test is committed.\""),
                PatternRow(left: "Feature", middle: "Run unit/integration tests for changed surface; manually inspect behavior if UI.", right: "\"Done when CLI --json emits valid JSON and existing text output remains unchanged.\""),
                PatternRow(left: "Refactor", middle: "Run existing tests; compare external behavior; review diff for accidental API changes.", right: "\"Done when public behavior is unchanged and no new dependencies or broad catches were added.\""),
                PatternRow(left: "Frontend", middle: "Build, lint, check responsive behavior, verify changed user flow.", right: "\"Done when page loads on desktop/mobile and screenshots or manual steps confirm the UI.\""),
                PatternRow(left: "Docs/config", middle: "Run the command that proves the guidance/config loads.", right: "\"Done when Codex summarizes active instructions in expected precedence order.\""),
            ],
            bullets: [],
            templates: [
                PromptTemplate(title: "Verification Block", body: """
Verification:
- Start by identifying the smallest reliable repro or acceptance check.
- Add or update tests when behavior changes.
- Run the narrowest relevant checks first, then broader lint/type/build if appropriate.
- Before final response, review the diff for regressions, silent failures, broad catches, and unrelated edits.
""")
            ],
            keywords: ["verification", "tests", "lint", "done when", "regression"]
        ),
        CheatSection(
            title: "Task Breakdown Tips",
            icon: "square.stack.3d.up",
            summary: "OpenAI recommends breaking complex Codex work into smaller, focused steps because smaller tasks are easier for Codex to test and easier for users to review. For difficult or fuzzy tasks, OpenAI suggests Plan mode, asking Codex to interview the user, or using a PLANS.md/execution-plan template before coding.",
            tableHeaders: ("If the task is…", "Split it into…", "Prompt move"),
            rows: [
                PatternRow(left: "Ambiguous", middle: "Plan/interview phase, then implementation phase", right: "\"Ask up to 5 questions or propose assumptions before coding.\""),
                PatternRow(left: "Large feature", middle: "Data model/API, UI, tests, docs", right: "\"Implement slice 1 end-to-end before expanding.\""),
                PatternRow(left: "Hard bug", middle: "Repro, trace, root cause, fix, regression test", right: "\"Do not patch symptoms until root cause is identified.\""),
                PatternRow(left: "Risky refactor", middle: "Read conventions, create characterization tests, change one boundary", right: "\"Preserve behavior; stop if tests reveal unclear intent.\""),
                PatternRow(left: "Parallelizable", middle: "Independent agents/threads per component", right: "\"Use separate worktrees/threads; avoid two agents editing same files.\""),
            ],
            bullets: [],
            templates: [
                PromptTemplate(title: "Breakdown Prompt", body: """
This is a multi-step change. First inspect only the minimum context needed and propose a 3-6 step plan.
After the plan, implement one coherent slice at a time.
After each slice, update the plan, run the relevant check, and continue unless blocked.
Close every plan item as Done, Blocked, or Cancelled before the final response.
""")
            ],
            keywords: ["task breakdown", "plan mode", "worktrees", "slices"]
        ),
        CheatSection(
            title: "Use-Case Templates",
            icon: "rectangle.stack",
            summary: "Ready-to-fill prompt templates for the five most common Codex tasks. Use the Prompt Builder tab to fill these in interactively.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Bug Fixing", body: """
Goal: Fix [bug].
Context: [error log], [steps to reproduce], [suspected files], [recent changes].
Constraints: preserve public behavior except the bug; no broad try/catch or silent fallback.
Process: reproduce or explain why not; identify root cause; implement minimal coherent fix; add regression test.
Done when: repro passes, targeted tests pass, diff reviewed for unrelated edits.
"""),
                PromptTemplate(title: "Feature Writing", body: """
Goal: Add [feature] for [user/job].
Context: [existing command/API/page], [examples], [acceptance criteria].
Constraints: follow existing patterns; avoid new dependencies unless necessary; keep type safety.
Process: search for prior art, implement across all relevant surfaces, update docs/tests.
Done when: feature works through the intended entry point and lint/type/tests pass.
"""),
                PromptTemplate(title: "Codebase Exploration", body: """
Goal: Explain how [module/flow] works.
Context: start from [entry file], [route], or [command].
Constraints: read only; do not edit files.
Output: concise map of key files, control flow, data contracts, extension points, and uncertainties.
Done when: answer cites concrete files/functions and separates facts from hypotheses.
"""),
                PromptTemplate(title: "Refactor", body: """
Goal: Refactor [area] to [target design].
Context: [pain point], [current tests], [compatibility constraints].
Constraints: preserve behavior; keep public APIs stable unless requested; batch logical edits.
Process: characterize behavior, search for duplicate helpers, change one boundary at a time.
Done when: existing tests pass and diff shows no unrelated rewrites.
"""),
                PromptTemplate(title: "AGENTS.md Update", body: """
Goal: Improve durable Codex guidance for this repo.
Context: recurring mistake: [describe mistake].
Constraints: keep AGENTS.md short, practical, and repo-specific.
Process: inspect existing AGENTS.md, add the smallest rule that prevents recurrence, include verification commands.
Done when: Codex can summarize the active instruction sources and the new rule.
"""),
            ],
            keywords: ["bug fixing", "feature writing", "exploration", "refactor", "templates"]
        ),
        CheatSection(
            title: "Anti-Patterns and Fixes",
            icon: "exclamationmark.triangle",
            summary: "OpenAI's best-practices guide warns against overloading prompts with durable rules, skipping planning on complex work, not giving test commands, giving full computer permissions too early, and running live threads on the same files without worktrees.",
            tableHeaders: ("Anti-pattern", "Likely failure", "Replace with"),
            rows: [
                PatternRow(left: "\"Look into this.\"", middle: "Unbounded exploration or vague summary.", right: "Goal + context + done-when + verification command."),
                PatternRow(left: "Huge task in one prompt", middle: "Half-finished rollout or hard-to-review diff.", right: "Plan mode or sequential slices with checks."),
                PatternRow(left: "Prompt repeats repo rules every time", middle: "Long prompts, drift, omissions.", right: "Move recurring rules to AGENTS.md or a skill."),
                PatternRow(left: "No verification instructions", middle: "Code that looks plausible but is untested.", right: "Explicit repro, tests, lint/type/build, diff review."),
                PatternRow(left: "Two threads edit same files", middle: "Merge conflicts and duplicated work.", right: "Use separate worktrees or assign disjoint file areas."),
                PatternRow(left: "Full permissions too early", middle: "Unwanted file/network side effects.", right: "Start with default sandbox/approval; loosen only for trusted workflows."),
            ],
            bullets: [
                "State the exact outcome: bug fixed, feature shipped, code explained, or tests added.",
                "Attach context: files, logs, screenshots, commands, acceptance criteria, and constraints.",
                "Name the verification path: repro, tests, lint, typecheck, build, manual UI check, or instruction-source check.",
                "Set autonomy: implement now, plan first, read-only exploration, or non-interactive execution.",
                "Move durable repo rules into AGENTS.md after they prove useful.",
            ],
            templates: [],
            keywords: ["anti-patterns", "checklist", "worktrees", "permissions"]
        ),
        CheatSection(
            title: "One-Page Master Prompt",
            icon: "doc.richtext",
            summary: "Combines the official Goal, Context, Constraints, Done when structure from Codex best practices with the autonomy, persistence, tool-use, and verification patterns from the Codex Prompting Guide. Use the Prompt Builder tab to fill this in interactively.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Master Prompt", body: """
You are Codex working in this repository.

Goal:
[One sentence describing the concrete outcome.]

Context:
- Relevant files/docs/logs: [paths or pasted excerpts]
- Current behavior: [what happens now]
- Desired behavior: [what should happen]

Constraints:
- Follow existing repo conventions and AGENTS.md.
- Reuse existing helpers before adding new ones.
- Preserve unrelated user changes and avoid destructive git commands.
- Do not add dependencies or change public behavior unless required.

Autonomy:
Act as an autonomous senior engineer. Gather context, make reasonable assumptions, implement, test, and refine. Ask only if blocked by a decision with real product/security risk.

Verification:
- Reproduce or define the smallest acceptance check.
- Add/update tests if behavior changes.
- Run targeted tests plus lint/type/build when relevant.
- Review the final diff for regressions, unrelated edits, broad catches, and silent failures.

Done when:
[Specific measurable completion criteria.]

Final response:
Summarize what changed, files touched, checks run, results, and any residual risk.
""")
            ],
            keywords: ["master prompt", "one-page", "goal", "context", "constraints"]
        ),
    ]
}
