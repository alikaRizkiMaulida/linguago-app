import cv2
import os

video_path = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\Screen Recording 2026-06-12 010523.mp4"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames"

cap = cv2.VideoCapture(video_path)
fps = cap.get(cv2.CAP_PROP_FPS)

seconds = [18, 19, 20, 21]

for s in seconds:
    frame_no = int(s * fps)
    cap.set(cv2.CAP_PROP_POS_FRAMES, frame_no)
    ret, frame = cap.read()
    if ret:
        out_path = os.path.join(output_dir, f"frame_{s}s.png")
        cv2.imwrite(out_path, frame)
        print(f"Saved frame for {s}s at {out_path}")
    else:
        print(f"Failed to read frame at {s}s")

cap.release()
