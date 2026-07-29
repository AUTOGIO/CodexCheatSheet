import SwiftUI

struct CheatSheetBrowserView: View {
    @State private var searchText = ""
    @State private var selectedSectionID: CheatSection.ID?

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
            List(filteredSections, selection: $selectedSectionID) { section in
                Label(section.title, systemImage: section.icon)
                    .tag(section.id)
            }
            .searchable(text: $searchText, placement: .sidebar, prompt: "Search cheat sheet")
            .navigationSplitViewColumnWidth(min: 220, ideal: 240)
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

    private func syncSelectionWithFilter() {
        if let selectedSectionID,
           filteredSections.contains(where: { $0.id == selectedSectionID }) {
            return
        }
        selectedSectionID = filteredSections.first?.id
    }
}
