import XCTest
@testable import CodexCheatSheetCore

@MainActor
final class PersistenceStoresTests: XCTestCase {
    func testContentKeysBrowserRoundTrip() {
        let key = ContentKeys.browserTemplate(sectionTitle: "Bug Fixing", templateTitle: "Quick Fix")
        let parsed = ContentKeys.parseBrowserKey(key)
        XCTAssertEqual(parsed?.sectionTitle, "Bug Fixing")
        XCTAssertEqual(parsed?.templateTitle, "Quick Fix")
        XCTAssertNil(ContentKeys.parseBuilderKey(key))
    }

    func testContentKeysBuilderRoundTrip() {
        let key = ContentKeys.builderTemplate(name: "Bug Fixing")
        XCTAssertEqual(ContentKeys.parseBuilderKey(key), "Bug Fixing")
        XCTAssertNil(ContentKeys.parseBrowserKey(key))
        XCTAssertEqual(ContentKeys.displayTitle(for: key), "Bug Fixing")
    }

    func testContentKeysUniqueAcrossLiveBrowserTemplates() {
        var seen = Set<String>()
        for section in CheatSheetContent.sections {
            for template in section.templates {
                let key = ContentKeys.browserTemplate(
                    sectionTitle: section.title,
                    templateTitle: template.title
                )
                XCTAssertFalse(seen.contains(key), "Duplicate key: \(key)")
                seen.insert(key)
            }
        }
        XCTAssertFalse(seen.isEmpty)
    }

    func testFavoritesStoreTogglePersists() {
        let suiteName = "test.favorites.\(UUID().uuidString)"
        let suite = UserDefaults(suiteName: suiteName)!
        defer { suite.removePersistentDomain(forName: suiteName) }

        let store = FavoritesStore(defaults: suite)
        let key = ContentKeys.builderTemplate(name: "Refactor")
        XCTAssertFalse(store.contains(key))
        store.toggle(key)
        XCTAssertTrue(store.contains(key))
        store.toggle(key)
        XCTAssertFalse(store.contains(key))

        let reloaded = FavoritesStore(defaults: suite)
        XCTAssertEqual(reloaded.keys, store.keys)
    }

    func testRecentsStoreCapsAtTenAndDedupesByKey() {
        let suiteName = "test.recents.\(UUID().uuidString)"
        let suite = UserDefaults(suiteName: suiteName)!
        defer { suite.removePersistentDomain(forName: suiteName) }

        let store = RecentsStore(defaults: suite)
        for i in 0..<15 {
            store.record(
                key: "builder:T\(i)",
                title: "T\(i)",
                source: .builder,
                text: String(repeating: "x", count: 200)
            )
        }
        XCTAssertEqual(store.entries.count, RecentsStore.maxEntries)
        XCTAssertEqual(store.entries.first?.title, "T14")
        XCTAssertLessThanOrEqual(store.entries.first?.preview.count ?? 0, 121)

        store.record(key: "builder:T14", title: "T14", source: .builder, text: "updated")
        XCTAssertEqual(store.entries.filter { $0.key == "builder:T14" }.count, 1)
        XCTAssertEqual(store.entries.first?.preview, "updated")
    }

    func testBuilderHistoryStoreCapsAtTwentyAndRefillsAssemble() throws {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("ccs-history-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }

        let store = BuilderHistoryStore(baseURL: dir)
        let template = BuilderContent.templates.first { $0.name == "Bug Fixing" }!
        for i in 0..<25 {
            let values = ["bug": "bug \(i)", "errorLog": "log \(i)"]
            let assembled = template.assemble(with: values)
            store.record(templateName: template.name, fieldValues: values, assembled: assembled)
        }
        XCTAssertEqual(store.entries.count, BuilderHistoryStore.maxEntries)
        XCTAssertEqual(store.entries.first?.fieldValues["bug"], "bug 24")

        let entry = store.entries.first!
        let reassembled = template.assemble(with: entry.fieldValues)
        XCTAssertTrue(reassembled.hasPrefix(entry.assembledPreview.replacingOccurrences(of: "…", with: ""))
            || reassembled == entry.assembledPreview
            || RecentCopyEntry.makePreview(from: reassembled) == entry.assembledPreview)

        let reloaded = BuilderHistoryStore(baseURL: dir)
        XCTAssertEqual(reloaded.entries.count, BuilderHistoryStore.maxEntries)
        XCTAssertEqual(reloaded.entries.first?.id, entry.id)
    }

    func testBuilderSessionStorePersistsTemplateAndFields() {
        let suiteName = "test.session.\(UUID().uuidString)"
        let suite = UserDefaults(suiteName: suiteName)!
        defer { suite.removePersistentDomain(forName: suiteName) }

        let store = BuilderSessionStore(defaults: suite)
        store.selectTemplate(named: "Refactor")
        store.fieldValues = ["goal": "simplify"]
        XCTAssertEqual(store.selectedTemplateName, "Refactor")

        let reloaded = BuilderSessionStore(defaults: suite)
        XCTAssertEqual(reloaded.selectedTemplateName, "Refactor")
        XCTAssertEqual(reloaded.fieldValues["goal"], "simplify")
    }
}
