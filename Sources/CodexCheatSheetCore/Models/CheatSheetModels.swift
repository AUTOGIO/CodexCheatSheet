import Foundation

struct PatternRow: Identifiable, Hashable {
    let id = UUID()
    let left: String
    let middle: String
    let right: String
}

struct PromptTemplate: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let body: String
}

struct CheatSection: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let summary: String
    let tableHeaders: (String, String, String)?
    let rows: [PatternRow]
    let bullets: [String]
    let templates: [PromptTemplate]
    let keywords: [String]

    var searchableText: String {
        ([title, summary] + bullets + rows.map { "\($0.left) \($0.middle) \($0.right)" }
            + templates.map { "\($0.title) \($0.body)" } + keywords).joined(separator: " ").lowercased()
    }
}
