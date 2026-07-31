import Foundation

enum ContentKeys {
    static let unitSeparator = "\u{1F}"

    static func browserTemplate(sectionTitle: String, templateTitle: String) -> String {
        "\(sectionTitle)\(unitSeparator)\(templateTitle)"
    }

    static func builderTemplate(name: String) -> String {
        "builder:\(name)"
    }

    static func parseBrowserKey(_ key: String) -> (sectionTitle: String, templateTitle: String)? {
        guard !key.hasPrefix("builder:") else { return nil }
        let sep = unitSeparator.first!
        let parts = key.split(separator: sep, maxSplits: 1, omittingEmptySubsequences: false)
        guard parts.count == 2 else { return nil }
        return (String(parts[0]), String(parts[1]))
    }

    static func parseBuilderKey(_ key: String) -> String? {
        guard key.hasPrefix("builder:") else { return nil }
        return String(key.dropFirst("builder:".count))
    }

    static func resolveBrowser(key: String) -> (section: CheatSection, template: PromptTemplate)? {
        guard let (sectionTitle, templateTitle) = parseBrowserKey(key) else { return nil }
        guard let section = CheatSheetContent.sections.first(where: { $0.title == sectionTitle }) else { return nil }
        guard let template = section.templates.first(where: { $0.title == templateTitle }) else { return nil }
        return (section, template)
    }

    static func resolveBuilder(key: String) -> BuilderTemplate? {
        guard let name = parseBuilderKey(key) else { return nil }
        return BuilderContent.templates.first { $0.name == name }
    }

    static func displayTitle(for key: String) -> String {
        if let name = parseBuilderKey(key) { return name }
        if let parsed = parseBrowserKey(key) { return parsed.templateTitle }
        return key
    }
}
