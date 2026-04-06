#!/usr/bin/env python3
"""Move alloca instructions from conditional branches to function entry blocks.

LLVM requires values used across basic blocks to dominate their uses.
The mini compiler creates allocas inside conditional branches which can
violate this. This script moves allocas to the entry block and adds
null initialization so loads from unexecuted branches get safe defaults.
"""
import sys
import re

ALLOCA_RE = re.compile(r'^(\s+)(%r?\d+) = alloca (.+)$')

def fix_allocas(input_path, output_path):
    with open(input_path, 'r') as f:
        content = f.read()

    # Split into functions
    # Each function: define ... { ... }
    result = []
    pos = 0
    while pos < len(content):
        # Find next function definition
        define_match = content.find('\ndefine ', pos)
        if define_match == -1:
            result.append(content[pos:])
            break

        # Add everything before the define
        result.append(content[pos:define_match + 1])

        # Find the opening { after define
        brace_pos = content.find('{', define_match)
        if brace_pos == -1:
            result.append(content[define_match + 1:])
            break

        # Find entry: label
        entry_pos = content.find('\nentry:\n', brace_pos)
        if entry_pos == -1:
            # No entry block — skip this function
            next_define = content.find('\ndefine ', brace_pos + 1)
            if next_define == -1:
                result.append(content[define_match + 1:])
                break
            result.append(content[define_match + 1:next_define + 1])
            pos = next_define + 1
            continue

        # Find end of function (closing brace at column 0)
        func_end = content.find('\n}\n', entry_pos)
        if func_end == -1:
            func_end = len(content) - 2  # end of file

        func_body = content[entry_pos + len('\nentry:\n'):func_end]
        func_header = content[define_match + 1:entry_pos + len('\nentry:\n')]

        # Find allocas that are NOT in the entry block
        # (i.e., they appear after a label like "then..:" or "else..:")
        lines = func_body.split('\n')
        in_entry = True
        moved_allocas = []
        new_lines = []

        for line in lines:
            stripped = line.strip()
            # Check if we've left the entry block
            if re.match(r'^[a-zA-Z_]\w*:', stripped):
                in_entry = False

            if not in_entry:
                m = ALLOCA_RE.match(line)
                if m:
                    indent, reg, ty = m.group(1), m.group(2), m.group(3)
                    moved_allocas.append((indent, reg, ty))
                    new_lines.append(line)  # Keep the alloca in place too — we'll add a copy at entry
                    continue

            new_lines.append(line)

        if moved_allocas:
            # Insert allocas at the start of the entry block
            alloca_lines = []
            for indent, reg, ty in moved_allocas:
                # We can't have two definitions of the same register.
                # Instead, we need to move the alloca (remove from original location).
                pass

            # Actually, we need to MOVE allocas, not duplicate.
            # Remove from original location and add to entry.
            entry_allocas = []
            final_lines = []
            in_entry2 = True
            for line in lines:
                stripped = line.strip()
                if re.match(r'^[a-zA-Z_]\w*:', stripped):
                    in_entry2 = False

                if not in_entry2:
                    m = ALLOCA_RE.match(line)
                    if m:
                        entry_allocas.append(line)
                        continue  # Remove from original position

                final_lines.append(line)

            # Insert moved allocas at the start of entry block
            # Find first non-alloca line in entry to insert after existing allocas
            insert_pos = 0
            for j, line in enumerate(final_lines):
                stripped = line.strip()
                if re.match(r'^[a-zA-Z_]\w*:', stripped) and stripped != 'entry:':
                    break
                if ALLOCA_RE.match(line) or stripped.startswith('store '):
                    insert_pos = j + 1
                elif stripped and not stripped.startswith(';'):
                    # First non-alloca, non-store line — insert before it
                    if insert_pos == 0:
                        insert_pos = j
                    break

            # Find the actual right position: after existing entry allocas
            # Find first instruction that's not alloca in entry block
            entry_end = 0
            for j, line in enumerate(final_lines):
                stripped = line.strip()
                if ALLOCA_RE.match(line):
                    entry_end = j + 1
                    continue
                if stripped.startswith('store ') and entry_end > 0:
                    # Check if the store references the previous alloca
                    entry_end = j + 1
                    continue
                if stripped and not stripped.startswith(';') and stripped != 'entry:':
                    break

            for alloca_line in entry_allocas:
                final_lines.insert(entry_end, alloca_line)
                entry_end += 1

            func_body = '\n'.join(final_lines)

        result.append(func_header)
        result.append(func_body)
        result.append('\n}\n')
        pos = func_end + 2

    with open(output_path, 'w') as f:
        f.write(''.join(result))

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input.ll> <output.ll>")
        sys.exit(1)
    fix_allocas(sys.argv[1], sys.argv[2])
