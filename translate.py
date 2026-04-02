import os
import re
import json

def process_file(filepath, strings_dict):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex patterns
    patterns = [
        # (pattern, replacement format, capture group index for string)
        (r'Text\(\s*["\']([^"\'\\]+)["\']', r'Text("\1".tr', 1),
        (r'hintText:\s*["\']([^"\'\\]+)["\']', r'hintText: "\1".tr', 1),
        (r'labelText:\s*["\']([^"\'\\]+)["\']', r'labelText: "\1".tr', 1),
        (r'CommonMethod\.getXSnackBar\(\s*["\']([^"\'\\]+)["\']\s*,\s*["\']([^"\'\\]+)["\']', 
            r'CommonMethod.getXSnackBar("\1".tr, "\2".tr', None),  # Two groups handled differently
        (r'title:\s*["\']([^"\'\\]+)["\']', r'title: "\1".tr', 1),
        (r'label:\s*["\']([^"\'\\]+)["\']', r'label: "\1".tr', 1),
        (r'PrimaryTextButton\(\s*title:\s*["\']([^"\'\\]+)["\']', r'PrimaryTextButton(title: "\1".tr', 1),
        (r'ActionTextButton\(\s*title:\s*["\']([^"\'\\]+)["\']', r'ActionTextButton(title: "\1".tr', 1),
        (r'CancelTextButton\(\s*title:\s*["\']([^"\'\\]+)["\']', r'CancelTextButton(title: "\1".tr', 1),
    ]

    new_content = content
    modified = False

    # Extract two strings from getXSnackBar
    snack_pattern = re.compile(r'CommonMethod\.getXSnackBar\(\s*["\']([^"\'\\]+)["\']\s*,\s*["\']([^"\'\\]+)["\']')
    for match in snack_pattern.finditer(new_content):
        s1 = match.group(1)
        s2 = match.group(2)
        strings_dict[s1] = s1
        strings_dict[s2] = s2
        
    new_content = snack_pattern.sub(r'CommonMethod.getXSnackBar("\1".tr, "\2".tr', new_content)

    for p, repl, grp_idx in patterns:
        if grp_idx is None:
            continue
        regex = re.compile(p)
        for match in regex.finditer(new_content):
            s = match.group(grp_idx)
            strings_dict[s] = s
        new_content = regex.sub(repl, new_content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")
        
def generate_translation_file(strings_dict):
    output_path = r'b:\moremito_mobile_app\lib\utils\app_translations.dart'
    
    # We will just duplicate the english string for Chinese as a placeholder for the user to translate
    
    keys_str = ""
    for k in strings_dict.keys():
        safe_k = k.replace('"', '\\"').replace('$', '\\$').replace('\n', '\\n')
        keys_str += f'        "{safe_k}": "{safe_k}",\n'
        
    zh_keys_str = ""
    for k in strings_dict.keys():
        safe_k = k.replace('"', '\\"').replace('$', '\\$').replace('\n', '\\n')
        zh_keys_str += f'        "{safe_k}": "{safe_k} (zh)",\n'

    content = f"""import 'package:get/get.dart';

class AppTranslations extends Translations {{
  @override
  Map<String, Map<String, String>> get keys => {{
        'en_US': {{
{keys_str}
        }},
        'zh_CN': {{
{zh_keys_str}
        }},
      }};
}}
"""
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
    print(f"Generated {output_path} with {len(strings_dict)} translations.")

def main():
    directory = r'b:\moremito_mobile_app\lib'
    strings_dict = {}
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart') and file != 'app_translations.dart':
                filepath = os.path.join(root, file)
                process_file(filepath, strings_dict)

    generate_translation_file(strings_dict)

if __name__ == '__main__':
    main()
