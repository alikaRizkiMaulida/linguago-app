import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"

# Colors (BGR)
mascot_color = np.array([199, 131, 156])  # #9C83C7
qmark_color = np.array([152, 60, 93])     # #5D3C98
text_color = np.array([53, 17, 28])       # #1C1135

frame_files = sorted(os.listdir(frames_dir), key=lambda x: float(x.split("_")[1].replace("s.png", "")) if "_" in x else 0)

print("Chronological Layout Analysis of Video:")

current_state = None

for filename in frame_files:
    if not filename.endswith(".png"):
        continue
    filepath = os.path.join(frames_dir, filename)
    img = cv2.imread(filepath)
    if img is None:
        continue
    
    timestamp = float(filename.split("_")[1].replace("s.png", ""))
    
    # Check if mascot is present
    diff_m = np.linalg.norm(img - mascot_color, axis=2)
    m_mask = diff_m < 15
    m_pixels = np.argwhere(m_mask)
    has_mascot = len(m_pixels) > 100
    
    # Check if question mark is present
    diff_q = np.linalg.norm(img - qmark_color, axis=2)
    q_mask = diff_q < 20
    q_pixels = np.argwhere(q_mask)
    has_qmark = len(q_pixels) > 50
    
    # Check if text is present
    diff_t = np.linalg.norm(img - text_color, axis=2)
    text_mask = diff_t < 15
    text_pixels = np.argwhere(text_mask)
    has_text = len(text_pixels) > 100
    
    # Determine the layout state
    if not has_mascot and not has_text:
        state = "Blank/Other"
    elif has_mascot and has_qmark and not has_text:
        state = "Mascot + Question Mark (Thinking)"
    elif has_mascot and not has_qmark and not has_text:
        state = "Mascot Only (Smiling)"
    elif has_mascot and has_text:
        # Check if text is below mascot (vertical) or next to it (horizontal)
        # Mascot bounding box
        my_min, mx_min = m_pixels.min(axis=0)
        my_max, mx_max = m_pixels.max(axis=0)
        
        # Text bounding box
        ty_min, tx_min = text_pixels.min(axis=0)
        ty_max, tx_max = text_pixels.max(axis=0)
        
        # Check overlap or relative position
        if tx_min > mx_max - 50: # text is to the right
            state = "Horizontal Logo (Mascot + Text side-by-side)"
        elif ty_min > my_max - 20: # text is below
            state = "Vertical Logo (Mascot + Text below)"
        else:
            state = f"Mascot + Text Overlapping (m: x={mx_min}..{mx_max}, y={my_min}..{my_max} | t: x={tx_min}..{tx_max}, y={ty_min}..{ty_max})"
    elif not has_mascot and has_text:
        state = "Text Only"
        
    if state != current_state:
        print(f"Time {timestamp:0.1f}s: Transitioned to '{state}'")
        current_state = state
