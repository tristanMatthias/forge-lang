#!/usr/bin/env python3
"""Analyze compiler coverage from covmap + profdata dump.

Usage: compiler-coverage-report.py <covmap.json> <profdata_dump.txt> [lcov_output]
"""
import json, sys, os
from collections import defaultdict

covmap_path = sys.argv[1]
profdata_path = sys.argv[2]
lcov_out = sys.argv[3] if len(sys.argv) > 3 and sys.argv[3] else None

# Parse covmap
with open(covmap_path) as f:
    covmap = json.load(f)

# Parse profdata dump — map function name → counter array
lines = open(profdata_path).readlines()
fn = None
fn_counters = {}
for line in lines:
    line = line.strip()
    if (line.endswith(':') and not line.startswith('Counters')
            and not line.startswith('Instrumentation')
            and not line.startswith('Total')
            and not line.startswith('Maximum')):
        fn = line[:-1]
    elif line.startswith('Block counts:') and fn:
        counts_str = line.split('[')[1].split(']')[0]
        fn_counters[fn] = [int(x.strip()) for x in counts_str.split(',')]
        fn = None

# Build per-function stats
fn_stats = defaultdict(lambda: {
    "total_lines": set(), "hit_lines": set(),
    "fn_entry_count": 0,
    "total_branches": 0, "hit_branches": 0
})

for counter in covmap['counters']:
    cid = counter['id']
    fname = counter['fn']
    ctype = counter['type']
    cline = counter['line']
    count = 0
    if fname in fn_counters and cid < len(fn_counters[fname]):
        count = fn_counters[fname][cid]
    if ctype == 'fn_entry':
        fn_stats[fname]["fn_entry_count"] = count
    elif ctype == 'line' and cline > 0:
        fn_stats[fname]["total_lines"].add(cline)
        if count > 0:
            fn_stats[fname]["hit_lines"].add(cline)
    elif ctype in ('branch_then', 'branch_else'):
        fn_stats[fname]["total_branches"] += 1
        if count > 0:
            fn_stats[fname]["hit_branches"] += 1

# Collect results
results = []
for fname, stats in fn_stats.items():
    tl = len(stats["total_lines"])
    hl = len(stats["hit_lines"])
    pct = int(hl * 100 / tl) if tl > 0 else 100
    results.append((pct, hl, tl, stats["fn_entry_count"],
                    stats["total_branches"], stats["hit_branches"], fname))
results.sort()

tl_all = sum(r[2] for r in results)
hl_all = sum(r[1] for r in results)
opct = int(hl_all * 100 / tl_all) if tl_all > 0 else 0
tb = sum(r[4] for r in results)
hb = sum(r[5] for r in results)
bpct = int(hb * 100 / tb) if tb > 0 else 0
entered = sum(1 for r in results if r[3] > 0)

# Module grouping
mod_stats = defaultdict(lambda: {"total": 0, "hit": 0, "fns": 0, "entered": 0, "bt": 0, "bh": 0})
for pct, hl, tl, ec, bt, bh, fname in results:
    parts = fname.split('::')
    if fname.startswith('__lambda'):
        mod = 'lambdas'
    elif len(parts) >= 2:
        mod = '::'.join(parts[:-1])
    else:
        mod = 'top-level'
    mod_stats[mod]["total"] += tl
    mod_stats[mod]["hit"] += hl
    mod_stats[mod]["fns"] += 1
    mod_stats[mod]["bt"] += bt
    mod_stats[mod]["bh"] += bh
    if ec > 0:
        mod_stats[mod]["entered"] += 1

# Print report
W = 70
print("=" * W)
print("AVRA COMPILER SELF-COVERAGE")
print("=" * W)
print(f"Functions: {len(results)} total, {entered} entered")
print(f"Line coverage:   {hl_all}/{tl_all} ({opct}%)")
print(f"Branch coverage: {hb}/{tb} ({bpct}%)")
print()

# Color helpers
GREEN = '\033[32m'
YELLOW = '\033[33m'
RED = '\033[31m'
RESET = '\033[0m'

def color_pct(p):
    if p >= 80: return f"{GREEN}{p:3d}%{RESET}"
    if p >= 50: return f"{YELLOW}{p:3d}%{RESET}"
    return f"{RED}{p:3d}%{RESET}"

print(f"{'MODULE':<45} {'LINES':>10}  {'BRANCH':>10}  {'FNS':>7}")
print("-" * W)
for mod in sorted(mod_stats, key=lambda m: mod_stats[m]["hit"] * 100 // (mod_stats[m]["total"] or 1)):
    s = mod_stats[mod]
    lp = int(s["hit"] * 100 / s["total"]) if s["total"] > 0 else 0
    bp = int(s["bh"] * 100 / s["bt"]) if s["bt"] > 0 else -1
    lstr = f"{s['hit']}/{s['total']}"
    bstr = f"{s['bh']}/{s['bt']}" if s["bt"] > 0 else "n/a"
    fstr = f"{s['entered']}/{s['fns']}"
    # Use color for percentage
    lpct = color_pct(lp)
    bpct_s = color_pct(bp) if bp >= 0 else "    "
    print(f"{mod:<45} {lstr:>10} {lpct} {bstr:>7} {bpct_s}  {fstr:>7}")

# Uncovered functions
uncov = [(p, h, t, e, bt, bh, f) for p, h, t, e, bt, bh, f in results if e == 0 and t >= 5]
if uncov:
    print(f"\nNEVER-ENTERED FUNCTIONS (>= 5 lines): {len(uncov)}")
    print("-" * W)
    for _, _, t, _, _, _, fname in uncov[:20]:
        print(f"  {t:3d} lines  {fname}")
    if len(uncov) > 20:
        print(f"  ... and {len(uncov) - 20} more")

# Low coverage entered functions
low = [(p, h, t, e, bt, bh, f) for p, h, t, e, bt, bh, f in results if e > 0 and p < 50 and t >= 5]
if low:
    print(f"\nENTERED BUT <50% COVERAGE ({len(low)} functions)")
    print("-" * W)
    for p, h, t, e, _, _, fname in low[:15]:
        print(f"  {color_pct(p)} ({h:3d}/{t:3d})  calls={e:6d}  {fname}")

# LCOV output
if lcov_out:
    source_file = covmap['file']
    with open(lcov_out, 'w') as f:
        f.write("TN:\n")
        f.write(f"SF:{os.path.abspath(source_file)}\n")
        # Function data
        fn_list = [(fname, stats["fn_entry_count"])
                   for fname, stats in fn_stats.items()]
        fn_list.sort(key=lambda x: x[0])
        for fname, _ in fn_list:
            f.write(f"FN:0,{fname}\n")
        for fname, ec in fn_list:
            f.write(f"FNDA:{ec},{fname}\n")
        f.write(f"FNF:{len(fn_list)}\n")
        f.write(f"FNH:{entered}\n")
        # Line data
        all_lines = {}
        for fname, stats in fn_stats.items():
            for ln in stats["total_lines"]:
                hit = 1 if ln in stats["hit_lines"] else 0
                all_lines[ln] = all_lines.get(ln, 0) + hit
        for ln in sorted(all_lines):
            f.write(f"DA:{ln},{all_lines[ln]}\n")
        f.write(f"LF:{tl_all}\n")
        f.write(f"LH:{hl_all}\n")
        f.write("end_of_record\n")
    print(f"\nLCOV written to: {lcov_out}")

print()
