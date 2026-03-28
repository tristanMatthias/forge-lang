#!/usr/bin/env python3
"""Fix forward-reference and bad-type loads in Stage 2 LLVM IR.

Strategy: When a load/store uses "ptr %N" where %N is not a valid pointer
(forward ref, icmp result, call result, etc.), replace with the most
recently stored-to alloca of a compatible type.
"""
import re
import sys

def fix_function(fn_lines):
    fixes = 0

    # Parse all register definitions
    reg_info = {}  # reg_num -> (line_idx, type_str, kind)
    allocas = {}   # reg_num -> alloca_type
    param_stores = {}  # alloca_reg -> param_name

    for i, line in enumerate(fn_lines):
        m = re.match(r'\s+%(\d+)\s*=\s*(.*)', line)
        if m:
            reg = int(m.group(1))
            rest = m.group(2).strip()
            if rest.startswith('alloca '):
                am = re.match(r'alloca (\S+)', rest)
                ty = am.group(1).rstrip(',') if am else 'i64'
                allocas[reg] = ty
                reg_info[reg] = (i, 'ptr', 'alloca')
            elif rest.startswith('icmp '):
                reg_info[reg] = (i, 'i1', 'icmp')
            elif rest.startswith('load '):
                lm = re.match(r'load (\S+),', rest)
                ty = lm.group(1).rstrip(',') if lm else 'i64'
                reg_info[reg] = (i, ty, 'load')
            elif rest.startswith('call '):
                cm = re.match(r'call (\S+) @', rest)
                ty = cm.group(1) if cm else 'ptr'
                reg_info[reg] = (i, ty, 'call')
            elif rest.startswith('getelementptr '):
                reg_info[reg] = (i, 'ptr', 'gep')
            else:
                # extractvalue, insertvalue, cast, etc
                reg_info[reg] = (i, 'other', 'other')

        sm = re.match(r'\s+store (\S+) %(\w+)\.arg, ptr %(\d+)', line)
        if sm:
            param_stores[int(sm.group(3))] = sm.group(2)

    # Fix pass: iterate through lines, track what's been defined
    result = []
    seen = set()
    # Track most recent store target for each alloca type
    last_stored_alloca = {}  # alloca_type -> reg_num (most recently stored to)

    for i, line in enumerate(fn_lines):
        # Track stores to allocas: "store TYPE VAL, ptr %N"
        sm = re.match(r'\s+store (\S+) .+, ptr %(\d+)', line)
        if sm:
            store_reg = int(sm.group(2))
            if store_reg in allocas:
                last_stored_alloca[allocas[store_reg]] = store_reg

        # Find "ptr %N" references where %N is bad
        fixed_line = line
        for m in re.finditer(r'ptr %(\d+)', line):
            ref = int(m.group(1))

            # Skip definitions
            if re.match(r'\s+%' + str(ref) + r'\s*=', line):
                continue
            # Skip store targets (the "ptr %N" in "store ... ptr %N" is the dest)
            if re.match(r'\s+store .+, ptr %' + str(ref), line):
                # This is the store destination — should be an alloca, which is fine
                if ref in allocas:
                    continue

            is_bad = False
            if ref not in seen:
                is_bad = True
            elif ref in reg_info:
                _, rtype, rkind = reg_info[ref]
                if rkind not in ('alloca', 'gep') and rtype != 'ptr':
                    is_bad = True

            if is_bad:
                # Determine what type of load this is
                lm = re.search(r'load (\S+), ptr %' + str(ref), line)
                load_type = lm.group(1).rstrip(',') if lm else None

                # Find best replacement alloca
                best = None

                if load_type:
                    # Exact match: alloca of same type, prefer param allocas
                    for areg, atype in sorted(allocas.items()):
                        if atype == load_type and (areg in seen or reg_info.get(areg, (0,))[0] < i):
                            if areg in param_stores:
                                best = areg
                                break
                    if best is None:
                        for areg, atype in sorted(allocas.items()):
                            if atype == load_type and (areg in seen or reg_info.get(areg, (0,))[0] < i):
                                best = areg
                                break

                # If no exact type match, try any alloca that was stored to
                # (for struct field loads where type doesn't exactly match)
                if best is None:
                    # Use the alloca that was most recently stored to
                    for atype, areg in last_stored_alloca.items():
                        if areg in seen:
                            best = areg
                            break

                # Last resort: first alloca that has a param stored
                if best is None:
                    for areg in sorted(allocas.keys()):
                        if areg in param_stores and (areg in seen or reg_info.get(areg, (0,))[0] < i):
                            best = areg
                            break

                if best is not None and best != ref:
                    start = m.start(1)
                    end = m.end(1)
                    fixed_line = fixed_line[:start] + str(best) + fixed_line[end:]
                    fixes += 1
                    break  # One fix per line

        # Track definitions
        dm = re.match(r'\s+%(\d+)\s*=', line)
        if dm:
            seen.add(int(dm.group(1)))

        result.append(fixed_line)

    return result, fixes

def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} input.ll output.ll")
        sys.exit(1)

    with open(sys.argv[1]) as f:
        lines = f.read().split('\n')

    output = []
    fn_buf = []
    in_fn = False
    total = 0

    for line in lines:
        if line.startswith('define '):
            in_fn = True
            fn_buf = [line]
        elif in_fn and line == '}':
            fn_buf.append(line)
            fixed, n = fix_function(fn_buf)
            total += n
            output.extend(fixed)
            in_fn = False
        elif in_fn:
            fn_buf.append(line)
        else:
            output.append(line)

    with open(sys.argv[2], 'w') as f:
        f.write('\n'.join(output))

    print(f"Total: {total} fixes")

if __name__ == '__main__':
    main()
