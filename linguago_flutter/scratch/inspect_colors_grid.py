import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"

frames_to_inspect = ["frame_2.0s.png", "frame_10.0s.png", "frame_13.0s.png", "frame_22.0s.png"]

for name in frames_to_inspect:
    path = os.path.join(frames_dir, name)
    if not os.path.exists(path):
        print(f"{name} not found")
        continue
    
    img = cv2.imread(path)
    h, w, c = img.shape
    print(f"\n--- Colors at Center Grid for {name} ({w}x{h}) ---")
    
    # Let's sample a 9x9 grid around the center
    cx, cy = w // 2, h // 2
    for dy in [-100, -50, 0, 50, 100]:
        row = []
        for dx in [-100, -50, 0, 50, 100]:
            px = img[cy + dy, cx + dx]
            hex_color = f"#{px[2]:02X}{px[1]:02X}{px[0]:02X}"
            row.append(hex_color)
        print("  " + " ".join(row))
