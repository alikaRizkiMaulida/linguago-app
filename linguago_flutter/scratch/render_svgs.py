import subprocess
import os

chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"
os.makedirs(output_dir, exist_ok=True)

svgs = [
    ("logo.svg", 213, 53),
    ("Group 36698 (2).svg", 261, 191),
    ("blink.svg", 271, 188),
    ("Group 106.svg", 271, 188),
    ("Group 36716.svg", 132, 85),
    ("Group 36730.svg", 148, 89),
    ("Group 36741.svg", 148, 117),
    ("Group 36726.svg", 148, 148),
    ("Group 36727.svg", 148, 148),
]

for name, w, h in svgs:
    input_path = os.path.join(assets_dir, name)
    if not os.path.exists(input_path):
        print(f"Skipping {name} (not found)")
        continue
    
    # We create a temporary HTML file because headless Chrome doesn't render SVG directly with background colors correctly
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
    
    # Run Chrome headless to take screenshot
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
        
    # Clean up temp html
    if os.path.exists(temp_html):
        os.remove(temp_html)
