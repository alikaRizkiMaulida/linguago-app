import cv2
import numpy as np
import os

filepath = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders\crop_large_45s.png"

if os.path.exists(filepath):
    img = cv2.imread(filepath)
    h, w, c = img.shape
    print(f"Analyzing {filepath} ({w}x{h})...")
    
    # Let's filter for all purple/violet pixels (both mascot and logo colors)
    # Convert to HSV for better color segmentation
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    # Purple/violet range in HSV: Hue [120, 160], Saturation [40, 255], Value [40, 255]
    lower_purple = np.array([120, 30, 40])
    upper_purple = np.array([160, 255, 255])
    
    mask = cv2.inRange(hsv, lower_purple, upper_purple)
    
    # Perform morphological opening to remove small noise
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    mask_cleaned = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
    
    # Find connected components
    num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask_cleaned)
    
    # Filter components by size (width > 10, height > 10)
    valid_components = []
    for i in range(1, num_labels): # 0 is background
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
            
    # Sort left to right
    valid_components.sort(key=lambda item: item["x"])
    
    print(f"Found {len(valid_components)} main components in the layout:")
    for idx, comp in enumerate(valid_components):
        print(f"  Component {idx + 1}: x={comp['x']}, y={comp['y']}, w={comp['w']}, h={comp['h']}, area={comp['area']}, center=({comp['cx']:.1f}, {comp['cy']:.1f})")
        
    if len(valid_components) >= 2:
        # Component 1 (left) is likely the mascot
        # Component 2 (right) is likely the logo text
        mascot = valid_components[0]
        logo = valid_components[1]
        gap = logo["x"] - (mascot["x"] + mascot["w"])
        print(f"\nSpacing results:")
        print(f"  Mascot (Left): x={mascot['x']}..{mascot['x'] + mascot['w']} (w={mascot['w']}, h={comp['h']})")
        print(f"  Logo Text (Right): x={logo['x']}..{logo['x'] + logo['w']} (w={logo['w']}, h={logo['h']})")
        print(f"  Horizontal Gap = {gap} pixels")
        print(f"  Vertical offset between centers = {abs(mascot['cy'] - logo['cy']):.1f} pixels")
else:
    print("File not found")
