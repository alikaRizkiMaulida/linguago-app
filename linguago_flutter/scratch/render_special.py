import subprocess
import os

chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"

name = "ini yang mw di pakek.svg"
input_path = os.path.join(assets_dir, name)
out_path = os.path.join(output_dir, "render_special.png")

# Let's inspect the SVG tag first to get width/height
import re
with open(input_path, "r", errors="ignore") as f:
    head = f.read(2000)
    match = re.search(r'<svg[^>]*>', head)
    tag = match.group(0) if match else ""
    print("SVG Tag:", tag)

# Usually we can screenshot it at a default size like 800x600 or check its viewBox
# If viewBox is present, parse it
w, h = 800, 600
v_match = re.search(r'viewBox="([^"]+)"', tag)
if v_match:
    vb = v_match.group(1).split()
    if len(vb) == 4:
        w, h = int(float(vb[2])), int(float(vb[3]))
        print(f"Parsed size from viewBox: {w}x{h}")

temp_html = os.path.join(output_dir, "temp_special.html")
with open(temp_html, "w") as f:
    f.write(f"""
    <html>
    <body style="margin:0; padding:0; background: #F3EEFB; overflow:hidden;">
        <img src="{input_path}" width="{w}" height="{h}" style="display:block;" />
    </body>
    </html>
    """)

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
print("Rendered special image to:", out_path)
