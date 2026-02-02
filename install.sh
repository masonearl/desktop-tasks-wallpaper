#!/bin/bash

# Installation script for Desktop Tasks Wallpaper System
# One-command setup: ./install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.cursor/desktop-tasks}"

echo "🚀 Installing Desktop Tasks Wallpaper System..."
echo ""

# Create installation directory
echo "📁 Creating installation directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Copy all necessary files
echo "📋 Copying files..."
cp "$SCRIPT_DIR/generate-html.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/update-wallpaper.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/add-task.sh" "$INSTALL_DIR/"

# Copy tasks.json template if it doesn't exist
if [ ! -f "$INSTALL_DIR/tasks.json" ]; then
    if [ -f "$SCRIPT_DIR/tasks.json.example" ]; then
        cp "$SCRIPT_DIR/tasks.json.example" "$INSTALL_DIR/tasks.json"
    else
        # Create default tasks.json
        cat > "$INSTALL_DIR/tasks.json" << 'TASKS_EOF'
{
  "week_of": "This Week",
  "tasks": [
    {
      "id": 1,
      "task": "Example task - edit tasks.json to add your own",
      "priority": "high",
      "due": "This week",
      "status": "pending"
    }
  ]
}
TASKS_EOF
    fi
    echo "✅ Created tasks.json template"
else
    echo "⚠️  tasks.json already exists, keeping your tasks"
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/generate-html.sh"
chmod +x "$INSTALL_DIR/update-wallpaper.sh"
chmod +x "$INSTALL_DIR/add-task.sh"

# Generate initial HTML files
echo "🔧 Generating initial HTML files..."
TASKS_DIR="$INSTALL_DIR" bash "$INSTALL_DIR/generate-html.sh"

# Optional: Set up automatic updates
echo ""
read -p "Set up automatic hourly updates? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    PLIST_FILE="$HOME/Library/LaunchAgents/com.desktop-tasks-wallpaper.plist"
    cat > "$PLIST_FILE" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.desktop-tasks-wallpaper</string>
    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_DIR/update-wallpaper.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/wallpaper-update.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/wallpaper-update-error.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        <key>TASKS_DIR</key>
        <string>$INSTALL_DIR</string>
    </dict>
</dict>
</plist>
PLIST_EOF
    
    launchctl unload "$PLIST_FILE" 2>/dev/null || true
    launchctl load "$PLIST_FILE"
    echo "✅ Automatic updates enabled (runs every hour)"
fi

# Run first update
echo ""
echo "🖼️  Running first wallpaper update..."
TASKS_DIR="$INSTALL_DIR" bash "$INSTALL_DIR/update-wallpaper.sh"

echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Quick commands:"
echo "  Edit tasks:      nano $INSTALL_DIR/tasks.json"
echo "  Update wallpaper: $INSTALL_DIR/update-wallpaper.sh"
echo "  Add task:        $INSTALL_DIR/add-task.sh \"Task description\" high \"Today\""
echo ""
echo "💡 Tip: Just edit tasks.json and run update-wallpaper.sh - HTML is generated automatically!"
