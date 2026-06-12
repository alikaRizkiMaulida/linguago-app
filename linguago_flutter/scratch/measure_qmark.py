import cv2
import numpy as np
import os

filepath = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\renders\crop_large_41s.png"

if os.path.exists(filepath):
    img = cv2.imread(filepath)
    h, w, c = img.shape
    print(f"Analyzing {filepath} ({w}x{h})...")
    
    # Mascot
    mascot_color = np.array([199, 131, 156])  # BGR #9C83C7
    diff_m = np.linalg.norm(img - mascot_color, axis=2)
    m_mask = diff_m < 15
    m_pixels = np.argwhere(m_mask)
    
    # Question Mark
    qmark_color = np.array([152, 60, 93])     # BGR #5D3C98
    diff_q = np.linalg.norm(img - qmark_color, axis=2)
    q_mask = diff_q < 20
    q_pixels = np.argwhere(q_mask)
    
    if len(m_pixels) > 0 and len(q_pixels) > 0:
        my_min, mx_min = m_pixels.min(axis=0)
        my_max, mx_max = m_pixels.max(axis=0)
        mw, mh = mx_max - mx_min, my_max - my_min
        print(f"Mascot: x={mx_min}..{mx_max} (w={mw}), y={my_min}..{my_max} (h={mh})")
        
        qy_min, qx_min = q_pixels.min(axis=0)
        qy_max, qx_max = q_pixels.max(axis=0)
        qw, qh = qx_max - qx_min, qy_max - qy_min
        print(f"Question mark: x={qx_min}..{qx_max} (w={qw}), y={qy_min}..{qy_max} (h={qh})")
        
        # Calculate offsets
        # Gap between top of mascot and bottom of question mark
        gap_y = my_min - qy_max
        # How much is the question mark shifted to the right relative to the mascot center?
        mascot_cx = mx_min + mw / 2
        qmark_cx = qx_min + qw / 2
        offset_x = qmark_cx - mascot_cx
        
        print(f"\nQuestion Mark Position relative to Mascot:")
        print(f"  Vertical gap (y_mascot_top - y_qmark_bottom) = {gap_y} pixels")
        print(f"  Horizontal offset from mascot center (qmark_cx - mascot_cx) = {offset_x:.1f} pixels")
        print(f"  Mascot center X = {mascot_cx:.1f}")
        print(f"  Question mark center X = {qmark_cx:.1f}")
        # Ratios
        print(f"  Vertical gap to mascot height ratio = {gap_y / mh:.3f}")
        print(f"  Horizontal offset to mascot width ratio = {offset_x / mw:.3f}")
    else:
        print(f"Mascot found: {len(m_pixels) > 0}, Q-Mark found: {len(q_pixels) > 0}")
else:
    print("File not found")
