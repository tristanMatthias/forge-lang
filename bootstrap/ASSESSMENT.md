# DEEP ARCHITECTURAL ASSESSMENT: Bootstrap Compiler

## Feature Progress (131 total: 63 done, 58 todo, 10 n/a)

| # | Feature | Status | Notes |
|---|---------|--------|-------|
| 1 | let binding | ✅ | |
| 2 | mut binding | ✅ | |
| 3 | const binding | ✅ | parsed as let |
| 4 | type annotation | ✅ | |
| 5 | immutability enforcement | 🔲 | |
| 6 | field mutability | ✅ | parsed, not enforced |
| 7 | shorthand fields | ✅ | |
| 8 | int (i64) | ✅ | |
| 9 | float (f64) | 🔲 | |
| 10 | string | ✅ | |
| 11 | bool | ✅ | |
| 12 | null | ✅ | |
| 13 | hex/bin/oct literals | ✅ | |
| 14 | numeric underscores | 🔲 | |
| 15 | fn declaration | ✅ | |
| 16 | return | ✅ | |
| 17 | implicit return | ✅ | |
| 18 | extern fn | ✅ | |
| 19 | fn types | 🔲 | |
| 20 | closures / lambdas | 🔲 | high priority |
| 21 | `it` parameter | 🔲 | needs closures |
| 22 | generics | ✅ | parsed, erased |
| 23 | generic constraints | 🔲 | |
| 24 | type declaration | ✅ | |
| 25 | struct literal | ✅ | |
| 26 | field access | ✅ | |
| 27 | field assign | ✅ | |
| 28 | `with` expression | ✅ | functional update, dogfooded in Ctx |
| 29 | traits | ✅ | no dynamic dispatch |
| 30 | impl for trait | ✅ | desugars to Type__method |
| 31 | impl block | ✅ | |
| 32 | enum declaration | ✅ | |
| 33 | enum constructor | ✅ | |
| 34 | match statement | ✅ | |
| 35 | match expression | ✅ | |
| 36 | wildcard pattern | ✅ | |
| 37 | variant binding | ✅ | |
| 38 | nested patterns | 🔲 | |
| 39 | match guards | 🔲 | |
| 40 | match tables | 🔲 | |
| 41 | `is` keyword | 🔲 | |
| 42 | contextual resolution | 🔲 | |
| 43 | if / else | ✅ | stmt + expr |
| 44 | else if | ✅ | |
| 45 | while | ✅ | |
| 46 | for-in | 🔲 | needs iterators |
| 47 | for-range | ✅ | |
| 48 | break / continue | ✅ | |
| 49 | expression blocks | ✅ | |
| 50 | defer | 🔲 | |
| 51 | arithmetic | ✅ | |
| 52 | comparison | ✅ | |
| 53 | logical (&&/\|\|) | ✅ | short-circuit |
| 54 | logical keywords | ✅ | and/or/not |
| 55 | unary | ✅ | |
| 56 | bitwise | 🔲 | |
| 57 | pipe | ✅ | |
| 58 | ranges | 🔲 | |
| 59 | type operators | 🔲 | |
| 60 | string literals | ✅ | |
| 61 | string concat | ✅ | |
| 62 | string indexing | ✅ | |
| 63 | .length | ✅ | |
| 64 | .substring | ✅ | |
| 65 | string templates | ✅ | with sub-parser for expressions |
| 66 | tagged templates | 🔲 | |
| 67 | .split, .trim | 🔲 | |
| 68 | .contains, .starts_with | 🔲 | |
| 69 | .replace, .upper, .lower | 🔲 | |
| 70 | char_code | 🔲 | |
| 71 | nullable types (T?) | ✅ | erased |
| 72 | null check | ✅ | |
| 73 | force unwrap (!) | ✅ | |
| 74 | optional chaining (?.) | ✅ | |
| 75 | null coalescing (??) | ✅ | |
| 76 | null throw | 🔲 | |
| 77 | error propagation (?) | ✅ | dogfooded (98 patterns) |
| 78 | catch blocks | 🔲 | |
| 79 | list literal | 🔲 | |
| 80 | map literal | 🔲 | |
| 81 | tuple literal | ✅ | with type tracking |
| 82 | tuple destructuring | ✅ | |
| 83 | slicing | 🔲 | |
| 84 | list methods | 🔲 | |
| 85 | map methods | 🔲 | |
| 86 | mod declaration | ✅ | |
| 87 | use import | ✅ | |
| 88 | export | ✅ | |
| 89 | package use | ✅ | |
| 90 | proper separate compilation | 🔲 | |
| 91 | println / print | ✅ | |
| 92 | eprintln / eprint | ✅ | |
| 93 | string() conversion | ✅ | |
| 94 | int() conversion | ✅ | |
| 95 | float() conversion | 🔲 | |
| 96 | file_exists | ✅ | |
| 97 | read_file | ✅ | |
| 98 | write_file | ✅ | |
| 99 | json.parse / stringify | 🔲 | |
| 100 | process_uptime | 🔲 | |
| 101 | datetime | 🔲 | |
| 102 | durations | 🔲 | |
| 103 | shell shorthand | 🔲 | |
| 104 | spawn | 🔲 | |
| 105 | channels | 🔲 | |
| 106 | select | 🔲 | |
| 107 | parallel | 🔲 | |
| 108 | component blocks | ⬜ | n/a |
| 109 | config declaration | ⬜ | n/a |
| 110 | events | ⬜ | n/a |
| 111 | custom syntax | ⬜ | n/a |
| 112 | spec tests | 🔲 | |
| 113 | table literals | 🔲 | |
| 114 | validation | 🔲 | |
| 115 | annotations | 🔲 | |
| 116 | ptr arithmetic | 🔲 | |
| 117 | ptr indexing | 🔲 | |
| 118 | ptr ↔ string | 🔲 | |
| 119 | c_abi_trampolines | 🔲 | |
| 120–131 | packages (@llvm, @process, etc.) | mixed | 4 done, 4 todo, 6 n/a |

