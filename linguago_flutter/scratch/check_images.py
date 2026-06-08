import re

images = [
    "assets/image 427.svg",
    "assets/image 428.svg",
    "assets/image 429.svg"
]

for img in images:
    try:
        with open(img, "r", encoding="utf-8") as f:
            content = f.read()
            print(f"--- File: {img} ---")
            print("  Length:", len(content))
            # Look for specific text, or base64 images
            embedded = re.findall(r'<image[^>]+>', content)
            print(f"  Embedded images: {len(embedded)}")
            if embedded:
                print("  First tag starts with:", embedded[0][:120])
    except Exception as e:
        print(f"Error {img}: {e}")
