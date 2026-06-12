import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"
target_color_bgr = np.array([199, 131, 156]) # #9C83C7 in BGR: B=199, G=131, R=156

found_frames = []

for filename in sorted(os.listdir(frames_dir), key=lambda x: float(x.split("_")[1].replace("s.png", "")) if "_" in x else 0):
    if filename.endswith(".png"):
        filepath = os.path.join(frames_dir, filename)
        img = cv2.imread(filepath)
        if img is None:
            continue
        
        # Check if the target color exists in the image
        diff = np.linalg.norm(img - target_color_bgr, axis=2)
        match_count = np.sum(diff < 15)
        
        if match_count > 500: # at least 500 pixels of the mascot color
            timestamp = filename.split("_")[1].replace("s.png", "")
            found_frames.append((timestamp, filename, match_count))

print(f"Mascot color found in {len(found_frames)} frames:")
for t, f, count in found_frames:
    print(f"- {t}s: match count = {count} pixels ({f})")
