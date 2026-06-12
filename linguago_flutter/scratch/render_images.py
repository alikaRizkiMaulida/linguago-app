import subprocess
import os

chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"
os.makedirs(output_dir, exist_ok=True)

images = [
    ("image 395.svg", 120, 132),
    ("image 396.svg", 120, 132),
    ("image 397.svg", 120, 120),
    ("image 399.svg", 120, 132),
    ("image 400.svg", 120, 116),
    ("image 401.svg", 120, 120),
    ("image 402.svg", 120, 120),
]

for name, w, h in images:
    input_path = os.path.join(assets_dir, name)
    if not os.path.exists(input_path):
        print(f"Skipping {name} (not found)")
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
    
    cmd = [
        chrome_path,
        "--headless",
        "--disable-gpu",
        f"--screenshot={out_path}",
        f"--window-size={w},{h}",
        temp_html
    ]
    
    try:
        subprocess.run(cmd, check=True)
        print(f"Rendered {name} to {out_path}")
    except Exception as e:
        print(f"Failed to render {name}: {e}")
        
    if os.path.exists(temp_html):
        os.remove(temp_html)
