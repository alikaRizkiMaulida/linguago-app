import os
import re
import base64

assets_dir = 'assets'
files = ['image 414.svg', 'image 416.svg', 'image 417.svg', 'image 424.svg']

for f in files:
    path = os.path.join(assets_dir, f)
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as file:
            content = file.read()
            match = re.search(r'xlink:href=\"data:image/png;base64,([^\"]+)\"', content)
            if match:
                b64_data = match.group(1)
                img_data = base64.b64decode(b64_data)
                out_name = f.replace('.svg', '.png')
                out_path = os.path.join(assets_dir, out_name)
                with open(out_path, 'wb') as out_file:
                    out_file.write(img_data)
                print(f"Success: Extracted {f} -> {out_name}")
            else:
                print(f"Error: No embedded PNG found in {f}")
    else:
        print(f"Error: {f} does not exist in assets.")
