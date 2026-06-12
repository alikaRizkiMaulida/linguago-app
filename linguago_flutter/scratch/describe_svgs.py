import os
import re

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
svgs = [
    "blink.svg",
    "Group 36697.svg",
    "Group 36698 (2).svg",
    "Group 36716.svg",
    "Group 36730.svg",
    "Group 36741.svg"
]

for name in svgs:
    filepath = os.path.join(assets_dir, name)
    if os.path.exists(filepath):
        with open(filepath, "r") as f:
            header = f.readline() + f.readline() + f.readline()
            # Find svg tag with width, height, viewBox
            match = re.search(r'<svg[^>]*>', header)
            tag = match.group(0) if match else "No svg tag in first 3 lines"
            print(f"- {name}: {tag}")
