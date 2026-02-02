# Desktop Tasks Wallpaper

Display your weekly tasks as a custom wallpaper on macOS. Works with **any number of monitors** in **any configuration** - the system auto-detects your displays and generates appropriately sized wallpapers for each.

## Features

- **Any Monitor Setup** - Works with 1, 2, 3+ monitors of any size or orientation
- **Auto-Detection** - Automatically detects all connected displays
- **Same Tasks Everywhere** - Your task list appears on every screen
- **Smart Scaling** - Text size optimized for each monitor's resolution
- **Fully Automatic** - Just edit `tasks.json` and run the update script
- **One-Command Setup** - Install and configure in seconds

## Quick Start

```bash
# Clone the repo
git clone https://github.com/masonearl/desktop-tasks-wallpaper.git
cd desktop-tasks-wallpaper

# Install (sets up everything automatically)
./install.sh
```

That's it! The installer will:
- Detect your monitors automatically
- Copy files to `~/.cursor/desktop-tasks`
- Create your `tasks.json` file
- Generate wallpapers for all displays
- Optionally enable hourly auto-updates

## Usage

### Edit Your Tasks

Edit `~/.cursor/desktop-tasks/tasks.json`:

```json
{
  "week_of": "Week of January 27, 2026",
  "tasks": [
    {
      "id": 1,
      "task": "Submit project proposal",
      "priority": "high",
      "due": "Monday",
      "status": "pending"
    },
    {
      "id": 2,
      "task": "Review client feedback",
      "priority": "medium",
      "due": "Wednesday",
      "status": "pending"
    }
  ]
}
```

### Update Wallpaper

```bash
~/.cursor/desktop-tasks/update-wallpaper.sh
```

This will:
1. Detect all your monitors
2. Generate HTML for each display (same tasks, optimized sizing)
3. Create wallpaper images
4. Set them as your desktop backgrounds

### Add a Task Quickly

```bash
~/.cursor/desktop-tasks/add-task.sh "New task description" high "Today"
```

This adds the task AND updates all wallpapers automatically.

## Requirements

- macOS 12+
- Google Chrome (for generating wallpaper images)
- Python 3 (included with macOS)

## How It Works

1. **detect-displays.sh** - Finds all connected monitors and their resolutions
2. **generate-html.sh** - Creates HTML files from `tasks.json`, one per display
3. **update-wallpaper.sh** - Takes screenshots and sets wallpapers

The system automatically scales text based on monitor size:
- Larger monitors get larger text
- Portrait monitors get optimized vertical layout
- Landscape monitors get horizontal layout

## Monitor Configuration

The system automatically detects:
- Monitor resolution (e.g., 6016x3384, 1440x2560)
- Orientation (landscape vs portrait)
- Number of displays

Example detection output:
```
Display 1: DELL U4320Q (6016x3384, landscape)
Display 2: DELL S2725DS (1440x2560, portrait)
Display 3: LG 27UK850 (3840x2160, landscape)
```

### Manual Configuration

If auto-detection doesn't work, you can manually edit `displays.json`:

```json
[
  {"name": "Main", "width": 2560, "height": 1440, "orientation": "landscape"},
  {"name": "Secondary", "width": 1920, "height": 1080, "orientation": "landscape"},
  {"name": "Vertical", "width": 1080, "height": 1920, "orientation": "portrait"}
]
```

## Customization

### Priority Colors

- **High**: Red-orange (`#e17055`)
- **Medium**: Yellow (`#fdcb6e`)
- **Low**: Green (`#00b894`)

### Task Status

Set `"status": "completed"` to show a task as done (strikethrough).

### Styling

Edit `generate-html.sh` to customize fonts, colors, and layout.

## File Structure

```
~/.cursor/desktop-tasks/
├── tasks.json              # Your tasks (edit this!)
├── displays.json           # Auto-detected display config
├── detect-displays.sh      # Display detection script
├── generate-html.sh        # Converts JSON → HTML
├── update-wallpaper.sh     # Main script
├── add-task.sh             # Quick task addition
├── tasks-display-1.html    # Generated HTML for display 1
├── tasks-display-2.html    # Generated HTML for display 2
├── wallpaper-1.png         # Wallpaper for display 1
└── wallpaper-2.png         # Wallpaper for display 2
```

## Troubleshooting

### Wallpaper not updating?
```bash
# Run manually and check for errors
~/.cursor/desktop-tasks/update-wallpaper.sh
```

### Wrong display order?
macOS assigns desktop numbers that may not match your physical layout. Try swapping monitors in System Preferences > Displays.

### Display not detected?
Check that your monitor is connected and recognized by macOS:
```bash
system_profiler SPDisplaysDataType
```

### Chrome not found?
Install Google Chrome or update the path in `update-wallpaper.sh`.

## Automatic Updates

The installer can set up hourly auto-updates via launchd. To enable manually:

```bash
# Create LaunchAgent
cat > ~/Library/LaunchAgents/com.desktop-tasks-wallpaper.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.desktop-tasks-wallpaper</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/.cursor/desktop-tasks/update-wallpaper.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Load it
launchctl load ~/Library/LaunchAgents/com.desktop-tasks-wallpaper.plist
```

## License

MIT - Use freely!

## Contributing

PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
