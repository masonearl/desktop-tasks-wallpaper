# Desktop Tasks Wallpaper

Display your weekly tasks as a custom wallpaper on macOS. Perfect for keeping tasks visible on your desktop using Cursor or any task management workflow.

## Features

- **Fully Automatic** - Just edit `tasks.json` and run the update script
- **Dual Monitor Support** - Works with landscape and portrait monitors
- **Modern Design** - Dark theme that looks great on any desktop
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
- Copy files to `~/.cursor/desktop-tasks`
- Create your `tasks.json` file
- Generate wallpapers and set them
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

### Add a Task Quickly

```bash
~/.cursor/desktop-tasks/add-task.sh "New task description" high "Today"
```

This adds the task AND updates the wallpaper automatically.

## Requirements

- macOS 12+
- Google Chrome (for generating wallpaper images)
- Python 3 (included with macOS)

## How It Works

1. You edit `tasks.json` with your tasks
2. `generate-html.sh` converts JSON to styled HTML pages
3. Chrome takes screenshots of the HTML
4. AppleScript sets the screenshots as your wallpapers

**No manual HTML editing required!**

## Monitor Configuration

Default setup:
- **Left monitor (Desktop 1)**: Portrait/vertical (1440x2560)
- **Right monitor (Desktop 2)**: Landscape/main (6016x3384)

Edit `update-wallpaper.sh` to adjust dimensions or swap assignments.

## Customization

### Priority Colors

- **High**: Red-orange (`#e17055`)
- **Medium**: Yellow (`#fdcb6e`)
- **Low**: Green (`#00b894`)

### Task Status

Set `"status": "completed"` to show a task as done (strikethrough).

### Styling

Edit `generate-html.sh` to customize fonts, sizes, colors, and layout.

## File Structure

```
~/.cursor/desktop-tasks/
├── tasks.json           # Your tasks (edit this!)
├── generate-html.sh     # Converts JSON → HTML
├── update-wallpaper.sh  # Main script
├── add-task.sh          # Quick task addition
├── tasks-main.html      # Generated (don't edit)
├── tasks-portrait.html  # Generated (don't edit)
├── wallpaper-main.png   # Generated wallpaper
└── wallpaper-portrait.png
```

## Troubleshooting

### Wallpaper not updating?
```bash
# Run manually and check for errors
~/.cursor/desktop-tasks/update-wallpaper.sh
```

### Wrong monitor assignment?
Edit `update-wallpaper.sh` and swap `PORTRAIT_IMAGE` and `MAIN_IMAGE` in the AppleScript section.

### Chrome not found?
Install Google Chrome or update the path in `update-wallpaper.sh`.

## License

MIT - Use freely!

## Contributing

PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
