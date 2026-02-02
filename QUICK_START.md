# Quick Start Guide

## First Time Setup

1. **Copy this folder** to your desired location (e.g., `~/.cursor/desktop-tasks`)

2. **Update tasks.json** with your tasks

3. **Update HTML files** - Copy tasks from tasks.json into the static HTML:
   - Edit `tasks-main.html` for horizontal monitors
   - Edit `tasks-portrait.html` for vertical monitors

4. **Run the update script**:
   ```bash
   ./update-wallpaper.sh
   ```

## Daily Usage

### Add a Task
```bash
./add-task.sh "Follow up with client" high "Today"
```
Then manually update the HTML files and run `./update-wallpaper.sh`

### Update Wallpaper
```bash
./update-wallpaper.sh
```

### Mark Task Complete
1. Edit `tasks.json` - change `"status": "pending"` to `"status": "completed"`
2. Edit HTML - add `completed` class to task item
3. Run `./update-wallpaper.sh`

## File Structure

```
desktop-tasks-wallpaper/
├── README.md              # Full documentation
├── QUICK_START.md         # This file
├── tasks.json             # Your task list
├── tasks-main.html        # HTML for horizontal monitors
├── tasks-portrait.html    # HTML for vertical monitors
├── update-wallpaper.sh    # Main script to regenerate wallpapers
├── add-task.sh            # Helper to add tasks to JSON
├── wallpaper-main.png     # Generated wallpaper (horizontal)
└── wallpaper-portrait.png # Generated wallpaper (vertical)
```

## Tips

- Keep HTML static (no JavaScript) - Chrome headless doesn't execute JS reliably
- Update both HTML files when adding tasks
- The `bg-cover` div prevents white bars at bottom
- Desktop 1 = Left monitor, Desktop 2 = Right monitor
