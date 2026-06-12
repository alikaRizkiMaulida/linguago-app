import cv2
import numpy as np
import os

renders_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"

# Colors (BGR)
mascot_color = np.array([199, 131, 156])  # #9C83C7
logo_color = np.array([122, 71, 87])      # #57477A

def measure_layout(crop_name):
    path = os.path.join(renders_dir, crop_name)
    if not os.path.exists(path):
        print(f"{crop_name} not found")
        return
        
    img = cv2.imread(path)
    h, w, c = img.shape
    print(f"\n--- Spacing Analysis for {crop_name} ({w}x{h}) ---")
    
    # Bounding box of mascot (use strict threshold)
    diff_m = np.linalg.norm(img - mascot_color, axis=2)
    m_mask = diff_m < 15
    m_pixels = np.argwhere(m_mask)
    
    # Bounding box of logo text (use strict threshold)
    diff_l = np.linalg.norm(img - logo_color, axis=2)
    l_mask = diff_l < 15
    l_pixels = np.argwhere(l_mask)
    
    if len(m_pixels) > 0 and len(l_pixels) > 0:
        my_min, mx_min = m_pixels.min(axis=0)
        my_max, mx_max = m_pixels.max(axis=0)
        mw, mh = mx_max - mx_min, my_max - my_min
        print(f"Mascot: x={mx_min}..{mx_max} (w={mw}), y={my_min}..{my_max} (h={mh})")
        
        ly_min, lx_min = l_pixels.min(axis=0)
        ly_max, lx_max = l_pixels.max(axis=0)
        lw, lh = lx_max - lx_min, ly_max - ly_min
        print(f"Logo text: x={lx_min}..{lx_max} (w={lw}), y={ly_min}..{ly_max} (h={lh})")
        
        # Check alignment and distance
        # Check if vertical layout (logo is below mascot)
        if ly_min > my_max:
            gap = ly_min - my_max
            print(f"Vertical layout detected. Gap (height) = {gap} pixels")
            # Calculate ratio: Gap / Mascot_Height
            print(f"  Gap to Mascot Height ratio = {gap / mh:.3f}")
        # Check if horizontal layout (logo is to the right of mascot)
        elif lx_min > mx_max:
            gap = lx_min - mx_max
            print(f"Horizontal layout detected. Gap (width) = {gap} pixels")
            # Calculate ratio: Gap / Mascot_Width
            print(f"  Gap to Mascot Width ratio = {gap / mw:.3f}")
            # Calculate Mascot to Logo Height ratio
            print(f"  Mascot Height to Logo Height ratio = {mh / lh:.3f}")
        else:
            # Overlapping or different layout
            print("Layout is not simple vertical or horizontal side-by-side.")
            # Let's see if mascot and logo are overlapping, print their intersection
            overlap_x = max(0, min(mx_max, lx_max) - max(mx_min, lx_min))
            overlap_y = max(0, min(my_max, ly_max) - max(my_min, ly_min))
            print(f"  Overlap: X={overlap_x} pixels, Y={overlap_y} pixels")
    else:
        print(f"Mascot found: {len(m_pixels) > 0}, Logo found: {len(l_pixels) > 0}")

measure_layout("crop_large_43s.png")
measure_layout("crop_large_45s.png")
