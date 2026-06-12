import os
import re

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
target_color = "57477A"

found = []

for filename in os.listdir(assets_dir):
    if filename.endswith(".svg"):
        filepath = os.path.join(assets_dir, filename)
        with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            # If it has standard figma components or specific shapes
            # Let's count how many paths it has
            paths = content.count("<path")
            # Let's find viewBox
            vb_match = re.search(r'viewBox="([^"]+)"', content)
            vb = vb_match.group(1) if vb_match else "none"
            
            # Let's check if it has a rounded rect like rx=
            has_rx = "rx=" in content
            
            found.append({
                "name": filename,
                "paths": paths,
                "viewBox": vb,
                "has_rx": has_rx,
                "size": os.path.getsize(filepath)
            })

# Sort by size
found.sort(key=lambda x: x["size"])

print("All SVGs:")
for item in found:
    print(f"- {item['name']}: size={item['size']} bytes, viewBox={item['viewBox']}, paths={item['paths']}, has_rx={item['has_rx']}")
