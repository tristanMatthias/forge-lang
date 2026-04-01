#!/usr/bin/env python3
"""Comprehensive Stage 2 IR analysis — replaces audit_stage2.sh with root cause analysis.

Usage: python3 scripts/verify_ir.py [path/to/output.ll]

Categorizes ALL semantic issues and groups by root cause so you can fix
entire categories at once instead of chasing individual symptoms.
"""
import re
import sys
from collections import Counter, defaultdict

def parse_arg_types(args_text):
    """Extract top-level argument types from a call's argument list."""
    types = []; depth = 0; i = 0
    while i < len(args_text):
        c = args_text[i]
        if c == '{': depth += 1
        elif c == '}': depth -= 1
        elif depth == 0 and c == ',': i += 1; continue
        if depth == 0:
            rest = args_text[i:]
            m = re.match(r'(%[A-Z]\w*|\{ [^}]+ \}|ptr|i64|i32|i8|i1|double)\s', rest)
            if m:
                types.append(m.group(1))
                while i < len(args_text) and args_text[i] != ',':
                    if args_text[i] == '{':
                        d = 1; i += 1
                        while i < len(args_text) and d > 0:
                            if args_text[i] == '{': d += 1
                            elif args_text[i] == '}': d -= 1
                            i += 1
                        continue
                    i += 1
                continue
        i += 1
    return types

def analyze(ir_path):
    with open(ir_path) as f:
        text = f.read()
    lines = text.split('\n')

    # ── Phase 1: Build indexes ──
    # Function declarations with parameter types
    fn_params = {}
    fn_ret_types = {}
    for line in lines:
        m = re.match(r'define (\S+) @(\w+)\(([^)]*)\)', line)
        if m:
            ret_ty = m.group(1)
            name = m.group(2)
            params = m.group(3)
            types = re.findall(r'(%[A-Z]\w*|\{ [^}]+ \}|ptr|i64|i32|i8|i1|double|void)', params)
            fn_params[name] = types
            fn_ret_types[name] = ret_ty

    BIG5 = {'%Statement', '%Expr', '%Token', '%Type', '%ForgeString'}

    # ── Phase 2: Scan for issues ──
    issues = []
    current_fn = ""

    for i, line in enumerate(lines):
        # Track function context
        m = re.match(r'define \S+ @(\w+)\(', line)
        if m: current_fn = m.group(1)

        # 1. br i1 false — dead branches
        if re.match(r'\s+br i1 false', line):
            issues.append(('br_i1_false', current_fn, 'constant false branch condition'))

        # 2. ret undef
        if re.match(r'\s+ret \S+ undef', line):
            issues.append(('ret_undef', current_fn, 'returns undef'))

        # 3. null operands
        if '<null operand!>' in line:
            issues.append(('null_operand', current_fn, 'null operand in IR'))

        # 4. call_type_mismatch — i64 arg where struct expected
        if 'call ' in line:
            cm = re.search(r'@(\w+)\(([^)]*)\)', line)
            if cm and cm.group(1) in fn_params:
                declared = fn_params[cm.group(1)]
                actual = parse_arg_types(cm.group(2))
                for j, (a, d) in enumerate(zip(actual, declared)):
                    if a != d:
                        if a == 'i64' and d in BIG5:
                            issues.append(('struct_as_i64', current_fn,
                                f'call @{cm.group(1)} arg {j}: i64 → {d}'))
                        elif a != d:
                            issues.append(('call_type_mismatch', current_fn,
                                f'call @{cm.group(1)} arg {j}: {a} → {d}'))

    # ── Phase 3: Categorize and Report ──
    categories = Counter()
    by_cat = defaultdict(list)
    by_fn = defaultdict(lambda: Counter())

    for cat, fn, detail in issues:
        categories[cat] += 1
        by_cat[cat].append((fn, detail))
        by_fn[fn][cat] += 1

    weights = {'struct_as_i64': 5, 'call_type_mismatch': 1, 'br_i1_false': 3,
               'load_type_mismatch': 1, 'null_operand': 10, 'ret_undef': 0}
    score = sum(categories[c] * weights.get(c, 1) for c in categories)

    print(f"=== IR Verification Report ===")
    print(f"Total issues: {sum(categories.values())}")
    print(f"Score: {score}")
    print(f"Functions: {len(fn_params)}")
    print()

    for cat, count in categories.most_common():
        w = weights.get(cat, 1)
        print(f"  {cat:25s}  {count:4d}  (×{w} = {count*w:5d})")
    print()

    # ── Root Cause: struct_as_i64 — which structs are passed as i64? ──
    if 'struct_as_i64' in by_cat:
        print("── struct_as_i64: Which struct types? ──")
        struct_counts = Counter()
        callee_counts = Counter()
        for fn, detail in by_cat['struct_as_i64']:
            m = re.search(r'→ (%\w+)', detail)
            if m: struct_counts[m.group(1)] += 1
            m2 = re.search(r'@(\w+)', detail)
            if m2: callee_counts[m2.group(1)] += 1
        for ty, c in struct_counts.most_common():
            print(f"  {c:4d}×  i64 passed where {ty} expected")
        print()
        print("  Top callee functions:")
        for fn, c in callee_counts.most_common(10):
            print(f"  {c:4d}×  @{fn}")
        print()

    # ── Root Cause: call_type_mismatch — which type pairs? ──
    if 'call_type_mismatch' in by_cat:
        print("── call_type_mismatch: Which type conversions? ──")
        pair_counts = Counter()
        for fn, detail in by_cat['call_type_mismatch']:
            m = re.search(r'(\S+) → (\S+)', detail)
            if m: pair_counts[f"{m.group(1)} → {m.group(2)}"] += 1
        for pair, c in pair_counts.most_common(10):
            print(f"  {c:4d}×  {pair}")
        print()

    # ── Root Cause: br_i1_false — which functions have dead branches? ──
    if 'br_i1_false' in by_cat:
        print("── br_i1_false: Which functions? ──")
        fn_br = Counter()
        for fn, detail in by_cat['br_i1_false']:
            fn_br[fn] += 1
        for fn, c in fn_br.most_common(10):
            print(f"  {c:4d}×  @{fn}")
        print()

    # ── Worst Functions ──
    print("── Worst Functions (by weighted score) ──")
    fn_scores = {}
    for fn, cats in by_fn.items():
        fn_scores[fn] = sum(cats[c] * weights.get(c, 1) for c in cats)
    for fn, sc in sorted(fn_scores.items(), key=lambda x: -x[1])[:15]:
        cats = by_fn[fn]
        cats_str = ', '.join(f"{c}:{n}" for c, n in cats.most_common(3))
        print(f"  {sc:4d}  {fn:50s}  {cats_str}")

if __name__ == '__main__':
    ir_path = sys.argv[1] if len(sys.argv) > 1 else "output.ll"
    analyze(ir_path)
