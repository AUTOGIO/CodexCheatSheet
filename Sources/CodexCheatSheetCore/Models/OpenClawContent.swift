import Foundation

/// Ready-to-use OpenClaw prompts (macos-exec / repo-audit / local-first ops).
/// Personal absolute paths from source notes are replaced with [bracket] placeholders.
enum OpenClawContent {
    static let sections: [CheatSection] = [
        CheatSection(
            title: "OpenClaw · macOS Operations",
            icon: "desktopcomputer",
            summary: "Read-only macos-exec prompts for daily ops, LaunchAgents, Homebrew, listeners, disk, startup, and local AI runtime health. Optimized for OpenClaw + local-first Apple Silicon workflows.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Daily Operations Brief", body: """
Use macos-exec to generate a Daily macOS Operations Brief.

Include:
- Homebrew services
- LaunchAgent failures
- disk usage
- memory pressure
- OpenClaw/Codex/Ollama runtime health
- listener exposure
- top CPU consumers
- risk-ranked findings

Read-only only.
Do not make changes.
"""),
                PromptTemplate(title: "LaunchAgent Audit", body: """
Use macos-exec to inspect all user LaunchAgents.

Identify:
- failed agents
- crash loops
- invalid plists
- wildcard listeners
- duplicate services

Generate:
- risk-ranked report
- recommended next actions

Do not modify anything.
"""),
                PromptTemplate(title: "Homebrew Health Scan", body: """
Use macos-exec to inspect Homebrew services and formulas.

Report:
- failed services
- outdated formulas
- broken symlinks
- duplicate taps
- disabled services

Read-only only.
"""),
                PromptTemplate(title: "Listener Exposure Audit", body: """
Use macos-exec to inspect listening ports and exposure posture.

Classify:
- loopback-only
- LAN exposed
- wildcard listeners
- unexpected listeners

Generate:
- process owner
- PID
- risk level
- recommended next step

No remediation.
"""),
                PromptTemplate(title: "Apple Silicon Health Snapshot", body: """
Use macos-exec to generate an Apple Silicon runtime health snapshot.

Inspect:
- CPU usage
- memory pressure
- swap usage
- thermal indicators
- top processes

Target environment:
- [Apple Silicon Mac]
- [RAM]
- [macOS version]

Read-only only.
"""),
                PromptTemplate(title: "OpenClaw Runtime Audit", body: """
Use macos-exec to inspect OpenClaw runtime health.

Include:
- gateway status
- active sessions
- Codex process chain
- OpenAI provider state
- listener exposure
- resource usage

Generate:
- operational risk summary

No changes.
"""),
                PromptTemplate(title: "Ollama Runtime Audit", body: """
Use macos-exec to inspect Ollama runtime health.

Check:
- running models
- memory usage
- exposed listeners
- zombie processes
- launch configuration

Read-only only.
"""),
                PromptTemplate(title: "Disk Pressure Audit", body: """
Use macos-exec to inspect disk usage and storage pressure.

Identify:
- largest directories
- APFS free space
- cache-heavy paths
- duplicated storage

Generate:
- cleanup candidates
- risk-ranked findings

Do not delete files.
"""),
                PromptTemplate(title: "Startup Optimization Report", body: """
Use macos-exec to inspect startup/login operational load.

Include:
- LaunchAgents
- login items
- startup services
- memory-heavy processes

Generate:
- optimization opportunities
- estimated impact

No modifications.
"""),
                PromptTemplate(title: "Local AI Runtime Inventory", body: """
Use macos-exec to inventory all local AI runtimes.

Detect:
- OpenClaw
- Codex
- Ollama
- LM Studio
- MCP servers

Generate:
- process map
- listener map
- operational relationships

Read-only only.
"""),
            ],
            keywords: ["openclaw", "macos-exec", "launchagent", "homebrew", "listeners", "ollama"]
        ),
        CheatSection(
            title: "OpenClaw · Repo / Git / Skills",
            icon: "folder.badge.gearshape",
            summary: "repo-audit and skill-ops prompts: cleanliness, validators, dangerous shell patterns, documentation, drift, and skill inventory/overlap.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Repository Audit", body: """
Use repo-audit on:
[reposRoot]

Generate:
- git cleanliness
- large files
- untracked artifacts
- ignored reports
- stale branches

Read-only only.
"""),
                PromptTemplate(title: "Skill Validation Sweep", body: """
Validate all OpenClaw skills.

Run:
- validators
- bash -n checks
- structure checks

Generate:
- failing skills
- missing references
- broken validators

No modifications.
"""),
                PromptTemplate(title: "Dangerous Shell Scan", body: """
Inspect all shell scripts under openclaw-skills.

Flag:
- sudo
- rm -rf
- curl | bash
- chmod 777
- unquoted variables

Generate:
- risk-ranked findings

Read-only only.
"""),
                PromptTemplate(title: "Markdown Documentation Audit", body: """
Inspect all SKILL.md files.

Identify:
- missing sections
- inconsistent frontmatter
- vague instructions
- missing safety rules

Generate:
- improvement recommendations
"""),
                PromptTemplate(title: "Git Hygiene Audit", body: """
Inspect git hygiene across all local repos.

Check:
- ignored artifacts
- generated reports committed
- large binaries
- stale branches
- detached HEADs

Read-only only.
"""),
                PromptTemplate(title: "Validator Coverage Report", body: """
Generate validator coverage report for openclaw-skills.

Identify:
- skills without validators
- weak validators
- missing bash -n checks
- missing rollback tests
"""),
                PromptTemplate(title: "Repo Drift Detection", body: """
Inspect repo drift across local GitHub projects.

Detect:
- uncommitted changes
- modified configs
- stale generated files

Read-only only.
"""),
                PromptTemplate(title: "OpenClaw Skill Inventory", body: """
Generate inventory of all OpenClaw skills.

Include:
- skill purpose
- validators
- scripts
- operational risk
- overlap analysis
"""),
                PromptTemplate(title: "Skill Overlap Detection", body: """
Analyze all OpenClaw skills for overlap and redundancy.

Identify:
- duplicated functionality
- overlapping scripts
- conflicting workflows

Generate:
- consolidation recommendations
"""),
                PromptTemplate(title: "Local Automation Surface Audit", body: """
Inspect all local automation surfaces.

Include:
- LaunchAgents
- cron
- Homebrew services
- OpenClaw skills
- shell automation

Generate:
- operational map
- risk-ranked findings
"""),
            ],
            keywords: ["openclaw", "repo-audit", "skills", "git", "validators"]
        ),
        CheatSection(
            title: "OpenClaw · AI / MCP / Runtime",
            icon: "cpu",
            summary: "AI control-plane prompts: MCP, Cloudflare tunnels, OpenAI provider, Codex/Ollama memory and listeners, sessions, and gateway exposure.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "MCP Server Inventory", body: """
Inspect all MCP-related processes and listeners.

Identify:
- active servers
- exposed ports
- failing MCPs
- auth posture

Read-only only.
"""),
                PromptTemplate(title: "Cloudflare Tunnel Audit", body: """
Inspect all cloudflared usage.

Identify:
- active tunnels
- configs
- listeners
- duplicate services
- stale LaunchAgents

Do not modify anything.
"""),
                PromptTemplate(title: "OpenAI Provider Audit", body: """
Inspect OpenClaw provider configuration.

Check:
- provider availability
- auth state
- active model
- fallback posture

Do not expose secrets.
"""),
                PromptTemplate(title: "Codex Runtime Audit", body: """
Inspect Codex runtime health.

Include:
- process chain
- auth status
- listener posture
- runtime errors
- resource usage

Read-only only.
"""),
                PromptTemplate(title: "AI Runtime Memory Audit", body: """
Inspect memory usage across all AI runtimes.

Include:
- Ollama
- OpenClaw
- Codex
- LM Studio

Generate:
- memory pressure summary
- optimization candidates
"""),
                PromptTemplate(title: "Local AI Listener Audit", body: """
Inspect all AI-related listening ports.

Classify:
- loopback
- LAN
- wildcard exposure

Generate:
- risk-ranked findings
"""),
                PromptTemplate(title: "AI Runtime Process Graph", body: """
Generate process graph for all local AI systems.

Include:
- parent-child relationships
- active listeners
- runtime dependencies

Read-only only.
"""),
                PromptTemplate(title: "OpenClaw Session Audit", body: """
Inspect active OpenClaw sessions.

Include:
- age
- model usage
- failed sessions
- orphaned sessions

No cleanup.
"""),
                PromptTemplate(title: "Gateway Exposure Audit", body: """
Inspect OpenClaw gateway exposure posture.

Check:
- bind mode
- auth mode
- loopback posture
- wildcard listeners

Read-only only.
"""),
                PromptTemplate(title: "Local AI Operations Brief", body: """
Generate Local AI Operations Brief.

Include:
- OpenClaw
- Codex
- Ollama
- MCP
- cloudflared

Risk-ranked only.
No remediation.
"""),
            ],
            keywords: ["openclaw", "mcp", "codex", "ollama", "cloudflared", "gateway"]
        ),
        CheatSection(
            title: "OpenClaw · Apple / Home Automation",
            icon: "house.fill",
            summary: "Homebridge, Home Assistant, Shortcuts, Bonjour/mDNS, Apple Intelligence coexistence, and local network exposure — read-only diagnostics first.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Homebridge Exposure Audit", body: """
Inspect Homebridge operational posture.

Check:
- listeners
- LAN exposure
- crash loops
- plugin failures

Read-only only.
"""),
                PromptTemplate(title: "Home Assistant Runtime Audit", body: """
Inspect Home Assistant runtime health.

Include:
- process status
- logs
- listeners
- integrations
- resource usage

No changes.
"""),
                PromptTemplate(title: "Home Automation Surface Map", body: """
Generate map of all home automation runtimes.

Include:
- Home Assistant
- Homebridge
- tunnels
- listeners
- LaunchAgents

Read-only only.
"""),
                PromptTemplate(title: "Apple Shortcuts Audit", body: """
Inspect local Shortcuts-related automation surfaces.

Identify:
- automation density
- overlapping triggers
- fragile chains

Generate:
- operational recommendations
"""),
                PromptTemplate(title: "Home Automation Risk Audit", body: """
Generate home automation risk report.

Focus:
- exposed services
- stale bridges
- failing automations
- network exposure

Read-only only.
"""),
                PromptTemplate(title: "Bonjour Exposure Scan", body: """
Inspect Bonjour/mDNS-advertised services.

Identify:
- unnecessary exposure
- wildcard advertisement
- local discovery surfaces

Read-only only.
"""),
                PromptTemplate(title: "Apple Intelligence Runtime Audit", body: """
Inspect Apple Intelligence-related runtime components.

Focus:
- Foundation Models usage
- local AI runtime coexistence
- memory pressure

Read-only only.
"""),
                PromptTemplate(title: "macOS Beta Stability Brief", body: """
Generate operational stability brief for [macOS version] Beta.

Include:
- failing services
- unusual logs
- beta-related instability indicators

No remediation.
"""),
                PromptTemplate(title: "LaunchAgent Dependency Map", body: """
Generate LaunchAgent dependency map.

Identify:
- startup ordering
- dependent services
- orphaned agents

Read-only only.
"""),
                PromptTemplate(title: "Network Exposure Summary", body: """
Generate local network exposure summary.

Include:
- wildcard listeners
- LAN services
- loopback-only services
- tunnels

Risk-ranked only.
"""),
            ],
            keywords: ["openclaw", "homebridge", "home assistant", "shortcuts", "bonjour", "mdns"]
        ),
        CheatSection(
            title: "OpenClaw · Executive / Strategic",
            icon: "chart.bar.doc.horizontal",
            summary: "Executive briefs, drift detection, stability-first optimization, complexity/minimalism audits, risk register, maturity, and marginal-gain ranking.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Daily Executive Operations Brief", body: """
Generate Daily Executive Operations Brief.

Summarize:
- system health
- AI runtime health
- automation failures
- exposure risks
- recommended next action

Executive-style concise output.
"""),
                PromptTemplate(title: "Operational Drift Detection", body: """
Inspect operational drift since last maintenance snapshot.

Identify:
- new listeners
- changed services
- repo drift
- runtime changes

Read-only only.
"""),
                PromptTemplate(title: "Stability-First Optimization Report", body: """
Generate optimization report prioritizing:
- stability
- simplicity
- operational clarity

Reject speculative optimizations.
"""),
                PromptTemplate(title: "Automation Complexity Audit", body: """
Inspect local automation complexity.

Flag:
- orchestration creep
- recursive workflows
- overlapping automation
- fragile chains

Generate:
- simplification recommendations
"""),
                PromptTemplate(title: "AI Infrastructure Minimalism Audit", body: """
Inspect AI infrastructure for unnecessary complexity.

Recommend:
- removals
- simplifications
- consolidations

Read-only only.
"""),
                PromptTemplate(title: "Operational Risk Register", body: """
Generate operational risk register.

Include:
- severity
- likelihood
- impact
- mitigation

No remediation.
"""),
                PromptTemplate(title: "Local Control Plane Audit", body: """
Inspect local control plane architecture.

Include:
- OpenClaw
- MCP
- tunnels
- listeners
- LaunchAgents

Generate:
- architecture map
- risk-ranked findings
"""),
                PromptTemplate(title: "AI Toolchain Inventory", body: """
Generate complete AI toolchain inventory.

Include:
- OpenClaw
- Codex
- Ollama
- LM Studio
- MCP servers
- browser tooling

Read-only only.
"""),
                PromptTemplate(title: "Operational Maturity Assessment", body: """
Assess operational maturity of the current local AI stack.

Classify:
- stable
- experimental
- fragile
- production-ready

Generate:
- evidence-backed assessment
"""),
                PromptTemplate(title: "Marginal Gain Recommendations", body: """
Generate top 10 highest marginal-gain improvements.

Rules:
- prefer stability
- prefer simplicity
- prefer local-first
- avoid orchestration
- avoid speculative infrastructure

Rank:
- effort
- risk
- expected operational gain
"""),
            ],
            keywords: ["openclaw", "executive", "risk", "maturity", "marginal gain"]
        ),
        CheatSection(
            title: "OpenClaw · Must-Use",
            icon: "bolt.circle.fill",
            summary: "Highest-leverage OpenClaw prompts for the current stack: daily ops, runtime stability, FulôFiló watcher, Apple Home, LaunchAgent risk, exposure security, and marginal gains.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Daily macOS Operations Brief (Must-Use)", body: """
Use macos-exec to generate a Daily macOS Operations Brief.

Include:
- Homebrew services
- LaunchAgent failures
- OpenClaw runtime health
- Codex runtime health
- Ollama status
- disk pressure
- memory pressure
- listener exposure
- wildcard listeners
- top CPU consumers
- risk-ranked findings

Generate:
- Executive Summary
- HIGH/MEDIUM/LOW findings
- recommended next action

Read-only only.
Do not make changes.
"""),
                PromptTemplate(title: "OpenClaw Runtime Stability Audit (Must-Use)", body: """
Use macos-exec to inspect OpenClaw runtime stability.

Inspect:
- gateway uptime
- session latency
- event loop delay
- memory usage
- Codex runtime
- failed modules
- warning/error frequency
- WhatsApp health-monitor restarts

Generate:
- root-cause hypotheses
- operational risks
- marginal-gain recommendations

Read-only only.
"""),
                PromptTemplate(title: "FulôFiló Watcher Stability Check", body: """
Use macos-exec to inspect FulôFiló runtime health.

Inspect:
- com.fulofilo.saleswatch
- launchctl state
- runs count
- memory usage
- log freshness
- active ingestion state
- incoming CSV queue

Confirm:
- no respawn storm
- stable daemon state
- venv Python still active

Do not trigger ingestion manually.
Read-only only.
"""),
                PromptTemplate(title: "AI Runtime Inventory (Must-Use)", body: """
Use macos-exec to inventory all local AI runtimes.

Include:
- OpenClaw
- Codex
- Ollama
- LM Studio
- MCP servers
- cloudflared tunnels

Generate:
- process map
- listener map
- localhost vs LAN exposure
- operational relationships

Read-only only.
"""),
                PromptTemplate(title: "Apple Home Operational Brief", body: """
Use macos-exec to generate an Apple Home operational brief.

Inspect:
- Home Assistant runtime
- HomeKit Bridge
- Homebridge isolation
- LaunchAgent health
- HomeKit exposure
- mDNS listeners
- wildcard listeners
- bridge uptime

Validate:
- curated exposure model preserved
- Homebridge remains isolated
- localhost vs LAN posture

Do not modify Home Assistant or Homebridge.
Read-only only.
"""),
                PromptTemplate(title: "Home Automation Behavioral Architecture Review", body: """
Use macos-exec to generate a behavioral architecture review for the current Apple Home setup.

Focus:
- scene readiness
- Siri semantics
- room behavior structure
- deterministic workflows
- manual vs autonomous balance

Do NOT focus on:
- ZHA
- Matter
- Zigbee onboarding
- occupancy intelligence

Generate:
- recommended scenes
- semantic naming improvements
- room personality structure
- future automation foundations

Read-only only.
"""),
                PromptTemplate(title: "Siri Semantics Optimization", body: """
Use macos-exec to analyze Apple Home Siri semantics.

Inspect:
- exposed entity names
- room naming consistency
- phrase collisions
- long names
- ambiguous names

Generate:
- optimized Siri phrases
- semantic improvements
- naming simplification recommendations

Preserve:
- curated exposure philosophy

Do not rename entities automatically.
"""),
                PromptTemplate(title: "LaunchAgent Risk Audit (Must-Use)", body: """
Use macos-exec to perform a LaunchAgent risk audit.

Inspect:
- crash loops
- EX_CONFIG failures
- KeepAlive storms
- missing executables
- wildcard listeners
- duplicate artifacts
- stale LaunchAgents

Generate:
- HIGH/MEDIUM/LOW findings
- remediation priorities
- rollback considerations

Read-only only.
"""),
                PromptTemplate(title: "Local Exposure Security Audit", body: """
Use macos-exec to inspect local network exposure posture.

Inspect:
- wildcard TCP listeners
- LAN-exposed services
- localhost-only services
- cloudflared tunnels
- MCP listeners
- Home Assistant exposure
- Homebridge exposure
- OpenClaw exposure

Generate:
- attack surface summary
- intentional vs accidental exposure
- risk-ranked findings

No remediation.
Read-only only.
"""),
                PromptTemplate(title: "Marginal Gain Optimization Report (Must-Use)", body: """
Use macos-exec to generate a Marginal Gain Optimization Report for this Apple Silicon environment.

Rules:
- prioritize stability
- prioritize simplicity
- prioritize local-first
- reject speculative infrastructure
- avoid orchestration creep

Inspect:
- AI runtimes
- LaunchAgents
- Home automation
- OpenClaw
- Homebrew services
- disk usage
- memory pressure

Generate:
- top 10 highest-value improvements
- effort vs impact
- operational risk
- rollback complexity

Read-only only.
"""),
            ],
            keywords: ["openclaw", "must-use", "fulofilo", "apple home", "siri", "marginal gain"]
        )
    ]
}
