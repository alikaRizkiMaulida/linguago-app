import os
import re

filepath = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets\ini yang mw di pakek.svg"
if os.path.exists(filepath):
    print(f"File size: {os.path.getsize(filepath)} bytes")
    with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    
    # Count occurrences of the square mascot color
    color_count = len(re.findall(r'#9C83C7', content, re.IGNORECASE))
    print(f"Occurrences of #9C83C7 (square mascot body color): {color_count}")
    
    # Count occurrences of the round mascot color
    round_color_count = len(re.findall(r'#A289CB', content, re.IGNORECASE))
    print(f"Occurrences of #A289CB (round mascot body color): {round_color_count}")
    
    # Find IDs or labels in the SVG
    ids = re.findall(r'id="([^"]+)"', content)
    print(f"Total IDs found: {len(ids)}")
    mascot_ids = [i for i in ids if "mascot" in i.lower() or "frame" in i.lower() or "group" in i.lower()]
    print(f"Sample IDs: {mascot_ids[:20]}")
    
    # Check if there are other files in assets or if we can extract SVG paths
    # Let's see if there are any other colors or texts like "?" or "tandatanya"
    has_q = "?" in content or "question" in content.lower()
    print(f"Has question mark: {has_q}")
    
else:
    print("File does not exist!")
