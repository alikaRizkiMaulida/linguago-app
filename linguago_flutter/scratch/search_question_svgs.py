import os
import re

assets_dir = r"C:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets"
question_files = []

for filename in os.listdir(assets_dir):
    if filename.endswith(".svg"):
        filepath = os.path.join(assets_dir, filename)
        try:
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
                # Check for question mark character, or coordinates/tags related to a question mark
                if "?" in content or "question" in filename.lower() or "tanya" in filename.lower():
                    question_files.append(filename)
        except Exception as e:
            pass

print(f"Found {len(question_files)} SVGs with question mark/tanya:")
for f in question_files:
    print(f"- {f}")
