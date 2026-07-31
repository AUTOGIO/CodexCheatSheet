import AppKit
import Carbon
import CodexCheatSheetCore

extension Notification.Name {
    static let openQuickBuilder = Notification.Name("CodexCheatSheet.openQuickBuilder")
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?

    func applicationDidFinishLaunching(_ notification: Notification) {
        registerHotKey()
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
        if let eventHandler {
            RemoveEventHandler(eventHandler)
        }
    }

    private func registerHotKey() {
        let hotKeyID = EventHotKeyID(signature: OSType(0x43435348), id: 1) // 'CCSH'
        // ⌃⌥⌘B → keyCode 11 (B), control+option+command
        let modifiers = UInt32(controlKey | optionKey | cmdKey)
        let keyCode: UInt32 = 11

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        let handler: EventHandlerUPP = { (_, event, _) -> OSStatus in
            var hkID = EventHotKeyID()
            GetEventParameter(
                event,
                EventParamName(kEventParamDirectObject),
                EventParamType(typeEventHotKeyID),
                nil,
                MemoryLayout<EventHotKeyID>.size,
                nil,
                &hkID
            )
            if hkID.id == 1 {
                DispatchQueue.main.async {
                    NSApp.activate(ignoringOtherApps: true)
                    NotificationCenter.default.post(name: .openQuickBuilder, object: nil)
                }
            }
            return noErr
        }

        InstallEventHandler(GetApplicationEventTarget(), handler, 1, &eventType, nil, &eventHandler)
        let status = RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        if status != noErr {
            // Silent no-op on failure (plan)
            hotKeyRef = nil
        }
    }
}
