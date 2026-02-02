#!/bin/bash

# Detect all connected displays and their resolutions
# Outputs JSON with display info

python3 << 'PYTHON_SCRIPT'
import subprocess
import re
import json

def get_displays():
    """Detect all connected displays with their resolutions and orientations."""
    result = subprocess.run(
        ['system_profiler', 'SPDisplaysDataType'],
        capture_output=True, text=True
    )
    
    displays = []
    current_display = None
    
    for line in result.stdout.split('\n'):
        # Detect display name (indented lines that don't start with common keys)
        if re.match(r'^\s{8}\w', line) and ':' in line and 'Resolution' not in line:
            name = line.strip().rstrip(':')
            if not any(key in name for key in ['Chipset', 'Type', 'Bus', 'Cores', 'Vendor', 'Metal', 'Total']):
                if current_display:
                    displays.append(current_display)
                current_display = {'name': name, 'width': 0, 'height': 0, 'rotation': 0, 'main': False}
        
        # Get resolution
        if current_display and 'Resolution:' in line:
            match = re.search(r'(\d+)\s*x\s*(\d+)', line)
            if match:
                current_display['width'] = int(match.group(1))
                current_display['height'] = int(match.group(2))
        
        # Check if main display
        if current_display and 'Main Display: Yes' in line:
            current_display['main'] = True
        
        # Get rotation
        if current_display and 'Rotation:' in line:
            match = re.search(r'Rotation:\s*(\d+)', line)
            if match:
                current_display['rotation'] = int(match.group(1))
    
    # Don't forget the last display
    if current_display:
        displays.append(current_display)
    
    # Determine orientation based on dimensions
    for d in displays:
        if d['height'] > d['width']:
            d['orientation'] = 'portrait'
        else:
            d['orientation'] = 'landscape'
    
    return displays

displays = get_displays()
print(json.dumps(displays, indent=2))
PYTHON_SCRIPT
