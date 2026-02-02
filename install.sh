#!/bin/bash

# Installation script for Desktop Tasks Wallpaper System

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.cursor/desktop-tasks}"

echo "🚀 Installing Desktop Tasks Wallpaper System..."
echo ""

# Create installation directory
echo "📁 Creating installation directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Copy files
echo "📋 Copying files..."
cp "$SCRIPT_DIR/tasks-main.html" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/tasks-portrait.html" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/update-wallpaper.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/add-task.sh" "$INSTALL_DIR/"

# Copy tasks.json if it doesn't exist
if [ ! -f "$INSTALL_DIR/tasks.json" ]; then
    cp "$SCRIPT_DIR/tasks.json" "$INSTALL_DIR/tasks.json"
    echo "✅ Created tasks.json template"
else
    echo "⚠️  tasks.json already exists, skipping..."
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/update-wallpaper.sh"
chmod +x "$INSTALL_DIR/add-task.sh"

echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Edit $INSTALL_DIR/tasks.json with your tasks"
echo "  2. Update $INSTALL_DIR/tasks-main.html and tasks-portrait.html with your tasks"
echo "  3. Run: cd $INSTALL_DIR && ./update-wallpaper.sh"
echo ""
echo "💡 Tip: Add this to your shell profile to use from anywhere:"
echo "   export TASKS_DIR=\"$INSTALL_DIR\""
echo "   alias update-wallpaper=\"\$TASKS_DIR/update-wallpaper.sh\""