## Scaling Issues (priority order)

| # | Issue | Status | Impact |
|---|-------|--------|--------|
| 1 | Ctx copy-helper boilerplate | ✅ FIXED | `with` expressions eliminate field-listing |
| 2 | String type tags (ty: string) | ✅ FIXED | ValueType enum, pattern matching, no CSV parsing |
| 3 | String-based operator dispatch | ✅ FIXED | BinOp/UnOp/LogicOp enums, match dispatch |
| 4 | emit_expr/emit_stmt dispatcher size | ⏳ OK for now | 25 arms, manageable to ~50 |
| 5 | VarEnv O(n) lookup | ⏳ OK for now | Not bottleneck yet |
| 6 | Module preprocessor O(n²) concat | ⏳ OK for now | Fine for current codebase size |

---

## EXECUTIVE SUMMARY

       The bootstrap compiler is a 1,341-line codegen, 1,274-line parser, with 10 feature modules distributed across ~4,100 total lines. Current design patterns will BREAK at 30-50 features due to multiple scaling bottlenecks. The problems are not subtle—they are structural.

       ---
       FILE METRICS & FUNCTION DISTRIBUTION

       Core System

       ┌──────────────────┬───────┬───────────┬─────────┐
       │       File       │ Lines │ Functions │ Exports │
       ├──────────────────┼───────┼───────────┼─────────┤
       │ codegen/mod.fg   │ 1,341 │ 43        │ 2       │
       ├──────────────────┼───────┼───────────┼─────────┤
       │ parse/mod.fg     │ 1,274 │ 15        │ 2       │
       ├──────────────────┼───────┼───────────┼─────────┤
       │ core/cg.fg       │ 398   │ 33        │ 25      │
       ├──────────────────┼───────┼───────────┼─────────┤
       │ core/ast.fg      │ 479   │ 31        │ 14      │
       ├──────────────────┼───────┼───────────┼─────────┤
       │ core/resolver.fg │ 500   │ 25        │ 1       │
       ├──────────────────┼───────┼───────────┼─────────┤
       │ main.fg          │ 252   │ 9         │ 1       │
       └──────────────────┴───────┴───────────┴─────────┘

       Current Features (10 total)

       ┌─────────────┬───────┬───────────┐
       │   Feature   │ Lines │ Functions │
       ├─────────────┼───────┼───────────┤
       │ match       │ 170   │ 6         │
       ├─────────────┼───────┼───────────┤
       │ tuples      │ 122   │ 10        │
       ├─────────────┼───────┼───────────┤
       │ null_safety │ 105   │ 3         │
       ├─────────────┼───────┼───────────┤
       │ for_stmt    │ 59    │ 1         │
       ├─────────────┼───────┼───────────┤
       │ struct_decl │ 52    │ 3         │
       ├─────────────┼───────┼───────────┤
       │ fn_decl     │ 55    │ 3         │
       ├─────────────┼───────┼───────────┤
       │ enum_decl   │ 57    │ 3         │
       ├─────────────┼───────┼───────────┤
       │ if_stmt     │ 37    │ 1         │
       ├─────────────┼───────┼───────────┤
       │ while_stmt  │ 32    │ 1         │
       ├─────────────┼───────┼───────────┤
       │ let_stmt    │ 16    │ 1         │
       └─────────────┴───────┴───────────┘

       Total feature code: 605 lines. Average per feature: 60 lines. This is linear growth territory for now, but the coupling will make larger features expensive.

       ---
       CRITICAL SCALING PROBLEMS

       1. THE Ctx STRUCT — WILL EXPLODE

       Current state:
       export type Ctx = {
           lc: ptr, module: ptr, builder: ptr,
           current_fn: ptr,
           i64_type: ptr, i1_type: ptr, ptr_type: ptr,
           structs: StructReg,
           enums: EnumReg,
           fn_rets: FnRetTypes,
           top_level_vars: TopLevelVars,
           loops: LoopStack,  // ← NEW for loops
       }

       12 fields today. Every new context-sensitive feature adds fields:
       - Generics? type_params: TypeParamReg
       - Traits? trait_methods: TraitReg
       - Closures? closure_env: ClosureEnv
       - Async? async_stack: AsyncFrameStack
       - Error handlers? error_handlers: ErrorHandlerStack
       - Module imports? import_stack: ImportStack
       - Namespaces? namespace_stack: NamespaceStack

       At 30 features, expect 25-30 fields. Each feature:
       1. Adds a field to Ctx
       2. Requires 3 "copy with modification" helpers (like ctx_with_fn, ctx_with_loops) per variant — these lines scale O(fields × features)
       3. Creates thread-through boilerplate in every emit function

       CODEGEN COST:
       - Lines 288–298 in core/cg.fg are ctx copy helpers that spell out all 12 fields
       - At 25 fields, each of 3 helpers is ~25 lines (750 lines total for helpers alone)
       - This is pure boilerplate. At 100 features, this pattern becomes unmaintainable

       SOLUTION: Migrate to a feature-tagged union or map-based context store where each feature registers its data once, and Ctx holds a single feature_data: FeatureStore that any feature can read without coupling.

       ---
       2. emit_expr & emit_stmt DISPATCHERS — O(n) BLOAT

       Current emit_expr (lines ~564–610):
       match expr {
           .Number(text) -> ...
           .Bool(text) -> ...
           .Null -> ...
           .String(text) -> ...
           .Grouping(inner) -> ...
           .Unary(op, right) -> ...
           .Binary(left, op, right) -> ...
           .Logical(left, op, right) -> ...
           .Ident(name) -> ...
           .Assign(name, value) -> ...
           .Call(callee, args) -> ...
           .StructLit(name, inits) -> ...
           .FieldAccess(obj, field) -> ...
           .EnumCtor(type_name, variant, args) -> ...
           .Index(obj, idx) -> ...
           .Block(body) -> ...
           .MatchExpr(subject, arms) -> ...
           .FieldAssign(obj, field, value) -> ...
           .IfExpr(c, t, e) -> ...
           .NullCoalesce(left, right) -> ...
           .OptionalChain(obj, field) -> ...
           .Try(inner) -> ...
           .Tuple(elements) -> ...
           .TupleIndex(obj, idx) -> ...
           _ -> err_emit("unsupported expression type")
       }

       22 arms today. At 50 expression types, this is a 2–3 page function. The pattern is:
       - Each arm calls a feature-specific emit function imported from features/<X>/codegen.fg
       - The match statement is the central bottleneck in the codebase

       Problem:
       - Readability: A 50+ arm match is a wall of text
       - Search cost: Grep/IDE search for "emit_" returns 40+ unrelated functions
       - Refactoring: Adding a new expression type requires:
         a. Define it in core/ast.fg (1 line in the Expr enum)
         b. Parse it in parse/mod.fg (varies, but often 10–30 lines)
         c. Resolve it in core/resolver.fg (usually 5–10 lines)
         d. Add an arm in emit_expr (1–3 lines, but this is the visible change)
         e. Write features/<X>/codegen.fg (50–150 lines for real features)

       The dispatcher itself becomes a versioning bottleneck because changes to the structure affect every reader.

       Same for emit_stmt: Currently 20 arms, will be 40+ by 50 features.

       SOLUTION: Replace with function-pointer dispatch table:
       type ExprEmitter = fn(Ctx, VarEnv, Expr) -> EmitResult
       type EmitterRegistry = {
           emitters: [ExprEmitter; 64],
           count: int,
       }
       // Register once per module load:
       fn register_expr_emitter(reg: &EmitterRegistry, tag: int, fn: ExprEmitter)
       // Call via:
       let emitter = reg.emitters[expr_tag(expr)]
       emitter(ctx, env, expr)
       This moves the dispatch table from the source to registration-time configuration, and features register their emitters in isolation.

       ---
       3. TYPE SYSTEM — EVERYTHING IS STRING TAGS

       Type encoding is brittle:
       - "i64" — primitive
       - "str" — primitive
       - "enum:Name" — name-based dispatch
       - "struct:Name" — name-based dispatch
       - "tuple:ty1,ty2,ty3" — CSV parsing (lines 36–68 in features/tuples/codegen.fg)

       Problems:

       1. No type safety: A typo in a tag string is a runtime error, not a compile error.
         - Example: "strct:Foo" instead of "struct:Foo" will silently fall through all struct logic
         - Tuples parse CSV manually: extract_nth_csv (line 50–68) does string slicing to find commas
       2. CSV parsing is fragile: Line 45 in features/tuples/codegen.fg:
       fn tuple_element_type(tag: string, idx: int) -> string {
           if tag.length < 7 { return "i64" }
           let prefix = tag.substring(0, 6)
           if prefix != "tuple:" { return "i64" }
           let types_str = tag.substring(6, tag.length)
           extract_nth_csv(types_str, idx)  // ← O(n) string search per lookup
       }
       2. This recalculates the index position every time. With deeply nested tuples tuple:tuple:i64,str,tuple:i64,i64,i64,i64, the parser does O(tuple_depth) linear scans.
       3. No type caching: Each translate_param_type call (lines 264–280 in core/cg.fg) does:
       if ty == "str" { return "str" }
       if ty == "string" { return "str" }
       if ty == "i64" { return "i64" }
       if ty == "int" { return "i64" }
       if ty == "bool" { return "i64" }
       if ty == "ptr" { return "i64" }
       let enum_l = enum_reg_lookup(enums, ty)  // ← O(enums) lookup
       if enum_l.found { return "enum:" + ty }
       let struct_l = struct_reg_lookup(structs, ty)  // ← O(structs) lookup
       if struct_l.found { return "struct:" + ty }
       "i64"
       3. This is O(n) per type translation. With 50 types and deep nesting, this becomes expensive.
       4. Error messages are weak: String tags make debugging hard.
       let enum_name = strip_enum_prefix(r.ty)  // Line 79 in match/codegen.fg
       if enum_name == "" {
           return err_emit("match subject is not an enum (ty=" + r.ty + ")")
       }
       4. The error message includes the unparsed tag. Good for debugging, but the type information is already lost once it's a string.

       SOLUTION: Replace with a tagged union/discriminated type:
       export enum ValueType {
           Primitive(PrimitiveType)
           Struct(StructName)
           Enum(EnumName)
           Tuple(types: [ValueType])
           Function(params: [ValueType], ret: ValueType)
           Unknown
       }

       enum PrimitiveType {
           I64, Str, Bool, Ptr
       }
       This gives:
       - Type safety at parse time
       - O(1) lookups (no string search)
       - Compiler support for exhaustiveness checking
       - IDE support for refactoring

       ---
       4. VarEnv LINKED LIST — O(n) LOOKUP AT CODEGEN TIME

       Current design (lines 124–152 in core/ast.fg):
       export enum VarEnv {
           End
           Node(name: string, alloca: ptr, ty: string, next: VarEnv)
       }

       export fn env_lookup(env: VarEnv, name: string) -> VarLookup {
           match env {
               .End -> VarLookup { found: false, alloca: null, ty: "i64" }
               .Node(n, alloca, ty, next) -> {
                   if n == name { return VarLookup { found: true, alloca, ty } }
                   env_lookup(next, name)  // ← RECURSION DOWN THE CHAIN
               }
           }
       }

       Every variable lookup is O(n). With n = depth of scope nesting.

       Actual costs:
       - Function body with 20 local variables and 5 nested scopes: ~100 env_lookup calls
       - String comparison (line 142) happens O(100) times per function
       - 10 function bodies × 100 lookups × O(n) per lookup = O(10n) total

       At 100 functions with average 5 nested scopes, average 15 variables per scope:
       - Worst case: 1,500 lookup operations per compilation
       - Each lookup traverses the list linearly
       - With string comparison, this is O(total_vars × average_scope_depth) per function = O(n²) behavior

       When does this hurt? At 30+ features with deep module nesting:
       - A single function can have 50+ intermediate variables (after feature expansion)
       - Scope nesting becomes 8+ levels (modules × impl blocks × closures)
       - O(n²) becomes actual wall-clock time

       Why not use a hash table? Because Forge doesn't have them in the bootstrap, and building one would require:
       1. A hash function (non-trivial for bootstrapping)
       2. Memory management for dynamic sizing
       3. Equality checking (which is already available via string ==)

       Practical solution in bootstrap: Use a parallel flat name→alloca map built at scope entry:
       type VarMap = {
           names: [string; 128],
           allocas: [ptr; 128],
           types: [string; 128],
           count: int,
       }
       fn vmap_lookup(map: &VarMap, name: string) -> VarLookup {
           // O(map.count) linear scan, but with 1 string comparison per name
           // Faster in practice than linked-list traversal
           mut i = 0
           while i < map.count {
               if map.names[i] == name {
                   return VarLookup { found: true, alloca: map.allocas[i], ty: map.types[i] }
               }
               i = i + 1
           }
           VarLookup { found: false, alloca: null, ty: "i64" }
       }
       This trades linked-list overhead for array indexing and is still O(n) per lookup but with much better cache locality.

       ---
       5. MODULE PREPROCESSOR — STRING CONCATENATION

       Lines 80–121 in main.fg:
       fn preprocess_modules(source: string, entry_path: string) -> string {
           let dir = dirname(entry_path)
           mut out = ""  // ← MUTABLE STRING
           mut i = 0
           let n = source.length
           while i < n {
               // ... extract line ...
               let line = source.substring(line_start, i)
               let mod_name = extract_mod_name(line)
               if mod_name == "" {
                   out = out + line  // ← STRING CONCATENATION
               } else {
                   // Try sibling-file form first ...
                   if file_exists(sibling_path) {
                       let mod_src = read_file(sibling_path)
                       let inlined = preprocess_modules(mod_src, sibling_path)  // ← RECURSIVE
                       out = out + "// === module " + mod_name + " ===\n"
                       out = out + inlined
                       out = out + "\n"
                   } else if file_exists(dir_mod_path) {
                       // ...
                   }
               }
           }
           out
       }

       String concatenation is O(n) in most languages (requires copying the entire accumulated string). With recursive module loading, this becomes O(n²) or worse.

       Actual scenario:
       - Main file: 100 lines
       - 10 modules, each 200 lines
       - Total: 2,100 lines

       Concatenation sequence:
       1. out = "" (0)
       2. out = out + "line 1" (1)
       3. out = out + "line 2" (2) — copies 1 + new content
       4. ...
       5. out = out + "module 1 content" (200) — copies 100 + 200 = 300 chars
       6. ...
       7. out = out + "module 2 content" (200) — copies 1,300 + 200 = 1,500 chars

       Total work: 1 + 2 + 3 + ... + 2100 = ~2.2 million character copies (for just 2,100 lines of input).

       At 50 source files with 50,000 total lines:
       - ~1.25 billion character copies just to concatenate modules
       - This is CPU-bound string work that dominates compilation time

       SOLUTION: Use a rope/tree structure or memory buffer:
       type StringBuilder = {
           chunks: [string; 256],
           count: int,
       }
       fn append(sb: &StringBuilder, s: string) {
           if sb.count >= 256 { return } // ← Bounds check
           sb.chunks[sb.count] = s
           sb.count = sb.count + 1
       }
       fn build(sb: &StringBuilder) -> string {
           // O(total_size) single pass, not O(n²)
           // (implementation omitted)
       }

       ---
       6. EmitResult/StmtResult SHAPE — OVERLOADED

       Lines 57–96 in core/cg.fg:
       export type EmitResult = {
           value: ptr,
           ty: string,
           had_error: bool,
           error_message: string,
       }

       export type StmtResult = {
           env: VarEnv,
           had_error: bool,
           error_message: string,
       }

       Issues:

       1. Error handling is mixed with success: Every function returns 4 fields (EmitResult) or 3 fields (StmtResult) even on success. The value field is uninitialized garbage if had_error == true.
       2. Pattern matching for errors is verbose:
       let r = emit_expr(ctx, env, expr)
       if r.had_error { return r }  // ← EVERY FEATURE DOES THIS
       2. Repeated in 40+ feature emit functions. This is error-handling boilerplate that could be abstracted.
       3. Type field is error-prone: ty: string means typos in type tags are runtime errors, not compile-time errors (as mentioned above).
       4. Message field is optional but always checked: Every error site does:
       err_emit("message")  // Creates { value: null, ty: "i64", had_error: true, error_message: "codegen error: message" }
       4. But the caller usually ignores the message in nested calls. This is wasted space in the common case.

       Better design:
       export enum EmitOutcome {
           Ok(value: ptr, ty: ValueType)
           Err(message: string)
       }
       This forces error handling at the type level (Rust-style Result). Every match on EmitOutcome requires handling both cases.

       ---
       7. ExprList / StmtList RECURSIVE ENUMS — LINEARITY IN HIDDEN WAYS

       Lines 5–8 in core/ast.fg:
       export enum ExprList {
           End
           Node(expr: Expr, next: ExprList)
       }

       This is a singly-linked list. Indexing into it (e.g., "get the 5th argument to a function call") is O(n).

       Example: Function calls with many arguments

       A call like f(a, b, c, d, e, f, g, h, i, j) (10 arguments) creates:
       Node(a, Node(b, Node(c, ... Node(j, End))))

       Codegen to emit all arguments (line 917–926 in codegen/mod.fg):
       fn fill_arg_array(ctx: Ctx, env: VarEnv, arr: ptr, args: ExprList, idx: int) -> EmitResult {
           match args {
               .End -> ok_emit(null_ptr_val())
               .Node(arg, next) -> {
                   let r = emit_expr(ctx, env, arg)
                   if r.had_error { return r }
                   forge_llvm_value_array_set(arr, idx, r.value)
                   fill_arg_array(ctx, env, arr, next, idx + 1)
               }
           }
       }

       This is recursive descent through the list. With 10 arguments:
       - 10 stack frames (one per recursion)
       - 10 string comparisons (one per Node match)
       - 10 calls to emit_expr (one per argument)

       Is this a problem? No, not for 10 arguments. But when you have:
       - match expr { .Variant(args) -> ... } with 20 payload fields
       - List comprehensions that build intermediate lists of expressions
       - Nested tuples like (1, (2, (3, (4, (5)))))

       The linked-list structure becomes a performance pit because you can't random-access and you can't take slices.

       Why arrays aren't used: Forge doesn't have dynamic arrays in the bootstrap. The fixed arrays like [string; 128] would require pre-allocating a size, and the bootstrap source would need to know the max function arity at compile time.

       Solution: Wait until a real implementation. In the bootstrap, accept the linked-list cost for now, but avoid nested ExprLists in new features (e.g., don't create an ExprList of ExprLists—flatten it).

       ---
       8. STRING-BASED DISPATCH IN emit_binary / emit_logical

       Lines 1223–1280 in codegen/mod.fg:
       fn emit_binary(ctx: Ctx, env: VarEnv, left: Expr, operator: string, right: Expr) -> EmitResult {
           // ... setup code ...
           // then:
           if operator == "+" {
               if l.ty == "str" || r.ty == "str" { return emit_concat(ctx, l.value, r.value) }
               return ok_emit(forge_llvm_build_add(ctx.builder, lhs, rhs, "add"))
           }
           if operator == "-" { return ok_emit(forge_llvm_build_sub(ctx.builder, lhs, rhs, "sub")) }
           if operator == "*" { return ok_emit(forge_llvm_build_mul(ctx.builder, lhs, rhs, "mul")) }
           if operator == "/" { return ok_emit(forge_llvm_build_sdiv(ctx.builder, lhs, rhs, "div")) }
           if operator == "%" { return ok_emit(forge_llvm_build_srem(ctx.builder, lhs, rhs, "rem")) }
           if operator == "==" { return ok_emit(compare_ints(ctx, lhs, rhs, 32)) }
           if operator == "!=" { return ok_emit(compare_ints(ctx, lhs, rhs, 33)) }
           if operator == "<" { return ok_emit(compare_ints(ctx, lhs, rhs, 40)) }
           if operator == "<=" { return ok_emit(compare_ints(ctx, lhs, rhs, 41)) }
           if operator == ">" { return ok_emit(compare_ints(ctx, lhs, rhs, 42)) }
           if operator == ">=" { return ok_emit(compare_ints(ctx, lhs, rhs, 43)) }
           err_emit("unknown binary operator: " + operator)
       }

       10 string comparisons for 10 operators. This is O(k) where k = number of operators, and each comparison is a string equality check.

       At 30 operators (compound assignments, bitwise ops, custom operators):
       - 30 string comparisons per binary expression
       - In a function with 50 expressions, that's 1,500 string comparisons just for binary operators

       This scales linearly with operators added. The solution is enum-based dispatch:
       export enum BinaryOp {
           Add, Sub, Mul, Div, Rem,
           Eq, Ne, Lt, Le, Gt, Ge,
           BitAnd, BitOr, BitXor,
           // ... more ops ...
       }

       fn emit_binary(ctx: Ctx, env: VarEnv, left: Expr, op: BinaryOp, right: Expr) -> EmitResult {
           match op {
               .Add -> if l.ty == "str" || r.ty == "str" { ... } else { ... }
               .Sub -> ...
               // ... 30 branches, but compiler can jump-table this
           }
       }
       The parse phase converts "+" strings to BinaryOp.Add once, and codegen uses fast enum dispatch.

       ---
       SUMMARY TABLE: PAIN POINTS BY SCALE

       ┌────────────────────────────────┬─────────────────────────────┬───────────────────────────────────┬────────────────────────────────────────────────┐
       │            Problem             │    Impact @ 10 features     │       Impact @ 50 features        │             Impact @ 100 features              │
       ├────────────────────────────────┼─────────────────────────────┼───────────────────────────────────┼────────────────────────────────────────────────┤
       │ Ctx struct size                │ 12 fields, 3 helpers        │ 25 fields, 75+ helper lines       │ 35+ fields, 500+ helper lines                  │
       ├────────────────────────────────┼─────────────────────────────┼───────────────────────────────────┼────────────────────────────────────────────────┤
       │ emit_expr dispatcher           │ 22 arms, 1 page             │ 50 arms, 2 pages, hard to read    │ 100+ arms, search becomes nightmare            │
       ├────────────────────────────────┼─────────────────────────────┼───────────────────────────────────┼────────────────────────────────────────────────┤
       │ String type tags               │ Works, but brittle          │ Fragile CSV parsing, cache misses │ Unmaintainable, CSV parsing O(n²) with nesting │
       ├────────────────────────────────┼─────────────────────────────┼───────────────────────────────────┼────────────────────────────────────────────────┤
       │ VarEnv O(n) lookup             │ 100 lookups per compilation │ 10,000 lookups per compilation    │ 100,000+ lookups, visible slowdown             │
       ├────────────────────────────────┼─────────────────────────────┼───────────────────────────────────┼────────────────────────────────────────────────┤
       │ Module preprocessor O(n²)      │ 2,100 lines, unnoticed      │ 50,000 lines, ~1 second           │ 500,000 lines, ~100 seconds                    │
       ├────────────────────────────────┼─────────────────────────────┼───────────────────────────────────┼────────────────────────────────────────────────┤
       │ ExprList recursion depth       │ Max 20 args, OK             │ Max 50 args, stack risk           │ Fragile, limits expression complexity          │
       ├────────────────────────────────┼─────────────────────────────┼───────────────────────────────────┼────────────────────────────────────────────────┤
       │ String-based operator dispatch │ 10–15 operators             │ 30 operators                      │ Unscalable, needs O(1) jump table              │
       └────────────────────────────────┴─────────────────────────────┴───────────────────────────────────┴────────────────────────────────────────────────┘

       ---
       WHAT WILL HURT MOST, IN ORDER

       1. Ctx boilerplate (IMMEDIATE) — Every feature adds "let ctx = Ctx { ... }" copy-helper lines. At 20 features, this is 500+ lines of pure copy-paste. Fixes in next 1-2 features or you'll regret it.
       2. emit_expr/emit_stmt dispatchers (SOON) — At 30 features with 50 expression types, this is 2-3 pages of matching code that becomes a code navigation nightmare. Refactor to registry-based dispatch.
       3. String type system (MEDIUM TERM) — Works for 10 features, but when you add generics or function types (feature #15–20), the CSV parsing becomes a maintenance burden. Switch to enum-based ValueType.
       4. VarEnv lookup (LONG TERM) — Only hurts with large codebases. At 100 functions × 50 variables × 5 scopes = 25,000 lookups, you'll see compilation slowdown. Not critical now, but plan for it.
       5. Module preprocessor (NEVER) — Unlikely to matter unless you're loading 100+ source files into a single compilation unit. Probably fine as-is, but beware if you add incremental compilation.

       ---
       WHAT'S ACTUALLY FINE

       - ExprList/StmtList recursion: Works fine for typical expression depth (max 50 args to a function). Don't flatten them yet.
       - EmitResult shape: Works well for error propagation. No change needed.
       - VarEnv design (structurally): Singly-linked list is appropriate for scope stacks. The O(n) lookup is a problem in scale, not design.
       - Type registries (StructReg, EnumReg): Linear linked lists are fine. At 100 types, an O(n) lookup is still <1ms.

       ---
       ACTION ITEMS (IN PRIORITY ORDER)

       NOW (Before feature #12)

       - Replace Ctx copy-helpers with a FeatureData union or map (1-2 hours)
       - Document the fields of Ctx; freeze new non-essential fields (30 minutes)

       Before feature #20

       - Refactor emit_expr/emit_stmt to registry-based dispatch instead of massive match statements (4-6 hours)
       - Replace ty: string with ty: ValueType enum (6-8 hours, large refactor)

       Before feature #50

       - Implement a VarMap structure for faster variable lookup (2-3 hours, optional perf optimization)
       - Audit module preprocessor for any real-world file counts (1 hour, probably unnecessary)

       Documentation

       - Add comments to emit_expr/emit_stmt explaining the feature dispatch pattern
       - Document the type tag convention and CSV parsing rule for tuples

       ---
       FINAL VERDICT

       The bootstrap is well-structured for 10–15 features but will become unmaintainable at 30+ without the refactors above. The Ctx boilerplate is the most immediate pain point; the string type system is the most fundamental issue. Start addressing these in the next 1-2 feature additions before they become technical debt.
  ⎿  Done (41 tool uses · 167.1k tokens · 2m 26s)
