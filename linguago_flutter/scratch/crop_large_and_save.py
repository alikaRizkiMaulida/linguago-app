import cv2
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"
os.makedirs(output_dir, exist_ok=True)

# We crop 800x450 around center (960, 510)
cx, cy = 960, 510
w_size, h_size = 800, 450

frames = [
    ("frame_40.0s.png", "crop_large_40s.png"),
    ("frame_41.0s.png", "crop_large_41s.png"),
    ("frame_43.0s.png", "crop_large_43s.png"),
    ("frame_45.0s.png", "crop_large_45s.png")
]

for name, out_name in frames:
    path = os.path.join(frames_dir, name)
    if os.path.exists(path):
        img = cv2.imread(path)
        h, w, c = img.shape
        x1 = max(0, cx - w_size // 2)
        y1 = max(0, cy - h_size // 2)
        x2 = min(w, cx + w_size // 2)
        y2 = min(h, cy + h_size // 2)
        crop = img[y1:y2, x1:x2]
        cv2.imwrite(os.path.join(output_dir, out_name), crop)
        print(f"Saved {out_name} from {name}")
    else:
        print(f"{name} not found")
