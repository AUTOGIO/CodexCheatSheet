import Combine
import Foundation

struct BuilderHistoryEntry: Codable, Hashable, Identifiable {
    let id: UUID
    let templateName: String
    let fieldValues: [String: String]
    let assembledPreview: String
    let savedAt: Date

    init(
        id: UUID = UUID(),
        templateName: String,
        fieldValues: [String: String],
        assembledPreview: String,
        savedAt: Date = Date()
    ) {
        self.id = id
        self.templateName = templateName
        self.fieldValues = fieldValues
        self.assembledPreview = assembledPreview
        self.savedAt = savedAt
    }
}

@MainActor
public final class BuilderHistoryStore: ObservableObject {
    static let maxEntries = 20
    static let fileName = "builder-history.json"

    private let fileURL: URL
    private let fileManager: FileManager

    @Published private(set) var entries: [BuilderHistoryEntry] = []

    public init(baseURL: URL? = nil, fileManager: FileManager = .default) {
        self.fileManager = fileManager
        if let baseURL {
            self.fileURL = baseURL.appendingPathComponent(Self.fileName)
        } else {
            let support = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let dir = support.appendingPathComponent("CodexCheatSheet", isDirectory: true)
            self.fileURL = dir.appendingPathComponent(Self.fileName)
        }
        entries = load()
    }

    func record(templateName: String, fieldValues: [String: String], assembled: String) {
        let entry = BuilderHistoryEntry(
            templateName: templateName,
            fieldValues: fieldValues,
            assembledPreview: RecentCopyEntry.makePreview(from: assembled)
        )
        entries.insert(entry, at: 0)
        if entries.count > Self.maxEntries {
            entries = Array(entries.prefix(Self.maxEntries))
        }
        save()
    }

    func clear() {
        entries = []
        save()
    }

    private func load() -> [BuilderHistoryEntry] {
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([BuilderHistoryEntry].self, from: data)
        else { return [] }
        return decoded
    }

    private func save() {
        let dir = fileURL.deletingLastPathComponent()
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}
