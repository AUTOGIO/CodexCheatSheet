import Foundation

struct BuilderField: Identifiable, Hashable {
    let id = UUID()
    let key: String
    let label: String
    let placeholder: String
}

struct BuilderTemplate: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let rawTemplate: String
    let fields: [BuilderField]

    func assemble(with values: [String: String]) -> String {
        var result = rawTemplate
        for field in fields {
            let token = "{{\(field.key)}}"
            let value = values[field.key]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let replacement: String
            if !value.isEmpty {
                replacement = value
            } else if field.placeholder.isEmpty {
                replacement = ""
            } else {
                replacement = "[\(field.placeholder)]"
            }
            result = result.replacingOccurrences(of: token, with: replacement)
        }
        return result
    }
}
