import re

file_path = r"c:\Users\Naimah\FINAL PROJECT 2\linguago-app\linguago_flutter\assets\onboarding 2.svg"

with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

# Find all text elements or content inside <text> tags
texts = re.findall(r'<text[^>]*>(.*?)</text>', content)
print(f"Found {len(texts)} text elements:")
for t in texts[:20]:
    clean_text = re.sub(r'<[^>]+>', '', t).strip()
    if clean_text:
        print("-", clean_text)
