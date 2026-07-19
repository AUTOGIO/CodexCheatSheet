import SwiftUI

struct CheatSheetBrowserView: View {
    @State private var searchText = ""
    @State private var selectedSection: CheatSection?

    private var filteredSections: [CheatSection] {
        guard !searchText.isEmpty else { return CheatSheetContent.sections }
        let query = searchText.lowercased()
        return CheatSheetContent.sections.filter { $0.searchableText.contains(query) }
    }

    var body: some View {
        NavigationSplitView {
            List(filteredSections, selection: $selectedSection) { section in
                Label(section.title, systemImage: section.icon)
                    .tag(section)
            }
            .searchable(text: $searchText, placement: .sidebar, prompt: "Search cheat sheet")
            .navigationSplitViewColumnWidth(min: 220, ideal: 240)
        } detail: {
            if let section = selectedSection ?? filteredSections.first {
                SectionDetailView(section: section)
            } else {
                ContentUnavailableView("No matches", systemImage: "magnifyingglass")
            }
        }
        .onAppear {
            if selectedSection == nil { selectedSection = CheatSheetContent.sections.first }
        }
    }
}
