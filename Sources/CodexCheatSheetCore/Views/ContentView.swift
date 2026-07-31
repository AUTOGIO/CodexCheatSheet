import SwiftUI

public struct ContentView: View {
    @State private var selectedTab: AppTab = .cheatSheet

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            CheatSheetBrowserView(selectedTab: $selectedTab)
                .tabItem { Label("Cheat Sheet", systemImage: "book") }
                .tag(AppTab.cheatSheet)
            PromptBuilderView()
                .tabItem { Label("Prompt Builder", systemImage: "wand.and.stars") }
                .tag(AppTab.promptBuilder)
        }
        .frame(minWidth: 900, minHeight: 600)
    }
}
