import cv2
import numpy as np
import os

renders_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders"

def analyze_crop(name):
    path = os.path.join(renders_dir, name)
    if not os.path.exists(path):
        print(f"{name} not found")
        return
        
    img = cv2.imread(path)
    h, w, c = img.shape
    print(f"\n--- Crop Analysis for {name} ({w}x{h}) ---")
    
    # Check background color
    # Let's count the most common color
    pixels = img.reshape(-1, c)
    unique_colors, counts = np.unique(pixels, axis=0, return_counts=True)
    sorted_idx = np.argsort(-counts)
    
    print("Top 5 colors in image:")
    for i in range(min(5, len(sorted_idx))):
        idx = sorted_idx[i]
        color = unique_colors[idx]
        hex_color = f"#{color[2]:02X}{color[1]:02X}{color[0]:02X}"
        percentage = (counts[idx] / len(pixels)) * 100
        print(f"  Color {hex_color}: {percentage:.2f}% ({counts[idx]} pixels)")
        
    # Search for mascot color (#9C83C7 / BGR [199, 131, 156])
    mascot_color = np.array([199, 131, 156])
    diff_m = np.linalg.norm(img - mascot_color, axis=2)
    m_mask = diff_m < 15
    m_pixels = np.argwhere(m_mask)
    if len(m_pixels) > 0:
        min_y, min_x = m_pixels.min(axis=0)
        max_y, max_x = m_pixels.max(axis=0)
        print(f"  Mascot: x={min_x}..{max_x}, y={min_y}..{max_y} (w={max_x - min_x}, h={max_y - min_y})")
    
    # Search for text color (#1C1135 / BGR [53, 17, 28])
    text_color = np.array([53, 17, 28])
    diff_t = np.linalg.norm(img - text_color, axis=2)
    t_mask = diff_t < 15
    t_pixels = np.argwhere(t_mask)
    if len(t_pixels) > 0:
        min_y, min_x = t_pixels.min(axis=0)
        max_y, max_x = t_pixels.max(axis=0)
        print(f"  Text logo: x={min_x}..{max_x}, y={min_y}..{max_y} (w={max_x - min_x}, h={max_y - min_y})")
        
    # Search for question mark (#5D3C98 / BGR [152, 60, 93])
    qmark_color = np.array([152, 60, 93])
    diff_q = np.linalg.norm(img - qmark_color, axis=2)
    q_mask = diff_q < 20
    q_pixels = np.argwhere(q_mask)
    if len(q_pixels) > 0:
        min_y, min_x = q_pixels.min(axis=0)
        max_y, max_x = q_pixels.max(axis=0)
        print(f"  Question mark: x={min_x}..{max_x}, y={min_y}..{max_y} (w={max_x - min_x}, h={max_y - min_y})")

analyze_crop("crop_22s.png")
analyze_crop("crop_45s.png")
