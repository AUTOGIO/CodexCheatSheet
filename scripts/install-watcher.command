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

# Finder/.command launches often have a minimal PATH; ensure system tools are reachable.
export PATH="/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"
if ! command -v xcrun >/dev/null 2>&1; then
  echo "ERROR: xcrun not found; install Xcode"
  read -r -p "Press Enter to close…"
  exit 1
fi

if [[ ! -f "$WATCHER" ]]; then
  echo "ERROR: Watcher script missing: $WATCHER"
  read -r -p "Press Enter to close…"
  exit 1
fi
if [[ ! -f "$PLIST_SRC" ]]; then
  echo "ERROR: LaunchAgent plist missing: $PLIST_SRC"
  read -r -p "Press Enter to close…"
  exit 1
fi

if [[ ! -x "$BINARY" ]]; then
  echo "Building CodexCheatSheet..."
  (cd "$REPO_ROOT" && xcrun swift build)
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

if ! launchctl print "gui/$(id -u)/$LABEL" >/dev/null 2>&1; then
  echo "ERROR: LaunchAgent not loaded after install: $LABEL"
  echo "Check: launchctl print \"gui/\$(id -u)/$LABEL\""
  read -r -p "Press Enter to close…"
  exit 1
fi

echo "Installed and started: $LABEL"
echo "Open ChatGPT, Claude, or Desktop Commander — Codex Cheat Sheet should follow within a few seconds."
echo "Cheat Sheet quits only when all three partner apps are closed."
echo "Log: $REPO_ROOT/logs/watcher.log"
read -r -p "Press Enter to close…"
