#!/usr/bin/env python3
"""Dogfooding task runner for the bootstrap compiler.

Tracks adoption of every language feature across every .fg source file.
State lives in dogfood_progress.csv. The agent only interacts via this CLI.

Usage:
    python3 scripts/dogfood.py next                        # Get the next task
    python3 scripts/dogfood.py done                        # Mark current task done, get next
    python3 scripts/dogfood.py skip "reason"               # Skip current task with reason, get next
    python3 scripts/dogfood.py progress                    # Show overall progress
    python3 scripts/dogfood.py reset                       # Reset all progress (regenerate CSV)
"""

import csv
import os
import sys
from collections import OrderedDict

BOOTSTRAP = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(BOOTSTRAP, "src")
CSV_PATH = os.path.join(BOOTSTRAP, "dogfood_progress.csv")

# ─── Feature definitions ────────────────────────────────────────────

FEATURES = [
    {
        "key": "string_templates",
        "name": "String Templates",
        "desc": "Use `\"hello ${name}\"` interpolation instead of string concatenation.",
        "look_for": "Grep for `\" + \"` and `+ string(` — these are concatenation chains that could be a single template string.",
        "example": (
            "// Before:\n"
            '"error: " + msg + " at line " + string(line)\n'
            "// After:\n"
            '"error: ${msg} at line ${string(line)}"'
        ),
    },
    {
        "key": "with_expr",
        "name": "With Expressions",
        "desc": "Use `obj with { field: new }` instead of manually copying every field of a struct.",
        "look_for": (
            "Grep for struct literals where most fields are `old.field` — e.g., "
            "`Ctx { builder: ctx.builder, module: ctx.module, ..., new_field: x }`. "
            "These should be `ctx with { new_field: x }`."
        ),
        "example": (
            "// Before:\n"
            "NameCtx { tree: ctx.tree, aliases: ctx.aliases, current_module: mod, locals: ctx.locals }\n"
            "// After:\n"
            "ctx with { current_module: mod }"
        ),
    },
    {
        "key": "pipe_operator",
        "name": "Pipe Operator",
        "desc": "Use `value |> fn` to chain function calls left-to-right instead of nested calls.",
        "look_for": (
            "Grep for deeply nested function calls like `f(g(h(x)))` or "
            "`render_bag(source, path, bag_report(bag_new(), diag_error(...)))`. "
            "These read inside-out; pipes read left-to-right."
        ),
        "example": (
            "// Before:\n"
            "render_bag(source, path, bag_report(bag_new(), diag_error(code, msg, sp)))\n"
            "// After:\n"
            "bag_new() |> bag_report(diag_error(code, msg, sp)) |> render_bag(source, path, _)"
        ),
    },
    {
        "key": "if_expr",
        "name": "If Expressions",
        "desc": (
            "Use `if cond { a } else { b }` as an expression instead of "
            "`mut x = ...; if cond { x = a } else { x = b }`."
        ),
        "look_for": (
            "Grep for `mut` followed shortly by `if` that reassigns the same variable "
            "in both branches. Also look for `let x = if ...` that could replace a temporary."
        ),
        "example": (
            "// Before:\n"
            'mut result = ""\n'
            'if has_error { result = "fail" } else { result = "ok" }\n'
            "// After:\n"
            'let result = if has_error { "fail" } else { "ok" }'
        ),
    },
    {
        "key": "match_expr",
        "name": "Match Expressions",
        "desc": (
            "Use match as an expression (returns a value) instead of match as a "
            "statement with assignments in each arm."
        ),
        "look_for": (
            "Grep for `mut` followed by a `match` where every arm assigns to the "
            "same variable. The match should return the value directly."
        ),
        "example": (
            "// Before:\n"
            'mut label = ""\n'
            'match kind { .Add -> { label = "add" }, .Sub -> { label = "sub" } }\n'
            "// After:\n"
            'let label = match kind { .Add -> "add", .Sub -> "sub" }'
        ),
    },
    {
        "key": "match_guard",
        "name": "Match Guards",
        "desc": "Use `pattern if condition -> body` instead of matching then immediately checking a condition with if.",
        "look_for": (
            "Look for match arms that start with `if` as the first thing in the body "
            "— these could often be guards on the arm itself."
        ),
        "example": (
            "// Before:\n"
            ".Node(name, next) -> { if name == target { ... } else { lookup(next, target) } }\n"
            "// After:\n"
            ".Node(name, _) if name == target -> { ... }\n"
            ".Node(_, next) -> lookup(next, target)"
        ),
    },
    {
        "key": "for_in",
        "name": "For-In Loops",
        "desc": "Use `for item in collection { }` instead of `while` with manual index increment.",
        "look_for": (
            "Grep for `mut i = 0` followed by `while i < ` with `i = i + 1` at the "
            "end — classic index loop that could be for-in if iterating a list or string."
        ),
        "example": (
            "// Before:\n"
            "mut i = 0\n"
            "while i < str.length { let ch = str[i]; ...; i = i + 1 }\n"
            "// After:\n"
            "for ch in str { ... }"
        ),
    },
    {
        "key": "is_keyword",
        "name": "Is Keyword",
        "desc": "Use `expr is .Variant` for type/variant checks instead of a full match just to check one case.",
        "look_for": (
            "Grep for `match x { .Variant -> true, _ -> false }` or "
            "`match x { .Variant(_) -> { ... }, _ -> {} }` patterns that only care about one variant."
        ),
        "example": (
            "// Before:\n"
            "match result { .End -> true, _ -> false }\n"
            "// After:\n"
            "result is .End"
        ),
    },
    {
        "key": "contextual_enum",
        "name": "Contextual Enum Constructors",
        "desc": "Use `.Variant(args)` without the type prefix when the type can be inferred from context.",
        "look_for": (
            "Look for enum constructors with the full type name where the context "
            "makes the type obvious — e.g., in match arms, return positions, or "
            "function args with known types."
        ),
        "example": (
            "// Before (in a match arm on ExprList):\n"
            "ExprList.End\n"
            "// After:\n"
            ".End"
        ),
    },
    {
        "key": "try_operator",
        "name": "Try Operator",
        "desc": "Use `expr?` for error propagation instead of manual `if result.had_error { return ... }`.",
        "look_for": "Grep for `if *.had_error` or `if * == null { return` patterns that propagate errors manually.",
        "example": (
            "// Before:\n"
            "let result = parse(source)\n"
            "if result.had_error { return error_result(result.error_message) }\n"
            "// After:\n"
            "let result = parse(source)?"
        ),
    },
    {
        "key": "null_coalesce",
        "name": "Null Coalescing",
        "desc": "Use `left ?? right` instead of `if left != null { left } else { right }`.",
        "look_for": "Grep for `if .* != null { .* } else {` or `if .* == null { default } else { value }` patterns.",
        "example": (
            "// Before:\n"
            'let name = if user.name != null { user.name } else { "anonymous" }\n'
            "// After:\n"
            'let name = user.name ?? "anonymous"'
        ),
    },
    {
        "key": "optional_chain",
        "name": "Optional Chaining",
        "desc": "Use `obj?.field` instead of null-checking before field access.",
        "look_for": "Grep for `if obj != null { obj.field }` or `if obj != null { obj!.field }` patterns.",
        "example": (
            "// Before:\n"
            "if user != null { user!.name } else { null }\n"
            "// After:\n"
            "user?.name"
        ),
    },
    {
        "key": "force_unwrap",
        "name": "Force Unwrap",
        "desc": "Use `expr!` to assert non-null where you know the value exists, instead of ignoring nullability.",
        "look_for": (
            "Look for places where a nullable value is used without null checking and "
            "the code assumes it's non-null. These should either use `!` or proper null handling."
        ),
        "example": (
            "// Before (if parse always succeeds here):\n"
            "let stmts = result.stmts  // nullable but we know it's set\n"
            "// After:\n"
            "let stmts = result.stmts!"
        ),
    },
    {
        "key": "closures",
        "name": "Closures / Lambdas",
        "desc": "Use `(x) -> expr` anonymous functions where a named helper function is only called once.",
        "look_for": (
            "Look for small named functions that are only referenced once (as a callback "
            "or passed to a higher-order function). These could be inline lambdas."
        ),
        "example": (
            "// Before:\n"
            "fn double(x: int) -> int { x * 2 }\n"
            "list.map(double)\n"
            "// After:\n"
            "list.map((x) -> x * 2)"
        ),
    },
    {
        "key": "destructure",
        "name": "Let Destructuring",
        "desc": "Use `let (a, b) = tuple` instead of indexing with `.0`, `.1`.",
        "look_for": "Grep for `.0` and `.1` tuple field access — these could use destructuring if the tuple is bound to a name first.",
        "example": (
            "// Before:\n"
            "let pair = get_pair()\n"
            "let x = pair.0\n"
            "let y = pair.1\n"
            "// After:\n"
            "let (x, y) = get_pair()"
        ),
    },
    {
        "key": "block_expr",
        "name": "Block Expressions",
        "desc": "Use `{ stmts; expr }` as an expression to compute a value with intermediate steps inline.",
        "look_for": (
            "Look for sequences where a temporary variable is created, used in 2-3 steps, "
            "then the final value is what matters. This could be a block expression."
        ),
        "example": (
            "// Before:\n"
            "let temp = compute()\n"
            "let adjusted = temp + offset\n"
            "do_thing(adjusted)\n"
            "// After:\n"
            "do_thing({ let temp = compute(); temp + offset })"
        ),
    },
    {
        "key": "defer",
        "name": "Defer Statement",
        "desc": "Use `defer expr` for cleanup that should happen when leaving scope, regardless of how.",
        "look_for": "Look for cleanup code duplicated in multiple return paths, or resources that need closing/releasing.",
        "example": (
            "// Before:\n"
            "let f = open(path)\n"
            "if error { close(f); return }\n"
            "process(f)\n"
            "close(f)\n"
            "// After:\n"
            "let f = open(path)\n"
            "defer close(f)\n"
            "if error { return }\n"
            "process(f)"
        ),
    },
    {
        "key": "list_methods",
        "name": "List Methods",
        "desc": "Use `.map`, `.filter`, `.reduce`, `.foreach` instead of manual loops over lists.",
        "look_for": (
            "Look for `for item in list { ... result.push(transform(item)) }` patterns "
            "— these are `.map`. Look for conditional pushes — those are `.filter`."
        ),
        "example": (
            "// Before:\n"
            "mut result = []\n"
            "for item in items { result.push(item.name) }\n"
            "// After:\n"
            "let result = items.map((item) -> item.name)"
        ),
    },
    {
        "key": "string_methods",
        "name": "String Methods",
        "desc": (
            "Use `.contains`, `.starts_with`, `.ends_with`, `.replace`, `.trim`, "
            "`.split`, `.index_of` instead of manual character loops."
        ),
        "look_for": (
            "Look for manual character-by-character loops that check for substrings, "
            'or `substring(0, n) == prefix` patterns that should be `.starts_with`.'
        ),
        "example": (
            "// Before:\n"
            'if name.substring(0, 2) == "__" { ... }\n'
            "// After:\n"
            'if name.starts_with("__") { ... }'
        ),
    },
    {
        "key": "map_methods",
        "name": "Map Methods",
        "desc": "Use `.get`, `.set`, `.has`, `.keys` for map operations.",
        "look_for": "Look for index-based map access or manual key existence checks that could use map methods.",
        "example": (
            "// Before:\n"
            "let val = my_map[key]  // might crash if key missing\n"
            "// After:\n"
            "let val = my_map.get(key) ?? default_val"
        ),
    },
    {
        "key": "list_literal",
        "name": "List Literals",
        "desc": "Use `[a, b, c]` list literal syntax where lists are being built element-by-element.",
        "look_for": "Look for `let list = []; list.push(a); list.push(b); list.push(c)` patterns that could be `[a, b, c]`.",
        "example": (
            "// Before:\n"
            "mut items = []\n"
            'items.push("a")\n'
            'items.push("b")\n'
            "// After:\n"
            'let items = ["a", "b"]'
        ),
    },
    {
        "key": "map_literal",
        "name": "Map Literals",
        "desc": 'Use `{"key": val}` map literal syntax where maps are being built entry-by-entry.',
        "look_for": "Look for map construction followed by multiple `.set` calls that could be a literal.",
        "example": (
            "// Before:\n"
            "mut m = {}\n"
            'm.set("a", 1)\n'
            'm.set("b", 2)\n'
            "// After:\n"
            'let m = {"a": 1, "b": 2}'
        ),
    },
    {
        "key": "tuples",
        "name": "Tuples",
        "desc": "Use `(a, b)` tuples for lightweight multi-return instead of single-use structs.",
        "look_for": (
            "Look for struct types with 2-3 generic fields (like `{ first: T, second: U }`) "
            "used only to return multiple values from one function. Tuples are lighter."
        ),
        "example": (
            "// Before:\n"
            "type Pair = { x: int, y: int }\n"
            "fn get_pos() -> Pair { Pair { x: 1, y: 2 } }\n"
            "// After:\n"
            "fn get_pos() -> (int, int) { (1, 2) }"
        ),
    },
    {
        "key": "tuple_index",
        "name": "Tuple Indexing",
        "desc": "Use `tuple.0`, `tuple.1` for tuple field access.",
        "look_for": "Informational — note where tuples are used and whether indexing or destructuring is cleaner.",
        "example": "let pos = get_pos()\nprintln(string(pos.0))  // x\nprintln(string(pos.1))  // y",
    },
    {
        "key": "table_literal",
        "name": "Table Literals",
        "desc": "Use `table { col1 | col2; val1 | val2 }` for structured tabular data.",
        "look_for": "Look for parallel lists or arrays of structs that represent tabular data — these could use table syntax for clarity.",
        "example": (
            "// Before: parallel lists\n"
            'let names = ["a", "b"]\n'
            "let ages = [1, 2]\n"
            "// After:\n"
            'let data = table { name | age; "a" | 1; "b" | 2 }'
        ),
    },
    {
        "key": "slice",
        "name": "Slice Operator",
        "desc": "Use `obj[start..end]` instead of manual substring/sublist extraction.",
        "look_for": "Grep for `.substring(` calls — some could be slices. Also look for manual list range extraction.",
        "example": (
            "// Before:\n"
            "let sub = name.substring(2, name.length)\n"
            "// After:\n"
            "let sub = name[2..]"
        ),
    },
    {
        "key": "tagged_template",
        "name": "Tagged Templates",
        "desc": "Use `tag\\`template ${x}\\`` for DSL-style string processing.",
        "look_for": "Look for function calls that take a single formatted string argument — these might read better as tagged templates.",
        "example": (
            "// Before:\n"
            'sql("SELECT * FROM users WHERE id = " + string(id))\n'
            "// After:\n"
            "sql`SELECT * FROM users WHERE id = ${id}`"
        ),
    },
    {
        "key": "index_access",
        "name": "Index Access",
        "desc": "Use `obj[i]` for collection element access.",
        "look_for": "Informational — verify index access is used consistently, not manual linked-list traversal where indexing exists.",
        "example": "let ch = str[i]\nlet item = list[idx]",
    },
    {
        "key": "bitwise_ops",
        "name": "Bitwise Operators",
        "desc": "Use `&`, `|`, `^`, `~`, `<<`, `>>` for bit manipulation.",
        "look_for": "Look for manual power-of-2 multiplication/division that could be shifts, or flag checking that could use bitwise AND.",
        "example": "// Before:\nlet doubled = x * 2\n// After:\nlet doubled = x << 1",
    },
    {
        "key": "float_lit",
        "name": "Float Literals",
        "desc": "Use float literals where decimal precision is needed.",
        "look_for": "Look for integer arithmetic that loses precision (like `area = width * height / 2`) where float would be more accurate.",
        "example": (
            "// Before:\n"
            "let ratio = count / total  // integer division!\n"
            "// After:\n"
            "let ratio = float(count) / float(total)"
        ),
    },
    {
        "key": "annotations",
        "name": "Annotations",
        "desc": "Use `@name` or `@name(args)` annotations on declarations for metadata.",
        "look_for": "Look for `export` that isn't using annotation syntax, or places where metadata could be attached to declarations.",
        "example": '@export\nfn public_api() { ... }\n\n@deprecated("use new_fn instead")\nfn old_fn() { ... }',
    },
    {
        "key": "impl_block",
        "name": "Impl Blocks",
        "desc": "Use `impl Type { fn method(self) }` for methods instead of free functions that take the type as first arg.",
        "look_for": (
            "Grep for functions whose first parameter is a struct/enum type — "
            "`fn do_thing(ctx: Ctx, ...)`. If there are 3+ functions taking the same "
            "type as arg 1, they should be methods in an impl block."
        ),
        "example": (
            "// Before:\n"
            "fn ctx_enter(ctx: Ctx) -> Ctx { ... }\n"
            "fn ctx_exit(ctx: Ctx) -> Ctx { ... }\n"
            "// After:\n"
            "impl Ctx {\n"
            "    fn enter(self) -> Ctx { ... }\n"
            "    fn exit(self) -> Ctx { ... }\n"
            "}"
        ),
    },
    {
        "key": "trait_decl",
        "name": "Trait Declarations",
        "desc": "Use `trait Name { fn method(self) }` for shared interfaces.",
        "look_for": "Look for multiple types that implement the same set of function signatures — these could share a trait.",
        "example": (
            "// Before: both types have render() but no shared interface\n"
            "fn render_expr(e: Expr) -> string { ... }\n"
            "fn render_stmt(s: Stmt) -> string { ... }\n"
            "// After:\n"
            "trait Renderable { fn render(self) -> string }"
        ),
    },
    {
        "key": "enum_decl",
        "name": "Enum Declarations",
        "desc": "Use enums for sum types instead of structs with tag fields.",
        "look_for": 'Look for structs with a `tag` or `kind` field used to distinguish variants — these are enums in disguise.',
        "example": (
            "// Before:\n"
            "type Value = { tag: string, int_val: int, str_val: string }\n"
            "// After:\n"
            "enum Value { IntVal(n: int), StrVal(s: string) }"
        ),
    },
    {
        "key": "struct_decl",
        "name": "Struct Declarations",
        "desc": "Use `type Name = { fields }` for product types.",
        "look_for": "Look for functions returning multiple related values via tuples that would be clearer as named struct fields.",
        "example": (
            "// Before:\n"
            "fn parse() -> (bool, string, StmtList) { ... }\n"
            "// After:\n"
            "type ParseResult = { had_error: bool, message: string, stmts: StmtList }"
        ),
    },
    {
        "key": "type_annotations",
        "name": "Type Annotations",
        "desc": "Add explicit `: Type` annotations where they improve readability.",
        "look_for": (
            "Look for complex expressions where the resulting type isn't obvious — "
            "adding an annotation makes intent clear. Don't over-annotate obvious cases."
        ),
        "example": (
            "// Before:\n"
            "let result = parse(source)  // what type is this?\n"
            "// After:\n"
            "let result: ParseResult = parse(source)"
        ),
    },
    {
        "key": "module_use",
        "name": "Module Use Imports",
        "desc": "Ensure all cross-module references use explicit `use` imports.",
        "look_for": "Look for qualified identifiers that could benefit from a `use` import for readability, or missing imports that rely on global resolution.",
        "example": (
            "// Before: fully qualified everywhere\n"
            "core::ast::render_expr(e)\n"
            "// After:\n"
            "use core.ast.{render_expr}\n"
            "render_expr(e)"
        ),
    },
    {
        "key": "export_visibility",
        "name": "Export Visibility",
        "desc": "Ensure public APIs are `export` and internal helpers are not.",
        "look_for": "Look for functions that are used from other modules but lack `export`, or functions with `export` that are only used locally.",
        "example": (
            "// Should be exported (used by other modules):\n"
            "export fn resolve_names(stmts: StmtList) -> NameResolveResult { ... }\n"
            "// Should NOT be exported (internal helper):\n"
            "fn alias_lookup(aliases: AliasEntry, name: string) -> string { ... }"
        ),
    },
    {
        "key": "parallel_block",
        "name": "Parallel Blocks",
        "desc": "Use `parallel { }` for concurrent execution.",
        "look_for": "Look for independent operations that could run concurrently — especially I/O-bound operations or independent computations.",
        "example": (
            "// Before: sequential\n"
            "let a = fetch_data(url1)\n"
            "let b = fetch_data(url2)\n"
            "// After:\n"
            "parallel { let a = fetch_data(url1); let b = fetch_data(url2) }"
        ),
    },
    {
        "key": "select_stmt",
        "name": "Select Statement",
        "desc": "Use `select { }` for channel multiplexing.",
        "look_for": "Look for polling loops or sequential channel reads that could use select for concurrent channel handling.",
        "example": "select {\n    msg <- inbox -> { handle(msg) }\n    tick <- timer -> { update() }\n}",
    },
    {
        "key": "spec_test",
        "name": "Spec Tests",
        "desc": "Use `spec/given/then` blocks for inline testing.",
        "look_for": "Look for files that have no test coverage and could benefit from inline spec blocks to verify behavior.",
        "example": (
            'spec "parser" {\n'
            '    given "simple expression" {\n'
            '        then "parses number" { assert(parse("42") != null) }\n'
            "    }\n"
            "}"
        ),
    },
    {
        "key": "for_range",
        "name": "For Range Loops",
        "desc": "Use `for i in start..end { }` instead of `while` with manual counter.",
        "look_for": (
            "Grep for `mut i = 0` + `while i < N` + `i = i + 1` — the classic "
            "C-style loop that should be `for i in 0..N`."
        ),
        "example": (
            "// Before:\n"
            "mut i = 0\n"
            "while i < count { process(i); i = i + 1 }\n"
            "// After:\n"
            "for i in 0..count { process(i) }"
        ),
    },

    # ─── DRY / Code Quality ─────────────────────────────────────────

    {
        "key": "dry_duplicate_blocks",
        "name": "DRY: Duplicate Code Blocks",
        "desc": (
            "Find and extract duplicate or near-duplicate code blocks into shared "
            "helper functions. Two blocks that differ only in a variable name or "
            "error message should be one function with a parameter."
        ),
        "look_for": (
            "Look for match arms, if-else branches, or function bodies that are "
            "near-identical (same structure, different variable names). Key hotspot: "
            "codegen/mod.fg `.Ident` vs `.QualifiedIdent` arms (~48 duplicated lines). "
            "Also check for repeated multi-line patterns across features."
        ),
        "example": (
            "// Before: two 25-line match arms that differ only in `name` vs `path`\n"
            ".Ident(name) -> { let local = env_lookup(env, name); ... }\n"
            ".QualifiedIdent(path) -> { let local = env_lookup(env, path); ... }\n"
            "// After: one helper, two one-line arms\n"
            "fn emit_name_lookup(ctx, env, name, label) -> EmitResult { ... }\n"
            '.Ident(name) -> emit_name_lookup(ctx, env, name, "variable")\n'
            '.QualifiedIdent(path) -> emit_name_lookup(ctx, env, path, "qualified name")'
        ),
    },
    {
        "key": "dry_use_helpers",
        "name": "DRY: Use Existing Helpers",
        "desc": (
            "Replace manual struct construction with existing helper functions. "
            "If `ok_emit_typed(value, ty)` exists, don't write "
            "`EmitResult { value: v, ty: t, had_error: false, error_message: \"\" }` by hand."
        ),
        "look_for": (
            "Grep for `had_error: false, error_message: \"\"` — every hit is a manual "
            "construction that should use a helper. Check codegen/types.fg for the "
            "available helpers: ok_emit, ok_emit_str, ok_emit_typed, err_emit, "
            "ok_stmt, err_stmt, err_stmt_from_expr. "
            "~36 manual EmitResult constructions exist; ~15 are straightforward replacements."
        ),
        "example": (
            "// Before:\n"
            "EmitResult { value: loaded, ty: local.ty, had_error: false, error_message: \"\" }\n"
            "// After:\n"
            "ok_emit_typed(loaded, local.ty)"
        ),
    },
    {
        "key": "dry_error_propagation",
        "name": "DRY: Error Propagation Boilerplate",
        "desc": (
            "Identify and reduce repetitive `if r.had_error { return r }` / "
            "`if r.had_error { return err_stmt_from_expr(r) }` chains. "
            "NOTE: The `?` operator currently only works on nullable values (null check), "
            "NOT on structs with had_error fields. So `?` cannot be used directly. "
            "Instead, look for opportunities to: (a) chain operations to avoid intermediate "
            "error checks, (b) extract common error-check-and-continue patterns into helpers, "
            "(c) restructure to use early returns more cleanly."
        ),
        "look_for": (
            "Grep for `if.*had_error.*return` — there are ~107 instances across codegen files. "
            "Many follow the exact same pattern: emit_expr → check error → use value. "
            "Look for cases where 3+ sequential emit+check pairs could be a helper like "
            "`emit_two_exprs(ctx, env, left, right)` that returns both values or an error."
        ),
        "example": (
            "// Before: 6 lines per operand\n"
            "let l = emit_expr(ctx, env, left)\n"
            "if l.had_error { return l }\n"
            "let r = emit_expr(ctx, env, right)\n"
            "if r.had_error { return r }\n"
            "// After: helper handles both\n"
            "let (lv, rv) = emit_pair(ctx, env, left, right)?\n"
            "// Or at minimum, extract to:\n"
            "let l = emit_or_bail(ctx, env, left)  // returns EmitResult, caller checks once"
        ),
    },
    {
        "key": "dry_magic_numbers",
        "name": "DRY: Magic Numbers and Strings",
        "desc": (
            "Replace magic numbers and unexplained string constants with named constants "
            "or at minimum add a comment explaining what they mean."
        ),
        "look_for": (
            "Grep for bare numeric literals that aren't 0 or 1 — e.g., `-559038737` "
            "(closure marker), `32` (LLVM icmp predicate for EQ), `33`/`34`/etc. "
            "Also look for string literals used as type tags or dispatch keys."
        ),
        "example": (
            "// Before:\n"
            "call_2(ctx, push_fn, closure_arr, const_i64(ctx, -559038737), \"\")\n"
            "// After:\n"
            "let CLOSURE_MARKER = -559038737  // 0xDEADBEEF — sentinel to identify closure arrays\n"
            "call_2(ctx, push_fn, closure_arr, const_i64(ctx, CLOSURE_MARKER), \"\")"
        ),
    },
    {
        "key": "dry_dead_code",
        "name": "DRY: Dead Code and Unused Params",
        "desc": (
            "Find and remove dead code: functions never called, variables assigned "
            "but never read, match arms that can't be reached, parameters that are "
            "always passed the same value."
        ),
        "look_for": (
            "For each function defined in the file, grep the codebase for callers. "
            "If zero callers exist outside the definition, it's dead. Also look for "
            "`let x = ...` where x is never used again, or `_ -> ` catch-all arms "
            "after exhaustive matching."
        ),
        "example": (
            "// Before:\n"
            "fn unused_helper(ctx: Ctx) -> int { ... }  // nobody calls this\n"
            "let temp = compute()  // temp never read\n"
            "// After: delete both"
        ),
    },
]

