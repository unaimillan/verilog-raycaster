import ast
from pathlib import Path
import re


REGEX_PATTERN = re.compile(r'`to_fix\s?\((?<expression>.+?)\)')


def preprocess_line(line: str) -> str:
    result = []
    pos = 0
    for re_match in REGEX_PATTERN.finditer(line):
        match_begin, match_end = re_match.span(0)
        exp_begin, exp_end     = re_match.span(1)
        match_str = re_match.group(0)
        exp =  re_match.group(1)

        # TODO: use ast.parse with definitions of the constants like PI, WIDTH, etc.
        evaluated = ast.literal_eval(exp)
        hexed = f"'h{int(evaluated * 2**16):h}"

        result.append(match_str[:exp_begin])
        result.append(hexed)
        result.append(match_str[exp_end:match_end])
        pos = match_end
    
    result.append(line[pos:])
    return ''.join(result)


def preprocess_file(file_path: Path):
    file_lines = None
    with file_path.open() as file:
        file_lines = file.readlines()
    
    for i in range(len(file_lines)):
        file_lines[i] = preprocess_line(file_lines[i])
    
    with file_path.open('w') as file:
        file.writelines(file_lines)


def preprocess_dir(dir_path: Path):
    for file in dir_path.rglob('*.sv'):
        preprocess_file(file)


def main():
    pass


if __name__ == '__main__':
    main()
