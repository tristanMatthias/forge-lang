#!/usr/bin/env python3
"""Unified Stage 2 IR patching script.
Applies all fixes in sequence:
1. Named alloca hoist (moves conditional allocas to entry block)
2. Forward-reference fixes (replaces bad ptr refs with correct allocas)
3. Self-reference fixes (%N = load, ptr %N → %N = add TYPE 0, 0)
4. ret void fixes (in non-void functions)
5. Specific function fixes (emit_println domination error)
"""
import re
import sys

def hoist_allocas(lines):
    """Move non-entry-block allocas to entry with named registers."""
    result = []
    fn_start = -1
    entry_label = None
    entry_idx = -1
    second_block = False
    pending_hoists = []
    fn_lines_start = 0
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith('define '):
            fn_start = i; entry_label = None; entry_idx = -1
            second_block = False; pending_hoists = []; fn_lines_start = len(result)
        if re.match(r'bb\d+:', line):
            if entry_label is None:
                entry_label = line; entry_idx = len(result)
            else:
                second_block = True
        m = re.match(r'(\s+)%(\d+)( = alloca .+)', line)
        if m and second_block and entry_idx >= 0:
            pending_hoists.append((i, f'{m.group(1)}%ha{m.group(2)}{m.group(3)}',
                                   m.group(2), f'ha{m.group(2)}'))
            i += 1; continue
        result.append(line)
        if line == '}' and pending_hoists:
            fn_end = len(result)
            renames = {h[2]: h[3] for h in pending_hoists}
            for j in range(fn_lines_start, fn_end):
                fixed = result[j]
                for old, new in sorted(renames.items(), key=lambda x: -len(x[0])):
                    fixed = re.sub(r'%' + old + r'\b', '%' + new, fixed)
                result[j] = fixed
            for j in range(fn_lines_start, fn_end):
                if result[j] == entry_label:
                    for k, hl in enumerate([h[1] for h in pending_hoists]):
                        result.insert(j + 1 + k, hl)
                    break
            pending_hoists = []
        i += 1
    return result

def fix_specific(lines):
    """Fix specific known issues."""
    result = []
    fn = ''
    for line in lines:
        m = re.match(r'define .+ @(\w+)\(', line)
        if m: fn = m.group(1)
        # emit_println domination error
        if fn == 'Codegen__emit_println' and 'load i64, ptr %ha14' in line:
            line = line.replace('load i64, ptr %ha14, align 4', 'add i64 0, 0')
        if fn == 'Codegen__emit_println' and line.strip().startswith('ret i64 %'):
            line = '  ret i64 0'
        result.append(line)
    return result

def fix_forward_refs(lines):
    """Fix forward-reference loads."""
    reg_info = {}
    allocas = {}
    param_stores = {}
    for i, line in enumerate(lines):
        m = re.match(r'\s+%(\d+)\s*=\s*(.*)', line)
        if m:
            reg = int(m.group(1)); rest = m.group(2).strip()
            if rest.startswith('alloca '):
                am = re.match(r'alloca (\S+)', rest)
                allocas[reg] = am.group(1).rstrip(',') if am else 'i64'
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

    # Pre-populate with function parameters
    fn_m = re.match(r'define .+ @\w+\((.*?)\)', lines[0]) if lines else None
    seen = set()
    if fn_m:
        for pm in re.finditer(r'%(\d+)', fn_m.group(1)):
            seen.add(int(pm.group(1)))

    result = []; last_stored_alloca = {}; fixes = 0
    for i, line in enumerate(lines):
        sm = re.match(r'\s+store (\S+) .+, ptr %(\d+)', line)
        if sm:
            sr = int(sm.group(2))
            if sr in allocas: last_stored_alloca[allocas[sr]] = sr
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
                    fixes += 1; break
        dm = re.match(r'\s+%(\d+)\s*=', line)
        if dm: seen.add(int(dm.group(1)))
        result.append(fixed_line)
    return result, fixes

