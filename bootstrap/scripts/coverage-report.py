#!/usr/bin/env python3
"""Coverage report generator — reads profdata + covmap JSON, produces terminal report + LCOV."""

import json, sys, subprocess, os

source_file = sys.argv[1]
profdata_file = sys.argv[2]
covmap_file = sys.argv[3]
lcov_out = sys.argv[4] if sys.argv[4] else None
llvm_prefix = sys.argv[5]

with open(source_file) as f:
    lines = f.readlines()

covmap = None
if os.path.exists(covmap_file):
    with open(covmap_file) as f:
        covmap = json.load(f)

# Parse profdata — map function name → counter array
result = subprocess.run(
    [f"{llvm_prefix}/bin/llvm-profdata", "show", "--all-functions", "--counts", profdata_file],
    capture_output=True, text=True
)

fn_counters = {}
current_fn = None
for line in result.stdout.split('\n'):
    line = line.strip()
    if line.endswith(':') and not line.startswith('Counters') and not line.startswith('Instrumentation') and not line.startswith('Total') and not line.startswith('Maximum'):
        current_fn = line[:-1]
    elif line.startswith('Block counts:') and current_fn:
        counts_str = line.split('[')[1].split(']')[0]
        fn_counters[current_fn] = [int(x.strip()) for x in counts_str.split(',')]
        current_fn = None

# Build coverage data from covmap
line_hits = {}
fn_entries = {}
branches = {}
conditions = {}

if covmap:
    for counter in covmap['counters']:
        cid = counter['id']
        fn = counter['fn']
        ctype = counter['type']
        cline = counter['line']
        branch_id = counter['branch']

        count = 0
        if fn in fn_counters and cid < len(fn_counters[fn]):
            count = fn_counters[fn][cid]

        if ctype == 'fn_entry':
            fn_entries[fn] = (cline, count)
        elif ctype == 'line':
            line_hits[cline] = line_hits.get(cline, 0) + count
        elif ctype == 'branch_then':
            key = (cline, branch_id)
            if key not in branches:
                branches[key] = {"then": 0, "else": 0}
            branches[key]["then"] = count
        elif ctype == 'branch_else':
            key = (cline, branch_id)
            if key not in branches:
                branches[key] = {"then": 0, "else": 0}
            branches[key]["else"] = count
        elif ctype == 'condition_true':
            key = (cline, branch_id)  # branch_id = decision_id
            if key not in conditions:
                conditions[key] = []
            conditions[key].append(("true", count))
        elif ctype == 'condition_false':
            key = (cline, branch_id)
            if key not in conditions:
                conditions[key] = []
            conditions[key].append(("false", count))
        elif ctype == 'match_arm':
            line_hits[cline] = line_hits.get(cline, 0) + count
else:
    for fn, counts in fn_counters.items():
        for idx, count in enumerate(counts):
            if count > 0:
                line_hits[idx] = line_hits.get(idx, 0) + count

# Terminal report
total_lines = 0
covered_lines = 0
for i, line_text in enumerate(lines, 1):
    stripped = line_text.strip()
    is_code = stripped and not stripped.startswith('//') and not stripped.startswith('///')

    count = line_hits.get(i, 0)

    if is_code:
        total_lines += 1
        if count > 0:
            covered_lines += 1
            print(f"\033[32m{count:5d}x\033[0m | {line_text.rstrip()}")
        else:
            print(f"\033[31m    \u2717 \033[0m | {line_text.rstrip()}")
    else:
        print(f"       | {line_text.rstrip()}")

total_branches = len(branches) * 2
taken_branches = sum(1 for b in branches.values() for v in [b["then"], b["else"]] if v > 0)
fn_total = len(fn_entries)
fn_hit = len([f for f, (l, c) in fn_entries.items() if c > 0])

print()
pct = (covered_lines * 100 // total_lines) if total_lines > 0 else 0
print(f"Line coverage:     {covered_lines}/{total_lines} ({pct}%)")
if total_branches > 0:
    bpct = (taken_branches * 100 // total_branches)
    print(f"Branch coverage:   {taken_branches}/{total_branches} ({bpct}%)")
if fn_total > 0:
    print(f"Function coverage: {fn_hit}/{fn_total} ({fn_hit * 100 // fn_total}%)")

# MC/DC condition coverage
if conditions:
    # Each decision has a list of (direction, count) pairs.
    # For MC/DC: each sub-condition must have both true and false exercised.
    # A condition pair is: one condition_true + one condition_false for the same decision.
    # MC/DC is satisfied when each condition independently affects the decision.
    total_conditions = 0
    covered_conditions = 0
    for (cline, decision_id), entries in sorted(conditions.items()):
        # Pair up: entries come in order [left_sc, left_eval, right_true, right_false]
        true_count = sum(c for d, c in entries if d == "true")
        false_count = sum(c for d, c in entries if d == "false")
        total_conditions += 1
        # A condition is MC/DC-covered if both true and false outcomes were observed
        if true_count > 0 and false_count > 0:
            covered_conditions += 1
    cpct = (covered_conditions * 100 // total_conditions) if total_conditions > 0 else 0
    print(f"MC/DC coverage:    {covered_conditions}/{total_conditions} conditions ({cpct}%)")

# LCOV output
if lcov_out:
    with open(lcov_out, 'w') as f:
        f.write("TN:\n")
        f.write(f"SF:{os.path.abspath(source_file)}\n")

        for fn, (fline, fcount) in sorted(fn_entries.items(), key=lambda x: x[1][0]):
            f.write(f"FN:{fline},{fn}\n")
        for fn, (fline, fcount) in sorted(fn_entries.items(), key=lambda x: x[1][0]):
            f.write(f"FNDA:{fcount},{fn}\n")
        f.write(f"FNF:{fn_total}\n")
        f.write(f"FNH:{fn_hit}\n")

        for i in range(1, len(lines) + 1):
            stripped = lines[i - 1].strip()
            if stripped and not stripped.startswith('//'):
                f.write(f"DA:{i},{line_hits.get(i, 0)}\n")
        f.write(f"LF:{total_lines}\n")
        f.write(f"LH:{covered_lines}\n")

        for (bline, branch_id), counts in sorted(branches.items()):
            f.write(f"BRDA:{bline},{branch_id},0,{counts['then']}\n")
            f.write(f"BRDA:{bline},{branch_id},1,{counts['else']}\n")
        f.write(f"BRF:{total_branches}\n")
        f.write(f"BRH:{taken_branches}\n")

        f.write("end_of_record\n")

    print(f"\nLCOV written to: {lcov_out}")
