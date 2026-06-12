import os
import re

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"

files = ["Group 36871.svg", "Group 36872.svg", "Group 36873.svg"]

for name in files:
    path = os.path.join(assets_dir, name)
    if os.path.exists(path):
        print(f"--- File: {name} ---")
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()
            # Viewbox and size
            vb_match = re.search(r'viewBox="([^"]+)"', content)
            print(f"ViewBox: {vb_match.group(1) if vb_match else 'none'}")
            # Unique colors
            colors = re.findall(r'#[0-9a-fA-F]{6}', content)
            print(f"Colors: {list(set(colors))}")
            # Elements count
            paths = content.count("<path")
            rects = content.count("<rect")
            circles = content.count("<circle")
            print(f"Paths: {paths}, Rects: {rects}, Circles: {circles}")
    else:
        print(f"File {name} does not exist!")
