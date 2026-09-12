import os
import sys

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Skip files we already manually processed
    if 'lib/theme/app_colors.dart' in filepath or 'lib/theme/app_theme.dart' in filepath or 'lib/screens/profile/profile_screen.dart' in filepath or 'lib/theme/app_text_styles.dart' in filepath:
        return

    if 'AppColors.' not in content:
        return
        
    print(f"Modifying {filepath}")

    # Add the import if not already present
    import_statement = "import 'package:flutter/material.dart';" # just in case
    # Actually we just need to ensure context is available. The extension is in app_colors.dart, which is already imported where AppColors is used.
    
    # Simple replacement
    new_content = content.replace('AppColors.', 'context.appColors.')
    
    with open(filepath, 'w') as f:
        f.write(new_content)

def find_and_process(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                process_file(os.path.join(root, file))

if __name__ == '__main__':
    find_and_process('lib')
