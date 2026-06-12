import re
import os

filepath = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets\logo.svg"

with open(filepath, "r") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "<path" in line:
        # Extract d attribute
        d_match = re.search(r'd="([^"]+)"', line)
        fill_match = re.search(r'fill="([^"]+)"', line)
        if d_match:
            d = d_match.group(1)
            fill = fill_match.group(1) if fill_match else "none"
            # Find all numbers in d
            coords = [float(x) for x in re.findall(r'[-+]?\d*\.\d+|\d+', d)]
            x_coords = coords[0::2]
            y_coords = coords[1::2]
            if x_coords and y_coords:
                min_x, max_x = min(x_coords), max(x_coords)
                min_y, max_y = min(y_coords), max(y_coords)
                print(f"Path {i}: fill={fill}, X=[{min_x:.2f}, {max_x:.2f}], Y=[{min_y:.2f}, {max_y:.2f}]")