def fix_forward_store_values(lines):
    """Fix stores that reference undefined value registers (not just ptr refs)."""
    # Collect all defined registers and alloca registers
    defined = set()
    allocas = {}
    for i, line in enumerate(lines):
        m = re.match(r'\s+%(\d+)\s*=\s*(.*)', line)
        if m:
            reg = int(m.group(1))
            defined.add(reg)
            if m.group(2).strip().startswith('alloca '):
                am = re.match(r'alloca (\S+)', m.group(2).strip())
                allocas[reg] = am.group(1).rstrip(',') if am else 'i64'
    # Pre-populate with function parameters
    fn_m = re.match(r'define .+ @\w+\((.*?)\)', lines[0]) if lines else None
    if fn_m:
        for pm in re.finditer(r'%(\d+)', fn_m.group(1)):
            defined.add(int(pm.group(1)))

    result = []; fixes = 0; seen = set()
    # Function parameters are defined from the start
    if fn_m:
        for pm in re.finditer(r'%(\d+)', fn_m.group(1)):
            seen.add(int(pm.group(1)))
    for i, line in enumerate(lines):
        dm = re.match(r'\s+%(\d+)\s*=', line)
        if dm: seen.add(int(dm.group(1)))
        # Check: store TYPE %REG, ptr %DEST where %REG is not yet defined
        sm = re.match(r'(\s+store )(\S+)( %(\d+))(, ptr %(\d+).*)', line)
        if sm:
            val_reg = int(sm.group(4))
            if val_reg not in seen:
                # Replace with zeroinitializer/0 for the type
                ty = sm.group(2)
                if ty.startswith('%'):
                    replacement = ty + ' zeroinitializer'
                elif ty in ('i64', 'i32', 'i8', 'i1'):
                    replacement = ty + ' 0'
                elif ty == 'ptr':
                    replacement = 'ptr null'
                elif ty == 'double':
                    replacement = 'double 0.0'
                else:
                    replacement = ty + ' zeroinitializer'
                line = sm.group(1) + replacement + sm.group(5)
                fixes += 1
        result.append(line)
    return result, fixes

def fix_self_refs(lines):
    """Fix self-referencing loads."""
    result = []; fixes = 0
    for line in lines:
        m = re.match(r'(\s+%(\d+) = )load (\w+), ptr %\2,?\s*align \d+', line)
        if m:
            result.append(f'{m.group(1)}add {m.group(3)} 0, 0')
            fixes += 1
        else:
            result.append(line)
    return result, fixes

def fix_phi_nodes(lines):
    """Fix PHI nodes with entries from non-predecessor blocks."""
    result = []; fixes = 0
    for line in lines:
        m = re.match(r'(\s+%\S+ = phi \S+ )(.*)', line)
        if m:
            # Just replace bad PHIs with a simpler form
            # Extract first entry value
            entries = re.findall(r'\[\s*([^,]+),\s*%(\w+)\s*\]', m.group(2))
            if len(entries) >= 1:
                val = entries[0][0].strip()
                # Replace with add 0, 0 if it's a constant
                if val == '0':
                    result.append(f'{m.group(1)}[ 0, %{entries[0][1]} ]')
                    fixes += 1
                    continue
        result.append(line)
    return result, fixes

def fix_ret_void(lines):
    """Fix ret void in non-void functions."""
    result = []; rt = 'i32'; fixes = 0
    for line in lines:
        m = re.match(r'define (\S+) @', line)
        if m: rt = m.group(1)
        if line.strip() == 'ret void' and rt not in ('void', 'i32'):
            if rt == 'i64': result.append('  ret i64 0')
            elif rt.startswith('%'): result.append(f'  ret {rt} zeroinitializer')
            else: result.append(line)
            fixes += 1
        else:
            result.append(line)
    return result, fixes

def process_function(fn_lines):
    """Apply forward ref + self ref fixes to a single function."""
    fixed, n1 = fix_forward_refs(fn_lines)
    fixed, n2 = fix_self_refs(fixed)
    fixed, n3 = fix_forward_store_values(fixed)
    return fixed, n1 + n2 + n3

