import cv2
import numpy as np
import os

filepath = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders\crop_large_43s.png"

if os.path.exists(filepath):
    img = cv2.imread(filepath)
    h, w, c = img.shape
    print(f"Analyzing {filepath} ({w}x{h})...")
    
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    lower_purple = np.array([120, 30, 40])
    upper_purple = np.array([160, 255, 255])
    
    mask = cv2.inRange(hsv, lower_purple, upper_purple)
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    mask_cleaned = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
    
    num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask_cleaned)
    
    valid_components = []
    for i in range(1, num_labels):
        x, y, cw, ch, area = stats[i]
        if cw > 10 and ch > 10 and area > 100:
            valid_components.append({
                "id": i,
                "x": x,
                "y": y,
                "w": cw,
                "h": ch,
                "area": area,
                "cx": centroids[i][0],
                "cy": centroids[i][1]
            })
            
    # Sort top to bottom
    valid_components.sort(key=lambda item: item["y"])
    
    print(f"Found {len(valid_components)} main components in the layout:")
    for idx, comp in enumerate(valid_components):
        print(f"  Component {idx + 1}: x={comp['x']}, y={comp['y']}, w={comp['w']}, h={comp['h']}, area={comp['area']}, center=({comp['cx']:.1f}, {comp['cy']:.1f})")
        
    # Let's group components that belong to the text logo (which should be below y > 250)
    mascot_comp = None
    text_comps = []
    
    for comp in valid_components:
        if comp["y"] < 200 and comp["h"] > 100:
            # Mascot is large and at the top
            mascot_comp = comp
        else:
            text_comps.append(comp)
            
    if mascot_comp and len(text_comps) > 0:
        # Sort text components left to right to show the letters
        text_comps.sort(key=lambda item: item["x"])
        # Find the top edge of the text logo
        text_top_y = min(comp["y"] for comp in text_comps)
        gap = text_top_y - (mascot_comp["y"] + mascot_comp["h"])
        print(f"\nSpacing results:")
        print(f"  Mascot (Top): y={mascot_comp['y']}..{mascot_comp['y'] + mascot_comp['h']} (w={mascot_comp['w']}, h={mascot_comp['h']})")
        print(f"  Logo Text (Bottom): y={text_top_y} (first letter at x={text_comps[0]['x']})")
        print(f"  Vertical Gap = {gap} pixels")
else:
    print("File not found")
