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
