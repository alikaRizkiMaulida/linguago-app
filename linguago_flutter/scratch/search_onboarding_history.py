import json
import os

log_path = r"C:\Users\Naimah\.gemini\antigravity\brain\4f215eba-2447-44ee-b8d7-acac09ff53a1\.system_generated\logs\transcript.jsonl"

if not os.path.exists(log_path):
    print("Log file not found!")
    exit(1)

with open(log_path, 'r', encoding='utf-8') as f:
    for line in f:
        try:
            step = json.loads(line)
            content = step.get('content', '')
            if 'Welcome To' in content or 'onboarding' in content.lower() or 'onboarding_page' in content.lower():
                # print some context
                for term in ["Welcome To", "subtitle", "subtitle:", "OnboardingData"]:
                    if term in content:
                        print(f"Match found in step {step.get('step_index')}:")
                        lines = content.split('\n')
                        for l in lines:
                            if any(x in l for x in ["Welcome To", "subtitle", "OnboardingData", "title", "Explore", "Complete"]):
                                print("  ", l.strip())
                        print("-" * 40)
                        break
        except Exception as e:
            pass
