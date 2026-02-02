#!/bin/bash

# Add a task to tasks.json
# Usage: ./add-task.sh "Task description" [priority: high/medium/low] [due: "date"]

TASKS_DIR="$(cd "$(dirname "$0")" && pwd)"
TASKS_FILE="$TASKS_DIR/tasks.json"

TASK="$1"
PRIORITY="${2:-medium}"
DUE="${3:-This week}"

if [ -z "$TASK" ]; then
    echo "Usage: ./add-task.sh \"Task description\" [priority] [due]"
    exit 1
fi

# Get next ID
NEXT_ID=$(python3 -c "import json; data=json.load(open('$TASKS_FILE')); print(max([t['id'] for t in data['tasks']], default=0) + 1)" 2>/dev/null || echo "1")

# Add task to JSON
python3 << EOF
import json

with open('$TASKS_FILE', 'r') as f:
    data = json.load(f)

new_task = {
    "id": $NEXT_ID,
    "task": "$TASK",
    "priority": "$PRIORITY",
    "due": "$DUE",
    "status": "pending"
}

data['tasks'].append(new_task)

with open('$TASKS_FILE', 'w') as f:
    json.dump(data, f, indent=2)

print(f"Added task #{$NEXT_ID}: $TASK")
EOF

echo ""
echo "⚠️  Remember to update tasks-main.html and tasks-portrait.html with the new task!"
echo "Then run: ./update-wallpaper.sh"
