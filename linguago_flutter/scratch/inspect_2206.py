import os
import re

filepath = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets\Frame 1000002206.svg"
if os.path.exists(filepath):
    print(f"File size: {os.path.getsize(filepath)} bytes")
    with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    
    # Check dimensions
    width_match = re.search(r'width="(\d+)"', content)
    height_match = re.search(r'height="(\d+)"', content)
    viewbox_match = re.search(r'viewBox="([^"]+)"', content)
    print(f"Dimensions: width={width_match.group(1) if width_match else None}, height={height_match.group(1) if height_match else None}, viewBox={viewbox_match.group(1) if viewbox_match else None}")
    
    # Check if it has base64 encoded images (often starting with data:image/png;base64)
    has_base64 = "data:image/" in content
    print(f"Contains base64 image data: {has_base64}")
    
    # Check colors present in the file
    colors = re.findall(r'#[0-9a-fA-F]{6}', content)
    print(f"Unique colors found: {list(set(colors))[:20]}")
    
else:
    print("File does not exist!")
