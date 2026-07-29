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
}
