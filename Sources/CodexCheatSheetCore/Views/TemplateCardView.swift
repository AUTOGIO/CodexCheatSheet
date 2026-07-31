import SwiftUI
#if canImport(AppKit)
import AppKit
#endif

struct TemplateCardView: View {
    let sectionTitle: String
    let template: PromptTemplate
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var recents: RecentsStore
    @State private var copied = false

    private var key: String {
        ContentKeys.browserTemplate(sectionTitle: sectionTitle, templateTitle: template.title)
    }

    private var isFavorite: Bool {
        favorites.contains(key)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(template.title)
                    .font(.headline)
                Spacer()
                Button {
                    favorites.toggle(key)
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                }
                .buttonStyle(.borderless)
                .help(isFavorite ? "Remove from favorites" : "Add to favorites")
                Button {
                    copyToPasteboard(template.body)
                    recents.record(
                        key: key,
                        title: template.title,
                        source: .browser,
                        text: template.body
                    )
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
                } label: {
                    Label(copied ? "Copied" : "Copy", systemImage: copied ? "checkmark" : "doc.on.doc")
                }
                .buttonStyle(.bordered)
            }
            Text(template.body)
                .font(.system(.callout, design: .monospaced))
                .textSelection(.enabled)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(14)
        .background(.quaternary.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
    }
}

func copyToPasteboard(_ text: String) {
#if canImport(AppKit)
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(text, forType: .string)
#endif
}
