#!/bin/bash

# Generate HTML files from tasks.json for all detected displays
# Creates one HTML file per display, optimized for its size/orientation

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TASKS_DIR="${TASKS_DIR:-$SCRIPT_DIR}"
TASKS_FILE="$TASKS_DIR/tasks.json"

if [ ! -f "$TASKS_FILE" ]; then
    echo "❌ tasks.json not found at $TASKS_FILE"
    exit 1
fi

# Generate HTML files for all displays
python3 << 'PYTHON_SCRIPT'
import json
import os
import subprocess
import re

tasks_dir = os.environ.get('TASKS_DIR', os.path.dirname(os.path.abspath(__file__)))
tasks_file = os.path.join(tasks_dir, 'tasks.json')

# Load tasks
with open(tasks_file, 'r') as f:
    data = json.load(f)

week_of = data.get('week_of', 'This Week')
tasks = data.get('tasks', [])

def get_displays():
    """Detect all connected displays."""
    result = subprocess.run(['system_profiler', 'SPDisplaysDataType'], capture_output=True, text=True)
    
    displays = []
    current_display = None
    
    for line in result.stdout.split('\n'):
        if re.match(r'^\s{8}\w', line) and ':' in line and 'Resolution' not in line:
            name = line.strip().rstrip(':')
            if not any(key in name for key in ['Chipset', 'Type', 'Bus', 'Cores', 'Vendor', 'Metal', 'Total']):
                if current_display:
                    displays.append(current_display)
                current_display = {'name': name, 'width': 0, 'height': 0, 'main': False}
        
        if current_display and 'Resolution:' in line:
            match = re.search(r'(\d+)\s*x\s*(\d+)', line)
            if match:
                current_display['width'] = int(match.group(1))
                current_display['height'] = int(match.group(2))
        
        if current_display and 'Main Display: Yes' in line:
            current_display['main'] = True
    
    if current_display:
        displays.append(current_display)
    
    for d in displays:
        d['orientation'] = 'portrait' if d['height'] > d['width'] else 'landscape'
    
    return displays

def get_priority_color(priority):
    colors = {'high': '#e17055', 'medium': '#fdcb6e', 'low': '#00b894'}
    return colors.get(priority.lower(), '#e17055')

def generate_task_html(task, font_scale=1.0):
    priority = task.get('priority', 'medium').lower()
    color = get_priority_color(priority)
    status = task.get('status', 'pending')
    completed_class = ' completed' if status == 'completed' else ''
    
    title_size = int(20 * font_scale)
    meta_size = int(14 * font_scale)
    badge_size = int(11 * font_scale)
    checkbox_size = int(24 * font_scale)
    padding_v = int(20 * font_scale)
    padding_h = int(24 * font_scale)
    
    due_html = f'<span>📅 {task.get("due", "")}</span>' if task.get('due') else ''
    
    return f'''            <li class="task-item{completed_class}" style="border-left-color: {color}; padding: {padding_v}px {padding_h}px;">
                <div class="task-content">
                    <div class="checkbox" style="width: {checkbox_size}px; height: {checkbox_size}px;"></div>
                    <div class="task-text">
                        <div class="task-title" style="font-size: {title_size}px;">{task["task"]}</div>
                        <div class="task-meta" style="font-size: {meta_size}px;">
                            <span class="priority-badge" style="font-size: {badge_size}px; background: rgba({int(color[1:3], 16)},{int(color[3:5], 16)},{int(color[5:7], 16)},0.15); color: {color};">{priority.upper()}</span>
                            {due_html}
                        </div>
                    </div>
                </div>
            </li>'''

