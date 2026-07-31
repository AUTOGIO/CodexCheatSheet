#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
BINARY="$REPO_ROOT/.build/debug/CodexCheatSheet"
LOG_DIR="$REPO_ROOT/logs"
LOG_FILE="$LOG_DIR/watcher.log"
POLL_SECONDS="${POLL_SECONDS:-3}"

# Partner apps: bundle_id|app_path (Cheat Sheet stays up while ANY are running)
PARTNERS=(
  "com.openai.codex|/Applications/ChatGPT.app"
  "com.anthropic.claudefordesktop|/Applications/Claude.app"
  "app.desktopcommander|/Applications/Desktop Commander.app"
)

mkdir -p "$LOG_DIR"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG_FILE"
}

app_running() {
  local bundle_id="$1"
  local app_path="$2"
  [[ -d "$app_path" ]] || return 1
  osascript -e "application id \"$bundle_id\" is running" 2>/dev/null | grep -qi true
}

any_partner_running() {
  local entry bundle_id app_path
  for entry in "${PARTNERS[@]}"; do
    bundle_id="${entry%%|*}"
    app_path="${entry#*|}"
    if app_running "$bundle_id" "$app_path"; then
      return 0
    fi
  done
  return 1
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

if [[ "${1:-}" == "--check" ]]; then
  echo "repo=$REPO_ROOT"
  echo "binary=$BINARY ($([[ -x $BINARY ]] && echo ok || echo missing))"
  for entry in "${PARTNERS[@]}"; do
    bundle_id="${entry%%|*}"
    app_path="${entry#*|}"
    if [[ -d "$app_path" ]]; then
      state=$(app_running "$bundle_id" "$app_path" && echo running || echo stopped)
      echo "partner ok: $app_path ($bundle_id) [$state]"
    else
      echo "partner missing: $app_path ($bundle_id)"
    fi
  done
  if any_partner_running; then
    echo "any_partner_running=yes"
  else
    echo "any_partner_running=no"
  fi
  exit 0
fi

log "Watcher started (repo=$REPO_ROOT partners=${#PARTNERS[@]})"

while true; do
  if any_partner_running; then
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
