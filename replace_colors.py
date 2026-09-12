import re
import sys

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Simple regex replacement for AppColors.someColor -> context.appColors.someColor
    # We must ensure we don't accidentally replace AppColors as a type in generics, though rarely used like that.
    # We'll just replace 'AppColors.' with 'context.appColors.'
    content = content.replace('AppColors.', 'context.appColors.')
    
    with open(filepath, 'w') as f:
        f.write(content)

if __name__ == '__main__':
    process_file(sys.argv[1])
