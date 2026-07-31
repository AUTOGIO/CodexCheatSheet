import Combine
import Foundation

enum RecentCopySource: String, Codable, Hashable {
    case browser
    case builder
}

struct RecentCopyEntry: Codable, Hashable, Identifiable {
    var id: String { key + "\(copiedAt.timeIntervalSince1970)" }
    let key: String
    let title: String
    let source: RecentCopySource
    let copiedAt: Date
    let preview: String

    static func makePreview(from text: String, maxLength: Int = 120) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > maxLength else { return trimmed }
        let end = trimmed.index(trimmed.startIndex, offsetBy: maxLength)
        return String(trimmed[..<end]) + "…"
    }
}

@MainActor
public final class RecentsStore: ObservableObject {
    static let maxEntries = 10

    private let defaults: UserDefaults
    private let storageKey = "recents.entries"

    @Published private(set) var entries: [RecentCopyEntry] = []

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        entries = Self.load(from: defaults, key: storageKey)
    }

    func record(key: String, title: String, source: RecentCopySource, text: String) {
        let entry = RecentCopyEntry(
            key: key,
            title: title,
            source: source,
            copiedAt: Date(),
            preview: RecentCopyEntry.makePreview(from: text)
        )
        entries.removeAll { $0.key == key }
        entries.insert(entry, at: 0)
        if entries.count > Self.maxEntries {
            entries = Array(entries.prefix(Self.maxEntries))
        }
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: storageKey)
    }

    private static func load(from defaults: UserDefaults, key: String) -> [RecentCopyEntry] {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([RecentCopyEntry].self, from: data)
        else { return [] }
        return decoded
    }
}
