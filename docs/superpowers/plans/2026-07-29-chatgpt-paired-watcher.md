# ChatGPT Paired Watcher Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Auto-launch Codex Cheat Sheet when ChatGPT.app (Codex) is open, quit it when ChatGPT quits, starting the watcher at Mac login.

**Architecture:** A LaunchAgent runs a shell watcher at login. The watcher polls every 3 seconds using AppleScript bundle-id checks for `com.openai.codex` (`/Applications/ChatGPT.app`) and process checks for `CodexCheatSheet`, then launches or kills the built binary accordingly.

**Tech Stack:** bash, launchd (LaunchAgent plist), osascript, `swift build` binary at `.build/debug/CodexCheatSheet`

## Global Constraints

- ChatGPT path: `/Applications/ChatGPT.app` (bundle id `com.openai.codex`)
- Cheat Sheet binary: `$REPO_ROOT/.build/debug/CodexCheatSheet`
- Logs: `$REPO_ROOT/logs/watcher.log` (directory already gitignored via `logs/`)
- Do not redesign the SwiftUI app
- Prefer move/edit over inventing new top-level folders; scripts live in `scripts/`
- Do not commit unless the user asks (skip commit steps during execution unless requested)

---

## File map

| Path | Responsibility |
|------|----------------|
| `scripts/codex-cheatsheet-watcher.sh` | Poll loop: pair ChatGPT ↔ Cheat Sheet |
| `scripts/com.autogio.codexcheatsheet.watcher.plist` | LaunchAgent template |
| `scripts/install-watcher.command` | Install plist + load LaunchAgent + ensure binary |
| `scripts/uninstall-watcher.command` | Unload + remove LaunchAgent |
| `README.md` | Short note: how to enable/disable watcher |
| `AGENTS.md` | Mention `scripts/` watcher purpose |

---

### Task 1: Watcher script

**Files:**
- Create: `scripts/codex-cheatsheet-watcher.sh`

**Interfaces:**
- Consumes: env `REPO_ROOT` (optional); otherwise derives repo root as parent of `scripts/`
- Produces: long-running process; exits only on signal; logs to `logs/watcher.log`

- [ ] **Step 1: Create the watcher script**

Create `scripts/codex-cheatsheet-watcher.sh` with executable bit (`chmod +x`):

```bash
#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
BINARY="$REPO_ROOT/.build/debug/CodexCheatSheet"
LOG_DIR="$REPO_ROOT/logs"
LOG_FILE="$LOG_DIR/watcher.log"
POLL_SECONDS=3
CHATGPT_BUNDLE_ID="com.openai.codex"
CHATGPT_APP="/Applications/ChatGPT.app"

mkdir -p "$LOG_DIR"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG_FILE"
}

chatgpt_running() {
  [[ -d "$CHATGPT_APP" ]] || return 1
  osascript -e "application id \"$CHATGPT_BUNDLE_ID\" is running" 2>/dev/null | grep -qi true
}

cheatsheet_running() {
  pgrep -xq "CodexCheatSheet"
}

launch_cheatsheet() {
  if [[ ! -x "$BINARY" ]]; then
    log "ERROR: binary missing at $BINARY — run swift build or install-watcher.command"
    return 1
  fi
  log "Starting CodexCheatSheet"
  "$BINARY" >>"$LOG_FILE" 2>&1 &
  disown || true
}

quit_cheatsheet() {
  log "Quitting CodexCheatSheet"
  pkill -x "CodexCheatSheet" 2>/dev/null || true
}

log "Watcher started (repo=$REPO_ROOT)"

while true; do
  if chatgpt_running; then
    if ! cheatsheet_running; then
      launch_cheatsheet || true
    fi
  else
    if cheatsheet_running; then
      quit_cheatsheet
    fi
  fi
  sleep "$POLL_SECONDS"
done
```

- [ ] **Step 2: Sanity-check syntax**

Run: `bash -n scripts/codex-cheatsheet-watcher.sh`  
Expected: no output, exit 0

- [ ] **Step 3: Skip commit** (unless user asked to commit)

---

### Task 2: LaunchAgent plist + install/uninstall

**Files:**
- Create: `scripts/com.autogio.codexcheatsheet.watcher.plist`
- Create: `scripts/install-watcher.command`
- Create: `scripts/uninstall-watcher.command`

**Interfaces:**
- Consumes: watcher script from Task 1; absolute path to repo (baked into installed plist by install script)
- Produces: `~/Library/LaunchAgents/com.autogio.codexcheatsheet.watcher.plist` when installed

- [ ] **Step 1: Create plist template**

Create `scripts/com.autogio.codexcheatsheet.watcher.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.autogio.codexcheatsheet.watcher</string>
  <key>ProgramArguments</key>
  <array>
    <string>__WATCHER_SCRIPT__</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>REPO_ROOT</key>
    <string>__REPO_ROOT__</string>
  </dict>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>__REPO_ROOT__/logs/watcher.launchd.out.log</string>
  <key>StandardErrorPath</key>
  <string>__REPO_ROOT__/logs/watcher.launchd.err.log</string>
</dict>
</plist>
```

