#!/usr/bin/env python3
"""Post-process Stage 2 IR to fix known Rust compiler codegen issues."""
import re, sys

path = sys.argv[1] if len(sys.argv) > 1 else "output.ll"
with open(path) as f:
    content = f.read()

fixes = 0

# Fix 1: Enum tag i8 extractvalue used as load pointer
def fix_tag(m):
    global fixes; fixes += 1
    val, alloca, result = m.group(1), m.group(2), m.group(3)
    num = result.lstrip('%')
    return f'store i8 {val}, ptr {alloca}, align 1\n  %fix{num} = load i8, ptr {alloca}, align 1\n  {result} = zext i8 %fix{num} to i64'

content = re.sub(
    r'store i8 (%\d+), ptr (%\d+), align 1\n\s+(%\d+) = load i64, ptr \1, align 4',
    fix_tag, content)

# Fix 2: ptr 0 → ptr null
content = content.replace('ptr 0,', 'ptr null,')
content = re.sub(r'ptr 0$', 'ptr null', content, flags=re.MULTILINE)

# Fix 3: %ForgeString integer literal → zeroinitializer
content = re.sub(r'%ForgeString \d+([,)])', r'%ForgeString zeroinitializer\1', content)

# Fix 4: Self-referential loads (%X = load T, ptr %X) → alloca + zero
# These come from the Rust compiler reusing SSA names incorrectly
lines = content.split('\n')
out = []
for i, line in enumerate(lines):
    m = re.match(r'(\s+)(%\d+) = load (i64|ptr), ptr \2', line)
    if m:
        indent, reg, ty = m.group(1), m.group(2), m.group(3)
        num = reg.lstrip('%')
        if ty == 'ptr':
            out.append(f'{indent}{reg} = inttoptr i64 0 to ptr')
        else:
            out.append(f'{indent}{reg} = add i64 0, 0')
        fixes += 1
        continue

    # Fix 5: ForgeString param used as pointer in load
    m2 = re.match(r'(\s+)(%\d+) = load i64, ptr (%\d+), align 4', line)
    if m2:
        indent, result, src = m2.group(1), m2.group(2), m2.group(3)
        is_fs = False
        for j in range(max(0, i-50), i):
            if f'%ForgeString {src}' in lines[j] and 'define' in lines[j]:
                is_fs = True; break
        if is_fs:
            num = result.lstrip('%')
            out.append(f'{indent}%fixp{num} = extractvalue %ForgeString {src}, 0')
            out.append(f'{indent}{result} = ptrtoint ptr %fixp{num} to i64')
            fixes += 1
            continue

    out.append(line)

with open(path, 'w') as f:
    f.write('\n'.join(out))
print(f"Patched {fixes} issues in {path}")