def generate_html(display_index, width, height, orientation):
    """Generate HTML optimized for a specific display."""
    
    # Calculate font scale based on display size
    if orientation == 'portrait':
        # Portrait: scale based on width (narrower)
        base_width = 1440
        font_scale = max(0.8, min(1.5, width / base_width))
        header_size = int(48 * font_scale)
        week_size = int(18 * font_scale)
        container_width = int(width * 0.85)
        padding_left = int(width * 0.075)
        padding_top = 60
    else:
        # Landscape: scale based on height
        base_height = 2160
        font_scale = max(1.0, min(2.0, height / base_height * 1.5))
        header_size = int(64 * font_scale)
        week_size = int(22 * font_scale)
        container_width = int(min(900 * font_scale, width * 0.4))
        padding_left = int(width * 0.04)
        padding_top = 0  # Vertically centered
    
    tasks_html = '\n'.join([generate_task_html(t, font_scale) for t in tasks])
    
    if orientation == 'portrait':
        body_style = f'''
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            padding: {padding_top}px {padding_left}px;
        '''
    else:
        body_style = f'''
            display: flex;
            align-items: center;
            padding-left: {padding_left}px;
        '''
    
    html = f'''<!DOCTYPE html>
<html lang="en" style="background:#2d3436;margin:0;padding:0;">
<head>
    <meta charset="UTF-8">
    <title>Weekly Tasks - Display {display_index + 1}</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        html, body {{ 
            width: {width}px; 
            height: {height}px;
            min-height: {height}px;
            background: #2d3436;
            overflow: hidden;
        }}
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif;
            background: linear-gradient(145deg, #2d3436 0%, #384048 40%, #3d4a52 100%);
            color: #fff;
            min-height: {height}px;
            {body_style}
        }}
        .bg-cover {{
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(145deg, #2d3436 0%, #384048 40%, #3d4a52 100%);
            z-index: -1;
        }}
        .container {{ max-width: {container_width}px; z-index: 1; }}
        .header {{ margin-bottom: {int(30 * font_scale)}px; }}
        .header h1 {{ font-size: {header_size}px; font-weight: 600; color: #e0e0e0; margin-bottom: {int(8 * font_scale)}px; }}
        .header .week {{ font-size: {week_size}px; color: #7f8c8d; }}
        .tasks-list {{ list-style: none; }}
        .task-item {{
            background: rgba(255,255,255,0.04);
            border-radius: {int(14 * font_scale)}px;
            margin-bottom: {int(16 * font_scale)}px;
            border: 1px solid rgba(255,255,255,0.06);
            border-left: {int(4 * font_scale)}px solid #e17055;
        }}
        .task-item.completed .task-title {{ text-decoration: line-through; opacity: 0.5; }}
        .task-item.completed .checkbox {{ background: #00b894; border-color: #00b894; }}
        .task-content {{ display: flex; align-items: flex-start; gap: {int(16 * font_scale)}px; }}
        .checkbox {{ 
            border: {int(2.5 * font_scale)}px solid rgba(255,255,255,0.25); 
            border-radius: {int(5 * font_scale)}px; 
            flex-shrink: 0; 
            margin-top: {int(3 * font_scale)}px; 
        }}
        .task-text {{ flex: 1; }}
        .task-title {{ 
            font-weight: 500; 
            line-height: 1.5; 
            margin-bottom: {int(8 * font_scale)}px; 
            color: rgba(255,255,255,0.9); 
        }}
        .task-meta {{ color: #7f8c8d; display: flex; gap: {int(14 * font_scale)}px; align-items: center; }}
        .priority-badge {{ 
            padding: {int(3 * font_scale)}px {int(8 * font_scale)}px; 
            border-radius: {int(4 * font_scale)}px; 
            font-weight: 600; 
            text-transform: uppercase;
        }}
    </style>
</head>
<body>
    <div class="bg-cover"></div>
    <div class="container">
        <div class="header">
            <h1>This Week</h1>
            <div class="week">{week_of}</div>
        </div>
        <ul class="tasks-list">
{tasks_html}
        </ul>
    </div>
</body>
</html>
'''
    return html

# Detect displays
displays = get_displays()

if not displays:
    # Fallback to default displays if detection fails
    displays = [
        {'name': 'Main', 'width': 2560, 'height': 1440, 'orientation': 'landscape', 'main': True},
    ]
    print("⚠️  Could not detect displays, using default configuration")

# Save display config for update script
config_path = os.path.join(tasks_dir, 'displays.json')
with open(config_path, 'w') as f:
    json.dump(displays, f, indent=2)

# Generate HTML for each display
for i, display in enumerate(displays):
    html = generate_html(i, display['width'], display['height'], display['orientation'])
    html_path = os.path.join(tasks_dir, f'tasks-display-{i + 1}.html')
    with open(html_path, 'w') as f:
        f.write(html)

print(f"✅ Generated HTML for {len(displays)} display(s) with {len(tasks)} task(s) each")
for i, d in enumerate(displays):
    print(f"   Display {i + 1}: {d['name']} ({d['width']}x{d['height']}, {d['orientation']})")
PYTHON_SCRIPT
