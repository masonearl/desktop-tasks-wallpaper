#!/bin/bash

# Desktop Tasks Wallpaper Updater - Dual Monitor Support
# Automatically generates HTML from tasks.json and sets wallpapers

# Set TASKS_DIR environment variable or use script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TASKS_DIR="${TASKS_DIR:-$SCRIPT_DIR}"

# Main display: 6016 x 3384 (landscape - right monitor)
MAIN_HTML="$TASKS_DIR/tasks-main.html"
MAIN_IMAGE="$TASKS_DIR/wallpaper-main.png"
MAIN_WIDTH=6016
MAIN_HEIGHT=3384

# Portrait display (DELL): 1440 x 2560 (vertical - left monitor)
PORTRAIT_HTML="$TASKS_DIR/tasks-portrait.html"
PORTRAIT_IMAGE="$TASKS_DIR/wallpaper-portrait.png"
PORTRAIT_WIDTH=1440
PORTRAIT_HEIGHT=2560

# Step 1: Generate HTML from tasks.json automatically
echo "Generating HTML from tasks.json..."
if [ -f "$TASKS_DIR/generate-html.sh" ]; then
    TASKS_DIR="$TASKS_DIR" bash "$TASKS_DIR/generate-html.sh"
else
    echo "⚠️  generate-html.sh not found, using existing HTML files"
fi

# Step 2: Generate wallpaper screenshots
echo "Generating wallpapers for dual monitors..."

echo "  Main display (${MAIN_WIDTH}x${MAIN_HEIGHT})..."
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --headless \
    --disable-gpu \
    --disable-software-rasterizer \
    --screenshot="$MAIN_IMAGE" \
    --window-size="${MAIN_WIDTH},${MAIN_HEIGHT}" \
    --hide-scrollbars \
    --default-background-color=2d3436 \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=2000 \
    "file://$MAIN_HTML" \
    2>/dev/null

echo "  Portrait display (${PORTRAIT_WIDTH}x${PORTRAIT_HEIGHT})..."
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --headless \
    --disable-gpu \
    --disable-software-rasterizer \
    --screenshot="$PORTRAIT_IMAGE" \
    --window-size="${PORTRAIT_WIDTH},${PORTRAIT_HEIGHT}" \
    --hide-scrollbars \
    --default-background-color=2d3436 \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=2000 \
    "file://$PORTRAIT_HTML" \
    2>/dev/null

# Step 3: Set wallpapers using AppleScript
# Desktop 1 = Left monitor (portrait/vertical)
# Desktop 2 = Right monitor (main/landscape)
echo "Setting wallpapers..."
osascript << EOF
tell application "System Events"
    set desktopCount to count of desktops
    repeat with i from 1 to desktopCount
        set currentDesktop to desktop i
        if i = 1 then
            set picture of currentDesktop to "$PORTRAIT_IMAGE"
        else
            set picture of currentDesktop to "$MAIN_IMAGE"
        end if
    end repeat
end tell
EOF

echo "Done! Wallpapers set for both monitors."
