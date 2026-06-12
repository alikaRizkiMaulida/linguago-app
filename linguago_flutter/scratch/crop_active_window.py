import cv2
import numpy as np
import os

frames_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\scratch\frames_new"

# Read frame_22.0s.png to find the active region
filepath = os.path.join(frames_dir, "frame_22.0s.png")
if not os.path.exists(filepath):
    print("frame_22.0s.png not found")
else:
    img = cv2.imread(filepath)
    h, w, c = img.shape
    
    # Background of desktop seems to be #19181B (dark)
    # Let's find pixels that are significantly different from #19181B (e.g. brighter or lighter)
    bg_color = np.array([27, 24, 25]) # BGR for #19181B
    diff = np.linalg.norm(img - bg_color, axis=2)
    active_pixels = np.argwhere(diff > 50)
    
    if len(active_pixels) > 0:
        min_y, min_x = active_pixels.min(axis=0)
        max_y, max_x = active_pixels.max(axis=0)
        print(f"Active window region: x={min_x}, y={min_y}, w={max_x - min_x}, h={max_y - min_y}")
        
        # Crop this region for a few frames and analyze what is inside them
        # Let's print out what elements are found in this cropped region for:
        # frame_8.5s.png, frame_13.0s.png, frame_22.0s.png, frame_45.0s.png
        frames = ["frame_8.5s.png", "frame_13.0s.png", "frame_22.0s.png", "frame_45.0s.png"]
        for name in frames:
            fpath = os.path.join(frames_dir, name)
            if os.path.exists(fpath):
                fimg = cv2.imread(fpath)
                crop = fimg[min_y:max_y, min_x:max_x]
                ch, cw, cc = crop.shape
                # Let's inspect colors at key regions of this cropped window
                print(f"\nCropped {name} ({cw}x{ch}):")
                # Look for the mascot (#9C83C7) inside the cropped window
                mascot_color = np.array([199, 131, 156]) # BGR
                diff_m = np.linalg.norm(crop - mascot_color, axis=2)
                m_pixels = np.argwhere(diff_m < 15)
                if len(m_pixels) > 0:
                    my_min, mx_min = m_pixels.min(axis=0)
                    my_max, mx_max = m_pixels.max(axis=0)
                    print(f"  Mascot relative: x={mx_min}, y={my_min}, w={mx_max - mx_min}, h={my_max - my_min}")
                else:
                    print("  Mascot relative: Not found")
                    
                # Look for question mark (#5D3C98)
                qmark_color = np.array([152, 60, 93]) # BGR
                diff_q = np.linalg.norm(crop - qmark_color, axis=2)
                q_pixels = np.argwhere(diff_q < 20)
                if len(q_pixels) > 0:
                    qy_min, qx_min = q_pixels.min(axis=0)
                    qy_max, qx_max = q_pixels.max(axis=0)
                    print(f"  Question Mark relative: x={qx_min}, y={qy_min}, w={qy_max - qy_min}, h={qy_max - qy_min}")
                else:
                    print("  Question Mark relative: Not found")
                    
                # Look for logo text (#1C1135)
                text_color = np.array([53, 17, 28]) # BGR
                diff_t = np.linalg.norm(crop - text_color, axis=2)
                t_pixels = np.argwhere(diff_t < 15)
                if len(t_pixels) > 0:
                    ty_min, tx_min = t_pixels.min(axis=0)
                    ty_max, tx_max = t_pixels.max(axis=0)
                    print(f"  Text relative: x={tx_min}, y={ty_min}, w={tx_max - tx_min}, h={ty_max - ty_min}")
                else:
                    print("  Text relative: Not found")
    else:
        print("No active region found")