- [ ] **Step 2: Create install-watcher.command**

```bash
#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LABEL="com.autogio.codexcheatsheet.watcher"
PLIST_SRC="$SCRIPT_DIR/$LABEL.plist"
PLIST_DST="$HOME/Library/LaunchAgents/$LABEL.plist"
WATCHER="$SCRIPT_DIR/codex-cheatsheet-watcher.sh"
BINARY="$REPO_ROOT/.build/debug/CodexCheatSheet"

mkdir -p "$HOME/Library/LaunchAgents" "$REPO_ROOT/logs"
chmod +x "$WATCHER" "$SCRIPT_DIR/install-watcher.command" "$SCRIPT_DIR/uninstall-watcher.command" 2>/dev/null || true

if [[ ! -x "$BINARY" ]]; then
  echo "Building CodexCheatSheet..."
  (cd "$REPO_ROOT" && swift build)
fi

if [[ ! -x "$BINARY" ]]; then
  echo "ERROR: Build failed; binary not found at $BINARY"
  read -r -p "Press Enter to close…"
  exit 1
fi

sed \
  -e "s|__WATCHER_SCRIPT__|$WATCHER|g" \
  -e "s|__REPO_ROOT__|$REPO_ROOT|g" \
  "$PLIST_SRC" > "$PLIST_DST"

launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_DST"
launchctl enable "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl kickstart -k "gui/$(id -u)/$LABEL" 2>/dev/null || launchctl load "$PLIST_DST" 2>/dev/null || true

echo "Installed and started: $LABEL"
echo "Open ChatGPT.app — Codex Cheat Sheet should follow within a few seconds."
echo "Log: $REPO_ROOT/logs/watcher.log"
read -r -p "Press Enter to close…"
```

- [ ] **Step 3: Create uninstall-watcher.command**

```bash
#!/bin/bash
set -euo pipefail

LABEL="com.autogio.codexcheatsheet.watcher"
PLIST_DST="$HOME/Library/LaunchAgents/$LABEL.plist"

launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl unload "$PLIST_DST" 2>/dev/null || true
rm -f "$PLIST_DST"
pkill -x "CodexCheatSheet" 2>/dev/null || true

echo "Uninstalled: $LABEL"
read -r -p "Press Enter to close…"
```

- [ ] **Step 4: chmod +x both `.command` files and the watcher**

Run: `chmod +x scripts/codex-cheatsheet-watcher.sh scripts/install-watcher.command scripts/uninstall-watcher.command`

- [ ] **Step 5: Skip commit** (unless user asked)

---

### Task 3: Docs + install smoke test

**Files:**
- Modify: `README.md`
- Modify: `AGENTS.md`

- [ ] **Step 1: Update README.md** — add a short “Auto-launch with ChatGPT” section:

```markdown
## Auto-launch with ChatGPT (Codex)

Paired with `/Applications/ChatGPT.app`: open ChatGPT → Cheat Sheet opens; quit ChatGPT → Cheat Sheet quits. Starts at login.

1. Double-click `scripts/install-watcher.command`
2. To stop: double-click `scripts/uninstall-watcher.command`
3. Log: `logs/watcher.log`
```

- [ ] **Step 2: Update AGENTS.md** — under scripts row, note the ChatGPT paired watcher lives in `scripts/`.

- [ ] **Step 3: Install and verify LaunchAgent is loaded**

Run: `bash scripts/install-watcher.command` (may need to skip the trailing `read` for non-interactive — use `yes '' |` or temporarily comment; prefer running the core install lines in Terminal for CI-like check)

Verify: `launchctl print gui/$(id -u)/com.autogio.codexcheatsheet.watcher 2>&1 | head -20`  
Expected: shows the job as running / path to watcher script

- [ ] **Step 4: Manual behavior check (user or agent if ChatGPT available)**

1. Ensure ChatGPT not running → Cheat Sheet should not stay open (watcher quits it).
2. Open `/Applications/ChatGPT.app` → within ~3–6s Cheat Sheet appears.
3. Quit ChatGPT → Cheat Sheet quits.
4. Confirm log lines in `logs/watcher.log`.

- [ ] **Step 5: Skip commit** (unless user asked)

---

## Spec coverage checklist

| Spec requirement | Task |
|------------------|------|
| Launch when ChatGPT open | Task 1 |
| Quit when ChatGPT quits | Task 1 |
| Start at login (LaunchAgent) | Task 2 |
| install / uninstall `.command` | Task 2 |
| Log to `logs/watcher.log` | Task 1 |
| Binary `.build/debug/CodexCheatSheet` + build on install | Task 1–2 |
| Docs for user | Task 3 |
