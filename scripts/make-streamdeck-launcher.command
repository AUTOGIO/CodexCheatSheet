#!/bin/zsh
# Builds a self-contained "Launch Codex Cheat Sheet.app" for Elgato Stream Deck.
# Always targets this CodexCheatSheet repo (not the Stream Deck profile folder).
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h}"
APP_NAME="Launch Codex Cheat Sheet.app"
APP_PATH="$SCRIPT_DIR/$APP_NAME"
LAUNCHER="$SCRIPT_DIR/streamdeck-launch-cheatsheet.sh"
HOME_APPS="$HOME/Applications"
HOME_APP_PATH="$HOME_APPS/$APP_NAME"
# Stream Deck profile folder already wired to this path:
STREAMDECK_APP_PATH="$HOME/Documents/GitHub/ipad-stream-deck-console/$APP_NAME"

chmod +x "$LAUNCHER" "$SCRIPT_DIR/make-streamdeck-launcher.command" 2>/dev/null || true

if [[ ! -x "$LAUNCHER" ]]; then
  print -u2 "ERROR: missing launcher script: $LAUNCHER"
  exit 1
fi

# Absolute path baked into the .app so copies/moves still call the real script.
build_app() {
  local dest="$1"
  rm -rf "$dest"
  osacompile -o "$dest" <<EOF
on run
  do shell script "zsh " & quoted form of "$LAUNCHER"
end run
EOF
  codesign --force --deep --sign - "$dest" 2>/dev/null || true
}

build_app "$APP_PATH"

mkdir -p "$HOME_APPS"
rm -rf "$HOME_APP_PATH"
ditto "$APP_PATH" "$HOME_APP_PATH"
codesign --force --deep --sign - "$HOME_APP_PATH" 2>/dev/null || true

if [[ -d "$HOME/Documents/GitHub/ipad-stream-deck-console" ]]; then
  rm -rf "$STREAMDECK_APP_PATH"
  ditto "$APP_PATH" "$STREAMDECK_APP_PATH"
  codesign --force --deep --sign - "$STREAMDECK_APP_PATH" 2>/dev/null || true
fi

echo "Created: $APP_PATH"
echo "Installed: $HOME_APP_PATH"
[[ -d "$STREAMDECK_APP_PATH" ]] && echo "Installed: $STREAMDECK_APP_PATH"
echo ""
echo "Stream Deck: keep System → Open pointed at:"
echo "  $STREAMDECK_APP_PATH"
echo "(or $HOME_APP_PATH)"
echo "Launcher script (must exist): $LAUNCHER"
