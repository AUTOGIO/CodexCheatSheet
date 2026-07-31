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
