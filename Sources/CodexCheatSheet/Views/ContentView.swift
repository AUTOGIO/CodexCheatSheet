import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CheatSheetBrowserView()
                .tabItem { Label("Cheat Sheet", systemImage: "book") }
            PromptBuilderView()
                .tabItem { Label("Prompt Builder", systemImage: "wand.and.stars") }
        }
        .frame(minWidth: 900, minHeight: 600)
    }
}
