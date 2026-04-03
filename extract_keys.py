#!/usr/bin/env python3
"""
Extract all untranslated keys and create comprehensive translation mapping
"""

import re
import sys

filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Find all (zh) placeholders and extract the English keys
pattern = r'"([^"]*)":\s*"([^"]*\s*\(zh\))"'
matches = re.findall(pattern, content)

unique_keys = {}
for english_key, placeholder in matches:
    if english_key not in unique_keys:
        unique_keys[english_key] = placeholder

print(f"Found {len(unique_keys)} unique untranslated keys:\n")
for key in sorted(unique_keys.keys()):
    # Try to generate a Chinese translation
    print(f'"{key}": "{key}",')
