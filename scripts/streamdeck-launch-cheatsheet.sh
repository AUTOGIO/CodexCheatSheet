#!/bin/zsh
# Non-blocking launcher for Elgato Stream Deck / Shortcuts / Automator.
# Focuses CodexCheatSheet if already running; otherwise builds (if needed) and starts it detached.
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h}"
BINARY="$REPO_ROOT/.build/debug/CodexCheatSheet"
LOG_DIR="$REPO_ROOT/logs"
LOG_FILE="$LOG_DIR/streamdeck-launch.log"

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin${PATH:+:$PATH}"

mkdir -p "$LOG_DIR"

if pgrep -xq "CodexCheatSheet"; then
  osascript -e 'tell application "System Events" to set frontmost of first process whose name is "CodexCheatSheet" to true' 2>/dev/null || true
  exit 0
fi

if ! command -v xcrun >/dev/null 2>&1; then
  osascript -e 'display notification "xcrun not found — install Xcode CLT." with title "Codex Cheat Sheet"'
  exit 1
fi

cd "$REPO_ROOT"

if [[ ! -x "$BINARY" ]]; then
  osascript -e 'display notification "Building Codex Cheat Sheet…" with title "Codex Cheat Sheet"' 2>/dev/null || true
  xcrun swift build >>"$LOG_FILE" 2>&1 || {
    osascript -e 'display notification "Build failed — see logs/streamdeck-launch.log" with title "Codex Cheat Sheet"'
    exit 1
  }
fi

if [[ ! -x "$BINARY" ]]; then
  osascript -e 'display notification "Binary missing after build." with title "Codex Cheat Sheet"'
  exit 1
fi

# Ad-hoc sign helps Gatekeeper when launching from Stream Deck.
codesign --force --sign - "$BINARY" >>"$LOG_FILE" 2>&1 || true

nohup "$BINARY" >>"$LOG_FILE" 2>&1 &
disown
exit 0
