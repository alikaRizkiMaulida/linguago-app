import os

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
target_paths = [
    "M3.48026 10.1938", # Letter L
    "M30.6254 20.2863", # Letter i
    "M39.6741 23.4185", # Letter n
    "M94.3127 20.2863", # Letter u
]

found_files = {}

for filename in os.listdir(assets_dir):
    if filename.endswith(".svg"):
        filepath = os.path.join(assets_dir, filename)
        try:
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
                matches = []
                for p in target_paths:
                    if p in content:
                        matches.append(p)
                if matches:
                    found_files[filename] = matches
        except Exception as e:
            pass

print("Found matching SVGs:")
for k, v in found_files.items():
    print(f"- {k}: matched {len(v)} target paths {v}")
