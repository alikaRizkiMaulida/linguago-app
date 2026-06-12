import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"

def find_mascot_contours(filename):
    path = os.path.join(frames_dir, filename)
    if not os.path.exists(path):
        print(f"{filename} not found")
        return
        
    img = cv2.imread(path)
    h, w, c = img.shape
    print(f"\n--- Mascot instances in {filename} ({w}x{h}) ---")
    
    mascot_color = np.array([199, 131, 156])  # BGR #9C83C7
    diff = np.linalg.norm(img - mascot_color, axis=2)
    mask = (diff < 15).astype(np.uint8) * 255
    
    # Find contours
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    valid_instances = []
    for i, cnt in enumerate(contours):
        x, y, cw, ch = cv2.boundingRect(cnt)
        # Filter out tiny noises (less than 10x10)
        if cw > 10 and ch > 10:
            valid_instances.append((x, y, cw, ch))
            
    # Sort left to right
    valid_instances.sort(key=lambda item: item[0])
    
    print(f"Found {len(valid_instances)} instances:")
    for idx, (x, y, cw, ch) in enumerate(valid_instances):
        print(f"  Instance {idx + 1}: x={x}, y={y}, w={cw}, h={ch}")

find_mascot_contours("frame_22.0s.png")
find_mascot_contours("frame_45.0s.png")