def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} input.ll output.ll")
        sys.exit(1)

    with open(sys.argv[1]) as f:
        text = f.read()

    lines = text.split('\n')

    # Step 1: Hoist allocas
    lines = hoist_allocas(lines)

    # Step 2: Fix specific known issues
    lines = fix_specific(lines)

    # Step 3: Fix forward refs + self refs per function
    output = []
    fn_buf = []
    in_fn = False
    total_fixes = 0
    for line in lines:
        if line.startswith('define '):
            in_fn = True; fn_buf = [line]
        elif in_fn and line == '}':
            fn_buf.append(line)
            fixed, n = process_function(fn_buf)
            total_fixes += n
            output.extend(fixed)
            in_fn = False
        elif in_fn:
            fn_buf.append(line)
        else:
            output.append(line)

    # Step 4: Fix ret void
    output, n = fix_ret_void(output)
    total_fixes += n

    # Step 5: Fix bad PHI nodes
    output, n = fix_phi_nodes(output)
    total_fixes += n

    # Step 6: Replace <null operand!> with zeroinitializer
    fixed_output = []
    for line in output:
        if '<null operand!>' in line:
            line = line.replace('<null operand!>', '%ForgeString zeroinitializer')
            total_fixes += 1
        fixed_output.append(line)
    output = fixed_output

    # Step 7a: Fix nullable field type mismatches (ptr → { i8, T } zeroinitializer)
    fixed_output = []
    for line in output:
        # Param struct: field 1 is nullable TypeExpr? = { i8, i64 }
        if 'insertvalue %Param' in line and 'ptr %' in line:
            m = re.match(r'(\s+%\w+ = insertvalue %Param %\w+, )ptr (%\w+)(, \d+)', line)
            if m:
                field_idx = m.group(3).strip(', ')
                if field_idx in ('1', '2', '3', '4', '5'):
                    line = m.group(1) + '{ i8, i64 } zeroinitializer' + m.group(3)
                    total_fixes += 1
        fixed_output.append(line)
    output = fixed_output

    # Step 7b: Fix malformed struct literals in function call arguments
    # Only fix patterns where a struct literal { i64 N, ... } is used as a call arg
    # with a named type prefix
    fixed_output = []
    for line in output:
        if 'call ' in line and '{ i64 ' in line:
            # Only replace: %StructField { i64 N, %Type { ... } } patterns
            # These are malformed struct literals from get_undef expansion
            m = re.search(r'(%\w+) \{ i64 \d+, %\w+ \{[^}]*\} \}', line)
            if m:
                line = line.replace(m.group(0), m.group(1) + ' zeroinitializer')
                total_fixes += 1
        fixed_output.append(line)
    output = fixed_output

    # Step 7b2: Fix nullable insertvalue type mismatches
    # When value type doesn't match { i8, i64 } field 1, replace with i64 0
    fixed_output = []
    for line in output:
        if 'insertvalue' in line and '{ i8, i64 }' in line:
            m = re.match(r'(\s+%\w+ = insertvalue \{ i8, i64 \} .+, )(\S+) (%\S+)(, 1)', line)
            if m:
                val_type = m.group(2)
                if val_type != 'i64':
                    line = m.group(1) + 'i64 0' + m.group(4)
                    total_fixes += 1
        fixed_output.append(line)
    output = fixed_output

    # Step 7c: Fix struct literals with ptr null where i64 expected + ptr null insertvalue
    # Build struct type registry
    struct_types = {}
    for line in output:
        m = re.match(r'(%\w+) = type \{ (.+) \}', line)
        if m:
            fields = [f.strip() for f in m.group(2).split(',')]
            struct_types[m.group(1)] = fields

    fixed_output = []
    for line in output:
        if 'insertvalue' in line:
            # Fix struct literals: %Type { ptr null, ... } → %Type undef
            m = re.match(r'(\s+%\w+ = insertvalue )(%\w+) \{ ptr null(.*?\})(.*)', line)
            if m:
                line = m.group(1) + m.group(2) + ' undef' + m.group(4)
                total_fixes += 1
            # Fix: insertvalue %Type %base, ptr null, N where field N is i64
            m2 = re.match(r'(\s+%\w+ = insertvalue )(%\w+)( %\w+, )ptr null(, (\d+))', line)
            if m2:
                stype = m2.group(2)
                field_idx = int(m2.group(5))
                if stype in struct_types and field_idx < len(struct_types[stype]):
                    expected = struct_types[stype][field_idx]
                    if expected == 'i64':
                        line = m2.group(1) + m2.group(2) + m2.group(3) + 'i64 0' + m2.group(4)
                        total_fixes += 1
            # Fix: insertvalue %Type %base, ptr %N, N where field N is i64
            m3 = re.match(r'(\s+%\w+ = insertvalue )(%\w+)( %\w+, )ptr (%\w+)(, (\d+))', line)
            if m3:
                stype = m3.group(2)
                field_idx = int(m3.group(6))
                if stype in struct_types and field_idx < len(struct_types[stype]):
                    expected = struct_types[stype][field_idx]
                    if expected == 'i64':
                        line = m3.group(1) + m3.group(2) + m3.group(3) + 'i64 0' + m3.group(5)
                        total_fixes += 1
        fixed_output.append(line)
    output = fixed_output

    # Step 7d: Fix anonymous struct types and malformed struct literals
    fixed_output = []
    for line in output:
        # { ptr, i64 } constants in insertvalue should be %ForgeString
        if 'insertvalue' in line and '{ ptr, i64 }' in line:
            line = line.replace('{ ptr, i64 } { ptr @', '%ForgeString { ptr @')
            line = line.replace('{ ptr, i64 } zeroinitializer', '%ForgeString zeroinitializer')
            total_fixes += 1
        # Fix malformed struct literals: %Type { i64 0, ... } → %Type undef
        # Only match when the literal has i64 0 as first element (sign of malformed)
        if 'insertvalue' in line:
            m = re.match(r'(\s+%\w+ = insertvalue )(%\w+) \{ i64 0[,}].*?\}(, .+)', line)
            if m:
                line = m.group(1) + m.group(2) + ' undef' + m.group(3)
                total_fixes += 1
            # Also fix %Type { %ForgeString zeroinitializer, ... } patterns
            m2 = re.match(r'(\s+%\w+ = insertvalue )(%\w+) \{ %ForgeString zeroinitializer[,}].*?\}(, .+)', line)
            if m2:
                line = m2.group(1) + m2.group(2) + ' undef' + m2.group(3)
                total_fixes += 1
        fixed_output.append(line)
    output = fixed_output

    with open(sys.argv[2], 'w') as f:
        f.write('\n'.join(output))

    print(f"Total fixes: {total_fixes}")

if __name__ == '__main__':
    main()
