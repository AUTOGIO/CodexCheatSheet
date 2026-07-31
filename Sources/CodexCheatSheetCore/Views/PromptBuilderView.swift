import SwiftUI

struct PromptBuilderView: View {
    @EnvironmentObject private var session: BuilderSessionStore
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var recents: RecentsStore
    @EnvironmentObject private var history: BuilderHistoryStore

    @State private var copied = false
    @State private var sidebarSelection: String?

    private var selectedTemplate: BuilderTemplate? {
        session.selectedTemplate
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $sidebarSelection) {
                Section("Templates") {
                    ForEach(BuilderContent.templates) { template in
                        HStack {
                            Label(template.name, systemImage: template.icon)
                            Spacer(minLength: 8)
                            Button {
                                favorites.toggle(ContentKeys.builderTemplate(name: template.name))
                            } label: {
                                Image(systemName: favorites.contains(ContentKeys.builderTemplate(name: template.name))
                                      ? "star.fill" : "star")
                            }
                            .buttonStyle(.borderless)
                        }
                        .tag("template:\(template.name)")
                    }
                }
                if !history.entries.isEmpty {
                    Section("History") {
                        ForEach(history.entries) { entry in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.templateName).lineLimit(1)
                                Text(entry.assembledPreview)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            .tag("history:\(entry.id.uuidString)")
                        }
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 220, ideal: 240)
            .onChange(of: sidebarSelection) { _, newValue in
                handleSidebarSelection(newValue)
            }
            .onAppear {
                if sidebarSelection == nil {
                    sidebarSelection = "template:\(session.selectedTemplateName)"
                }
            }
            .onChange(of: session.selectedTemplateName) { _, name in
                if sidebarSelection?.hasPrefix("history:") != true {
                    sidebarSelection = "template:\(name)"
                }
            }
        } detail: {
            if let selectedTemplate {
                HSplitView {
                    formPane(for: selectedTemplate)
                    previewPane(for: selectedTemplate)
                }
            } else {
                ContentUnavailableView("No templates", systemImage: "doc.text")
            }
        }
    }

    private func handleSidebarSelection(_ value: String?) {
        guard let value else { return }
        if value.hasPrefix("template:") {
            let name = String(value.dropFirst("template:".count))
            session.selectTemplate(named: name)
            return
        }
        if value.hasPrefix("history:") {
            let idString = String(value.dropFirst("history:".count))
            if let id = UUID(uuidString: idString),
               let entry = history.entries.first(where: { $0.id == id }) {
                session.applyHistory(entry)
            }
        }
    }

    private func formPane(for template: BuilderTemplate) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(template.name)
                    .font(.title2).bold()
                Text("Fill in what you have — anything left blank keeps its bracketed placeholder.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(template.fields) { field in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(field.label).font(.subheadline).bold()
                        TextEditor(text: bindingFor(field.key))
                            .font(.body)
                            .frame(minHeight: 40, maxHeight: 90)
                            .padding(4)
                            .background(.quaternary.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
                    }
                }

                Button("Clear fields") {
                    session.clearFields(for: template)
                }
                .buttonStyle(.bordered)
            }
            .padding(20)
            .frame(minWidth: 320)
        }
    }

    private func previewPane(for template: BuilderTemplate) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Assembled Prompt").font(.headline)
                Spacer()
                Button {
                    performCopy(template: template)
                } label: {
                    Label(copied ? "Copied" : "Copy Prompt", systemImage: copied ? "checkmark" : "doc.on.doc")
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return, modifiers: .command)
            }
            ScrollView {
                Text(template.assemble(with: session.fieldValues))
                    .font(.system(.callout, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
            }
            .background(.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(20)
        .frame(minWidth: 380)
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
