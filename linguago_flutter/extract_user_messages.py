import json

log_path = r"C:\Users\Naimah\.gemini\antigravity\brain\e5951c8a-74fe-432b-9a8f-5a311bf68bae\.system_generated\logs\transcript.jsonl"
out_path = r"C:\Users\Naimah\.gemini\antigravity\brain\e5951c8a-74fe-432b-9a8f-5a311bf68bae\scratch\all_user_messages.txt"

with open(log_path, 'r', encoding='utf-8') as f, open(out_path, 'w', encoding='utf-8') as out:
    for idx, line in enumerate(f):
        try:
            step = json.loads(line)
            source = step.get('source')
            type_ = step.get('type')
            content = step.get('content')
            if type_ == 'USER_INPUT' or source == 'USER_EXPLICIT':
                out.write(f"=== STEP {idx} ===\n")
                out.write(f"[{source}/{type_}]: {content}\n")
                out.write("-" * 50 + "\n")
        except Exception as e:
            pass
print("Done writing to all_user_messages.txt")
