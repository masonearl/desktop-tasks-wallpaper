#!/bin/bash

# Desktop Tasks Wallpaper Updater - Dual Monitor Support
# Set TASKS_DIR environment variable or use default location
TASKS_DIR="${TASKS_DIR:-$HOME/.cursor/desktop-tasks}"

# Main display: 6016 x 3384
MAIN_HTML="$TASKS_DIR/tasks-main.html"
MAIN_IMAGE="$TASKS_DIR/wallpaper-main.png"
MAIN_WIDTH=6016
MAIN_HEIGHT=3384

# Portrait display (DELL): 1440 x 2560 
PORTRAIT_HTML="$TASKS_DIR/tasks-portrait.html"
PORTRAIT_IMAGE="$TASKS_DIR/wallpaper-portrait.png"
PORTRAIT_WIDTH=1440
PORTRAIT_HEIGHT=2560

echo "Generating wallpapers for dual monitors..."

# Generate main display wallpaper with proper background
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

# Generate portrait display wallpaper
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

# Set wallpapers using AppleScript
echo "Setting wallpapers..."
osascript << EOF
tell application "System Events"
    set desktopCount to count of desktops
    repeat with i from 1 to desktopCount
        set currentDesktop to desktop i
        if i = 1 then
            set picture of currentDesktop to "$MAIN_IMAGE"
        else
            set picture of currentDesktop to "$PORTRAIT_IMAGE"
        end if
    end repeat
end tell
EOF

echo "Done! Wallpapers set for both monitors."
