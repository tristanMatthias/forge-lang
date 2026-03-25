#!/usr/bin/env python3
"""Validate self-hosted compiler IR: test each function, stub invalid ones.

Temporary build step until all 382 functions produce valid IR.
Usage: python3 scripts/validate_ir.py /tmp/forgec_out.ll /tmp/forgec_out_validated.ll
"""
import re, subprocess, sys

LLC = "/opt/homebrew/opt/llvm@18/bin/llvm-as"

def main():
    infile = sys.argv[1] if len(sys.argv) > 1 else "/tmp/forgec_out.ll"
    outfile = sys.argv[2] if len(sys.argv) > 2 else "/tmp/forgec_out_validated.ll"

    with open(infile) as f:
        text = f.read()

    functions = re.split(r'(?=\ndefine )', text)
    header = functions[0]

    fn_sigs = {}
    for part in functions[1:]:
        m = re.match(r'\ndefine ([^{]+)\{', part, re.DOTALL)
        m2 = re.search(r'@(\w+)\(', part)
        if m and m2:
            fn_sigs[m2.group(1)] = f'declare {m.group(1).strip()}\n'

    fixed_parts = [header]
    good = bad = 0

    for part in functions[1:]:
        m = re.match(r'\ndefine (%[\w.]+|i\d+|void|%ForgeString) @(\w+)\([^)]*\)\s*\{', part)
        if not m:
            fixed_parts.append(part)
            continue
        ret_type = m.group(1)
        fn_name = m.group(2)
        other_decls = '\n'.join(d for n, d in fn_sigs.items() if n != fn_name)
        test_ir = header + '\n' + other_decls + '\n' + part
        with open('/tmp/_test_fn.ll', 'w') as f:
            f.write(test_ir)
        result = subprocess.run([LLC, '/tmp/_test_fn.ll', '-o', '/dev/null'],
                              capture_output=True, text=True)
        if result.returncode == 0:
            fixed_parts.append(part)
            good += 1
        else:
            sig = part[:part.index('{') + 1]
            if ret_type == 'void':
                stub = f'{sig}\n  ret void\n}}\n'
            elif ret_type in ('i64', 'i32', 'i1'):
                stub = f'{sig}\n  ret {ret_type} 0\n}}\n'
            else:
                stub = f'{sig}\n  ret {ret_type} undef\n}}\n'
            fixed_parts.append(stub)
            bad += 1

    with open(outfile, 'w') as f:
        f.writelines(fixed_parts)

    print(f'Valid: {good}/{good+bad}, Stubbed: {bad}')

if __name__ == '__main__':
    main()
