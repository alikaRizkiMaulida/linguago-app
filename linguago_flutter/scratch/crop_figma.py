import cv2
import os

img_path = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders\render_special.png"
output_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders\slices"
os.makedirs(output_dir, exist_ok=True)

img = cv2.imread(img_path)
h, w, c = img.shape
print(f"Loaded image size: {w}x{h}")

# Let's slice the image vertically into 10 parts
slice_height = h // 10

for i in range(10):
    y_start = i * slice_height
    y_end = (i + 1) * slice_height if i < 9 else h
    slice_img = img[y_start:y_end, 0:w]
    out_path = os.path.join(output_dir, f"slice_{i}.png")
    cv2.imwrite(out_path, slice_img)
    print(f"Saved slice {i} to {out_path}")
