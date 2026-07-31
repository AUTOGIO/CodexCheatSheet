import Foundation

/// Tool-agnostic power prompts (#51–100). Companion to OpenClaw's original 50.
/// Works with any AI/agent that has shell + file access — no tool names hardcoded.
/// Defaults: read-only unless stated, no destructive actions, risk-ranked output, executive-concise formatting.
enum ToolAgnosticContent {
    static let sections: [CheatSection] = [
        CheatSection(
            title: "Power · macOS Operations",
            icon: "laptopcomputer",
            summary: "Tool-agnostic read-only macOS ops: login items, Spotlight, Time Machine, network/DNS, battery, Keychain, software updates, and multi-display health.",
            tableHeaders: nil,
            rows: [],
            bullets: [
                "Defaults across all Power prompts: read-only unless stated, no destructive actions, risk-ranked output, executive-concise formatting."
            ],
            templates: [
                PromptTemplate(title: "Login Items & Background Task Audit", body: """
Inspect all login items and background task agents on this Mac.

Identify:
- items launching at login
- hidden background helpers
- items with no visible UI
- duplicate or orphaned entries

Generate:
- risk-ranked findings
- removal candidates (do not remove)

Read-only only.
"""),
                PromptTemplate(title: "Spotlight/mds Resource Audit", body: """
Inspect Spotlight indexing (mds/mdworker) resource usage.

Check:
- current CPU/memory load from indexing processes
- excluded vs indexed volumes
- reindex loops or repeated indexing events
- privacy-sensitive paths being indexed unintentionally

Generate:
- findings
- exclusion recommendations

Do not change Spotlight settings.
"""),
                PromptTemplate(title: "Time Machine / Backup Health Check", body: """
Inspect backup health on this Mac (Time Machine or equivalent).

Check:
- last successful backup timestamp
- backup destination free space
- skipped/failed backup events
- backup frequency vs configured schedule

Generate:
- risk-ranked findings
- recommended next action

Read-only only.
"""),
                PromptTemplate(title: "Network Interface & DNS Configuration Audit", body: """
Inspect network interface and DNS configuration.

Check:
- active interfaces and priority order
- DNS servers in use
- DNS resolution latency
- VPN/proxy configuration if present
- unexpected search domains

Generate:
- findings
- risk-ranked recommendations

No changes.
"""),
                PromptTemplate(title: "Battery & Power Management Audit", body: """
Inspect battery health and power management on this Mac.

Check:
- battery cycle count and condition
- power-hungry processes
- App Nap / power-saving exceptions
- charging behavior anomalies

Generate:
- health summary
- optimization candidates

Read-only only.
"""),
                PromptTemplate(title: "Keychain & Certificate Expiry Audit", body: """
Inspect Keychain and installed certificates.

Check:
- expired or soon-to-expire certificates
- self-signed certificates in use
- duplicate keychain entries
- login keychain lock/unlock behavior

Generate:
- risk-ranked findings

Do not modify or delete any keychain item.
"""),
                PromptTemplate(title: "Software Update / Patch Compliance Check", body: """
Inspect OS and installed application update status.

Check:
- pending OS updates
- outdated applications with known CVEs (if determinable)
- auto-update settings per app
- last update check timestamp

Generate:
- compliance summary
- risk-ranked findings

Do not install anything.
"""),
                PromptTemplate(title: "Window Manager / Multi-Display Health Check", body: """
Inspect window manager and multi-display configuration health.

Check:
- window manager process status
- config file validity
- display arrangement vs saved profile
- crash/restart history

Generate:
- findings
- recommended fixes (do not apply)

Read-only only.
"""),
            ],
            keywords: ["power", "tool-agnostic", "macos", "login items", "spotlight", "time machine", "dns", "battery", "keychain", "software update"]
        ),
        CheatSection(
            title: "Power · Repo / Git / Skills",
            icon: "hammer",
            summary: "Tool-agnostic repo hygiene: dependency freshness, secrets in git history, README gaps, branch hygiene, dead code, licenses, commit quality, and naming consistency.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Dependency Freshness Audit", body: """
Inspect dependency files (package.json, requirements.txt, Podfile, etc.) across all local repos.

Identify:
- outdated dependencies
- dependencies with known vulnerabilities (if determinable)
- unpinned/floating versions
- unused declared dependencies

Generate:
- risk-ranked findings
- upgrade priority list

Read-only only. Do not run installs or upgrades.
"""),
                PromptTemplate(title: "Secrets/Credential Leak Scan (Git History)", body: """
Scan git history and working tree across local repos for exposed secrets.

Look for:
- API keys, tokens, passwords in code or commit history
- .env files committed by mistake
- hardcoded credentials in config files

Generate:
- findings with file + commit reference
- severity ranking

Do not rewrite history. Do not print full secret values — mask them.
"""),
                PromptTemplate(title: "README/Documentation Completeness Audit", body: """
Inspect README and documentation files across local repos.

Check for:
- missing setup instructions
- missing usage examples
- outdated references (renamed files, dead links)
- inconsistent formatting across repos

Generate:
- gap list per repo
- improvement recommendations

No edits — report only.
"""),
                PromptTemplate(title: "Branch Protection & Merge Hygiene Review", body: """
Inspect branch structure and merge history across local repos.

Check:
- stale branches (no activity in 60+ days)
- unmerged feature branches
- direct commits to main/master
- merge conflict frequency

Generate:
- cleanup candidates
- risk-ranked findings

Read-only only.
"""),
                PromptTemplate(title: "Dead Code / Unused File Detection", body: """
Scan repos for dead code and unused files.

Identify:
- files never imported/referenced
- commented-out large code blocks
- unused functions/exports (where determinable)
- orphaned assets

Generate:
- candidate list for removal
- confidence level per candidate

Do not delete anything.
"""),
                PromptTemplate(title: "License & Attribution Compliance Check", body: """
Inspect all repos for license and attribution compliance.

Check:
- presence of LICENSE file
- consistency of license across repo and dependencies
- missing attribution for third-party code/assets

Generate:
- compliance summary
- risk-ranked findings

Read-only only.
"""),
                PromptTemplate(title: "Commit Message Quality Audit", body: """
Inspect commit history quality across local repos.

Check:
- vague messages ("fix", "update", "wip")
- missing context on breaking changes
- inconsistent commit conventions

Generate:
- quality score per repo
- improvement recommendations

Read-only only.
"""),
                PromptTemplate(title: "Cross-Repo Naming Convention Consistency Check", body: """
Inspect naming conventions across all local repos.

Check:
- file/folder naming consistency
- function/variable naming style consistency
- config key naming consistency

Generate:
- inconsistency findings
- standardization recommendations

No renames — report only.
"""),
            ],
            keywords: ["power", "tool-agnostic", "repo", "git", "dependencies", "secrets", "readme", "dead code", "license", "commit"]
        ),
        CheatSection(
            title: "Power · AI / MCP / Runtime",
            icon: "cpu",
            summary: "Tool-agnostic AI control-plane audits: credential rotation, context cost, local vs cloud routing, quotas, tool-call failures, multi-agent handoffs, version drift, and fallback resilience.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "API Key & Token Rotation Audit", body: """
Inspect API keys and tokens used by local AI tooling and configs.

Check:
- age of each credential (if determinable from config/file metadata)
- credentials with overly broad scope
- credentials stored in plaintext vs secure storage

Generate:
- risk-ranked findings
- rotation priority list

Do not print full credential values — mask them. Do not rotate anything.
"""),
                PromptTemplate(title: "Prompt/Context Window Cost Audit", body: """
Inspect recent AI usage patterns (logs, session history) for cost efficiency.

Check:
- oversized context windows relative to task
- repeated redundant context re-sending
- opportunities to cache or shorten prompts

Generate:
- cost-saving recommendations
- estimated impact per change

Read-only only.
"""),
                PromptTemplate(title: "Local vs Cloud Model Routing Decision Report", body: """
Analyze current tasks/workloads run through AI tooling.

Classify each by:
- suitability for local model execution
- suitability for cloud model execution
- latency/cost/privacy trade-offs

Generate:
- routing recommendation per workload type
- rationale

No changes to routing config.
"""),
                PromptTemplate(title: "Rate Limit / Quota Exposure Check", body: """
Inspect API rate limit and quota usage for connected AI providers.

Check:
- current usage vs limit
- recent throttling events
- providers nearing quota exhaustion

Generate:
- risk-ranked findings
- recommended mitigation

Read-only only.
"""),
                PromptTemplate(title: "Agent Tool-Call Failure Pattern Analysis", body: """
Inspect recent agent/tool-call logs for failure patterns.

Identify:
- most frequent failure types
- tools with highest failure rate
- retry storms or infinite loops

Generate:
- root-cause hypotheses
- stability recommendations

Read-only only.
"""),
                PromptTemplate(title: "Multi-Agent Handoff Reliability Audit", body: """
Inspect handoff points between agents/tools in current automation chains.

Check:
- data format consistency across handoffs
- silent failure points
- missing error propagation

Generate:
- reliability findings
- recommended safeguards

No changes.
"""),
                PromptTemplate(title: "AI Runtime Update/Version Drift Check", body: """
Inspect installed AI runtime and model versions across the system.

Check:
- version drift between tools that should be aligned
- deprecated model versions still in use
- breaking-change risk on next update

Generate:
- risk-ranked findings

Read-only only. Do not update anything.
"""),
                PromptTemplate(title: "Fallback Chain Resilience Test Plan", body: """
Design a test plan (do not execute changes) to validate AI provider fallback chains.

Cover:
- primary provider failure simulation
- fallback trigger conditions
- expected degraded-mode behavior

Generate:
- step-by-step test plan
- success/failure criteria per step

Planning only — no execution against production config.
"""),
            ],
            keywords: ["power", "tool-agnostic", "ai", "mcp", "api key", "quota", "routing", "handoff", "fallback"]
        ),
        CheatSection(
            title: "Power · Apple / Home Automation",
            icon: "house",
            summary: "Tool-agnostic home automation audits: HomeKit conflicts, scene latency, firmware compliance, IoT isolation, notification fatigue, energy usage, occupancy accuracy, and backup readiness.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "HomeKit Automation Conflict Detection", body: """
Inspect all HomeKit/home automation rules and scenes.

Identify:
- conflicting automations (opposite actions on same device)
- overlapping triggers
- automations that never fire (dead rules)

Generate:
- conflict list
- resolution recommendations

Do not modify automations.
"""),
                PromptTemplate(title: "Scene Reliability & Trigger Latency Audit", body: """
Inspect scene execution reliability and trigger latency.

Check:
- average time from trigger to execution
- scenes with frequent partial failures
- devices consistently slow to respond

Generate:
- reliability findings
- recommended fixes

Read-only only.
"""),
                PromptTemplate(title: "Device Firmware/Update Compliance Check", body: """
Inspect firmware/update status of all connected smart home devices.

Check:
- devices on outdated firmware
- devices with known stability issues on current firmware
- update availability

Generate:
- compliance summary
- risk-ranked findings

Do not push updates.
"""),
                PromptTemplate(title: "Guest Network / IoT Isolation Audit", body: """
Inspect network isolation posture for IoT/smart home devices.

Check:
- devices on main LAN vs isolated VLAN/guest network
- devices with unnecessary internet access
- devices communicating cross-segment unexpectedly

Generate:
- risk-ranked findings
- isolation recommendations

Read-only only.
"""),
                PromptTemplate(title: "Notification Fatigue Audit", body: """
Inspect home automation notification volume and relevance.

Check:
- notification frequency per device/automation
- low-value or redundant alerts
- alerts with no clear action needed

Generate:
- fatigue score
- recommended notification reductions

No changes applied.
"""),
                PromptTemplate(title: "Energy Usage Pattern Report", body: """
Inspect energy usage data from smart plugs/monitored devices, if available.

Report:
- highest-consumption devices
- unusual consumption patterns
- always-on standby loads

Generate:
- findings
- efficiency recommendations

Read-only only.
"""),
                PromptTemplate(title: "Presence/Occupancy Automation Accuracy Check", body: """
Inspect presence/occupancy-based automations.

Check:
- false-positive trigger rate
- false-negative (missed) trigger rate
- sensor placement or type issues contributing to inaccuracy

Generate:
- accuracy findings
- recommended adjustments

Do not modify sensors or automations.
"""),
                PromptTemplate(title: "Home Automation Backup/Restore Readiness Check", body: """
Inspect backup/restore readiness for the home automation setup.

Check:
- last configuration backup date
- backup completeness (devices, automations, scenes)
- restore procedure documented or not

Generate:
- readiness assessment
- gap list

Read-only only.
"""),
            ],
            keywords: ["power", "tool-agnostic", "homekit", "automation", "firmware", "iot", "notification", "energy", "occupancy"]
        ),
        CheatSection(
            title: "Power · Executive / Strategic",
            icon: "chart.line.uptrend.xyaxis",
            summary: "Tool-agnostic executive reviews: weekly progress vs plan, scope creep, ADR consistency, tech-debt priority, tool consolidation, freeze/kill candidates, dependency risk, and stability vs growth balance.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Weekly Progress vs Plan Review", body: """
Generate a Weekly Progress vs Plan Review across active projects.

For each active project, report:
- planned milestone for the week
- actual progress
- variance and likely cause
- carry-over risk to next week

Generate:
- executive summary
- one recommended action per project

No remediation — report only.
"""),
                PromptTemplate(title: "Scope Creep Detection Across Active Projects", body: """
Inspect active projects for scope creep.

Identify:
- features/requirements added beyond original stated goal
- "nice to have" additions delaying core delivery
- projects with growing but undelivered scope

Generate:
- scope-creep findings per project
- recommended scope cuts

Report only — no changes to project plans.
"""),
                PromptTemplate(title: "Decision Log / ADR Consistency Audit", body: """
Inspect past decisions/notes across projects for consistency.

Check:
- contradictory decisions across time
- decisions never followed through
- undocumented but implemented decisions

Generate:
- consistency findings
- recommended reconciliation

Read-only only.
"""),
                PromptTemplate(title: "Technical Debt Prioritization Report", body: """
Inspect known technical debt items across active projects.

Rank by:
- impact if unresolved
- effort to resolve
- risk of compounding if delayed

Generate:
- prioritized debt list
- recommended resolution order

Report only.
"""),
                PromptTemplate(title: "Tool Consolidation Opportunity Report", body: """
Inspect the current tool/app stack across all active projects.

Identify:
- overlapping tools serving the same function
- tools with low usage relative to maintenance cost
- consolidation opportunities

Generate:
- consolidation recommendations
- estimated complexity reduction

No changes applied.
"""),
                PromptTemplate(title: "Project Freeze/Kill Candidate Assessment", body: """
Assess all active projects for freeze or kill candidacy.

Evaluate:
- time since last meaningful progress
- alignment with current priorities
- cost of maintaining vs cost of freezing

Generate:
- freeze/kill/continue recommendation per project
- rationale

Assessment only — no project status changes made.
"""),
                PromptTemplate(title: "Cross-Project Dependency Risk Map", body: """
Map dependencies between active projects (shared code, data, infrastructure, or tooling).

Identify:
- single points of failure shared across projects
- projects blocked by another project's instability

Generate:
- dependency map
- risk-ranked findings

Read-only only.
"""),
                PromptTemplate(title: "Quarterly Stability vs Growth Balance Review", body: """
Generate a Quarterly Stability vs Growth Balance Review.

Assess:
- time spent stabilizing vs time spent expanding scope
- number of new tools/projects started vs finished
- alignment with "stabilize before automate" principle

Generate:
- balance assessment
- rebalancing recommendation for next quarter

Report only.
"""),
            ],
            keywords: ["power", "tool-agnostic", "executive", "scope creep", "adr", "tech debt", "consolidation", "dependency"]
        ),
        CheatSection(
            title: "Power · Personal Productivity",
            icon: "person.crop.circle",
            summary: "Tool-agnostic personal ops: workflow suggestion quality, activity tracking gaps, feature completion, subscriptions, spend reconciliation, habits, backlog aging, deep work, automation reliability, and life-admin bottlenecks.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Workflow Suggestion Quality Audit", body: """
Inspect recent passive workflow tracking and suggestion output.

Evaluate:
- suggestion relevance to actual observed behavior
- false-positive suggestion rate
- time from pattern detection to suggestion delivered

Generate:
- quality findings
- tuning recommendations

Read-only only.
"""),
                PromptTemplate(title: "Activity Tracking Data Completeness Check", body: """
Inspect passive activity tracking data for gaps.

Check:
- tracking downtime/gaps
- apps or windows not being captured
- data retention vs expected window

Generate:
- completeness report
- gap findings

Read-only only.
"""),
                PromptTemplate(title: "Personal App Feature Completion Status Report", body: """
Generate a feature completion status report for your personal productivity app(s) in progress.

For each planned feature, report:
- status (not started / in progress / done)
- blockers
- last activity date

Generate:
- executive summary
- stalled-feature flags

Report only.
"""),
                PromptTemplate(title: "Subscription Audit (Unknown-Cycle/Cost Detection)", body: """
Inspect all recurring subscriptions (software, cloud, services).

Identify:
- unknown or unclear billing cycle
- unknown or unclear cost
- duplicate/overlapping subscriptions
- unused subscriptions

Generate:
- risk-ranked findings
- cancellation candidates

Do not cancel anything.
"""),
                PromptTemplate(title: "Monthly Spend Reconciliation", body: """
Reconcile monthly recurring spend (AI tools, cloud services, hardware/software subscriptions) against expected budget.

Check:
- unexpected charges
- price increases since last review
- spend trend over the last 3 months

Generate:
- reconciliation summary
- flagged items for review

Report only.
"""),
                PromptTemplate(title: "Daily Habit/Routine Adherence Report", body: """
Generate a daily habit/routine adherence report based on tracked data.

Report:
- adherence rate per habit
- streak status
- most common drop-off point in the day

Generate:
- summary
- one highest-leverage adjustment recommendation

Report only — no automated changes to routines.
"""),
                PromptTemplate(title: "Task Backlog Aging & Priority Audit", body: """
Inspect the personal/task backlog for aging items.

Identify:
- tasks open longer than 30/60/90 days
- high-priority tasks with no recent activity
- tasks that no longer appear relevant

Generate:
- aging report
- recommended close/defer/escalate per item

Report only.
"""),
                PromptTemplate(title: "Focus Session / Deep Work Consistency Report", body: """
Inspect tracked focus/deep-work session data.

Report:
- session frequency and average length over the last 2 weeks
- most common interruption source (if trackable)
- consistency trend (improving/declining)

Generate:
- summary
- one adjustment recommendation

Report only.
"""),
                PromptTemplate(title: "Personal Automation Reliability Scorecard", body: """
Generate a reliability scorecard for all personal automations (Shortcuts, scripts, scheduled tasks).

For each automation, report:
- success rate
- last failure date and likely cause
- maintenance burden (low/medium/high)

Generate:
- scorecard
- top 3 reliability risks

Read-only only.
"""),
                PromptTemplate(title: "Life Admin Bottleneck Identification Report", body: """
Inspect recurring life-admin tasks (financial reviews, tax prep, subscription management, backups, etc.) for bottlenecks.

Identify:
- tasks consistently delayed or skipped
- tasks with unclear ownership/next step
- tasks that could be simplified or automated (flag only, do not implement)

Generate:
- bottleneck findings
- simplification candidates ranked by effort vs relief

Report only.
"""),
            ],
            keywords: ["power", "tool-agnostic", "productivity", "subscription", "habit", "backlog", "focus", "life admin"]
        ),
    ]
}
