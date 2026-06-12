import cv2
import os

video_path = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\Screen Recording 2026-06-12 024811.mp4"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"
os.makedirs(output_dir, exist_ok=True)

cap = cv2.VideoCapture(video_path)
fps = cap.get(cv2.CAP_PROP_FPS)
total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
duration = total_frames / fps if fps > 0 else 0

print(f"FPS: {fps}")
print(f"Total frames: {total_frames}")
print(f"Duration: {duration} seconds")

# Extract frames every 0.5 seconds up to the duration
for i in range(int(duration * 2) + 1):
    s = i / 2.0
    frame_no = int(s * fps)
    cap.set(cv2.CAP_PROP_POS_FRAMES, frame_no)
    ret, frame = cap.read()
    if ret:
        out_path = os.path.join(output_dir, f"frame_{s}s.png")
        cv2.imwrite(out_path, frame)
        print(f"Saved frame for {s}s")
    else:
        print(f"Failed to read frame at {s}s")

cap.release()
