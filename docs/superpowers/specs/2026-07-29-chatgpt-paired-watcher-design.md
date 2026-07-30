# ChatGPT ↔ Codex Cheat Sheet paired watcher

Date: 2026-07-29  
Status: approved in chat (Approach 1 + behaviors A/B)

## Goal

Whenever **ChatGPT** (`/Applications/ChatGPT.app`) is open, **Codex Cheat Sheet** is open. When ChatGPT quits, Cheat Sheet quits. The watcher starts automatically at Mac login.

## Non-goals

- Redesigning the SwiftUI app
- Shortcuts / Automator as the primary mechanism
- Syncing windows, focus, or Codex conversation state

## Approach

**LaunchAgent + shell watcher** (Apple-native `launchd`).

| File | Role |
|------|------|
| `scripts/codex-cheatsheet-watcher.sh` | Loop: detect ChatGPT → launch/quit Cheat Sheet |
| `scripts/com.autogio.codexcheatsheet.watcher.plist` | LaunchAgent template (RunAtLoad, KeepAlive) |
| `scripts/install-watcher.command` | One-time: install plist to `~/Library/LaunchAgents`, load it |
| `scripts/uninstall-watcher.command` | Stop and remove LaunchAgent |

## Behavior

1. Watcher runs in the background after login.
2. Every few seconds:
   - If ChatGPT **is** running and Cheat Sheet **is not** → start Cheat Sheet once.
   - If ChatGPT **is not** running and Cheat Sheet **is** → quit Cheat Sheet.
3. Do not launch a second Cheat Sheet if one is already running.
4. ChatGPT process detection: app at `/Applications/ChatGPT.app` (bundle id / process name as available).
5. Cheat Sheet launch target: repo-built binary `.build/debug/CodexCheatSheet`. If missing, install/watcher may run `swift build` once or fail with a clear log message.

## Install / uninstall (user steps)

1. Double-click `scripts/install-watcher.command` (or run in Terminal).
2. macOS may ask for Automation / Accessibility permissions if quitting apps via AppleScript — grant if prompted.
3. To stop: double-click `scripts/uninstall-watcher.command`.

## Logs

Write simple status to `logs/watcher.log` under the repo (gitignored) so failures are easy to see.

## Success criteria

- Log in → watcher is loaded (`launchctl` list shows the job).
- Open ChatGPT → Cheat Sheet appears within a few seconds.
- Quit ChatGPT → Cheat Sheet quits.
- Uninstall removes the LaunchAgent and stops the loop.

## Out of scope later improvements

- Shipping a proper `.app` bundle instead of `.build/debug/...`
- Menu-bar toggle for pause
