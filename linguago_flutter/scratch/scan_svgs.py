import os
import re

svgs = [f for f in os.listdir("assets") if f.endswith(".svg")]
print(f"Total SVGs found: {len(svgs)}")

for f_name in sorted(svgs):
    f_path = os.path.join("assets", f_name)
    try:
        with open(f_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            svg_tag = re.search(r'<svg[^>]+>', content)
            if svg_tag:
                tag_str = svg_tag.group(0)
                # print properties if width/height is small (like icons or illustrations)
                w_match = re.search(r'width="([^"]+)"', tag_str)
                h_match = re.search(r'height="([^"]+)"', tag_str)
                vb_match = re.search(r'viewBox="([^"]+)"', tag_str)
                
                w = w_match.group(1) if w_match else "?"
                h = h_match.group(1) if h_match else "?"
                vb = vb_match.group(1) if vb_match else "?"
                
                # Filter for files that are likely icons (width between 20 and 100)
                try:
                    w_val = float(w)
                    h_val = float(h)
                except ValueError:
                    w_val = 0
                    h_val = 0
                
                # Print information for files of interest
                if (20 <= w_val <= 150) or ("Group" in f_name) or ("Frame" in f_name):
                    print(f"{f_name}: width={w}, height={h}, viewBox={vb}")
                    # Check if there is a yellow/gold circle, purple circle, or heart in the SVG paths/fills
                    yellow_match = re.search(r'fill="#FF[CDE][0-9A-F]', content, re.I) or re.search(r'fill="#FFE031"', content)
                    purple_match = re.search(r'fill="#[89AB][0-9A-F]75', content, re.I) or re.search(r'fill="#7C55C5"', content)
                    heart_match = "heart" in content.lower() or "love" in content.lower() or "heart" in f_name.lower()
                    
                    matches = []
                    if yellow_match: matches.append("yellow/gold")
                    if purple_match: matches.append("purple")
                    if heart_match: matches.append("heart")
                    if matches:
                        print(f"  -> Matches: {', '.join(matches)}")
    except Exception as e:
        pass
