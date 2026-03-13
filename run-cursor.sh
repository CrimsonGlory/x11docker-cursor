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

# Enable window resizing
xev -root -event randr | while read -r _; do xrandr; done &

# Download cursor if it does not exist already.
# We do it here instead of the Dockerfile because the user may want to use
# Beta, or Nightly version of Cursor. So we need Cursor to be able to overwrite
# the AppImage and remember it after a restart. For that we need Cursor binary to
# be stored on a mounted folder. If we download Cursor on the Dockerfile, the first
# execution (with a mounted folder) will have an empty folder (unless we hosted
# the binary on the git repo).
echo "Downloading cursor"
wget --no-clobber -O /opt/cursor/cursor.AppImage https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/ || echo "Cursor file already exists"
echo "Checking if cursor.AppImage exists"
test -e /opt/cursor/cursor.AppImage
chmod +x /opt/cursor/cursor.AppImage
# Exec Cursor (replace shell so signals work)
exec /opt/cursor/cursor.AppImage --appimage-extract-and-run --no-sandbox
