#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h}"
BINARY="$REPO_ROOT/.build/debug/CodexCheatSheet"

# Finder / minimal shells often lack Xcode tooling on PATH.
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin${PATH:+:$PATH}"

if ! command -v xcrun >/dev/null 2>&1; then
  print -u2 "ERROR: xcrun not found; install Xcode Command Line Tools or Xcode."
  exit 1
fi

cd "$REPO_ROOT"

if [[ ! -x "$BINARY" ]]; then
  print "Building CodexCheatSheet..."
  xcrun swift build
fi

if [[ ! -x "$BINARY" ]]; then
  print -u2 "ERROR: Build failed; binary not found at $BINARY"
  exit 1
fi

# Avoid re-launching if already running.
if pgrep -xq "CodexCheatSheet"; then
  print "CodexCheatSheet is already running."
  # Bring to front when possible
  osascript -e 'tell application "System Events" to set frontmost of first process whose name is "CodexCheatSheet" to true' 2>/dev/null || true
  exit 0
fi

print "Launching CodexCheatSheet..."
exec "$BINARY"
