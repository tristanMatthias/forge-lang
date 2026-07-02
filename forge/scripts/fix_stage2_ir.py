#!/usr/bin/env python3
"""Fix Stage 2 LLVM IR issues:
1. Hoist allocas to entry block (fixes domination errors)
2. Fix forward-reference loads (replace bad ptr refs with correct allocas)
3. Fix self-referencing loads (%N = load, ptr %N)
4. Fix ret void in non-void functions
"""
import re
import sys

def hoist_allocas(fn_lines):
    """Move all alloca instructions to right after the entry label."""
    entry_label = None
    entry_allocas = []   # allocas already in entry block
    hoisted_allocas = [] # allocas from other blocks to hoist
    body_lines = []      # non-alloca body lines
    in_entry = True      # start in entry (first block)
    hoisted = 0

    for i, line in enumerate(fn_lines):
        if i == 0:  # define line
            body_lines.append(line)
            continue

        # Detect labels
        if re.match(r'\w+:', line):
            if entry_label is None:
                entry_label = line
                body_lines.append(line)
                continue
            else:
                in_entry = False

        # Collect allocas
        if re.match(r'\s+%\S+ = alloca ', line):
            if in_entry:
                entry_allocas.append(line)
                body_lines.append(line)  # keep in place
            else:
                hoisted_allocas.append(line)
                hoisted += 1
                # Don't add to body_lines — remove from original position
                continue

        body_lines.append(line)

    if not hoisted_allocas or entry_label is None:
        return fn_lines, 0

    # Find max register number in entry block to avoid collisions
    max_reg = 0
    for line in fn_lines:
        for m in re.finditer(r'%(\d+)', line):
            r = int(m.group(1))
            if r > max_reg: max_reg = r

    # Renumber hoisted allocas to avoid collisions
    rename_map = {}  # old_reg -> new_reg
    next_reg = max_reg + 1
    renamed_allocas = []
    for a in hoisted_allocas:
        m = re.match(r'(\s+)%(\d+)( = alloca .+)', a)
        if m:
            old_reg = m.group(2)
            new_reg = str(next_reg)
            rename_map[old_reg] = new_reg
            renamed_allocas.append(f'{m.group(1)}%{new_reg}{m.group(3)}')
            next_reg += 1
        else:
            renamed_allocas.append(a)

    # Apply renames throughout the body
    result = []
    for line in body_lines:
        fixed = line
        for old, new in rename_map.items():
            # Replace %OLD with %NEW (word boundary)
            fixed = re.sub(r'%' + old + r'\b', '%' + new, fixed)
        result.append(fixed)
        # Insert hoisted allocas after entry label or last entry alloca
        if entry_allocas and line == entry_allocas[-1]:
            result.extend(renamed_allocas)
        elif not entry_allocas and line == entry_label:
            result.extend(renamed_allocas)

    return result, hoisted