FEATURE_KEYS = [f["key"] for f in FEATURES]
FEATURE_BY_KEY = {f["key"]: f for f in FEATURES}


# ─── File discovery ─────────────────────────────────────────────────

def find_fg_files():
    """Find all .fg source files under src/, excluding tests/."""
    files = []
    for root, dirs, fnames in os.walk(SRC):
        dirs[:] = [d for d in dirs if d != "tests"]
        for f in fnames:
            if f.endswith(".fg"):
                rel = os.path.relpath(os.path.join(root, f), BOOTSTRAP)
                files.append(rel)
    files.sort()
    return files


# ─── CSV state management ───────────────────────────────────────────

def load_state():
    """Load progress from CSV. Returns dict: (feature_key, file) -> {status, notes}."""
    state = OrderedDict()
    if not os.path.exists(CSV_PATH):
        return state
    with open(CSV_PATH, "r", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = (row["feature"], row["file"])
            state[key] = {"status": row["status"], "notes": row["notes"]}
    return state


def save_state(state):
    """Save progress to CSV."""
    with open(CSV_PATH, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["feature", "file", "status", "notes"])
        writer.writeheader()
        for (feature, file), data in state.items():
            writer.writerow({
                "feature": feature,
                "file": file,
                "status": data["status"],
                "notes": data["notes"],
            })


def init_state():
    """Create fresh CSV with all feature×file pairs as pending."""
    files = find_fg_files()
    state = OrderedDict()
    for feat in FEATURES:
        for f in files:
            state[(feat["key"], f)] = {"status": "pending", "notes": ""}
    save_state(state)
    return state


def ensure_state():
    """Load existing state or initialize if missing."""
    if not os.path.exists(CSV_PATH):
        return init_state()
    return load_state()


# ─── Task output ────────────────────────────────────────────────────

def find_next_task(state):
    """Find the next pending (feature, file) pair, in feature order then file order."""
    for (feat_key, file), data in state.items():
        if data["status"] == "pending":
            return feat_key, file
    return None, None


def find_current_feature(state):
    """Find the feature currently being worked on (has mix of pending and done)."""
    for feat in FEATURES:
        has_pending = False
        has_done = False
        for (fk, _), data in state.items():
            if fk != feat["key"]:
                continue
            if data["status"] == "pending":
                has_pending = True
            else:
                has_done = True
        if has_pending and has_done:
            return feat["key"]
        if has_pending and not has_done:
            return feat["key"]
    return None


def feature_file_counts(state, feat_key):
    """Count done/skipped/pending for a feature."""
    done = skipped = pending = 0
    for (fk, _), data in state.items():
        if fk != feat_key:
            continue
        if data["status"] == "done":
            done += 1
        elif data["status"] == "skipped":
            skipped += 1
        else:
            pending += 1
    return done, skipped, pending


def feature_is_complete(state, feat_key):
    """Check if all files for a feature are done/skipped."""
    _, _, pending = feature_file_counts(feat_key=feat_key, state=state)
    return pending == 0


def print_task(feat_key, file):
    """Print the full task prompt for the agent."""
    feat = FEATURE_BY_KEY[feat_key]
    feat_idx = FEATURE_KEYS.index(feat_key) + 1
    file_short = file.replace("src/", "")
    file_abs = os.path.join(BOOTSTRAP, file)

    print(f"={'=' * 70}")
    print(f"  TASK: Feature #{feat_idx} — {feat['name']}")
    print(f"  FILE: {file_short}")
    print(f"={'=' * 70}")
    print()
    print(f"## {feat['name']}")
    print()
    print(feat["desc"])
    print()
    print("### What to look for")
    print()
    print(feat["look_for"])
    print()
    print("### Example refactor")
    print()
    print("```forge")
    print(feat["example"])
    print("```")
    print()
    print(f"### Your task")
    print()
    print(f"Open `{file_short}` and audit it for this feature.")
    print(f"Full path: {file_abs}")
    print()
    print("- Search for the anti-patterns described above")
    print("- Apply the refactor wherever it improves the code")
    print("- If the file has no opportunities, that's fine — mark it done")
    print()
    print("### When done")
    print()
    print("```bash")
    print(f'python3 scripts/dogfood.py done          # if audited (changes or not)')
    print(f'python3 scripts/dogfood.py skip "reason"  # only if genuinely not applicable')
    print("```")
    print()


def print_feature_complete(feat_key):
    """Print instructions when a feature is fully audited."""
    feat = FEATURE_BY_KEY[feat_key]
    feat_idx = FEATURE_KEYS.index(feat_key) + 1

    print(f"={'=' * 70}")
    print(f"  FEATURE #{feat_idx} COMPLETE: {feat['name']}")
    print(f"={'=' * 70}")
    print()
    print("All files audited for this feature.")
    print()
    print("### Action required")
    print()
    print("1. Run `make build && make test` to verify nothing broke")
    print(f"2. Commit: `git add -A && git commit -m 'dogfood: {feat['name'].lower()}'`")
    print("3. Then run `python3 scripts/dogfood.py next` to continue")
    print()


def print_all_done():
    """Print message when everything is complete."""
    print(f"={'=' * 70}")
    print(f"  ALL DONE!")
    print(f"={'=' * 70}")
    print()
    print("Every feature has been audited across every file.")
    print(f"Total: {len(FEATURES)} features x {len(find_fg_files())} files = {len(FEATURES) * len(find_fg_files())} audits")
    print()


# ─── Commands ───────────────────────────────────────────────────────

def cmd_next():
    """Print the next task."""
    state = ensure_state()
    feat_key, file = find_next_task(state)

    if feat_key is None:
        print_all_done()
        return

    print_task(feat_key, file)


def cmd_done():
    """Mark current task as done, then print next task (or feature-complete message)."""
    state = ensure_state()
    feat_key, file = find_next_task(state)

    if feat_key is None:
        print_all_done()
        return

    # Mark done
    state[(feat_key, file)]["status"] = "done"
    save_state(state)

    done, skipped, pending = feature_file_counts(state, feat_key)
    total = done + skipped + pending
    print(f"Marked `{file.replace('src/', '')}` as done for {FEATURE_BY_KEY[feat_key]['name']}. ({done + skipped}/{total})")
    print()

    # Check if feature is now complete
    if pending == 0:
        print_feature_complete(feat_key)
        return

    # Otherwise print next task
    next_feat, next_file = find_next_task(state)
    if next_feat:
        print_task(next_feat, next_file)
    else:
        print_all_done()


def cmd_skip(reason):
    """Mark current task as skipped with reason, then print next task."""
    if not reason:
        print("error: skip requires a reason")
        print('Usage: python3 scripts/dogfood.py skip "reason"')
        sys.exit(1)

    state = ensure_state()
    feat_key, file = find_next_task(state)

    if feat_key is None:
        print_all_done()
        return

    # Mark skipped
    state[(feat_key, file)]["status"] = "skipped"
    state[(feat_key, file)]["notes"] = reason
    save_state(state)

    done, skipped, pending = feature_file_counts(state, feat_key)
    total = done + skipped + pending
    print(f"Skipped `{file.replace('src/', '')}` for {FEATURE_BY_KEY[feat_key]['name']}: {reason} ({done + skipped}/{total})")
    print()

    if pending == 0:
        print_feature_complete(feat_key)
        return

    next_feat, next_file = find_next_task(state)
    if next_feat:
        print_task(next_feat, next_file)
    else:
        print_all_done()


def cmd_progress():
    """Show overall progress report."""
    state = ensure_state()
    files = find_fg_files()
    total_all = len(FEATURES) * len(files)

    total_done = sum(1 for v in state.values() if v["status"] == "done")
    total_skipped = sum(1 for v in state.values() if v["status"] == "skipped")
    total_pending = total_all - total_done - total_skipped

    pct = (total_done + total_skipped) / total_all * 100 if total_all else 0
    bar_w = 30
    filled = int(bar_w * (total_done + total_skipped) / total_all) if total_all else 0
    bar = "\u2588" * filled + "\u2591" * (bar_w - filled)

    print(f"Overall: [{bar}] {pct:.1f}%")
    print(f"\u2705 {total_done} done  |  \u23ed\ufe0f {total_skipped} skipped  |  \u23f3 {total_pending} pending  |  {total_all} total")
    print()
    print(f"{'#':<4} {'Feature':<30} {'Done':>5} {'Skip':>5} {'Pend':>5} {'Total':>6}  Status")
    print(f"{'─' * 4} {'─' * 30} {'─' * 5} {'─' * 5} {'─' * 5} {'─' * 6}  {'─' * 20}")

    for i, feat in enumerate(FEATURES, 1):
        done, skipped, pending = feature_file_counts(state, feat["key"])
        total = done + skipped + pending
        pct_f = (done + skipped) / total * 100 if total else 0
        filled_f = int(10 * (done + skipped) / total) if total else 0
        mini_bar = "\u2588" * filled_f + "\u2591" * (10 - filled_f)

        if pending == 0:
            icon = "\u2705"
        elif done + skipped > 0:
            icon = "\U0001f6a7"
        else:
            icon = "\u23f3"

        print(f"{i:<4} {feat['name']:<30} {done:>5} {skipped:>5} {pending:>5} {total:>6}  {icon} {mini_bar} {pct_f:.0f}%")

    print()
    for feat in FEATURES:
        _, _, pending = feature_file_counts(state, feat["key"])
        if pending > 0:
            idx = FEATURE_KEYS.index(feat["key"]) + 1
            print(f"Next: #{idx} {feat['name']} ({pending} files remaining)")
            break
    else:
        print("All features complete!")


def cmd_reset():
    """Reset all progress."""
    state = init_state()
    files = find_fg_files()
    print(f"Reset: {len(FEATURES)} features \u00d7 {len(files)} files = {len(FEATURES) * len(files)} tasks")
    print(f"Saved to {CSV_PATH}")


# ─── CLI ────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 scripts/dogfood.py next              # Get the next task")
        print("  python3 scripts/dogfood.py done              # Mark current task done, get next")
        print('  python3 scripts/dogfood.py skip "reason"     # Skip current task, get next')
        print("  python3 scripts/dogfood.py progress          # Show progress report")
        print("  python3 scripts/dogfood.py reset             # Reset all progress")
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "next":
        cmd_next()
    elif cmd == "done":
        cmd_done()
    elif cmd == "skip":
        reason = sys.argv[2] if len(sys.argv) > 2 else ""
        cmd_skip(reason)
    elif cmd == "progress":
        cmd_progress()
    elif cmd == "reset":
        cmd_reset()
    else:
        print(f"Unknown command: {cmd}")
        sys.exit(1)


if __name__ == "__main__":
    main()
