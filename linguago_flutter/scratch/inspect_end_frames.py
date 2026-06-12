import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"

# Colors (BGR)
mascot_color = np.array([199, 131, 156])  # #9C83C7
qmark_color = np.array([152, 60, 93])     # #5D3C98
text_color = np.array([53, 17, 28])       # #1C1135

timestamps = [39.0, 39.5, 40.0, 40.5, 41.0, 41.5, 42.0, 42.5, 43.0, 43.5, 44.0, 44.5, 45.0, 45.5]

print("Chronological End Frames Analysis:")

for t in timestamps:
    name = f"frame_{t}s.png"
    path = os.path.join(frames_dir, name)
    if not os.path.exists(path):
        print(f"Time {t}s: Frame file not found")
        continue
        
    img = cv2.imread(path)
    h, w, c = img.shape
    
    # Mascot Bounding Box
    diff_m = np.linalg.norm(img - mascot_color, axis=2)
    m_mask = diff_m < 15
    m_pixels = np.argwhere(m_mask)
    
    # Question Mark Bounding Box
    diff_q = np.linalg.norm(img - qmark_color, axis=2)
    q_mask = diff_q < 20
    q_pixels = np.argwhere(q_mask)
    
    # Text Bounding Box
    diff_t = np.linalg.norm(img - text_color, axis=2)
    text_mask = diff_t < 15
    text_pixels = np.argwhere(text_mask)
    
    # Report what was found
    found = []
    if len(m_pixels) > 100:
        my_min, mx_min = m_pixels.min(axis=0)
        my_max, mx_max = m_pixels.max(axis=0)
        found.append(f"Mascot(x={mx_min}..{mx_max}, y={my_min}..{my_max})")
    if len(q_pixels) > 50:
        qy_min, qx_min = q_pixels.min(axis=0)
        qy_max, qx_max = q_pixels.max(axis=0)
        found.append(f"Q-Mark(x={qx_min}..{qx_max}, y={qy_min}..{qy_max})")
    if len(text_pixels) > 100:
        ty_min, tx_min = text_pixels.min(axis=0)
        ty_max, tx_max = text_pixels.max(axis=0)
        found.append(f"Text(x={tx_min}..{tx_max}, y={ty_min}..{ty_max})")
        
    print(f"Time {t}s: {', '.join(found) if found else 'Empty'}")
