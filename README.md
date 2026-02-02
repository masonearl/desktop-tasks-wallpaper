# Desktop Tasks Wallpaper System

A system to display your weekly tasks as a custom wallpaper on macOS with dual monitor support. Perfect for keeping your tasks visible on your desktop background using Cursor.

## Features

- 📋 Display your weekly tasks as a beautiful desktop wallpaper
- 🖥️ Dual monitor support (landscape and portrait orientations)
- 🎨 Modern, dark-themed design
- ⚡ Automatic wallpaper generation and updates
- 🔄 Easy task management via JSON

## Requirements

- macOS (tested on macOS 12+)
- Google Chrome (for headless screenshot generation)
- Screen recording permissions (for setting wallpapers)

## Installation

### Quick Install

```bash
git clone <your-repo-url>
cd desktop-tasks-wallpaper
./install.sh
```

The installer will:
- Create `~/.cursor/desktop-tasks` directory (or use `INSTALL_DIR` env var)
- Copy all necessary files
- Set up executable permissions
- Create a template `tasks.json` file

### Manual Install

1. **Clone or download this repository**

2. **Copy files to your desired location**:
```bash
mkdir -p ~/.cursor/desktop-tasks
cp tasks-main.html tasks-portrait.html update-wallpaper.sh add-task.sh ~/.cursor/desktop-tasks/
cp tasks.json.example ~/.cursor/desktop-tasks/tasks.json
chmod +x ~/.cursor/desktop-tasks/*.sh
```

3. **Edit `tasks.json`** with your tasks (see example below)

4. **Update HTML files** - Edit `tasks-main.html` and `tasks-portrait.html` to match your tasks.json content

## Configuration

### Setting Custom Installation Directory

```bash
export INSTALL_DIR="$HOME/my-custom-path"
./install.sh
```

Or set `TASKS_DIR` when running the update script:
```bash
TASKS_DIR="$HOME/my-custom-path" ./update-wallpaper.sh
```

### Task Format

Edit `tasks.json` with your tasks:
```json
{
  "week_of": "Week of January 27, 2026",
  "tasks": [
    {
      "id": 1,
      "task": "Your task description here",
      "priority": "high",
      "due": "This week",
      "status": "pending"
    }
  ]
}
```

**Priority options:** `high`, `medium`, `low`  
**Status options:** `pending`, `completed`

## Usage

### Updating Your Wallpaper

```bash
cd ~/.cursor/desktop-tasks
./update-wallpaper.sh
```

Or from anywhere (if you've set `TASKS_DIR`):
```bash
TASKS_DIR=~/.cursor/desktop-tasks ~/.cursor/desktop-tasks/update-wallpaper.sh
```

### Adding a Task

**Option 1: Using the helper script**
```bash
cd ~/.cursor/desktop-tasks
./add-task.sh "Follow up with client" high "Today"
```

Then manually update the HTML files (`tasks-main.html` and `tasks-portrait.html`) to include the new task, and run `./update-wallpaper.sh`.

**Option 2: Manual**
1. Edit `tasks.json` to add a new task
2. Update both HTML files (`tasks-main.html` and `tasks-portrait.html`) to include the new task in the static HTML
3. Run `./update-wallpaper.sh`

### Updating Task Status

1. Edit `tasks.json` to change `"status": "pending"` to `"status": "completed"`
2. Update HTML files to add `completed` class to the task item
3. Run `./update-wallpaper.sh`

### Automation

You can set up automatic updates using `cron` or `launchd`. For example, add to your crontab:

```bash
# Update wallpaper every hour
0 * * * * /Users/yourusername/.cursor/desktop-tasks/update-wallpaper.sh
```

### Dual Monitor Setup

The script supports dual monitor configurations:
- **Desktop 1** (first monitor): Uses `wallpaper-main.png` (6016x3384 - landscape)
- **Desktop 2** (second monitor): Uses `wallpaper-portrait.png` (1440x2560 - portrait)

The script automatically detects your monitors and sets the appropriate wallpaper to each desktop.

**Note:** Monitor assignments may vary. Desktop 1 is typically the left monitor, but this depends on your macOS display arrangement. Adjust the script if needed.

## Customization

### Colors

Edit the CSS in the HTML files:
- Background gradient: `linear-gradient(145deg, #2d3436 0%, #384048 40%, #3d4a52 100%)`
- Task card background: `rgba(255,255,255,0.04)`
- Priority colors:
  - High: `#e17055`
  - Medium: `#fdcb6e`
  - Low: `#00b894`

### Layout

- Main display: Tasks aligned left with 80px padding
- Portrait display: Tasks at top with 60px top padding, 40px side padding

## Troubleshooting

### White bar at bottom
- Ensure `bg-cover` div is present in HTML
- Check that `min-height: 100vh` is set on body
- Verify Chrome screenshot includes full viewport

### Tasks not showing
- Make sure HTML is static (no JavaScript) - Chrome headless may not execute JS
- Verify tasks are hardcoded in HTML, not loaded via JS

### Wrong monitor
- Desktop 1 = Left monitor
- Desktop 2 = Right monitor
- Adjust in `update-wallpaper.sh` if needed

## File Structure

```
desktop-tasks-wallpaper/
├── README.md              # This file
├── QUICK_START.md         # Quick reference guide
├── install.sh             # Installation script
├── tasks.json.example     # Example tasks file
├── tasks-main.html        # HTML template for landscape monitors
├── tasks-portrait.html    # HTML template for portrait monitors
├── update-wallpaper.sh    # Main script to regenerate wallpapers
├── add-task.sh            # Helper script to add tasks
└── .gitignore             # Git ignore file
```

## Troubleshooting

### Chrome not found
- Ensure Google Chrome is installed at `/Applications/Google Chrome.app`
- Or modify `update-wallpaper.sh` to point to your Chrome installation

### Permission errors
- Grant Screen Recording permissions in System Preferences > Security & Privacy
- Grant Automation permissions when prompted

### White bar at bottom
- Ensure `bg-cover` div is present in HTML
- Check that `min-height: 100vh` is set on body
- Verify Chrome screenshot includes full viewport

### Tasks not showing
- Make sure HTML is static (no JavaScript) - Chrome headless may not execute JS reliably
- Verify tasks are hardcoded in HTML, not loaded via JS
- Check that your HTML files match your `tasks.json` content

### Wrong monitor assignment
- Desktop 1 = First monitor (usually left)
- Desktop 2 = Second monitor (usually right)
- Adjust the monitor assignment in `update-wallpaper.sh` if needed

## Contributing

Contributions welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available for public use.

## Notes

- Wallpapers are regenerated as PNG images
- Chrome headless mode is used for screenshot generation
- System requires screen recording permission for setting wallpapers
- The system works best with static HTML (no JavaScript) for reliable rendering
