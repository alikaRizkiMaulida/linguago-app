import cv2
import numpy as np
import os

renders_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"

def find_logo(name):
    path = os.path.join(renders_dir, name)
    if not os.path.exists(path):
        print(f"{name} not found")
        return
        
    img = cv2.imread(path)
    h, w, c = img.shape
    print(f"\n--- Logo Search in {name} ({w}x{h}) ---")
    
    # logo color is #57477A -> BGR: B=122, G=71, R=87
    logo_color = np.array([122, 71, 87])
    diff = np.linalg.norm(img - logo_color, axis=2)
    mask = diff < 20
    pixels = np.argwhere(mask)
    
    if len(pixels) > 0:
        min_y, min_x = pixels.min(axis=0)
        max_y, max_x = pixels.max(axis=0)
        print(f"Logo text: x={min_x}..{max_x}, y={min_y}..{max_y} (w={max_x - min_x}, h={max_y - min_y})")
        
        # Mascot Bounding Box for comparison
        mascot_color = np.array([199, 131, 156])  # BGR #9C83C7
        diff_m = np.linalg.norm(img - mascot_color, axis=2)
        m_mask = diff_m < 15
        m_pixels = np.argwhere(m_mask)
        if len(m_pixels) > 0:
            my_min, mx_min = m_pixels.min(axis=0)
            my_max, mx_max = m_pixels.max(axis=0)
            print(f"Mascot: x={mx_min}..{mx_max}, y={my_min}..{my_max} (w={mx_max - mx_min}, h={my_max - my_min})")
            
            # Check relative position
            # If logo is to the right of mascot, print distance
            if min_x > mx_max:
                print(f"  Logo is to the RIGHT of mascot by {min_x - mx_max} pixels")
            elif min_y > my_max:
                print(f"  Logo is BELOW mascot by {min_y - my_max} pixels")
            else:
                print("  Logo and Mascot are overlapping or aligned differently")
    else:
        print("Logo text not found")

find_logo("crop_22s.png")
find_logo("crop_45s.png")