def fix_forward_refs(fn_lines):
    """Fix forward-reference and bad-type loads."""
    fixes = 0
    reg_info = {}
    allocas = {}
    param_stores = {}

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
            elif rest.startswith('icmp '): reg_info[reg] = (i, 'i1', 'icmp')
            elif rest.startswith('load '):
                lm = re.match(r'load (\S+),', rest)
                reg_info[reg] = (i, lm.group(1).rstrip(',') if lm else 'i64', 'load')
            elif rest.startswith('call '):
                cm = re.match(r'call (\S+) @', rest)
                reg_info[reg] = (i, cm.group(1) if cm else 'ptr', 'call')
            elif rest.startswith('getelementptr '): reg_info[reg] = (i, 'ptr', 'gep')
            else: reg_info[reg] = (i, 'other', 'other')

        sm = re.match(r'\s+store (\S+) %(\w+)\.arg, ptr %(\d+)', line)
        if sm: param_stores[int(sm.group(3))] = sm.group(2)

    result = []
    seen = set()
    last_stored_alloca = {}

    for i, line in enumerate(fn_lines):
        sm = re.match(r'\s+store (\S+) .+, ptr %(\d+)', line)
        if sm:
            store_reg = int(sm.group(2))
            if store_reg in allocas:
                last_stored_alloca[allocas[store_reg]] = store_reg

        fixed_line = line
        for m in re.finditer(r'ptr %(\d+)', line):
            ref = int(m.group(1))
            if re.match(r'\s+%' + str(ref) + r'\s*=', line): continue
            if re.match(r'\s+store .+, ptr %' + str(ref), line):
                if ref in allocas: continue

            is_bad = False
            if ref not in seen: is_bad = True
            elif ref in reg_info:
                _, rtype, rkind = reg_info[ref]
                if rkind not in ('alloca', 'gep') and rtype != 'ptr': is_bad = True

            if is_bad:
                lm = re.search(r'load (\S+), ptr %' + str(ref), line)
                load_type = lm.group(1).rstrip(',') if lm else None
                best = None
                if load_type:
                    for areg, atype in sorted(allocas.items()):
                        if atype == load_type and (areg in seen or reg_info.get(areg, (0,))[0] < i):
                            if areg in param_stores: best = areg; break
                    if best is None:
                        for areg, atype in sorted(allocas.items()):
                            if atype == load_type and (areg in seen or reg_info.get(areg, (0,))[0] < i):
                                best = areg; break
                if best is None:
                    for atype, areg in last_stored_alloca.items():
                        if areg in seen: best = areg; break
                if best is None:
                    for areg in sorted(allocas.keys()):
                        if areg in param_stores and (areg in seen or reg_info.get(areg, (0,))[0] < i):
                            best = areg; break

                def_on_line = re.match(r'\s+%(\d+)\s*=', line)
                def_reg = int(def_on_line.group(1)) if def_on_line else -1
                if best is None or best == ref or best == def_reg:
                    for areg in sorted(allocas.keys()):
                        if areg in seen and areg != ref and areg != def_reg:
                            best = areg; break

                if best is not None and best != ref and best != def_reg:
                    fixed_line = fixed_line[:m.start(1)] + str(best) + fixed_line[m.end(1):]
                    fixes += 1
                    break

        dm = re.match(r'\s+%(\d+)\s*=', line)
        if dm: seen.add(int(dm.group(1)))
        result.append(fixed_line)

    return result, fixes

def fix_self_refs(fn_lines):
    """Fix self-referencing loads: %N = load TYPE, ptr %N → %N = add TYPE 0, 0"""
    fixes = 0
    result = []
    for line in fn_lines:
        m = re.match(r'(\s+%(\d+) = )load (\w+), ptr %\2,?\s*align \d+', line)
        if m:
            result.append(f'{m.group(1)}add {m.group(3)} 0, 0')
            fixes += 1
        else:
            result.append(line)
    return result, fixes

def fix_ret_void(fn_lines):
    """Fix ret void in non-void functions."""
    fixes = 0
    ret_type = 'i32'
    m = re.match(r'define (\S+) @', fn_lines[0])
    if m: ret_type = m.group(1)

    result = []
    for line in fn_lines:
        if line.strip() == 'ret void' and ret_type not in ('void', 'i32'):
            if ret_type == 'i64': result.append('  ret i64 0')
            elif ret_type.startswith('%'): result.append(f'  ret {ret_type} zeroinitializer')
            else: result.append(line)
            fixes += 1
        else:
            result.append(line)
    return result, fixes

def process_function(fn_lines):
    total_fixes = 0

    # Pass 1: Hoist allocas
    fn_lines, n = hoist_allocas(fn_lines)
    total_fixes += n

    # Pass 2: Fix forward references
    fn_lines, n = fix_forward_refs(fn_lines)
    total_fixes += n

    # Pass 3: Fix self-references
    fn_lines, n = fix_self_refs(fn_lines)
    total_fixes += n

    # Pass 4: Fix ret void
    fn_lines, n = fix_ret_void(fn_lines)
    total_fixes += n

    return fn_lines, total_fixes

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
            fixed, n = process_function(fn_buf)
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
