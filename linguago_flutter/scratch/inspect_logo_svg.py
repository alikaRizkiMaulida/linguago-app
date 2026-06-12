import os
import re

filepath = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets\logo.svg"
if os.path.exists(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Find all hex colors
    colors = re.findall(r'#[0-9a-fA-F]{6}', content)
    print("logo.svg colors:", list(set(colors)))
else:
    print("logo.svg not found")
