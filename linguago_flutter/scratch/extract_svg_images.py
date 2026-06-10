import re
import base64
import os

svg_files = [
    "assets/image 395.svg",
    "assets/image 396.svg",
    "assets/image 397.svg",
    "assets/Frame 1000002501.svg",
    "assets/image 399.svg",
    "assets/image 400.svg",
    "assets/image 401.svg",
    "assets/image 402.svg",
    "assets/ngajarkacamata.svg",
    "assets/tandatanyaberfikir.svg"
]

dest_dir = r"C:\Users\Naimah\.gemini\antigravity\brain\03fa8582-5f45-45b2-a604-59620827979f"
os.makedirs(dest_dir, exist_ok=True)

for file_path in svg_files:
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Find base64 image data in href or xlink:href
    # format is usually: data:image/png;base64,iVBOR... or data:image/jpeg;base64,...
    matches = re.findall(r'href="data:image/(png|jpeg|jpg);base64,([^"]+)"', content)
    if not matches:
        matches = re.findall(r'xlink:href="data:image/(png|jpeg|jpg);base64,([^"]+)"', content)
        
    if matches:
        for idx, (img_type, b64_data) in enumerate(matches):
            base_name = os.path.splitext(os.path.basename(file_path))[0]
            out_filename = f"extracted_{base_name}_{idx}.{img_type}"
            out_path = os.path.join(dest_dir, out_filename)
            
            try:
                img_data = base64.b64decode(b64_data.strip())
                with open(out_path, 'wb') as out_f:
                    out_f.write(img_data)
                print(f"Extracted: {out_filename} from {file_path}")
            except Exception as e:
                print(f"Error extracting from {file_path}: {e}")
    else:
        print(f"No base64 image data found in {file_path}")
