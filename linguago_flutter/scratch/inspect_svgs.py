import re
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

for file_path in svg_files:
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    print(f"\n=== File: {file_path} ===")
    print(f"File size: {len(content)} bytes")
    
    # Let's search for any <text> tags
    text_matches = re.findall(r'<text[^>]*>(.*?)</text>', content, re.DOTALL)
    if text_matches:
        print(f"Text tags found ({len(text_matches)}):")
        for match in text_matches[:5]:
            # Clean up tags inside text
            clean_text = re.sub(r'<[^>]+>', '', match).strip()
            print(f"  - '{clean_text}'")
    else:
        print("No text tags found.")
        
    # Let's search for any data-name or id attributes on groups or paths
    names = re.findall(r'data-name="([^"]+)"', content)
    if names:
        print(f"Data names: {set(names)}")
    
    # Check if there are any embedded images
    images = re.findall(r'<image[^>]*>', content)
    print(f"Embedded images: {len(images)}")
