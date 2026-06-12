import subprocess
import os

chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"

images = [
    ("tandatanyaberfikir.svg", 148, 148),
    ("blink.svg", 271, 188),
]

for name, w, h in images:
    input_path = os.path.join(assets_dir, name)
    if not os.path.exists(input_path):
        print(f"Skipping {name}")
        continue
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
    cmd = [chrome_path, "--headless", "--disable-gpu", f"--screenshot={out_path}", f"--window-size={w},{h}", temp_html]
    subprocess.run(cmd)
    if os.path.exists(temp_html):
        os.remove(temp_html)
    print(f"Rendered {name}")
