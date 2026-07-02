#!/usr/bin/env python3
"""Strip llvm_* function definitions from Stage 1 IR.

The mini compiler compiles std-llvm wrapper functions (like llvm_type_of)
which are trivial wrappers around C functions (forge_llvm_type_of).
These wrappers already exist in libforge_llvm.a (the Rust LLVM bindings).
To avoid duplicate symbol errors at link time, we replace the definitions
with declarations.

We also strip forge_llvm_* definitions since those are in the Rust library too.
"""
import sys
import re

def strip_llvm_defs(input_path, output_path):
    with open(input_path, 'r') as f:
        lines = f.readlines()

    result = []
    i = 0
    stripped_count = 0

    while i < len(lines):
        line = lines[i]

        # Check for llvm_* or forge_llvm_* function definitions
        m = re.match(r'^define\s+(\S+)\s+@(forge_llvm_\w+|llvm_type_of|llvm_get_named_global)\(([^)]*)\)\s*\{', line)
        if m:
            ret_type = m.group(1)
            fn_name = m.group(2)
            params = m.group(3)

            # Convert to declaration
            # Strip parameter names, keep types
            param_types = []
            for p in params.split(','):
                p = p.strip()
                if p:
                    # "type %name.arg" → "type"
                    parts = p.split()
                    if parts:
                        param_types.append(parts[0])

            decl = f'declare {ret_type} @{fn_name}({", ".join(param_types)})\n'
            result.append(decl)
            stripped_count += 1

            # Skip function body until closing brace
            i += 1
            while i < len(lines) and not lines[i].startswith('}'):
                i += 1
            i += 1  # skip the }
            # Skip blank line after }
            if i < len(lines) and lines[i].strip() == '':
                i += 1
            continue

        result.append(line)
        i += 1

    with open(output_path, 'w') as f:
        f.writelines(result)

    if stripped_count:
        print(f"  Stripped {stripped_count} llvm_*/forge_llvm_* function definitions", file=sys.stderr)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input.ll> <output.ll>")
        sys.exit(1)
    strip_llvm_defs(sys.argv[1], sys.argv[2])
