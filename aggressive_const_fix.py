import re
import subprocess

def fix_all_consts():
    # Get all files with errors
    result = subprocess.run(['flutter', 'analyze'], capture_output=True, text=True)
    files_with_errors = set()
    for line in result.stdout.split('\n') + result.stderr.split('\n'):
        if 'invalid_constant' in line:
            parts = line.split(' • ')
            if len(parts) >= 3:
                location = parts[2].strip()
                file_path = location.split(':')[0]
                files_with_errors.add(file_path)
    
    # Aggressively remove 'const ' from these files
    widgets = ['Row', 'Column', 'Expanded', 'StatCard', 'Icon', 'Padding', 'Container', 'SizedBox', 'LinearGradient', 'BoxShadow', 'Text', 'Center', 'Align', 'Positioned', 'Card', 'ViolationCard', 'InspectionCard', 'PrimaryButton', 'SecondaryButton', 'FloatingScanButton', 'Divider']
    
    # Create regex for `const WidgetName(`
    pattern = re.compile(r'const\s+(' + '|'.join(widgets) + r')\s*\(')
    # Also handle `const [` or `const <Widget>[`
    pattern2 = re.compile(r'const\s*(\<[a-zA-Z0-9_]+\>)?\s*\[')

    for file_path in files_with_errors:
        try:
            with open(file_path, 'r') as f:
                content = f.read()
            
            new_content = pattern.sub(r'\1(', content)
            new_content = pattern2.sub(r'[', new_content)
            
            # Special case for scanner_screen line 435 where markerColor was messed up
            if 'scanner_screen.dart' in file_path:
                new_content = new_content.replace('markerColor = context.appColors.accentBlueGlow;', 'final markerColor = context.appColors.accentBlueGlow;')
            
            with open(file_path, 'w') as f:
                f.write(new_content)
            print(f"Aggressively removed consts in {file_path}")
        except Exception as e:
            print(f"Failed {file_path}: {e}")

if __name__ == '__main__':
    fix_all_consts()
