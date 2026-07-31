import SwiftUI

public struct QuickBuilderView: View {
    public init() {}

    @EnvironmentObject private var session: BuilderSessionStore
    @EnvironmentObject private var recents: RecentsStore
    @EnvironmentObject private var history: BuilderHistoryStore

    @State private var copied = false

    private var selectedTemplate: BuilderTemplate? {
        session.selectedTemplate
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let template = selectedTemplate {
                Picker("Template", selection: Binding(
                    get: { session.selectedTemplateName },
                    set: { session.selectTemplate(named: $0) }
                )) {
                    ForEach(BuilderContent.templates) { t in
                        Text(t.name).tag(t.name)
                    }
                }
                .labelsHidden()

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(template.fields) { field in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(field.label).font(.caption).bold()
                                TextField(
                                    field.placeholder.isEmpty ? field.label : field.placeholder,
                                    text: bindingFor(field.key),
                                    axis: .vertical
                                )
                                .lineLimit(2...4)
                            }
                        }
                    }
                }
                .frame(maxHeight: 220)

                Text(template.assemble(with: session.fieldValues))
                    .font(.system(.caption, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 6))
                    .lineLimit(6)

                HStack {
                    Spacer()
                    Button {
                        performCopy(template: template)
                    } label: {
                        Label(copied ? "Copied" : "Copy Prompt", systemImage: copied ? "checkmark" : "doc.on.doc")
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.return, modifiers: .command)
                }
            } else {
                Text("No templates available")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(width: 360, height: 420)
    }

    private func performCopy(template: BuilderTemplate) {
        let assembled = template.assemble(with: session.fieldValues)
        copyToPasteboard(assembled)
        session.rememberAfterCopy(templateName: template.name, fieldValues: session.fieldValues)
        history.record(
            templateName: template.name,
            fieldValues: session.fieldValues,
            assembled: assembled
        )
        recents.record(
            key: ContentKeys.builderTemplate(name: template.name),
            title: template.name,
            source: .builder,
            text: assembled
        )
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
    }

    private func bindingFor(_ key: String) -> Binding<String> {
        Binding(
            get: { session.fieldValues[key] ?? "" },
            set: { newValue in
                var next = session.fieldValues
                next[key] = newValue
                session.fieldValues = next
            }
        )
    }
}
