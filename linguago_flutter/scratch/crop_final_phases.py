import cv2
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\crops"
os.makedirs(output_dir, exist_ok=True)

# Centers of layout in the video: cx=960, cy=510
cx, cy = 960, 510

crops = [
    ("frame_41.0s.png", "thinking_phase.png", 600, 400),
    ("frame_43.0s.png", "vertical_logo_phase.png", 600, 450),
    ("frame_45.0s.png", "horizontal_logo_phase.png", 600, 300)
]

for name, out_name, cw, ch in crops:
    path = os.path.join(frames_dir, name)
    if os.path.exists(path):
        img = cv2.imread(path)
        h, w, c = img.shape
        x1 = max(0, cx - cw // 2)
        y1 = max(0, cy - ch // 2)
        x2 = min(w, cx + cw // 2)
        y2 = min(h, cy + ch // 2)
        crop = img[y1:y2, x1:x2]
        cv2.imwrite(os.path.join(output_dir, out_name), crop)
        print(f"Saved {out_name}")
    else:
        print(f"{name} not found")
