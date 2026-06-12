import os

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
target_color = "9C83C7" # Hex color of the square mascot body

found_files = []

for filename in os.listdir(assets_dir):
    if filename.endswith(".svg"):
        filepath = os.path.join(assets_dir, filename)
        try:
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
                if target_color.lower() in content.lower():
                    found_files.append(filename)
        except Exception as e:
            pass

print("Found SVGs containing square mascot body color:")
for f in found_files:
    print(f"- {f}")
