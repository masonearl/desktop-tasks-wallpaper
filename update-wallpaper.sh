#!/bin/bash

# Desktop Tasks Wallpaper Updater
# Automatically detects all displays, generates HTML, and sets wallpapers
# Works with any number of monitors in any configuration

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TASKS_DIR="${TASKS_DIR:-$SCRIPT_DIR}"

echo "🖥️  Desktop Tasks Wallpaper Updater"
echo "===================================="

# Step 1: Generate HTML from tasks.json for all displays
echo ""
echo "Step 1: Generating HTML from tasks.json..."
if [ -f "$TASKS_DIR/generate-html.sh" ]; then
    TASKS_DIR="$TASKS_DIR" bash "$TASKS_DIR/generate-html.sh"
else
    echo "❌ generate-html.sh not found"
    exit 1
fi

# Step 2: Read display configuration
if [ ! -f "$TASKS_DIR/displays.json" ]; then
    echo "❌ displays.json not found - run generate-html.sh first"
    exit 1
fi

# Step 3: Generate wallpaper screenshots for each display
echo ""
echo "Step 2: Generating wallpaper images..."

python3 << PYTHON_SCRIPT
import json
import subprocess
import os

tasks_dir = os.environ.get('TASKS_DIR', '$TASKS_DIR')

# Load display config
with open(os.path.join(tasks_dir, 'displays.json'), 'r') as f:
    displays = json.load(f)

chrome_path = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

for i, display in enumerate(displays):
    html_file = os.path.join(tasks_dir, f'tasks-display-{i + 1}.html')
    image_file = os.path.join(tasks_dir, f'wallpaper-{i + 1}.png')
    
    width = display['width']
    height = display['height']
    
    print(f"   Display {i + 1}: {display['name']} ({width}x{height})...")
    
    cmd = [
        chrome_path,
        '--headless',
        '--disable-gpu',
        '--disable-software-rasterizer',
        f'--screenshot={image_file}',
        f'--window-size={width},{height}',
        '--hide-scrollbars',
        '--default-background-color=2d3436',
        '--run-all-compositor-stages-before-draw',
        '--virtual-time-budget=2000',
        f'file://{html_file}'
    ]
    
    subprocess.run(cmd, capture_output=True)

print(f"   ✅ Generated {len(displays)} wallpaper image(s)")
PYTHON_SCRIPT

# Step 4: Set wallpapers for all desktops
echo ""
echo "Step 3: Setting wallpapers..."

python3 << PYTHON_SCRIPT
import json
import subprocess
import os

tasks_dir = os.environ.get('TASKS_DIR', '$TASKS_DIR')

# Load display config
with open(os.path.join(tasks_dir, 'displays.json'), 'r') as f:
    displays = json.load(f)

# Build AppleScript to set wallpapers
# Note: Desktop order in System Events may not match display order
# We'll set each desktop to a wallpaper based on its index
applescript = '''
tell application "System Events"
    set desktopCount to count of desktops
'''

for i in range(len(displays)):
    image_path = os.path.join(tasks_dir, f'wallpaper-{i + 1}.png')
    applescript += f'''
    if desktopCount >= {i + 1} then
        set picture of desktop {i + 1} to "{image_path}"
    end if
'''

applescript += '''
end tell
'''

result = subprocess.run(['osascript', '-e', applescript], capture_output=True, text=True)

if result.returncode == 0:
    print(f"   ✅ Set wallpapers for {len(displays)} desktop(s)")
else:
    print(f"   ⚠️  AppleScript warning: {result.stderr}")
PYTHON_SCRIPT

echo ""
echo "✅ Done! Wallpapers updated for all displays."
echo ""
echo "📋 Your tasks are now on all screens!"
