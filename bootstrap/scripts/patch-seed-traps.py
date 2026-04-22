#!/usr/bin/env python3
"""Patch seed.ll to convert all match trap blocks to safe fallthrough.

When adding new enum variants, the seed's exhaustive matches crash on
unknown tags. This script patches all forge_match_unreachable calls
to return a safe default value instead of calling unreachable.

Usage: python3 scripts/patch-seed-traps.py
"""
import re, sys

with open('seed/seed.ll', 'r') as f:
    content = f.read()

count = 0
def replace_trap(m):
    global count
    count += 1
    pos = m.start()
    func_start = content.rfind('define ', 0, pos)
    func_end = content.find('\n}\n', pos)
    if func_end == -1: func_end = len(content)
    func_text = content[func_start:func_end]
    if '%match_result' in func_text and ('match_end:' in func_text or 'match_end ' in func_text):
        return "store i64 0, ptr %match_result, align 8\n  br label %match_end"
    if 'ret void' in func_text: return "ret void"
    if 'ret ptr' in func_text: return "ret ptr null"
    if 'ret i64' in func_text: return "ret i64 0"
    if 'ret i1' in func_text: return "ret i1 0"
    return "ret void"

content = re.sub(r'call void @forge_match_unreachable\([^)]+\)\n\s+unreachable', replace_trap, content)
with open('seed/seed.ll', 'w') as f:
    f.write(content)
print(f"Patched {count} match traps in seed.ll")
