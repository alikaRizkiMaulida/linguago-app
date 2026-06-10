import os

svg_files = [
    "assets/image 395.svg",
    "assets/image 396.svg",
    "assets/image 397.svg",
    "assets/Frame 1000002501.svg",
    "assets/image 399.svg",
    "assets/image 400.svg",
    "assets/image 401.svg",
    "assets/image 402.svg"
]

for file_path in svg_files:
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
    
    print(f"\n=== File: {file_path} ===")
    with open(file_path, 'r', encoding='utf-8') as f:
        for i in range(40):
            line = f.readline()
            if not line:
                break
            # Print if it doesn't contain a huge base64 string
            if "data:image" in line:
                print(line[:100] + "... [BASE64 DATA] ...")
            else:
                print(line.strip())
