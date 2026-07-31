import CodexCheatSheetCore
import SwiftUI

@main
struct CodexCheatSheetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @StateObject private var favorites = FavoritesStore()
    @StateObject private var recents = RecentsStore()
    @StateObject private var builderSession = BuilderSessionStore()
    @StateObject private var builderHistory = BuilderHistoryStore()

    var body: some Scene {
        WindowGroup("Codex Cheat Sheet") {
            // Apply environmentObject *after* background so QuickBuilderHotkeyBridge inherits stores.
            ContentView()
                .background(QuickBuilderHotkeyBridge())
                .environmentObject(favorites)
                .environmentObject(recents)
                .environmentObject(builderSession)
                .environmentObject(builderHistory)
        }
        .windowResizability(.contentSize)

        MenuBarExtra("Codex Cheat Sheet", systemImage: "wand.and.stars") {
            QuickBuilderView()
                .environmentObject(favorites)
                .environmentObject(recents)
                .environmentObject(builderSession)
                .environmentObject(builderHistory)
        }
        .menuBarExtraStyle(.window)

        Window("Quick Builder", id: "quick-builder") {
            QuickBuilderView()
                .environmentObject(favorites)
                .environmentObject(recents)
                .environmentObject(builderSession)
                .environmentObject(builderHistory)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 360, height: 420)
    }
}

/// Listens for the global hotkey notification and opens the Quick Builder window.
private struct QuickBuilderHotkeyBridge: View {
    @Environment(\.openWindow) private var openWindow
    @EnvironmentObject private var session: BuilderSessionStore

    var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .onReceive(NotificationCenter.default.publisher(for: .openQuickBuilder)) { _ in
                session.showQuickBuilder = true
                openWindow(id: "quick-builder")
            }
            .onChange(of: session.showQuickBuilder) { _, show in
                if show {
                    openWindow(id: "quick-builder")
                    session.showQuickBuilder = false
                }
            }
    }
}
