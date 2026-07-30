import Foundation

/// Claude Cowork commands/workflows and distilled Skills-authoring guidance.
/// Paths and names use [bracket] placeholders — no personal absolute paths.
enum ClaudeContent {
    static let sections: [CheatSection] = [
        // MARK: Slash Commands
        CheatSection(
            title: "Claude · Slash Commands",
            icon: "command",
            summary: "Cowork slash commands that change session behavior: schedule, compact, clear, plan, diagnose, and rollback. Use before long or multi-system tasks.",
            tableHeaders: ("Command", "What it does", "When to use"),
            rows: [
                PatternRow(left: "/schedule", middle: "Recurring unattended tasks while Desktop is open.", right: "Daily/weekly briefs, cleanup, competitive scans"),
                PatternRow(left: "/compact", middle: "Compress history; keep important details.", right: "Long chats before Claude starts repeating mistakes"),
                PatternRow(left: "/clear", middle: "Wipe conversation and start fresh.", right: "Context too polluted to salvage"),
                PatternRow(left: "/strategy", middle: "Strategic canvas (vision, goals, audience, positioning).", right: "Product strategy; chain with business-model → pricing → plan-launch"),
                PatternRow(left: "/review", middle: "Custom checklist command from .claude/commands/.", right: "Repeatable review of content, code, proposals, reports"),
                PatternRow(left: "/memory", middle: "Show loaded memory files and context.", right: "Debug inconsistent behavior / missing context"),
                PatternRow(left: "/doctor", middle: "Diagnose Cowork environment state.", right: "Apps, skills, commands, or permissions look wrong"),
                PatternRow(left: "/plan", middle: "Force plan-then-approve before execution.", right: "Any task touching multiple files or systems"),
                PatternRow(left: "/cost", middle: "Estimate token cost before running.", right: "Pro plan or expensive multi-file jobs"),
                PatternRow(left: "/undo", middle: "Roll back the last file operation.", right: "Wrong move/rename/delete — act immediately"),
            ],
            bullets: [
                "Always use /plan when a task touches more than 3 files or multiple steps.",
                "Batch related work in one session — fewer tokens than many tiny sessions.",
                "Be specific: one precise instruction beats clarify-and-retry loops.",
            ],
            templates: [],
            keywords: ["Cowork", "/schedule", "/compact", "/clear", "/plan", "/doctor", "/memory", "/undo", "/cost", "slash command"]
        ),

        // MARK: File System
        CheatSection(
            title: "Claude · File System Workflows",
            icon: "folder",
            summary: "Intelligent rename, dedupe, organize, archive, template extraction, PDF research, format conversion, and storage audit prompts for local folders.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Batch Rename with Intelligence", body: """
Rename all files in [Downloads] using this pattern: YYYY-MM-DD_description_type.
Use the file creation date for the date and generate the description from the file content.
Show the proposed renames before applying.
"""),
                PromptTemplate(title: "Smart Deduplication", body: """
Find all duplicate files across [Documents] and [Desktop].
Show what you found before deleting anything.
For near-duplicates (same content, different names), keep the one with the most recent modification date.
"""),
                PromptTemplate(title: "Folder Structure from Chaos", body: """
Look at every file in [Downloads].
Create a logical folder structure based on what you find: group by project, then by file type within each project.
Move everything into the new structure and give me a summary of what went where.
"""),
                PromptTemplate(title: "Archive Stale Files", body: """
Find all files in [Projects] that have not been modified in 90 days.
Move them to [Archive]/[year]/[month].
Do not touch anything in [Projects]/Active.
"""),
                PromptTemplate(title: "Template Generator", body: """
Read all the proposals in [Proposals]/Completed.
Identify the common structure, sections, and formatting.
Create a blank template in [Templates]/proposal-template.docx that follows the same pattern.
"""),
                PromptTemplate(title: "Recursive Search and Extract", body: """
Search through every PDF in [Research] for mentions of [topic].
Extract the relevant paragraphs, note which document and page each one came from, and compile them into a single research summary file.
"""),
                PromptTemplate(title: "Format Converter Pipeline", body: """
Convert all .docx files in [Content] to .md format.
Preserve formatting, headers, and bullet points.
Save the markdown versions to [Content]/markdown with the same filenames.
"""),
                PromptTemplate(title: "Size Audit", body: """
Analyze my [Documents] folder.
Show me the 20 largest files, any folders over 1GB, and estimate how much space I could free up by removing files I have not opened in 6 months.
"""),
            ],
            keywords: ["rename", "dedupe", "archive", "Downloads", "PDF", "docx", "markdown", "storage"]
        ),

        // MARK: Connectors
        CheatSection(
            title: "Claude · Connector Workflows",
            icon: "link",
            summary: "Multi-app Cowork prompts across Gmail, Calendar, Slack, Drive, and slides — always summarize before send when drafts are involved.",
            tableHeaders: nil,
            rows: [],
            bullets: [
                "Prefer show-before-send for any email or Slack outbound draft.",
                "Name output paths with dates so scheduled runs do not overwrite.",
            ],
            templates: [
                PromptTemplate(title: "Gmail → Summary → Drive", body: """
Check my Gmail for all unread emails.
Categorize them: urgent, needs response, FYI, can delete.
Draft responses for the routine ones.
Save the entire summary to a file in my Google Drive [Daily] folder with today's date.
Show drafts before sending.
"""),
                PromptTemplate(title: "Calendar → Prep Brief", body: """
Check my Google Calendar for tomorrow.
For each meeting, research the attendees and their companies.
Create a one-page prep brief for each meeting and save them to [Meeting-Prep]/[date].
"""),
                PromptTemplate(title: "Slack → Action Items", body: """
Read my Slack messages from the last 24 hours across all channels.
Extract every action item directed at me.
Compile them into a task list sorted by channel and urgency.
Save to [Tasks]/slack-actions-[date].md.
"""),
                PromptTemplate(title: "Drive → Analysis → Slides", body: """
Pull the [Q3] data from the spreadsheet in my Google Drive.
Analyze trends, identify the top 3 insights, and create a 5-slide PowerPoint summary with charts.
Save to [Presentations].
"""),
                PromptTemplate(title: "Email Chain Resolver", body: """
Find the email thread about [project] in my Gmail.
Read the entire thread.
Summarize what was decided, what is still open, and who needs to do what next.
Draft a follow-up email that moves the conversation forward.
Show the draft before sending.
"""),
                PromptTemplate(title: "Multi-Source Report Builder", body: """
Pull this week's sales data from the Google Sheet in Drive.
Check Slack [#sales] for any deal updates mentioned this week.
Combine everything into a formatted weekly sales report and save as PDF to [Reports]/sales-[date].pdf.
"""),
                PromptTemplate(title: "Meeting Notes Distributor", body: """
Read the meeting notes I just saved to [Meetings].
Extract the action items.
For each person mentioned, draft a brief email with just their action items and deadlines.
Show me the emails before sending.
"""),
                PromptTemplate(title: "Cross-Platform Search", body: """
I am looking for information about [project name].
Search my Google Drive, Slack messages, and Gmail for anything related.
Compile everything you find into a single document organized by source.
Save to [Research]/[project name]-sources-[date].md.
"""),
            ],
            keywords: ["Gmail", "Calendar", "Slack", "Drive", "PowerPoint", "connector", "Cowork"]
        ),

        // MARK: Document & Content
        CheatSection(
            title: "Claude · Document & Content",
            icon: "doc.richtext",
            summary: "Turn transcripts, research folders, templates, contracts, spreadsheets, and drafts into polished deliverables and repurposed channel copy.",
            tableHeaders: nil,
            rows: [],
            bullets: [],
            templates: [
                PromptTemplate(title: "Voice Note to Polished Draft", body: """
Read the transcript in [Voice-Notes]/[filename].
This is a rough voice recording of my ideas about [topic].
Turn it into a polished 1,500-word article.
Keep my natural voice but add structure, clean up the rambling, and make it publication-ready.
"""),
                PromptTemplate(title: "Meeting Recording to Structured Notes", body: """
Process the meeting transcript at [Meetings]/[filename].
Create structured notes with: decisions made, action items (who owns each one + deadline), open questions, and key discussion points.
Format as markdown.
"""),
                PromptTemplate(title: "Research to Executive Brief", body: """
I have articles saved in [Research]/[project].
Read all of them.
Create a 2-page executive brief that synthesizes the key findings, identifies conflicting viewpoints, and recommends 3 action items based on the research.
Include source references.
"""),
                PromptTemplate(title: "Proposal Customizer", body: """
Read the proposal template at [Templates]/proposal.docx.
Read the client brief at [Clients]/[name]-brief.md.
Generate a customized proposal for this specific client.
Match the template structure but tailor every section to their situation.
"""),
                PromptTemplate(title: "Contract to Plain English", body: """
Read the contract at [Legal]/[filename].pdf.
Create a plain-English summary with: key terms, important deadlines, auto-renewal clauses, liability caps, and anything unusual or potentially problematic.
This is not legal advice — it is a time-saving first-pass review.
"""),
                PromptTemplate(title: "Spreadsheet Narrative Writer", body: """
Read the spreadsheet at [Data]/[filename].xlsx.
Write a narrative analysis for a non-technical audience.
Cover the top 3 trends, any anomalies worth investigating, and 2 recommended actions.
Include the specific numbers but explain what they mean.
"""),
                PromptTemplate(title: "Content Repurposing Pipeline", body: """
Read the article at [Content]/[filename].md.
Create: 8 standalone tweets, 2 LinkedIn posts, 3 Instagram captions, and 1 newsletter teaser email with a subject line.
Save each format in its own file in [Content]/repurposed/[date].
"""),
                PromptTemplate(title: "Weekly Newsletter Assembler", body: """
Read all files in [Content]/drafts created this week.
Select the 3 strongest pieces.
Write a newsletter that links to each one with a 2-sentence teaser.
Add an intro paragraph and a sign-off.
Save as newsletter-[date].md.
"""),
            ],
            keywords: ["transcript", "executive brief", "proposal", "contract", "newsletter", "repurpose"]
        ),

        // MARK: Scheduled Automations
        CheatSection(
            title: "Claude · Scheduled Automations",
            icon: "clock",
            summary: "Recurring Cowork jobs via /schedule: inbox zero, cleanup, Monday planning, finance, competitive scan, and end-of-day log. Machine must be on with Claude Desktop open.",
            tableHeaders: nil,
            rows: [],
            bullets: [
                "Batch related work in one session to save tokens.",
                "Be specific in instructions — avoid vague organize-my-files prompts.",
                "Schedule heavy tasks for evenings/weekends when throughput is often better.",
                "Always use /plan for complex multi-step automations first.",
                "Keep folder structure clean and predictable so Cowork navigates reliably.",
            ],
            templates: [
                PromptTemplate(title: "Daily Inbox Zero Processor", body: """
/schedule daily at 7am:
Check Gmail. Categorize all unread emails. Draft responses for routine ones. Flag urgent ones.
Save the summary to [Daily]/inbox-[date].md.
Show drafts before sending.
"""),
                PromptTemplate(title: "Weekly File Cleanup", body: """
/schedule every Friday at 5pm:
Sort [Downloads] by type. Move documents to [Documents], images to [Images], code to [Projects].
Delete anything older than 60 days that is not in [Important].
Show the deletion list before deleting.
"""),
                PromptTemplate(title: "Monday Planning Brief", body: """
/schedule every Monday at 7:30am:
Check my calendar for the week. Pull any relevant prep materials from Drive. Scan Gmail for outstanding action items.
Create a weekly planning document with priorities, meetings, and deadlines.
Save to [Weekly]/plan-[date].md.
"""),
                PromptTemplate(title: "Monthly Financial Organizer", body: """
/schedule the 1st of every month:
Process all receipt images in [Receipts]. Extract vendor, amount, date, and category from each.
Create a categorized expense spreadsheet. Calculate totals by category.
Save to [Finance]/expenses-[month].xlsx.
"""),
                PromptTemplate(title: "Bi-Weekly Competitive Scan", body: """
/schedule every other Monday:
Search the web for the latest news about [competitor 1], [competitor 2], and [competitor 3].
Check for pricing changes, product launches, and hiring. Compare to the previous scan.
Save to [Intelligence]/comp-scan-[date].md.
"""),
                PromptTemplate(title: "End of Day Log", body: """
/schedule daily at 6pm:
Read any files I created or modified today in [Projects].
Write a brief work log noting what was accomplished, what is in progress, and what needs attention tomorrow.
Save to [Daily]/log-[date].md.
"""),
            ],
            keywords: ["/schedule", "automation", "inbox", "cleanup", "competitive", "finance", "daily log"]
        ),

        // MARK: Skills Fundamentals
        CheatSection(
            title: "Claude · Skills Fundamentals",
            icon: "puzzlepiece.extension",
            summary: "A skill is a folder that teaches Claude a repeatable workflow once. Progressive disclosure, composability, portability, and Skills+MCP (recipes on a kitchen) are the core ideas.",
            tableHeaders: ("Principle", "Meaning", "Practice"),
            rows: [
                PatternRow(left: "Progressive disclosure", middle: "Frontmatter always loaded; body when relevant; linked files on demand.", right: "Keep SKILL.md lean; put depth in references/"),
                PatternRow(left: "Composability", middle: "Multiple skills can load together.", right: "Do not assume your skill is the only one active"),
                PatternRow(left: "Portability", middle: "Same skill across Claude.ai, Claude Code, and API (if deps exist).", right: "Avoid hard-coding one surface's quirks"),
                PatternRow(left: "Skills + MCP", middle: "MCP = connectivity; Skills = how to use it well.", right: "Ship workflows on top of tools, not tools alone"),
                PatternRow(left: "Folder layout", middle: "SKILL.md required; scripts/, references/, assets/ optional.", right: "Exact name SKILL.md; no README.md inside the skill folder"),
            ],
            bullets: [
                "Categories: (1) Document & asset creation, (2) Workflow automation, (3) MCP enhancement.",
                "Start with 2–3 concrete use cases before writing instructions.",
                "Install note: zip the skill folder → Claude.ai Settings > Capabilities > Skills, or place in the Claude Code skills directory. Host on GitHub for humans (repo README is separate from the skill folder).",
            ],
            templates: [],
            keywords: ["skill", "SKILL.md", "progressive disclosure", "MCP", "composability", "portability"]
        ),

        // MARK: Skill Authoring
        CheatSection(
            title: "Claude · Skill Authoring",
            icon: "square.and.pencil",
            summary: "Frontmatter decides when the skill loads. Description must say what it does and when to use it (triggers). Instructions should be specific, actionable, and error-aware.",
            tableHeaders: ("Rule", "Requirement", "Why"),
            rows: [
                PatternRow(left: "name", middle: "kebab-case; match folder; no spaces/capitals; not reserved claude/anthropic.", right: "Valid upload + clear identity"),
                PatternRow(left: "description", middle: "What + when/triggers; <1024 chars; no XML <> tags.", right: "First-level progressive disclosure / trigger accuracy"),
                PatternRow(left: "SKILL.md", middle: "Exact filename, case-sensitive.", right: "Upload fails otherwise"),
                PatternRow(left: "No skill-folder README.md", middle: "Docs live in SKILL.md or references/.", right: "Avoid conflicting entry docs"),
                PatternRow(left: "Good description", middle: "Specific tasks, phrases, file types users actually say.", right: "Triggers on paraphrases"),
                PatternRow(left: "Bad description", middle: "Vague ('helps with projects') or no triggers.", right: "Under- or over-triggers"),
            ],
            bullets: [
                "Description structure: [What it does] + [When to use it] + [Key capabilities].",
                "Instruction body: numbered steps, expected outputs, examples, troubleshooting.",
                "Be specific and actionable (show commands); include error handling; link references/ for depth.",
                "Optional frontmatter: license, compatibility, metadata (author, version, mcp-server).",
            ],
            templates: [
                PromptTemplate(title: "SKILL.md Skeleton", body: """
---
name: [your-skill-name]
description: [What it does]. Use when the user asks to [trigger phrases], uploads [file types], or mentions [keywords].
metadata:
  author: [name]
  version: 1.0.0
---

# [Your Skill Name]

## Instructions

### Step 1: [First major step]
Clear explanation of what happens.
Run: `[command or MCP tool]`
Expected output: [success looks like]

### Step 2: [Next step]
...

## Examples

### Example 1: [common scenario]
User says: "[phrase]"
Actions:
1. ...
Result: ...

## Troubleshooting

### Error: [common error]
Cause: [why]
Solution: [fix]
"""),
                PromptTemplate(title: "Description Quality Check", body: """
Review this skill description for trigger quality:

[paste description]

Check:
- Does it state what the skill does?
- Does it include concrete user phrases / file types?
- Is it under 1024 characters with no < > XML tags?
- Would it wrongly fire on unrelated asks? If yes, add negative scope.

Rewrite an improved description only.
"""),
            ],
            keywords: ["frontmatter", "description", "kebab-case", "triggers", "SKILL.md", "skill-creator"]
        ),

        // MARK: Testing & Patterns
        CheatSection(
            title: "Claude · Skills Testing & Patterns",
            icon: "checkmark.shield",
            summary: "Test triggering, functional outcomes, and vs-baseline performance. Prefer iterate-on-one-hard-task then expand. Use proven patterns and fix under/over-triggering via the description.",
            tableHeaders: ("Check", "Pass criteria", "Fail signal"),
            rows: [
                PatternRow(left: "Triggering", middle: "Loads on obvious + paraphrased asks; skips unrelated.", right: "Manual enable always / loads on weather asks"),
                PatternRow(left: "Functional", middle: "Valid outputs; MCP calls succeed; errors handled.", right: "User must redirect mid-flow"),
                PatternRow(left: "Performance", middle: "Fewer turns/tokens/failures vs no-skill baseline.", right: "Same thrash as prompting from scratch"),
                PatternRow(left: "Undertriggering", middle: "Add keywords, phrases, file types to description.", right: "Users ask when to use it"),
                PatternRow(left: "Overtriggering", middle: "Narrow scope; add Do NOT use for …", right: "Users disable the skill"),
                PatternRow(left: "Upload errors", middle: "Exact SKILL.md; valid YAML --- fences; kebab-case name.", right: "Could not find SKILL.md / invalid frontmatter"),
            ],
            bullets: [
                "Pattern 1 Sequential orchestration: ordered steps, validation gates, rollback notes.",
                "Pattern 2 Multi-MCP coordination: clear phases and data handoff between services.",
                "Pattern 3 Iterative refinement: draft → validate → loop until quality bar.",
                "Pattern 4 Context-aware tool selection: decision tree for which tool/path.",
                "Pattern 5 Domain-specific intelligence: embed compliance/expertise before action.",
                "Ask Claude: When would you use the [skill name] skill? — adjust description from the quote-back.",
            ],
            templates: [
                PromptTemplate(title: "Trigger Test Suite Prompt", body: """
I am testing the skill [skill-name].

Should trigger:
- "[obvious request 1]"
- "[paraphrase 2]"
- "[paraphrase 3]"

Should NOT trigger:
- "What's the weather in San Francisco?"
- "[unrelated domain ask]"

For each line, say whether you would load the skill and why, quoting the description.
"""),
                PromptTemplate(title: "Skill Improvement from Failure", body: """
Use the skill-creator skill to improve [skill-name].

Issues observed:
- [under/over trigger or wrong steps]
- [edge case from this chat]

Update description and instructions so this case is handled without user correction.
"""),
            ],
            keywords: ["testing", "undertriggering", "overtriggering", "patterns", "MCP", "skill-creator", "troubleshooting"]
        ),
    ]
}
