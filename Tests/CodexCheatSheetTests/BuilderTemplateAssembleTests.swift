import XCTest
@testable import CodexCheatSheetCore

final class BuilderTemplateAssembleTests: XCTestCase {
    private func sampleTemplate(
        rawTemplate: String = "Goal: Fix {{bug}}. Context: {{errorLog}}.",
        fields: [BuilderField]? = nil
    ) -> BuilderTemplate {
        BuilderTemplate(
            name: "Sample",
            icon: "ladybug",
            rawTemplate: rawTemplate,
            fields: fields ?? [
                BuilderField(key: "bug", label: "Bug", placeholder: "bug"),
                BuilderField(key: "errorLog", label: "Error log", placeholder: "error log"),
            ]
        )
    }

    func testAssembleSubstitutesFilledValues() {
        let template = sampleTemplate()
        let result = template.assemble(with: [
            "bug": "crash on launch",
            "errorLog": "EXC_BAD_ACCESS",
        ])
        XCTAssertEqual(result, "Goal: Fix crash on launch. Context: EXC_BAD_ACCESS.")
    }

    func testAssembleUsesBracketedPlaceholderWhenBlank() {
        let template = sampleTemplate()
        let result = template.assemble(with: [:])
        XCTAssertEqual(result, "Goal: Fix [bug]. Context: [error log].")
    }

    func testAssembleUsesEmptyStringWhenPlaceholderEmpty() {
        let template = sampleTemplate(
            rawTemplate: "Note: {{note}}",
            fields: [BuilderField(key: "note", label: "Note", placeholder: "")]
        )
        let result = template.assemble(with: ["note": "   "])
        XCTAssertEqual(result, "Note: ")
    }

    func testAssembleIgnoresUnknownKeys() {
        let template = sampleTemplate(rawTemplate: "Fix {{bug}}")
        let result = template.assemble(with: [
            "bug": "nil unwrap",
            "unused": "ignored",
        ])
        XCTAssertEqual(result, "Fix nil unwrap")
        XCTAssertFalse(result.contains("ignored"))
    }

    func testAssembleTrimsWhitespaceBeforeSubstitution() {
        let template = sampleTemplate(rawTemplate: "{{bug}}")
        let result = template.assemble(with: ["bug": "  spaced  "])
        XCTAssertEqual(result, "spaced")
    }
}

final class ContentSmokeTests: XCTestCase {
    func testCheatSheetSectionsNonEmpty() {
        XCTAssertFalse(CheatSheetContent.sections.isEmpty)
    }

    func testBuilderTemplatesNonEmpty() {
        XCTAssertFalse(BuilderContent.templates.isEmpty)
    }

    func testPairedTemplatesShareCoreIntent() {
        // Browser owns copy-ready wording; Builder owns {{token}} variants.
        // Guard that paired use-case names still exist on both sides.
        let browserTitles = Set(
            CheatSheetContent.sections
                .flatMap(\.templates)
                .map(\.title)
        )
        let builderNames = Set(BuilderContent.templates.map(\.name))
        for name in ["Bug Fixing", "Feature Writing", "Refactor"] {
            XCTAssertTrue(browserTitles.contains(name), "Missing browser template: \(name)")
            XCTAssertTrue(builderNames.contains(name), "Missing builder template: \(name)")
        }
    }

    func testOpenClawSectionsAndTemplatesPresent() {
        let openClaw = CheatSheetContent.sections.filter { $0.title.hasPrefix("OpenClaw") }
        XCTAssertEqual(openClaw.count, 6)
        let templateCount = openClaw.flatMap(\.templates).count
        XCTAssertEqual(templateCount, 60)
        XCTAssertTrue(openClaw.contains { $0.title == "OpenClaw · Must-Use" })
    }

    func testToolAgnosticPowerSectionsAndTemplatesPresent() {
        let power = CheatSheetContent.sections.filter { $0.title.hasPrefix("Power ·") }
        XCTAssertEqual(power.count, 6)
        let templateCount = power.flatMap(\.templates).count
        XCTAssertEqual(templateCount, 50)
        let expected = [
            "Power · macOS Operations",
            "Power · Repo / Git / Skills",
            "Power · AI / MCP / Runtime",
            "Power · Apple / Home Automation",
            "Power · Executive / Strategic",
            "Power · Personal Productivity",
        ]
        XCTAssertEqual(power.map(\.title), expected)
    }

    func testClaudeSectionsPresent() {
        let claude = CheatSheetContent.sections.filter { $0.title.hasPrefix("Claude ·") }
        XCTAssertEqual(claude.count, 8)
        let expected = [
            "Claude · Slash Commands",
            "Claude · File System Workflows",
            "Claude · Connector Workflows",
            "Claude · Document & Content",
            "Claude · Scheduled Automations",
            "Claude · Skills Fundamentals",
            "Claude · Skill Authoring",
            "Claude · Skills Testing & Patterns",
        ]
        XCTAssertEqual(claude.map(\.title), expected)
    }

    func testClaudeCoworkWorkflowTemplatesPresent() {
        let byTitle = Dictionary(
            uniqueKeysWithValues: CheatSheetContent.sections.map { ($0.title, $0) }
        )
        XCTAssertEqual(byTitle["Claude · File System Workflows"]?.templates.count, 8)
        XCTAssertEqual(byTitle["Claude · Connector Workflows"]?.templates.count, 8)
        XCTAssertEqual(byTitle["Claude · Document & Content"]?.templates.count, 8)
        XCTAssertEqual(byTitle["Claude · Scheduled Automations"]?.templates.count, 6)
        XCTAssertEqual(byTitle["Claude · Slash Commands"]?.rows.count, 10)
        XCTAssertFalse(byTitle["Claude · Skill Authoring"]?.templates.isEmpty ?? true)
    }
}
