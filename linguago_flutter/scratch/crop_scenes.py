import cv2
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"
os.makedirs(output_dir, exist_ok=True)

# Crop frame_22s around Instance 1 (1028, 302)
# Center: cx=1097, cy=367
img_22 = cv2.imread(os.path.join(frames_dir, "frame_22.0s.png"))
if img_22 is not None:
    h, w, c = img_22.shape
    cx, cy = 1097, 367
    size = 400
    x1 = max(0, cx - size // 2)
    y1 = max(0, cy - size // 2)
    x2 = min(w, cx + size // 2)
    y2 = min(h, cy + size // 2)
    crop_22 = img_22[y1:y2, x1:x2]
    cv2.imwrite(os.path.join(output_dir, "crop_22s.png"), crop_22)
    print("Saved crop_22s.png")

# Crop frame_45s around Instance 1 (820, 532)
# Center: cx=853, cy=565
img_45 = cv2.imread(os.path.join(frames_dir, "frame_45.0s.png"))
if img_45 is not None:
    h, w, c = img_45.shape
    cx, cy = 853, 565
    size = 300
    x1 = max(0, cx - size // 2)
    y1 = max(0, cy - size // 2)
    x2 = min(w, cx + size // 2)
    y2 = min(h, cy + size // 2)
    crop_45 = img_45[y1:y2, x1:x2]
    cv2.imwrite(os.path.join(output_dir, "crop_45s.png"), crop_45)
    print("Saved crop_45s.png")
