import os
import re

files = [f for f in os.listdir("assets") if f.startswith("Frame 1000002206")]
for f_name in files:
    f_path = os.path.join("assets", f_name)
    try:
        with open(f_path, "r", encoding="utf-8") as f:
            header = f.read(500)
            print(f"File: {f_name}")
            svg_tag = re.search(r'<svg[^>]+>', header)
            if svg_tag:
                print("  SVG tag:", svg_tag.group(0))
            rect_tag = re.search(r'<rect[^>]+>', header)
            if rect_tag:
                print("  Rect tag:", rect_tag.group(0))
    except Exception as e:
        print(f"Error {f_name}: {e}")
