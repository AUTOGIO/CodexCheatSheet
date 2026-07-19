import SwiftUI

struct PromptBuilderView: View {
    @State private var selectedTemplateID: BuilderTemplate.ID?
    @State private var fieldValues: [String: String] = [:]
    @State private var copied = false

    private var selectedTemplate: BuilderTemplate {
        BuilderContent.templates.first { $0.id == selectedTemplateID } ?? BuilderContent.templates[0]
    }

    var body: some View {
        NavigationSplitView {
            List(BuilderContent.templates, selection: $selectedTemplateID) { template in
                Label(template.name, systemImage: template.icon).tag(template.id)
            }
            .navigationSplitViewColumnWidth(min: 220, ideal: 240)
        } detail: {
            HSplitView {
                formPane
                previewPane
            }
        }
        .onAppear {
            if selectedTemplateID == nil { selectedTemplateID = BuilderContent.templates.first?.id }
        }
    }

    private var formPane: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(selectedTemplate.name)
                    .font(.title2).bold()
                Text("Fill in what you have — anything left blank keeps its bracketed placeholder.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(selectedTemplate.fields) { field in
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
                    for field in selectedTemplate.fields { fieldValues[field.key] = "" }
                }
                .buttonStyle(.bordered)
            }
            .padding(20)
            .frame(minWidth: 320)
        }
    }

    private var previewPane: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Assembled Prompt").font(.headline)
                Spacer()
                Button {
                    copyToPasteboard(selectedTemplate.assemble(with: fieldValues))
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
                } label: {
                    Label(copied ? "Copied" : "Copy Prompt", systemImage: copied ? "checkmark" : "doc.on.doc")
                }
                .buttonStyle(.borderedProminent)
            }
            ScrollView {
                Text(selectedTemplate.assemble(with: fieldValues))
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

    private func bindingFor(_ key: String) -> Binding<String> {
        Binding(
            get: { fieldValues[key] ?? "" },
            set: { fieldValues[key] = $0 }
        )
    }
}
