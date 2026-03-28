#!/usr/bin/env python3
"""Hoist non-entry-block allocas to the entry block.
Renumbers ALL instructions sequentially after hoisting."""
import re
import sys

def process_function(fn_text):
    lines = fn_text.split('\n')

    # Find entry block
    entry_idx = -1
    second_block_idx = -1
    for i, line in enumerate(lines):
        if re.match(r'bb\d+:', line):
            if entry_idx == -1:
                entry_idx = i
            elif second_block_idx == -1:
                second_block_idx = i
                break

    if entry_idx == -1 or second_block_idx == -1:
        return fn_text, 0

    # Count params (they take the first N numbers)
    param_count = 0
    m = re.match(r'define \S+ @\w+\((.*?)\)', lines[0])
    if m:
        params = m.group(1)
        if params.strip():
            param_count = params.count(',') + 1

    # Collect non-entry allocas
    hoists = []
    hoist_indices = set()
    for i in range(second_block_idx, len(lines)):
        if re.match(r'\s+%\d+ = alloca ', lines[i]):
            hoists.append(lines[i])
            hoist_indices.add(i)

    if not hoists:
        return fn_text, 0

    # Build new line order: remove hoisted allocas, insert at entry
    new_lines = []
    for i, line in enumerate(lines):
        if i in hoist_indices:
            continue
        new_lines.append(line)
        if i == entry_idx:
            new_lines.extend(hoists)

    # Renumber all %N registers sequentially
    # First pass: collect all old register numbers in order of definition
    old_to_new = {}
    next_num = param_count  # params take 0..param_count-1

    for line in new_lines:
        m = re.match(r'\s+%(\d+)\s*=', line)
        if m:
            old = m.group(1)
            if old not in old_to_new:
                old_to_new[old] = str(next_num)
                next_num += 1

    # Second pass: apply renumbering
    result = []
    for line in new_lines:
        fixed = line
        # Replace all %N occurrences with new numbers
        # Sort by descending length to avoid partial matches (%10 before %1)
        for old in sorted(old_to_new.keys(), key=lambda x: -len(x)):
            new = old_to_new[old]
            if old != new:
                fixed = re.sub(r'%' + old + r'\b', '%' + new, fixed)
        result.append(fixed)

    return '\n'.join(result), len(hoists)

def main():
    with open(sys.argv[1]) as f:
        text = f.read()

    parts = text.split('\ndefine ')
    result = [parts[0]]
    total = 0

    for part in parts[1:]:
        fn_text = 'define ' + part
        fixed, n = process_function(fn_text)
        total += n
        result.append(fixed[len('define '):])

    with open(sys.argv[2], 'w') as f:
        f.write('\ndefine '.join(result))

    print(f'Hoisted {total} allocas')

if __name__ == '__main__':
    main()
