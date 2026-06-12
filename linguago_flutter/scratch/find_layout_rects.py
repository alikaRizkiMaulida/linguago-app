import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"

# Colors (BGR)
mascot_color = np.array([199, 131, 156])  # #9C83C7
qmark_color = np.array([152, 60, 93])     # #5D3C98 (question mark purple)
text_color = np.array([53, 17, 28])       # #1C1135 (primary text dark color)

frames_to_inspect = ["frame_1.5s.png", "frame_10.0s.png", "frame_13.0s.png", "frame_22.0s.png"]

for name in frames_to_inspect:
    path = os.path.join(frames_dir, name)
    if not os.path.exists(path):
        print(f"Skipping {name} (not found)")
        continue
        
    img = cv2.imread(path)
    h, w, c = img.shape
    print(f"\n--- Analyzing {name} ({w}x{h}) ---")
    
    # Mascot Bounding Box
    diff_mascot = np.linalg.norm(img - mascot_color, axis=2)
    mascot_mask = diff_mascot < 15
    mascot_pixels = np.argwhere(mascot_mask)
    if len(mascot_pixels) > 0:
        min_y, min_x = mascot_pixels.min(axis=0)
        max_y, max_x = mascot_pixels.max(axis=0)
        mw, mh = max_x - min_x, max_y - min_y
        cx, cy = min_x + mw // 2, min_y + mh // 2
        print(f"Mascot: x={min_x}, y={min_y}, w={mw}, h={mh} (Center: {cx}, {cy})")
    else:
        print("Mascot: Not found")
        
    # Question Mark Bounding Box
    diff_q = np.linalg.norm(img - qmark_color, axis=2)
    q_mask = diff_q < 20
    q_pixels = np.argwhere(q_mask)
    if len(q_pixels) > 0:
        min_y, min_x = q_pixels.min(axis=0)
        max_y, max_x = q_pixels.max(axis=0)
        qw, qh = max_x - min_x, max_y - min_y
        print(f"Question Mark: x={min_x}, y={min_y}, w={qw}, h={qh}")
    else:
        print("Question Mark: Not found")
        
    # Text Bounding Box (near mascot)
    diff_text = np.linalg.norm(img - text_color, axis=2)
    text_mask = diff_text < 15
    text_pixels = np.argwhere(text_mask)
    if len(text_pixels) > 0:
        min_y, min_x = text_pixels.min(axis=0)
        max_y, max_x = text_pixels.max(axis=0)
        tw, th = max_x - min_x, max_y - min_y
        print(f"Text: x={min_x}, y={min_y}, w={tw}, h={th}")
    else:
        print("Text: Not found")
