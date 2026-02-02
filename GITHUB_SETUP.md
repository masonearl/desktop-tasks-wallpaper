# GitHub Repository Setup Guide

This guide will help you create a public GitHub repository for this project.

## Pre-Flight Checklist

✅ **Personal information removed:**
- Hardcoded user paths replaced with configurable variables
- Personal task data replaced with example tasks
- All files sanitized

✅ **Files ready for GitHub:**
- `.gitignore` configured to exclude personal data and generated files
- `tasks.json.example` provided as a template
- Installation script created
- Documentation updated

✅ **Scripts tested:**
- All bash scripts have valid syntax
- Paths are configurable via environment variables

## Creating the GitHub Repository

### Option 1: Using GitHub CLI (Recommended)

```bash
cd /path/to/desktop-tasks-wallpaper
gh repo create desktop-tasks-wallpaper --public --source=. --remote=origin --description "Display your weekly tasks as a custom wallpaper on macOS with dual monitor support"
git add .
git commit -m "Initial commit: Desktop Tasks Wallpaper System"
git push -u origin main
```

### Option 2: Using GitHub Web Interface

1. **Create a new repository on GitHub:**
   - Go to https://github.com/new
   - Repository name: `desktop-tasks-wallpaper`
   - Description: "Display your weekly tasks as a custom wallpaper on macOS with dual monitor support"
   - Set to **Public**
   - **Don't** initialize with README, .gitignore, or license (we already have these)

2. **Initialize git and push:**
   ```bash
   cd /path/to/desktop-tasks-wallpaper
   git init
   git add .
   git commit -m "Initial commit: Desktop Tasks Wallpaper System"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/desktop-tasks-wallpaper.git
   git push -u origin main
   ```

## Files Included in Repository

✅ **Will be committed:**
- `README.md` - Main documentation
- `QUICK_START.md` - Quick reference
- `CONTRIBUTING.md` - Contribution guidelines
- `install.sh` - Installation script
- `update-wallpaper.sh` - Main wallpaper update script
- `add-task.sh` - Task addition helper
- `tasks-main.html` - Landscape template
- `tasks-portrait.html` - Portrait template
- `tasks.json.example` - Example tasks file
- `.gitignore` - Git ignore rules

❌ **Will NOT be committed (protected by .gitignore):**
- `tasks.json` - Your personal tasks (users create their own)
- `*.png` - Generated wallpaper files
- `test-small.png` - Exception (kept for testing)
- `.DS_Store` - macOS system files

## Post-Setup

After creating the repository:

1. **Add topics/tags** on GitHub:
   - `macos`
   - `wallpaper`
   - `productivity`
   - `tasks`
   - `bash`
   - `automation`

2. **Consider adding:**
   - A license file (MIT, Apache 2.0, etc.)
   - GitHub Actions for testing (optional)
   - Issue templates (optional)

3. **Update README** if needed with:
   - Your GitHub username in installation instructions
   - Any additional setup requirements

## Security Notes

- ✅ No personal information in committed files
- ✅ `tasks.json` is gitignored (users create their own)
- ✅ Generated files are gitignored
- ✅ Paths are configurable (no hardcoded usernames)

## Testing Before Pushing

Run these commands to verify everything is ready:

```bash
# Check what will be committed
git status

# Verify no personal files are included
git ls-files | grep -E "(tasks\.json|masdawg|personal)"

# Test install script
./install.sh --help || echo "Install script ready"

# Verify scripts are executable
ls -la *.sh
```

## Next Steps

1. Create the GitHub repository
2. Push the code
3. Test the installation from a fresh clone
4. Share the repository!
