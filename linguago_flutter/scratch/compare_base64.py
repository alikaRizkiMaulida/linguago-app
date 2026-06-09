import re

images = [
    "assets/image 427.svg",
    "assets/image 428.svg",
    "assets/image 429.svg"
]

data = {}
for img in images:
    try:
        with open(img, "r", encoding="utf-8") as f:
            content = f.read()
            match = re.search(r'xlink:href="data:image/png;base64,([^"]+)"', content)
            if match:
                data[img] = match.group(1)
                print(f"{img}: base64 length = {len(data[img])}, prefix = {data[img][:50]}")
            else:
                print(f"{img}: No base64 found!")
    except Exception as e:
        print(f"Error {img}: {e}")

# Compare base64 hashes or prefix/suffix
if len(data) == 3:
    print("Compare 427 and 428:", data["assets/image 427.svg"][:1000] == data["assets/image 428.svg"][:1000])
    print("Compare 427 and 429:", data["assets/image 427.svg"][:1000] == data["assets/image 429.svg"][:1000])
    print("Compare 428 and 429:", data["assets/image 428.svg"][:1000] == data["assets/image 429.svg"][:1000])
