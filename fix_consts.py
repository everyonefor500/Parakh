import re

def fix_const_errors(analyze_file):
    with open(analyze_file, 'r') as f:
        lines = f.readlines()
    
    file_fixes = {}
    for line in lines:
        if 'invalid_constant' in line or 'const_initialized_with_non_constant_value' in line:
            parts = line.split(' • ')
            if len(parts) >= 3:
                location = parts[2].strip()
                file_path, line_num, _ = location.split(':')
                line_num = int(line_num)
                if file_path not in file_fixes:
                    file_fixes[file_path] = set()
                file_fixes[file_path].add(line_num)
    
    for file_path, line_nums in file_fixes.items():
        try:
            with open(file_path, 'r') as f:
                content = f.readlines()
            
            for line_num in line_nums:
                idx = line_num - 1
                if 0 <= idx < len(content):
                    content[idx] = content[idx].replace('const ', '').replace('const\n', '\n')
            
            with open(file_path, 'w') as f:
                f.writelines(content)
            print(f"Fixed const errors in {file_path}")
        except Exception as e:
            print(f"Failed to fix {file_path}: {e}")

if __name__ == '__main__':
    fix_const_errors('analyze_output.txt')
