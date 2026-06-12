import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"

# Colors (BGR)
purple_line_color = np.array([209, 101, 140])  # #8C65D1 in BGR: B=209, G=101, R=140
text_color = np.array([53, 17, 28])            # #1C1135 (primary text dark color)

for t in [22.0, 23.0, 24.0, 25.0]:
    name = f"frame_{t}s.png"
    path = os.path.join(frames_dir, name)
    if not os.path.exists(path):
        continue
        
    img = cv2.imread(path)
    h, w, c = img.shape
    print(f"\n--- Onboarding Analysis for {name} ({w}x{h}) ---")
    
    # Find purple loading bar pixels
    diff_p = np.linalg.norm(img - purple_line_color, axis=2)
    p_mask = diff_p < 20
    p_pixels = np.argwhere(p_mask)
    if len(p_pixels) > 0:
        py_min, px_min = p_pixels.min(axis=0)
        py_max, px_max = p_pixels.max(axis=0)
        print(f"Purple Line (Progress): x={px_min}..{px_max}, y={py_min}..{py_max} (h={py_max - py_min})")
    else:
        print("Purple Line (Progress): Not found")
        
    # Find back button (usually at top-left, x < 100, y < 100, dark color)
    # Let's crop top-left area
    top_left = img[0:100, 0:150]
    diff_t = np.linalg.norm(top_left - text_color, axis=2)
    t_mask = diff_t < 15
    t_pixels = np.argwhere(t_mask)
    if len(t_pixels) > 0:
        ty_min, tx_min = t_pixels.min(axis=0)
        ty_max, tx_max = t_pixels.max(axis=0)
        print(f"Back button region found: x={tx_min}..{tx_max}, y={ty_min}..{ty_max}")
    else:
        print("Back button region: Not found")
