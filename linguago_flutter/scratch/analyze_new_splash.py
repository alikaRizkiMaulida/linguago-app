import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"
splash_bg = [251, 238, 243] # RGB F3EEFB (in BGR: 251, 238, 243)

matching_frames = []

for filename in sorted(os.listdir(frames_dir), key=lambda x: float(x.split("_")[1].replace("s.png", "")) if "_" in x else 0):
    if filename.endswith(".png"):
        filepath = os.path.join(frames_dir, filename)
        img = cv2.imread(filepath)
        if img is None:
            continue
        
        # Check background color at corners to see if it's the splash screen
        h, w, c = img.shape
        corner_pixels = [img[10, 10], img[10, w-10], img[h-10, 10], img[h-10, w-10]]
        is_splash = all(np.linalg.norm(p - splash_bg) < 15 for p in corner_pixels)
        
        if is_splash:
            timestamp = filename.split("_")[1].replace("s.png", "")
            # Find elements in the center
            center_area = img[int(h*0.2):int(h*0.8), int(w*0.2):int(w*0.8)]
            # Count non-background pixels in the center
            diff = np.linalg.norm(center_area - splash_bg, axis=2)
            non_bg_ratio = np.mean(diff > 15)
            
            matching_frames.append({
                "time": timestamp,
                "file": filename,
                "non_bg_ratio": non_bg_ratio
            })

print(f"Total matching splash frames: {len(matching_frames)}")
for f in matching_frames:
    print(f"Time {f['time']}s: non-bg ratio = {f['non_bg_ratio']:.4f}")
