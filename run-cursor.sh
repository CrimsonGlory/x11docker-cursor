#!/usr/bin/env bash
set -e

# Ensure HOME is set (x11docker does this, but be defensive)
if [ -z "$HOME" ]; then
  echo "ERROR: HOME is not set"
  exit 1
fi

# Create a private temp dir inside HOME
TMPDIR="$HOME/.tmp"

mkdir -p "$TMPDIR"

# Ensure it is executable (required for AppImage)
chmod 700 "$TMPDIR"

# Export TMPDIR so AppImage uses it
export TMPDIR

# Electron / container quirks
export ELECTRON_DISABLE_SANDBOX=1
export NO_AT_BRIDGE=1

# fix Alt Gr key
: "${KEYBOARD_LAYOUT:=us}"
: "${XKB_OPTIONS:=lv3:ralt_switch}"
setxkbmap -layout "$KEYBOARD_LAYOUT" -option "$XKB_OPTIONS"

# Exec Cursor (replace shell so signals work)
exec /opt/cursor/cursor.AppImage --appimage-extract-and-run --no-sandbox
