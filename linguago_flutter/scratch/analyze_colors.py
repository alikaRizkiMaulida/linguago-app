import cv2
import numpy as np
import os

extracted_files = [
    "extracted_image 395_0.png",
    "extracted_image 396_0.png",
    "extracted_image 397_0.png",
    "extracted_Frame 1000002501_0.png",
    "extracted_image 399_0.png",
    "extracted_image 400_0.png",
    "extracted_image 401_0.png",
    "extracted_image 402_0.png"
]

base_dir = r"C:\Users\Naimah\.gemini\antigravity\brain\03fa8582-5f45-45b2-a604-59620827979f"

for filename in extracted_files:
    path = os.path.join(base_dir, filename)
    if not os.path.exists(path):
        print(f"File not found: {path}")
        continue
        
    img = cv2.imread(path)
    if img is None:
        print(f"Failed to load image: {path}")
        continue
        
    h, w, c = img.shape
    print(f"\n=== Image: {filename} ({w}x{h}) ===")
    
    # Calculate dominant colors (ignoring white/transparent background)
    # Convert to HSV for better color analysis
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    
    # Flatten the image pixels
    pixels = hsv.reshape(-1, 3)
    
    # Filter out very bright (white/background) or very dark pixels
    # White background usually has high value (V > 240) and low saturation (S < 15)
    non_bg_pixels = pixels[(pixels[:, 2] < 245) & (pixels[:, 1] > 10)]
    
    if len(non_bg_pixels) == 0:
        print("Mostly background or grayscale.")
        continue
        
    # Find dominant colors using k-means clustering
    n_colors = 3
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 1.0)
    flags = cv2.KMEANS_RANDOM_CENTERS
    
    # Convert to float for kmeans
    non_bg_pixels = np.float32(non_bg_pixels)
    compactness, labels, centers = cv2.kmeans(non_bg_pixels, n_colors, None, criteria, 10, flags)
    
    # Convert centers back to uint8
    centers = np.uint8(centers)
    
    # Count frequency of each cluster
    counts = np.bincount(labels.flatten())
    total = sum(counts)
    
    # Print the dominant colors in HSV and BGR
    for idx in np.argsort(counts)[::-1]:
        cnt = counts[idx]
        pct = (cnt / total) * 100
        center_hsv = centers[idx]
        
        # Convert HSV back to BGR/RGB to print readable color names
        h_val, s_val, v_val = center_hsv
        
        color_name = "Unknown"
        if v_val < 30:
            color_name = "Black/Dark"
        elif s_val < 20:
            color_name = "Gray/White"
        else:
            # HSV mapping
            if h_val < 10 or h_val > 170:
                color_name = "Red/Orange"
            elif h_val < 25:
                color_name = "Orange/Brown/Skin"
            elif h_val < 35:
                color_name = "Yellow"
            elif h_val < 85:
                color_name = "Green"
            elif h_val < 130:
                color_name = "Blue"
            elif h_val < 170:
                color_name = "Purple/Pink"
                
        print(f"  Color: {color_name} (H:{h_val}, S:{s_val}, V:{v_val}) - {pct:.1f}%")
