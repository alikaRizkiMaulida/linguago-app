import difflib
import os

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"

def diff_files(file1, file2):
    p1 = os.path.join(assets_dir, file1)
    p2 = os.path.join(assets_dir, file2)
    with open(p1, "r", encoding="utf-8") as f1, open(p2, "r", encoding="utf-8") as f2:
        l1 = f1.readlines()
        l2 = f2.readlines()
    
    diff = list(difflib.unified_diff(l1, l2, fromfile=file1, tofile=file2))
    print(f"\n--- Diff between {file1} and {file2} (showing first 30 diff lines) ---")
    for line in diff[:30]:
        print(line.strip())

diff_files("Frame 1000002826.svg", "Frame 1000002826-1.svg")
diff_files("Frame 1000002826-2.svg", "Frame 1000002826-3.svg")
