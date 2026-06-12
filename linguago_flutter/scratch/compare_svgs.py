import os

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"

files = [
    "Frame 1000002826.svg",
    "Frame 1000002826-1.svg",
    "Frame 1000002826-2.svg",
    "Frame 1000002826-3.svg"
]

for name in files:
    path = os.path.join(assets_dir, name)
    if os.path.exists(path):
        print(f"--- File: {name} (size: {os.path.getsize(path)}) ---")
        with open(path, "r", encoding="utf-8") as f:
            lines = f.readlines()
            print("First 10 lines:")
            for line in lines[:10]:
                print(" ", line.strip())
            # Find elements like mouth or eyes or question mark by simple keyword
            content = "".join(lines)
            has_question = "?" in content or "question" in content.lower()
            print(f"Has question mark character or word: {has_question}")
            # Count paths, circles, rects
            paths = content.count("<path")
            circles = content.count("<circle")
            rects = content.count("<rect")
            print(f"Elements - paths: {paths}, circles: {circles}, rects: {rects}")
    else:
        print(f"File {name} does not exist!")
