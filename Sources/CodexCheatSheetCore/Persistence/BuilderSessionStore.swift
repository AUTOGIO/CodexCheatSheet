import Combine
import Foundation

@MainActor
public final class BuilderSessionStore: ObservableObject {
    private let defaults: UserDefaults
    private let templateKey = "builder.session.templateName"
    private let fieldsKey = "builder.session.fieldValues"

    @Published public var selectedTemplateName: String {
        didSet { defaults.set(selectedTemplateName, forKey: templateKey) }
    }

    @Published public var fieldValues: [String: String] {
        didSet { persistFields() }
    }

    /// When true, MenuBarExtra / hotkey bridge should present Quick Builder.
    @Published public var showQuickBuilder = false

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let savedName = defaults.string(forKey: templateKey)
        if let savedName, BuilderContent.templates.contains(where: { $0.name == savedName }) {
            selectedTemplateName = savedName
        } else {
            selectedTemplateName = BuilderContent.templates.first?.name ?? ""
        }
        if let data = defaults.data(forKey: fieldsKey),
           let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
            fieldValues = decoded
        } else {
            fieldValues = [:]
        }
    }

    var selectedTemplate: BuilderTemplate? {
        BuilderContent.templates.first { $0.name == selectedTemplateName }
            ?? BuilderContent.templates.first
    }

    func selectTemplate(named name: String) {
        guard BuilderContent.templates.contains(where: { $0.name == name }) else { return }
        selectedTemplateName = name
    }

    func applyHistory(_ entry: BuilderHistoryEntry) {
        selectTemplate(named: entry.templateName)
        fieldValues = entry.fieldValues
    }

    func clearFields(for template: BuilderTemplate) {
        var next = fieldValues
        for field in template.fields {
            next[field.key] = ""
        }
        fieldValues = next
    }

    /// Remembers last-used template + fields after a successful copy.
    func rememberAfterCopy(templateName: String, fieldValues: [String: String]) {
        selectTemplate(named: templateName)
        self.fieldValues = fieldValues
    }

    private func persistFields() {
        guard let data = try? JSONEncoder().encode(fieldValues) else { return }
        defaults.set(data, forKey: fieldsKey)
    }
}
