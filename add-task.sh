#!/bin/bash

# Add a task to tasks.json and automatically update wallpaper
# Usage: ./add-task.sh "Task description" [priority: high/medium/low] [due: "date"]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TASKS_DIR="${TASKS_DIR:-$SCRIPT_DIR}"
TASKS_FILE="$TASKS_DIR/tasks.json"

TASK="$1"
PRIORITY="${2:-medium}"
DUE="${3:-This week}"

if [ -z "$TASK" ]; then
    echo "Usage: ./add-task.sh \"Task description\" [priority] [due]"
    echo ""
    echo "Examples:"
    echo "  ./add-task.sh \"Follow up with client\" high \"Today\""
    echo "  ./add-task.sh \"Review documents\" medium \"Friday\""
    echo "  ./add-task.sh \"Clean up code\" low"
    exit 1
fi

# Create tasks.json if it doesn't exist
if [ ! -f "$TASKS_FILE" ]; then
    echo '{"week_of": "This Week", "tasks": []}' > "$TASKS_FILE"
fi

# Add task to JSON using Python
python3 << EOF
import json

with open('$TASKS_FILE', 'r') as f:
    data = json.load(f)

# Get next ID
next_id = max([t.get('id', 0) for t in data.get('tasks', [])], default=0) + 1

new_task = {
    "id": next_id,
    "task": "$TASK",
    "priority": "$PRIORITY",
    "due": "$DUE",
    "status": "pending"
}

data['tasks'].append(new_task)

with open('$TASKS_FILE', 'w') as f:
    json.dump(data, f, indent=2)

print(f"✅ Added task #{next_id}: $TASK")
EOF

# Auto-update wallpaper
echo "🔄 Updating wallpaper..."
TASKS_DIR="$TASKS_DIR" bash "$TASKS_DIR/update-wallpaper.sh"
