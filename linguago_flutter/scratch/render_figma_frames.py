import subprocess
import os
import re

chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"

# Render Frame 1000002206 and its sub-frames
svgs = [
    ("Frame 1000002206.svg", 360, 800),
    ("Frame 1000002206-1.svg", 360, 800),
    ("Frame 1000002206-2.svg", 360, 800),
    ("Frame 1000002206-3.svg", 360, 800),
    ("Frame 1000002206-4.svg", 360, 800),
    ("Frame 1000002206-5.svg", 360, 800),
    ("Frame 1000002206-6.svg", 360, 800),
    ("Frame 1000002206-7.svg", 360, 800),
]

for name, w, h in svgs:
    input_path = os.path.join(assets_dir, name)
    if not os.path.exists(input_path):
        print(f"Skipping {name}")
        continue
        
    # Check viewBox to be precise
    with open(input_path, "r", errors="ignore") as f:
        head = f.read(1000)
        match = re.search(r'<svg[^>]*>', head)
        tag = match.group(0) if match else ""
        v_match = re.search(r'viewBox="([^"]+)"', tag)
        if v_match:
            vb = v_match.group(1).split()
            if len(vb) == 4:
                w, h = int(float(vb[2])), int(float(vb[3]))
                
    temp_html = os.path.join(output_dir, f"temp_{name}.html")
    with open(temp_html, "w") as f:
        f.write(f"""
        <html>
        <body style="margin:0; padding:0; background: #F3EEFB; overflow:hidden;">
            <img src="{input_path}" width="{w}" height="{h}" style="display:block;" />
        </body>
        </html>
        """)
        
    out_path = os.path.join(output_dir, f"render_{name}.png")
    cmd = [
        chrome_path,
        "--headless",
        "--disable-gpu",
        f"--screenshot={out_path}",
        f"--window-size={w},{h}",
        temp_html
    ]
    subprocess.run(cmd)
    if os.path.exists(temp_html):
        os.remove(temp_html)
    print(f"Rendered {name} ({w}x{h})")
