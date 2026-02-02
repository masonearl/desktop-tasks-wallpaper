#!/bin/bash

# Generate HTML files from tasks.json automatically
# This eliminates the need to manually update HTML files

TASKS_DIR="${TASKS_DIR:-$(cd "$(dirname "$0")" && pwd)}"
TASKS_FILE="$TASKS_DIR/tasks.json"

if [ ! -f "$TASKS_FILE" ]; then
    echo "❌ tasks.json not found at $TASKS_FILE"
    exit 1
fi

# Generate both HTML files from tasks.json
python3 << 'PYTHON_SCRIPT'
import json
import os

tasks_dir = os.environ.get('TASKS_DIR', os.path.dirname(os.path.abspath(__file__)))
tasks_file = os.path.join(tasks_dir, 'tasks.json')

with open(tasks_file, 'r') as f:
    data = json.load(f)

week_of = data.get('week_of', 'This Week')
tasks = data.get('tasks', [])

def get_priority_color(priority):
    colors = {
        'high': '#e17055',
        'medium': '#fdcb6e',
        'low': '#00b894'
    }
    return colors.get(priority.lower(), '#e17055')

def generate_task_html(task, show_due=True, compact=False):
    priority = task.get('priority', 'medium').lower()
    color = get_priority_color(priority)
    status = task.get('status', 'pending')
    completed_class = ' completed' if status == 'completed' else ''
    
    due_html = ''
    if show_due and task.get('due'):
        due_html = f'<span>📅 {task["due"]}</span>'
    
    return f'''            <li class="task-item{completed_class}" style="border-left-color: {color};">
                <div class="task-content">
                    <div class="checkbox"></div>
                    <div class="task-text">
                        <div class="task-title">{task["task"]}</div>
                        <div class="task-meta">
                            <span class="priority-badge" style="background: rgba({int(color[1:3], 16)},{int(color[3:5], 16)},{int(color[5:7], 16)},0.15); color: {color};">{priority.upper()}</span>
                            {due_html}
                        </div>
                    </div>
                </div>
            </li>'''

# Generate main (landscape) HTML - larger text for big monitor
tasks_html = '\n'.join([generate_task_html(t, show_due=True) for t in tasks])
main_html = f'''<!DOCTYPE html>
<html lang="en" style="background:#2d3436;margin:0;padding:0;">
<head>
    <meta charset="UTF-8">
    <title>Weekly Tasks</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        html, body {{ 
            width: 100%; 
            height: 100%;
            min-height: 100%;
            background: #2d3436;
            overflow: hidden;
        }}
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif;
            background: linear-gradient(145deg, #2d3436 0%, #384048 40%, #3d4a52 100%);
            background-attachment: fixed;
            background-size: cover;
            color: #fff;
            display: flex;
            align-items: center;
            padding-left: 120px;
            min-height: 100vh;
        }}
        .bg-cover {{
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(145deg, #2d3436 0%, #384048 40%, #3d4a52 100%);
            z-index: -1;
        }}
        .container {{ max-width: 800px; z-index: 1; }}
        .header {{ margin-bottom: 40px; }}
        .header h1 {{ font-size: 72px; font-weight: 600; color: #e0e0e0; margin-bottom: 10px; }}
        .header .week {{ font-size: 24px; color: #7f8c8d; }}
        .tasks-list {{ list-style: none; }}
        .task-item {{
            background: rgba(255,255,255,0.04);
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 20px;
            border: 1px solid rgba(255,255,255,0.06);
            border-left: 4px solid #e17055;
        }}
        .task-item.completed .task-title {{ text-decoration: line-through; opacity: 0.5; }}
        .task-item.completed .checkbox {{ background: #00b894; border-color: #00b894; }}
        .task-content {{ display: flex; align-items: flex-start; gap: 20px; }}
        .checkbox {{ 
            width: 32px; height: 32px; 
            border: 3px solid rgba(255,255,255,0.25); 
            border-radius: 6px; 
            flex-shrink: 0; 
            margin-top: 4px; 
        }}
        .task-text {{ flex: 1; }}
        .task-title {{ 
            font-size: 28px; 
            font-weight: 500; 
            line-height: 1.6; 
            margin-bottom: 10px; 
            color: rgba(255,255,255,0.9); 
        }}
        .task-meta {{ font-size: 18px; color: #7f8c8d; display: flex; gap: 16px; }}
        .priority-badge {{ 
            padding: 4px 10px; 
            border-radius: 4px; 
            font-size: 14px; 
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

# Generate portrait HTML - same tasks, optimized for vertical monitor
tasks_html_portrait = '\n'.join([generate_task_html(t, show_due=False, compact=True) for t in tasks])
portrait_html = f'''<!DOCTYPE html>
<html lang="en" style="background:#2d3436;margin:0;padding:0;">
<head>
    <meta charset="UTF-8">
    <title>Weekly Tasks - Portrait</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        html, body {{ 
            height: 100%; 
            width: 100%; 
            min-height: 100%;
            overflow: hidden;
            background: #2d3436;
        }}
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif;
            background: linear-gradient(180deg, #2d3436 0%, #384048 50%, #3d4a52 100%);
            background-attachment: fixed;
            background-size: cover;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            padding: 50px 35px;
            min-height: 100vh;
        }}
        .bg-cover {{
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(180deg, #2d3436 0%, #384048 50%, #3d4a52 100%);
            z-index: -1;
        }}
        .header {{ margin-bottom: 30px; z-index: 1; }}
        .header h1 {{ font-size: 42px; font-weight: 600; color: #e0e0e0; margin-bottom: 6px; }}
        .header .week {{ font-size: 16px; color: #7f8c8d; }}
        .tasks-list {{ list-style: none; z-index: 1; }}
        .task-item {{
            background: rgba(255,255,255,0.04);
            border-radius: 12px;
            padding: 18px 20px;
            margin-bottom: 14px;
            border: 1px solid rgba(255,255,255,0.06);
            border-left: 3px solid #e17055;
        }}
        .task-item.completed .task-title {{ text-decoration: line-through; opacity: 0.5; }}
        .task-item.completed .checkbox {{ background: #00b894; border-color: #00b894; }}
        .task-content {{ display: flex; align-items: flex-start; gap: 14px; }}
        .checkbox {{ width: 22px; height: 22px; border: 2px solid rgba(255,255,255,0.25); border-radius: 4px; flex-shrink: 0; margin-top: 2px; }}
        .task-text {{ flex: 1; }}
        .task-title {{ font-size: 16px; font-weight: 500; line-height: 1.5; margin-bottom: 6px; color: rgba(255,255,255,0.9); }}
        .task-meta {{ font-size: 12px; color: #7f8c8d; display: flex; gap: 12px; }}
        .priority-badge {{ 
            padding: 3px 6px; 
            border-radius: 3px; 
            font-size: 10px; 
            font-weight: 600; 
            text-transform: uppercase;
        }}
    </style>
</head>
<body>
    <div class="bg-cover"></div>
    <div class="header">
        <h1>Tasks</h1>
        <div class="week">{week_of}</div>
    </div>
    <ul class="tasks-list">
{tasks_html_portrait}
    </ul>
</body>
</html>
'''

# Write files
main_path = os.path.join(tasks_dir, 'tasks-main.html')
portrait_path = os.path.join(tasks_dir, 'tasks-portrait.html')

with open(main_path, 'w') as f:
    f.write(main_html)

with open(portrait_path, 'w') as f:
    f.write(portrait_html)

print(f"✅ Generated HTML files with {len(tasks)} task(s)")
PYTHON_SCRIPT
