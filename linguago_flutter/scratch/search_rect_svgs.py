import os
import re

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
square_mascot_files = []

for filename in os.listdir(assets_dir):
    if filename.endswith(".svg"):
        filepath = os.path.join(assets_dir, filename)
        try:
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
                # Find all rect tags
                rects = re.findall(r'<rect([^>]+)>', content)
                for rect_attrs in rects:
                    # Look for rx attribute (rounded corners) and width/height
                    if "rx=" in rect_attrs:
                        width_match = re.search(r'width="(\d+)"', rect_attrs)
                        height_match = re.search(r'height="(\d+)"', rect_attrs)
                        fill_match = re.search(r'fill="([^"]+)"', rect_attrs)
                        
                        if width_match and height_match:
                            w = int(width_match.group(1))
                            h = int(height_match.group(1))
                            fill = fill_match.group(1) if fill_match else "none"
                            # A square mascot usually has w == h or w/h between 40 and 200, rx >= 8
                            if abs(w - h) < 5 and 40 <= w <= 200:
                                square_mascot_files.append({
                                    "file": filename,
                                    "width": w,
                                    "height": h,
                                    "fill": fill,
                                    "rect_attrs": rect_attrs.strip()
                                })
                                break
        except Exception as e:
            pass

print(f"Found {len(square_mascot_files)} SVGs with a rounded square/rect:")
for item in square_mascot_files:
    print(f"- {item['file']}: width={item['width']}, height={item['height']}, fill={item['fill']}")
