import SwiftUI

enum AppTab: Hashable {
    case cheatSheet
    case promptBuilder
}

struct CheatSheetBrowserView: View {
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var recents: RecentsStore
    @EnvironmentObject private var builderSession: BuilderSessionStore
    @Binding var selectedTab: AppTab

    @State private var searchText = ""
    @State private var selectedSectionID: CheatSection.ID?
    @State private var sidebarSelection: String?

    private var filteredSections: [CheatSection] {
        guard !searchText.isEmpty else { return CheatSheetContent.sections }
        let query = searchText.lowercased()
        return CheatSheetContent.sections.filter { $0.searchableText.contains(query) }
    }

    private var selectedSection: CheatSection? {
        filteredSections.first { $0.id == selectedSectionID } ?? filteredSections.first
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $sidebarSelection) {
                if !favorites.keys.isEmpty {
                    Section("Favorites") {
                        ForEach(favorites.keys, id: \.self) { key in
                            favoriteRow(key: key)
                                .tag("fav:\(key)")
                        }
                    }
                }
                if !recents.entries.isEmpty {
                    Section("Recently copied") {
                        ForEach(recents.entries) { entry in
                            recentRow(entry: entry)
                                .tag("recent:\(entry.key):\(entry.copiedAt.timeIntervalSince1970)")
                        }
                    }
                }
                Section("Sections") {
                    ForEach(filteredSections) { section in
                        Label(section.title, systemImage: section.icon)
                            .tag("section:\(section.title)")
                    }
                }
            }
            .searchable(text: $searchText, placement: .sidebar, prompt: "Search cheat sheet")
            .navigationSplitViewColumnWidth(min: 220, ideal: 240)
            .onChange(of: sidebarSelection) { _, newValue in
                handleSidebarSelection(newValue)
            }
        } detail: {
            if let section = selectedSection {
                SectionDetailView(section: section)
            } else {
                ContentUnavailableView("No matches", systemImage: "magnifyingglass")
            }
        }
        .onAppear {
            syncSelectionWithFilter()
        }
        .onChange(of: searchText) { _, _ in
            syncSelectionWithFilter()
        }
    }

    @ViewBuilder
    private func favoriteRow(key: String) -> some View {
        if ContentKeys.parseBuilderKey(key) != nil {
            Label(ContentKeys.displayTitle(for: key), systemImage: "wand.and.stars")
        } else {
            Label(ContentKeys.displayTitle(for: key), systemImage: "star.fill")
        }
    }

    private func recentRow(entry: RecentCopyEntry) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.title).lineLimit(1)
            Text(entry.preview)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }

    private func handleSidebarSelection(_ value: String?) {
        guard let value else { return }
        if value.hasPrefix("section:") {
            let title = String(value.dropFirst("section:".count))
            if let section = filteredSections.first(where: { $0.title == title }) {
                selectedSectionID = section.id
            }
            return
        }
        if value.hasPrefix("fav:") {
            let key = String(value.dropFirst("fav:".count))
            openKey(key)
            return
        }
        if value.hasPrefix("recent:") {
            // tag format: recent:<key>:<timestamp> — key may contain separators; parse from entries
            if let entry = recents.entries.first(where: {
                value == "recent:\($0.key):\($0.copiedAt.timeIntervalSince1970)"
            }) {
                openKey(entry.key, preferBuilderSession: entry.source == .builder)
            }
        }
    }

    private func openKey(_ key: String, preferBuilderSession: Bool = false) {
        if let builderName = ContentKeys.parseBuilderKey(key) {
            builderSession.selectTemplate(named: builderName)
            selectedTab = .promptBuilder
            return
        }
        if preferBuilderSession, ContentKeys.parseBuilderKey(key) != nil {
            selectedTab = .promptBuilder
            return
        }
        if let resolved = ContentKeys.resolveBrowser(key: key) {
            searchText = ""
            // Find matching section in full list (IDs are per-process stable once loaded)
            if let section = CheatSheetContent.sections.first(where: { $0.title == resolved.section.title }) {
                selectedSectionID = section.id
                sidebarSelection = "section:\(section.title)"
            }
            selectedTab = .cheatSheet
        }
    }

    private func syncSelectionWithFilter() {
        if let selectedSectionID,
           filteredSections.contains(where: { $0.id == selectedSectionID }) {
            return
        }
        selectedSectionID = filteredSections.first?.id
        if let title = filteredSections.first?.title {
            sidebarSelection = "section:\(title)"
        }
    }
}
