# Avra Bootstrap Grammar

Assembled from `packages/std-avrac/src/features/*/grammar.md`.

---

# closures (lambdas)

## Syntax

```
lambda           = lambda_params "->" lambda_body
lambda_params    = "(" param_list? ")"
param_list       = param ("," param)*
param            = IDENT (":" type_expr)?
lambda_body      = expression | "{" statement_list "}"

it_lambda        = expression           # any expr containing `it` in method-call
                                        # arg position is implicitly wrapped
                                        # in `(it) -> expression`
```

## Examples

```avra
let inc = (x: int) -> x + 1
let pair = (a, b) -> (a, b)
let id = () -> 42
let block_form = (x) -> {
    let y = x * 2
    y + 1
}
```

Implicit `it` parameter — Avra recognises a bare expression
containing `it` in method-call argument position and wraps it
in a single-arg lambda automatically:

```avra
let doubled = [1, 2, 3].map(it * 2)
// equivalent to
let doubled = [1, 2, 3].map((it) -> it * 2)
```

`it`-wrapping is detected by `expr_contains_it` in
`features/closures/parser.av`. It walks every container Expr
variant (Binary / Unary / Call / Block / etc.) so an `it`
nested arbitrarily deep still triggers the lambda wrap.

## Semantics

Closures capture their enclosing scope by-value. Captured
bindings travel inside the closure's environment struct
(sized at codegen time by `Closure(num_captures, ret)` in
`ValueType`). The runtime represents a closure as an array:
`[CLOSURE_MARKER, fn_ptr, capture_1, capture_2, ...]`.

Lambda types are inferred from usage when not annotated. A
lambda passed to `fn(int) -> int` has both parameter and
return type pinned by the call site.

## `it` pronoun availability

`it` is only auto-bound when the lambda appears as a method-call
argument (`xs.map(it * 2)`, `xs.filter(it > 0)`). In other
positions you must write the explicit param list — `(it) -> it
* 2` works anywhere but bare `it * 2` outside a method-call arg
parses as a normal expression referencing an `it` binding (which
will fail if no such binding is in scope).

## Pipeline placement

- Parser produces `Expr.Lambda(params, body)`.
- The `it`-wrap pass runs inline in the parser during method-call
  argument parsing (see `wrap_in_it_lambda` + the call sites that
  consult `expr_contains_it`).
- Resolve walks the body in a child scope where the params bind
  the names.
- Type-check infers param types from the call site if not
  annotated.
- Codegen emits a function (mangled with a synthesised name) plus
  the closure-array allocation at the lambda site.

---

# component declarations + instantiation

## Syntax

```
component_decl   = "component" IDENT implements? "{" component_body "}"
implements       = "implements" ident_list

component_body   = config_block? children_block? init_or_methods

config_block     = "config" "{" config_field ("," config_field)* "}"
config_field     = IDENT ":" type_expr ("=" expression)?

children_block   = "children" "{" children_field ("," children_field)* "}"
children_field   = IDENT ":" "List" "<" IDENT ">"

component_block  = IDENT IDENT? "{" component_block_body "}"
                                       # `<comp_name> <instance>? { config, … }`
```

## Semantics

Components are the declarative-layer primitive of Components V2
(`vez6`). A `component foo { … }` declaration combines:

- a typed config schema (with optional defaults),
- a child-slot schema (which other component types can nest
  inside this one),
- methods or init logic,
- optional trait conformances (`implements Display`).

A `component_block` is an instantiation — it provides config
overrides and child instances, and the expansion pass splices
the result into the surrounding scope.

## Two flavours of component

### Data component (no `init`)

A component without an `init` function expands to:

- A struct type (`type Foo = { name: string, …config fields…,
  …children slot fields… }`).
- A factory function (`fn foo_new(name: string) -> Foo`) that
  fills in config defaults + zeroed children lists.
- One impl method per non-init method declared in the body.

```avra
component user {
    config {
        admin: bool = false,
        role: string = "guest",
    }

    fn describe(self) -> string {
        "${self.name} (${self.role})"
    }
}

let alice = user "alice" { admin: true, role: "admin" }
println(alice.describe())
```

### Template component (with `init`)

A component with an `init` function expands by inlining the
init body into the surrounding scope at instantiation sites,
rewriting `self.config.*` references to the supplied values.
Templates exist for the declarative-builder pattern (cli
commands, lsp handlers) where the "object" isn't really an
object — it's a piece of imperative setup parameterised by
config.

Phase 10 (`vez6.10`) deletes the template path; all current
template uses migrate to the data + `@expand` macro shape.

## Self-referenced fields

Inside a component body, the receiver `self` exposes:

- `self.name` — the implicit instance-name string (always
  present).
- `self.<config_field>` — resolved config value (user override
  or schema default).
- `self.<children_slot>` — the list of nested-child instances.
- (template only) `self.__parent`, `self.__parent_name` — the
  enclosing accumulator and its instance name. Goes away with
  vez6.10.

## Examples

Children + multi-component layout:

```avra
component menu {
    children {
        items: List<menu_item>,
    }
}

component menu_item {
    config {
        label: string,
        kind: string = "action",
    }
}

let m = menu "file" {
    menu_item "open"  { label: "Open…" },
    menu_item "save"  { label: "Save"   },
    menu_item "quit"  { label: "Quit", kind: "exit" },
}
```

The expansion produces:
- `type Menu = { name: string, items: List<MenuItem> }`
- `type MenuItem = { name: string, label: string, kind: string }`
- `fn menu_new(name) -> Menu` + `fn menu_item_new(name) -> MenuItem`
- A construction sequence that creates each child instance and
  pushes it onto its parent's slot.

## Pipeline placement

- Parser produces `Stmt.ComponentDef(name, implements, config,
  children, body, ...)` for declarations and
  `Stmt.ComponentBlock(comp_name, instance, config_pairs,
  body)` for instantiations.
- `expand_components` (in `features/component_decl/expand.av`)
  is the first non-resolver pass:
  1. `collect_component_defs` walks once, registering every
     def's schema + body.
  2. `expand_stmt_list` walks the program splicing in the
     synthesised struct + factory + methods at every def site,
     and the construction sequence at every block site.
- @expand-annotated component defs (vez6.8.5) are SKIPPED by
  the legacy expander — their instances route through
  `features/comptime/expand_macro.av` instead.

## Spec reference

Design doc: `docs/2026_05_08_COMPONENTS_V2_DESIGN.md`. The
epic `vez6` tracks all component-related work; phases 1–10
cover the design surface.

---

# @comptime + @expand (compile-time evaluation + macro expansion)

## Syntax

```
comptime_attr  = "@comptime"
expand_attr    = "@expand" "(" expression ")"

comptime_fn    = comptime_attr fn_decl
expand_target  = expand_attr decl
```

`@comptime` annotates a function declaration; `@expand`
annotates any declaration whose AST should be replaced at
compile time by the result of evaluating the named macro
function.

## Semantics

### @comptime functions

A function annotated `@comptime` becomes evaluable at compile
time. When the compiler sees a call to such a function with
fully-known arguments (literals or other comptime values), it
evaluates the call via the bundled tree-walking interpreter
and substitutes the result into the AST. No runtime call
survives.

```avra
@comptime
fn double(n: int) -> int { n * 2 }

let four = double(2)  // codegen sees `let four = 4`
```

### @expand macros

A function annotated `@comptime fn` that returns an AST value
(via `quote { … }`) can serve as a macro. Apply it to a
declaration with `@expand(name)`:

```avra
@comptime
fn derive_show(stmt: Stmt) -> Stmt {
    quote stmt {
        impl ~type_name(stmt) {
            fn show(self) -> string { ... }
        }
    }
}

@expand(derive_show)
type User = { id: int, name: string }
```

The `@expand` pass walks the AST and replaces every annotated
declaration with the macro's evaluated output.

## Pipeline placement

The two pieces are separate passes in the compile pipeline:

```
resolve_names → expand_macros → run_comptime → typecheck
```

- **expand_macros** runs first. It walks for `@expand`
  declarations, evaluates each macro fn against its decl
  argument, and splices the resulting AST node in place. Also
  handles the component-instance dispatch case (vez6.8.5) where
  a ComponentBlock instance routes through its def's `@expand`.
- **run_comptime** runs next. It folds every call to a
  `@comptime` fn with comptime-known arguments into the
  evaluated literal. Fast-path: programs with zero `@comptime`
  fns short-circuit without walking the AST.

Both passes pre-typecheck so the typechecker sees the
post-evaluation AST — no comptime nodes survive into the type
system or codegen.

## Why two passes

- `@expand` replaces a *declaration* with a different AST
  shape. It runs early so subsequent passes (resolver,
  typecheck) see the expanded form.
- `@comptime` folds *call sites* into literals. It runs after
  `@expand` because expanded code may itself contain
  comptime-call sites that should fold.

## Quoting + splicing

Macro bodies build their output via `quote { … }` (capture an
AST as a runtime value) and `~name` (splice a runtime AST
value into a quote body). See
`features/quote_expr/grammar.md` for the full quoting surface.

## Performance shape

- `collect_comptime_fns` walks the program once and registers
  every `@comptime` fn in a `CompTimeRegistry` (Map-indexed
  for O(1) lookup at call sites).
- `prepare_runtime` pre-loads the registry's fns into the
  shared evaluator Runtime — folding reuses one Runtime
  instance across every call site.
- The presence-scan fast-path in `expand_macros` /
  `run_comptime` skips the entire walk when no relevant
  annotations exist in the program.

## Examples

Pure compile-time constant fold:

```avra
@comptime
fn fact(n: int) -> int {
    if n <= 1 { 1 } else { n * fact(n - 1) }
}

let f5 = fact(5)  // codegen sees `let f5 = 120`
```

Macro-driven impl generation (real use today is
`features/marshal/derive.av`, which is implemented as a
hand-rolled pre-resolve pass rather than @comptime+@expand,
but the surface for user-level macros is the same):

```avra
@expand(derive_marshal)
type User = { id: int, name: string }
// expand_macros produces:
//   type User = { id: int, name: string }
//   impl User { fn to_bytes(self) -> bytes { ... } }
//   fn from_bytes_User(b: bytes) -> User { ... }
```

## Spec reference

Components V2 design doc: `docs/2026_05_08_COMPONENTS_V2_DESIGN.md`
sections 3.1 (comptime fold), 3.2 (quote/splice), 3.6 (expand).

---

# defer / errdefer statement

## Syntax

```
defer_stmt    = "defer" expression
errdefer_stmt = "errdefer" expression
```

Both forms accept any expression — typically a function call
that releases a resource — and stop at end-of-line.

## Semantics

`defer expr` runs `expr` at scope exit, in **LIFO order** with
respect to other `defer` / `errdefer` statements in the same
scope. The expression's result is discarded; defers exist for
their side effects.

`errdefer expr` is identical except it only fires on **error
exit** — when the enclosing function returns via `Result.Err(_)`
propagated by `?` or via `return Result.Err(_)`. Success paths
skip the errdefer entirely.

Both are spec Axis 12.7 (defer / errdefer — LIFO ordering).

## Examples

```avra
fn read_file(path: string) -> Result<string, IoError> {
    let f = file_open(path)?
    defer file_close(f)

    let buf = alloc_buf()
    errdefer free_buf(buf)

    let content = file_read(f, buf)?
    Result.Ok(content)
    // on success: defers fire LIFO — file_close(f).
    // on error from file_read?: errdefers + defers fire LIFO —
    //   free_buf(buf) then file_close(f).
}
```

Multiple defers stack:

```avra
fn nested() {
    defer println("1")
    defer println("2")
    defer println("3")
    // prints: 3, 2, 1
}
```

## Ordering

Inside a single scope, every `defer` and `errdefer` is pushed
onto the `DeferStack` for that function. On scope exit the
codegen pops in LIFO order. On error exit (via `?` or explicit
`return Result.Err`), every `errdefer` runs in addition to every
`defer`; on success exit, only `defer` runs.

Nested blocks each get their own stack — a `defer` inside an
`if`'s then-branch fires when the if-block exits, not when the
enclosing function returns.

## Codegen layout

The `Ctx.rc_cleanup` / `DeferStack` carry per-function defer
state through codegen. Each `Stmt.Defer(body)` emission pushes a
`Frame` onto the stack; each scope-exit emit-site (return /
fall-through / break / `?` propagation) walks the stack
filtered by whether this exit is success or error, emitting the
LIFO sequence inline.

`errdefer`'s filter is the `is_error` flag passed to
`emit_stack_filtered` — error-exit emit sites set it to 1, normal
exits to 0.

## Pipeline placement

- Parser produces `Stmt.Defer(body)` / `Stmt.Errdefer(body)`.
- Resolve walks the body in the current scope.
- Type-check accepts any expression type (return value
  discarded).
- Codegen pushes onto the per-function DeferStack at the
  statement's emit site, then unwinds at every exit point.

---

# enum — grammar fragment

```ebnf
EnumDecl    ::= 'enum' Ident '{' VariantList '}'
VariantList ::= (Variant (',' | <newline>) Variant)*
Variant     ::= Ident ('(' VariantFields ')')?
VariantFields ::= (Field (',' Field)*)?
```

---

# Result<T, E> + `?` propagation

## Syntax

```
result_ctor = "Result" "." "Ok" "(" expression ")"
            | "Result" "." "Err" "(" expression ")"

try_expr    = postfix_expr "?"
```

## Semantics

`Result<T, E>` is the canonical fallible-value enum surfaced
across the language and stdlib. It has two variants:

- `Ok(value: T)` — successful result.
- `Err(error: E)` — failure carrying an `E`-typed reason.

The `?` operator on an expression of `Result<T, E>` type:

- If the value is `Ok(v)`, unwraps to `v` (the expression's
  result is `v: T`).
- If the value is `Err(e)`, returns `Err(e)` from the enclosing
  function — every `errdefer` on the way out fires (Axis 12.7).

The enclosing function's return type must itself be `Result<_, F>`
for some `F` assignable from `E` (auto-widening through union
error types — Axis 12.5).

## Examples

Direct unwrap-or-propagate:

```avra
fn read_user(id: int) -> Result<User, IoError> {
    let raw = fetch_row(id)?     // unwraps Ok, returns Err
    let parsed = parse_user(raw)?
    Result.Ok(parsed)
}
```

Pattern-match consumption:

```avra
match read_user(42) {
    .Ok(u)  -> println("got ${u.name}")
    .Err(e) -> println("failed: ${e}")
}
```

`catch` recovery (Axis 12.6):

```avra
let user = read_user(42) catch (e) { default_user() }
```

## Result on tuple Ok types

`Result<(T, U), E>` works end-to-end including `?` propagation
into a let-destructure:

```avra
fn step() -> Result<(int, BytesReader), MarshalError> { ... }

fn consume() -> Result<int, MarshalError> {
    let r = bytes_reader(b)
    let (n, r) = r.try_read_int()?
    let (m, _) = r.try_read_int()?
    Result.Ok(n + m)
}
```

The `?` extracts the tuple, the let-destructure binds each
element. Codegen routes the Ok payload type through
`resolve_ok_type_with(name, type_args)` which prefers the
type_args-supplied substitution over the enum registry's
generic payload form. nce6.3 plumbing.

## Auto-widening at `?`

When the inner Result's error type is a strict subset of the
enclosing function's error type, `?` auto-widens:

```avra
fn parse() -> Result<int, ParseError> { ... }
fn fetch() -> Result<bytes, IoError> { ... }

fn run() -> Result<int, ParseError | IoError> {
    let raw = fetch()?     // IoError widens into the union
    parse()                // ParseError widens into the union
}
```

Union widening is implemented in `features/null_safety/codegen.av`
via `emit_union_wrap`.

## Where `?` does NOT propagate

- A function whose return type is NOT a Result (and NOT
  nullable `T?`). `?` triggers a type-check error.
- Inside a closure if the closure's return type isn't a Result
  — `?` inside `xs.map((x) -> compute(x)?)` would fail because
  the lambda's return type is `T`, not `Result<T, _>`.

## Spec reference

Axis 12 (Error handling). Result is one of the language's
small set of universal types that every user is expected to
know — like `int`, `string`, `bool`.

---

# extern — grammar fragment

```ebnf
ExternFnDecl ::= 'extern' 'fn' Ident '(' Params ')' ('->' Type)?
```

---

# fn — grammar fragment

```ebnf
FnDecl    ::= 'fn' Ident '(' Params ')' ('->' Type)? Block
Params    ::= (Param (',' Param)*)?
Param     ::= Ident (':' Type)?
```

---

## For Statement

```ebnf
for_stmt  ::= "for" IDENTIFIER "in" expr ".." expr block
```

The loop variable is scoped to the body, incremented by 1 each
iteration, and the range is half-open (start inclusive, end exclusive).

---

## Generics

```
<type_params>  ::= "<" IDENTIFIER ( "," IDENTIFIER )* ">"
<fn_decl>      ::= "fn" IDENTIFIER <type_params>? "(" <params> ")" ( "->" <type> )? "{" <body> "}"
<type_decl>    ::= "type" IDENTIFIER <type_params>? "=" "{" <fields> "}"
<enum_decl>    ::= "enum" IDENTIFIER <type_params>? "{" <variants> "}"
<type_ref>     ::= IDENTIFIER ( "<" <type_ref> ( "," <type_ref> )* ">" )? "?"?
```

---

# if — grammar fragment

```ebnf
IfStmt ::= 'if' Expr Block ('else' Stmt)?
IfExpr ::= 'if' Expr Block ('else' (IfExpr | Block | Expr))?
```

---

# impl — grammar fragment

```ebnf
ImplDecl       ::= 'impl' Ident '{' ImplMethods '}'
ImplMethods    ::= ImplMethod*
ImplMethod     ::= 'fn' Ident '(' MethodParams ')' ('->' Type)? Block
MethodParams   ::= 'self' (':' Type)? (',' Params)?
                 | Params
```

---

# in operator (membership test)

## Syntax

```
in_check = postfix_expr "in" "[" (expression ("," expression)*)? "]"
```

The right-hand side is always a bracketed list literal — `in`
is purely a literal-set membership test, not a general
container probe. Use `xs.contains(x)` for list-variable
membership.

## Semantics

`x in [a, b, c]` evaluates to `true` when `x` equals any of the
listed expressions. Lowering: the expression is desugared into
the equivalent `x == a || x == b || x == c` chain at codegen
time, so the actual equality semantics match `==` for the
operand types.

Practical use is variant-or-tag matching where listing the
options inline is clearer than a `match`:

```avra
enum Color { Red, Green, Blue, Yellow }

fn is_primary(c: Color) -> bool {
    c in [.Red, .Green, .Blue]
}
```

Numeric:

```avra
let allowed = code in [200, 201, 204]
```

String:

```avra
let is_vowel = ch in ["a", "e", "i", "o", "u"]
```

## Lowering

Each `Expr.InCheck(needle, items)` lowers to a left-associated
disjunction of `==` checks. The lowering preserves operand
order so the first equal element short-circuits the rest.

For empty `x in []`, the result is `false` — no element is
equal to `x`.

## Pipeline placement

- Parser produces `Expr.InCheck(needle, items: ExprList)`.
- Resolve walks the needle and every item.
- Type-check unifies all item types with the needle's type;
  mismatches surface as the same diagnostic any `==` mismatch
  would.
- Codegen emits the equality-disjunction chain via
  `features/in_operator/codegen.av`, reusing `emit_binary(Eq)`
  for each comparison so enum-tag / string / nullable handling
  comes through automatically.

## Why not `xs.contains(x)`

`in` is intentionally restricted to literal lists so the
operand list is part of the source — readable as a set of
options the author intended. For dynamic membership (`xs` is a
variable), use the explicit method form so the call site stays
honest about what's being scanned.

---

# is operator (type-narrowing test)

## Syntax

```
is_check = postfix_expr "is" variant_pattern
variant_pattern = "." IDENT
```

## Semantics

`expr is .Variant` evaluates to `true` when `expr`'s enum tag
matches `Variant`. In a flow-sensitive context (the `then`
branch of an `if`, the body of a `match` arm), the type-checker
also narrows `expr`'s type to `NarrowedEnum(enum, variant)` so
payload field accesses don't need an explicit destructure.

`is` works on:

- Concrete enums declared with `enum Foo { ... }`.
- Union-aliased shapes (`type Json = string | int | bool`)
  where the "variant" is the type tag.

## Examples

Tag check:

```avra
enum Status { Pending, Active(user: string), Failed(reason: string) }

let s = Status.Active("alice")
if s is .Active {
    // s is narrowed to NarrowedEnum(Status, "Active")
    println("user: ${s.user}")
}
```

Without the narrowing the same shape would require a match
arm; `is`-flow is the lightweight form for one-variant checks.

Union narrowing:

```avra
type Json = string | int | bool

fn render(j: Json) -> string {
    if j is .string { return j }
    if j is .int { return string(j) }
    if j is .bool { return if j { "true" } else { "false" } }
    ""  // unreachable per exhaustive-match lint
}
```

## Codegen layout

`Expr.IsCheck(subject, variant)` lowers to a tag-compare:

1. Evaluate `subject` to its enum pointer.
2. Load the i64 tag at offset 0 of the enum's `{tag, payload}`
   layout.
3. Compare against the variant's djb2 hash (the stable id used
   throughout codegen for variant dispatch).
4. ZExt the i1 result to i64-stored bool.

Union-tag `is` checks compare against the i64 type-tag in the
union's tagged-union runtime shape.

## Pipeline placement

- Parser produces `Expr.IsCheck(subject, variant_name)`.
- Resolve walks the subject.
- Type-check narrows: in flow-sensitive positions, the
  positive branch sees `subject` as
  `ValueType.NarrowedEnum(enum_name, variant_name, id)`.
- Codegen emits the tag-compare in
  `features/is_keyword/codegen.av`.

## Spec reference

Axis 11.2 (flow-sensitive type narrowing).

---

# isolated expression

## Syntax

```
isolated_expr = "isolated" "{" statement_list "}"
```

## Semantics

`isolated { body }` runs `body` in a forked subprocess (POSIX
`fork(2)` + anonymous pipe). The child inherits the parent's
memory via copy-on-write — closure captures travel for free
without explicit marshaling. Only the *return value* crosses the
IPC boundary.

Today (Phase A–C of `nce6`): the keyword produces a framed
`bytes` payload. Stdlib wrappers (`isolated_int`,
`isolated_string`, `isolated_bytes`, plus per-T `isolated_<T>`
synthesised by `@marshal`) unwrap the frame into
`Result<T, IsolatedError>`.

Phase D (`nce6.2`): the keyword itself returns
`Result<T, IsolatedError>` for any T whose type carries
`@marshal` — codegen looks up T from the body's type, wraps the
body in `() -> body.to_bytes()`, and routes the framed bytes
through `from_bytes_<T>`. Not yet shipped.

## Crash semantics

A `SIGSEGV`, `abort()`, or non-zero exit in the child surfaces
to the parent as `Result.Err(IsolatedError.Crashed)` — the
parent process stays alive. `fork(2)` failure (out of pids,
ulimit) surfaces as `IsolatedError.ForkFailed`. IPC pipe failure
mid-transfer surfaces as `IsolatedError.PipeFailed`.

## Examples

### Today (bytes-payload + stdlib wrapper)

```avra
use @std.process.{isolated_int}

let r = isolated_int(() -> 1 + 1)
match r {
    .Ok(n)  -> println("got ${n}")
    .Err(_) -> println("child crashed")
}
```

### With `@marshal` (per-T wrapper synthesised)

```avra
@marshal
type Report = { total: int, errors: List<string> }

match isolated_Report(() -> run_check("/some/path")) {
    .Ok(r)  -> println("found ${r.errors.length} errors")
    .Err(_) -> println("subprocess crashed")
}
```

### Future Phase D — keyword form

```avra
@marshal
type Report = { total: int, errors: List<string> }

let r: Result<Report, IsolatedError> = isolated {
    run_check("/some/path")
}
```

## Pipeline placement

The parser hands an `Expr.Isolated(body)` node to the resolver.
Resolve walks the body in the enclosing scope (matches `spawn`
semantics). Type-check declares the result type as `Bytes`
today; codegen wraps the body in a zero-arg lambda producing
`bytes` and calls `avra_isolated_run(closure)` to get the
framed payload back.

The runtime (`avra_isolated_run` in `runtime.c`) takes the
fork + pipe + wait4 path, framing the child's return as
`[i64 status][i64 length][payload bytes]`. Status `0` is OK;
`1` is crashed; `2` is fork failed; `3` is pipe failed.

## Captures

Avra closures capture by-value. Inside `isolated { body }`, the
captured environment is the parent process snapshot at the
moment of `fork(2)` — every binding referenced by `body` sees
the same value the parent had. No marshaling step is needed
for captures because the child literally inherits the address
space. Only the return value needs to cross the pipe.

---

# let / mut — grammar fragment

```ebnf
LetStmt ::= 'let' 'mut'? Ident (':' Type)? '=' Expr
MutStmt ::= 'mut' Ident (':' Type)? '=' Expr
```

---

# list literal

## Syntax

```
list_lit = "[" (expression ("," expression)*)? "]"
```

## Semantics

`[a, b, c]` evaluates each element left-to-right and pushes
into a freshly allocated `List<T>`. The element type `T` is
pinned by the first element's type; subsequent elements must be
assignable to it.

Empty literal `[]` evaluates to a `List<Unknown>` whose element
type is fixed by the first inferring use (e.g.
`let xs: List<int> = []` pins `T = int`).

## Examples

```avra
let nums = [1, 2, 3]                       // List<int>
let names = ["alice", "bob", "carol"]      // List<string>
let nested = [[1, 2], [3, 4]]              // List<List<int>>
let empty: List<int> = []                  // List<int>, zero-length
```

Expressions inside literals are evaluated in source order:

```avra
mut i = 0
let xs = [{ i = i + 1; i }, { i = i + 1; i }]
// xs == [1, 2]
```

Lists are immutable by value-binding but their methods produce
new lists. `push` returns the list with one more element rather
than mutating in place:

```avra
let xs = [1, 2]
let ys = xs.push(3)
// xs == [1, 2], ys == [1, 2, 3]
```

## Runtime layout

A `List<T>` is a pointer to `avra_array_*`-managed memory. Each
literal site emits an `avra_array_new` call followed by an
`avra_array_push` per element. Element values are stored
inline (i64 for primitives, ptr for heap-allocated types).

## Pipeline placement

- Parser produces `Expr.ListLit(elements: ExprList)`.
- Resolve walks every element expression.
- Type-check unifies element types — first non-Unknown element
  pins `T`; subsequent elements must be assignable to `T`.
- Codegen emits the array-build sequence in `list_lit/codegen.av`.

## Higher-order methods

List literals interop with the language's HOF surface — `map`,
`filter`, `fold`, `push`, `length`, indexing — implemented in
the runtime against the same array primitives. The element-type
inference + the implicit `it` lambda pronoun (see
`features/closures/grammar.md`) let common patterns stay terse:

```avra
let doubled = [1, 2, 3].map(it * 2)
let evens = [1, 2, 3, 4].filter(it % 2 == 0)
let sum = [1, 2, 3].fold(0, (acc, x) -> acc + x)
```

---

# map literal

## Syntax

```
map_lit   = "{" (map_entry ("," map_entry)*)? "}"
map_entry = expression ":" expression
```

The opening `{` is disambiguated from a block by context — only
positions that accept an expression of map type parse a literal
this way.

## Semantics

`{ k1: v1, k2: v2 }` evaluates each key and value left-to-right
and inserts into a freshly allocated `Map<K, V>`. Avra's v1.0
map is string-keyed; non-string keys aren't supported (open
sub-ticket).

Empty literal `{}` parses as a Map only in contexts where Map
is the expected type — otherwise it's a block.

## Examples

```avra
let counts = { "alice": 3, "bob": 5, "carol": 7 }
let empty: Map = {}
```

Combined with `with` for functional update isn't supported on
maps yet; use the builder pattern instead:

```avra
mut m = { "a": 1 }
m = m.set("b", 2)
m = m.set("c", 3)
```

## Runtime layout

A `Map` is a pointer to `avra_map_*` C-runtime storage —
hashed string keys, i64/ptr values. Each literal site emits an
`avra_map_new` plus one `avra_map_set` per entry. Key
expressions must evaluate to a string at runtime.

## Pipeline placement

- Parser produces `Expr.MapLit(entries: ExprList)` where
  entries alternates key, value, key, value, … (flat list, not
  paired — keeps the AST shape uniform with `Expr.ListLit`).
- Resolve walks each entry expression.
- Type-check pins V from the first value entry (or annotated
  context) and validates keys are strings.
- Codegen emits the map-build sequence in
  `features/map_lit/codegen.av`.

## v1.0 limitations

- String keys only — `Map<int, V>` etc. are tracked as a separate
  spec item.
- No literal-position `{}` outside an expected-Map type slot;
  use `Map.new()` or an annotated `let m: Map = {}` for
  empty-map construction.

---

# @marshal derive

## Syntax

```
marshal_attr   = "@marshal"
struct_decl    = marshal_attr? "type" IDENT "=" "{" field_list "}"
enum_decl      = marshal_attr? "enum" IDENT "{" variant_list "}"
```

The `@marshal` annotation lives in the standard `AnnotationList` slot
that precedes any declaration — no new grammar production. Detection
happens in the post-resolve pass `features/marshal/derive.av`, which
walks the AST and synthesises codec functions next to every annotated
type.

## What gets synthesised

For each `@marshal type T = { f1: TY1, f2: TY2, ... }`:

```
impl T {
    fn to_bytes(self) -> bytes { ... }
}
fn from_bytes_T(b: bytes) -> T { ... }
fn isolated_T(body: fn() -> T) -> Result<T, IsolatedError> { ... }
```

For each `@marshal enum T { V0, V1(...), V2(...) }`:

```
impl T {
    fn to_bytes(self) -> bytes { match self { ... } }
}
fn from_bytes_T(b: bytes) -> T { ... }
fn isolated_T(body: fn() -> T) -> Result<T, IsolatedError> { ... }
```

`from_bytes_<T>` is a top-level function, not an `impl T` method,
because Avra has no static-method syntax — `T.from_bytes(b)` parses
as enum-variant access.

`isolated_<T>` is the per-T equivalent of a generic
`isolated<T: Marshal>(body)` — runs `body` in a forked subprocess
and ships its return value back via `to_bytes`/`from_bytes_<T>`.

## Wire format

Concatenated, little-endian, no header:

| Field type                  | Bytes                                                  |
|-----------------------------|--------------------------------------------------------|
| `int`                       | 8 (i64)                                                |
| `bool`                      | 8 (i64; 0 or 1)                                        |
| `float`                     | 8 (IEEE-754 double)                                    |
| `string`                    | 8 length-prefix + UTF-8 payload                        |
| `List<int>`                 | 8 count + count × 8                                    |
| `List<bool>`                | 8 count + count × 8                                    |
| `List<string>`              | 8 count + count × length-prefixed payload              |
| `List<float>`               | 8 count + count × 8                                    |
| nested `@marshal` struct    | 8 length-prefix + inner `to_bytes()` payload           |
| `List<NestedMarshalStruct>` | 8 count + count × (8 length-prefix + inner payload)    |
| `@marshal` enum             | 8 tag (source-order variant index) + payload-as-above  |

Enum tag ordering matches source declaration order; adding a variant
at the end stays backwards-compatible, inserting in the middle does
not.

## Supported field types

Today (this commit):

- Primitives: `int` / `bool` / `string` / `float`.
- Homogeneous lists of any supported primitive.
- Nested `@marshal` structs (recursive).
- **Lists of nested `@marshal` structs** — synthesised as an inline
  `mut __b = base.write_int(len); for x in xs { __b = __b.write_bytes(x.to_bytes()) }`
  block-expr on the write side, and a `while __i < count` loop
  calling `from_bytes_<Inner>` on the read side.
- Enum variants whose payload fields are any of the above
  (primitives, lists, nested @marshal structs — all work).

Open (separate sub-tickets):

- `Map<K, V>` — key/value iteration; v1.0 may be intentionally
  excluded per the parent ticket.
- Nullable `T?` — blocked on `TypeExpr.Optional` being preserved in
  `ValueType` (currently lowered to `T`).

## Examples

### Struct round-trip

```avra
use @std.process.{bytes_builder, bytes_reader}

@marshal
type User = { id: int, name: string, admin: bool }

let u = User { id: 7, name: "alice", admin: true }
let b = u.to_bytes()
let u2 = from_bytes_User(b)
// u2.id == 7, u2.name == "alice", u2.admin == true
```

### Enum round-trip

```avra
@marshal
enum Status { Active, Pending(count: int), Failed(reason: string) }

let s = Status.Pending(42)
let s2 = from_bytes_Status(s.to_bytes())
// match s2 { .Pending(c) -> c == 42, ... }
```

### Across a fork boundary

```avra
@marshal
type Report = { total: int, errors: List<string> }

fn run_check(path: string) -> Report {
    // ... heavy work ...
    Report { total: 100, errors: ["bad-line:42"] }
}

match isolated_Report(() -> run_check("/some/path")) {
    .Ok(r)  -> println("found ${r.errors.length} errors")
    .Err(_) -> println("subprocess crashed")
}
```

## Pipeline placement

`derive_marshal` runs in the build pipeline as:

```
lower_quotes → desugar → inject_intrinsics → expand_components
  → derive_marshal → resolve_names → expand_macros → run_comptime
  → typecheck → monomorphize → codegen
```

Pre-resolve means the synthesised `impl T` is processed by
`resolve_names` together with the user's type declaration, so name
qualification stays consistent. The synthesised body calls
`@std::process::bytes_builder` (qualified) so consumers don't need
to `use` the byte primitives.

## Why not a trait

The ticket asked for a `trait Marshal { to_bytes; from_bytes }` with
generic `isolated<T: Marshal>(body)`. The pragmatic shortcut here is
per-T monomorphic synthesis — the user-facing DX is identical and the
language doesn't yet need trait-bound generics. Switching to a real
trait is a transparent refactor once those land.

---

# match — grammar fragment

```ebnf
MatchStmt    ::= 'match' Expr '{' MatchArm* '}'
MatchExpr    ::= 'match' Expr '{' MatchArm* '}'    (* in expression position *)

MatchArm     ::= Pattern '->' Expr ','?

Pattern      ::= '_'                               (* wildcard *)
               | '.' Ident                         (* nullary variant *)
               | '.' Ident '(' Bindings ')'        (* variant with payload bindings *)

Bindings     ::= Ident (',' Ident)*
               | '_'                               (* don't-bind placeholder *)
```

The arm body is parsed as an expression, but the parser temporarily
disables `.field` postfix consumption inside the arm body so the
next sibling pattern (`.Variant(...)`) on the following line isn't
gobbled into the previous body.

---

# modules + `use` / `mod`

## Syntax

```
mod_stmt   = "mod" IDENT             # sibling-file stub form
           | "mod" IDENT "{" stmts "}"  # inline-body form

use_stmt   = "use" path "." "{" name_list "}"
           | "use" path "." name
           | "use" "@" package_name dot_path "." "{" name_list "}"
path       = IDENT ("." IDENT)*
name_list  = name ("," name)*
name       = IDENT                   # plain import
           | IDENT "as" IDENT        # aliased import
```

## Semantics

A `mod foo` statement declares a sub-module. There are two
forms:

1. **Stub** (`mod foo`): the module resolver reads
   `./foo.av` relative to the declaring file and attaches the
   parsed body. Used for splitting large modules across files.
2. **Inline** (`mod foo { … }`): the body is right there in
   the source — no file I/O.

`use` statements bring names from another module / package
into the current scope. Three flavours:

- `use module.path.{name1, name2}` — relative module-tree
  navigation; `module.path` is a dot-separated chain of `mod`
  names rooted at the current package.
- `use @pkg.module.path.{...}` — cross-package import; `@pkg`
  resolves via the package manifest (`avra.toml`).
- `name as alias` — local rename for collision avoidance.

## Examples

Split-file module:

```avra
// foo.av
mod bar
mod baz

fn from_foo() { ... }
```

```avra
// foo/bar.av
fn from_bar() { ... }
```

Inline module:

```avra
mod helpers {
    fn shared() -> int { 42 }
}

fn caller() -> int {
    helpers.shared()
}
```

Cross-package import:

```avra
use @std.process.{bytes_builder, bytes_reader}
use @std.json.{json_str, json_object}
```

Aliased import:

```avra
use @std.process.{IsolatedError as IErr}
```

## Resolution pipeline

1. **Parser** produces `Stmt.Module(name, body)` for inline
   forms and `Stmt.Module(name, .End)` for stubs.
2. **resolve_module_files** (the only I/O pass in the
   pipeline) walks for stub modules, reads the corresponding
   `.av` files, parses each, and attaches the body. Stops on
   first error per file. Tracked under `LoadedPaths` to dedupe
   transitive imports.
3. **resolve_names** processes the now-complete AST: every
   `use` statement registers an alias from the bare name to
   its qualified form (`@std::process::bytes_builder`); every
   reference to a `use`d name is rewritten to
   `Expr.QualifiedIdent(canonical_path)`.

## Dir-as-module (g2eo.1)

A directory containing `mod.av` is also a module — its body is
the concatenation of `mod.av` + every sibling `.av` file in
the directory. This is how `@std/avrac/features/marshal/`
exposes `derive.av` alongside `mod.av` without an explicit
`mod derive` statement.

The resolver auto-loads siblings only when the entry lives
inside a real package's `src/` (parent dir has `avra.toml`).
Bare /tmp fixtures or ad-hoc files don't trigger sibling
loading — keeps test fixtures clean.

## Package layout

```
<package_root>/
    avra.toml              # manifest: name, version, deps
    src/
        <package_name>.av  # entry — or `mod.av` for dir-form
        <sibling1>.av
        <sibling2>.av
        <subdir>/
            mod.av         # nested module via dir-form
            <leaf>.av
```

Cross-package `use @pkg.…` resolves `@pkg` against:
- The current package's `avra.toml` `[dependencies]` table.
- The well-known `@std/*` packages bundled with the compiler.

## Pipeline placement

The whole module pipeline runs early — before name resolution
itself can complete — because every later pass needs the full
AST. Subsequent passes (`expand_components`, `derive_marshal`,
`resolve_names`, …) see a single flat tree with every module's
body inlined under its `Stmt.Module` wrapper.

---

## Null Safety

```
<null_coalesce> ::= <or_expr> ( "??" <or_expr> )*
<optional_chain> ::= <postfix_expr> "?." IDENTIFIER
```

---

# parallel statement

## Syntax

```
parallel_stmt = "parallel" "{" statement_list "}"
```

## Semantics

`parallel { s1; s2; s3 }` runs each top-level statement of the
body concurrently (one green thread per statement) and waits
for all to complete before returning. The statements share the
parent's lexical scope — captures work the same way as `spawn`
or `isolated`.

Avra's parallel is the structured-concurrency primitive: the
block doesn't exit until every spawned task has joined.
Compared to manual `spawn` + `join` pairs, parallel guarantees
no orphan tasks survive the block exit.

## Examples

```avra
parallel {
    fetch_alpha()
    fetch_beta()
    fetch_gamma()
}
// every fetch_* has completed by the time control reaches here
```

Captures from outer scope (by-value, like all closures):

```avra
let url_base = "https://example.com"
parallel {
    fetch("${url_base}/a")
    fetch("${url_base}/b")
}
```

Each statement is its own task — mixing different operations is
fine:

```avra
parallel {
    save_to_disk(results)
    upload_to_s3(results)
    log_metrics(results)
}
```

## Runtime layout

Codegen wraps each statement in a zero-arg closure (matching the
`avra_parallel_run` ABI), pushes every closure onto an array,
and emits a single call to `avra_parallel_run(closures)`. The
runtime spawns each as a green thread, blocks the caller until
every thread has joined, then frees the closure array.

Today (v1.0): tasks run on OS pthreads — the green-thread
runtime mentioned in spec Axis 18 is future work.

## Error semantics

If any spawned statement panics or returns an error, the parent
sees the failure after the block exits (the parent doesn't
short-circuit on the first failure — every statement still
runs). The detailed error-propagation rules are an open spec
item; today panics in a parallel statement are caught and
re-raised at the join point.

## Pipeline placement

- Parser produces `Stmt.Parallel(body: StmtList)`.
- Resolve walks each body statement in the enclosing scope.
- Type-check accepts any statement-typed body.
- Codegen lowers in `features/parallel_stmt/codegen.av` — one
  closure per body statement, batched into `avra_parallel_run`.

---

# quote / splice expression

## Syntax

```
quote_expr      = "quote" quote_kind? "{" quote_body "}"
quote_kind      = "stmt" | "stmts" | "type" | "decl"   # default is "expr"
quote_body      = expression                 # default kind
                | statement_list             # "stmts" kind
                | statement                  # "stmt" / "decl" kind
                | type_expression            # "type" kind

splice_expr     = "~" expression             # only inside a quote body
                                             # outside, ~ is unary bitwise NOT
```

## Semantics

`quote { body }` captures the AST of `body` as a runtime value
rather than evaluating it. The default kind produces an
`Expr`; the `stmt` / `stmts` / `type` / `decl` kinds produce
the matching AST shape.

`~target` inside a quote body **splices** — at evaluation time
the value of `target` (which must itself be an AST value) is
substituted into the constructed AST at that position. Outside
any quote body, `~` parses as `UnOp.BitNot`.

The lowering pass (`features/quote_expr/lower.av`) runs after
resolve_names and before typecheck. It walks each `Expr.Quote`
node and rewrites it as an AST-construction expression — a tree
of `Expr.Call`s that, when evaluated, rebuild the captured AST.

## Examples

```avra
use @std.avrac.core.{Expr, render_expr}

let e = quote { 5 + 3 }
render_expr(e) == "(+ 5 3)"
```

Splicing in a runtime AST value:

```avra
let inner: Expr = Expr.Number("7")
let outer = quote { 1 + ~inner }
render_expr(outer) == "(+ 1 7)"
```

Statement-quote produces a `Stmt` value:

```avra
let s: Stmt = quote stmt { let x = 5 }
render_stmt(s) == "(let x:<unknown> 5)"
```

StmtList-quote captures multiple stmts:

```avra
let sl: StmtList = quote stmts {
    let a = 1
    let b = 2
}
```

Identifier-position splice (a `~name` where a type-decl or
let-binding name is expected) substitutes a runtime string:

```avra
@comptime
fn make_pair_struct(field_name: string) -> Stmt {
    quote stmt { type Pair = { ~field_name: int, other: int } }
}
```

## Where quote is used

Avra's primary consumer is the AST-macro pipeline (Components V2 /
vez6). `@comptime` functions return AST values built with `quote`,
which the `@expand` pass splices into the surrounding program.
Direct user-facing use is rare; the language exposes it so the
macro authoring surface stays in-language rather than
host-language.

## Pipeline placement

- Parser produces `Expr.Quote(kind, body)` and
  `Expr.Splice(target)`. Inside-quote / outside-quote context
  is tracked at parse time.
- `lower_quotes(stmts)` runs after `resolve_names` and before
  `expand_macros` — typecheck never sees Quote / Splice nodes.
  Fast-path: zero-quote programs short-circuit via a
  non-allocating presence scan (most files).
- The lowering output is regular `Expr.Call(make_expr_*, args)`
  trees that build the runtime AST values. `Splice(target)`
  becomes a direct reference to `target` (whose runtime value
  must be the right AST shape).

## Kinds matrix

| Kind     | Body shape       | Result type     |
|----------|------------------|-----------------|
| (none)   | expression       | `Expr`          |
| `stmt`   | statement        | `Stmt`          |
| `decl`   | statement        | `Stmt`          |
| `stmts`  | statement list   | `StmtList`      |
| `type`   | type expression  | `ValueType`     |

---

# return — grammar fragment

```ebnf
ReturnStmt ::= 'return' Expr?
```

The expression is optional; an empty `return` becomes `RetEmpty`
in the AST and emits a zero value of the function's return type.

---

# select statement (channel multiplexing)

## Syntax

```
select_stmt   = "select" "{" select_arm ("," select_arm)* "}"
select_arm    = IDENT "<-" expression "->" "{" statement_list "}"
```

Each arm names a binding (`IDENT`), a channel expression (the
value to the left of `<-`), and a body. The first channel to
receive a value fires its arm with the received value bound to
its binding.

## Semantics

`select { ... }` blocks until any of its arms' channels has a
value ready, then runs that arm's body with the received value
bound. If multiple channels are ready simultaneously, one is
chosen non-deterministically — same semantics as Go's `select`.

The statement returns once the chosen arm's body completes.
There's no default-arm form yet; every `select` blocks until at
least one channel has data.

## Examples

```avra
let ch_a = channel<int>()
let ch_b = channel<string>()

spawn { ch_a.send(42) }
spawn { ch_b.send("hello") }

select {
    n <- ch_a -> { println("got int: ${n}") }
    s <- ch_b -> { println("got string: ${s}") }
}
```

Mixed channel element types are allowed — each arm's binding
takes the receiving channel's element type.

## Runtime layout

Codegen evaluates each arm's channel expression into a flat
array, calls `avra_select(channels, count)` (which blocks until
one channel has data), then reads `avra_select_index(result)`
to dispatch to the matching arm and `avra_select_value(result)`
to bind the received value.

The dispatch is an if-cascade on the index — each arm checks
whether `idx == N` and, if so, binds `val` to its named local
(under the arm's typed cast) and runs the body.

## Pipeline placement

- Parser produces `Stmt.Select(arms: SelectArmList)`. Each arm
  is `(binding, channel_expr, body_stmts, next)`.
- Resolve walks each channel expression in the enclosing scope,
  then each body with the arm's binding in scope.
- Type-check accepts any channel-typed expressions; arm
  bindings get the channel's element type.
- Codegen lowers in `features/select_stmt/codegen.av`:
  channel-array build → avra_select call → index-dispatch
  if-cascade.

## Spec reference

Axis 18 (Concurrency). `select` complements `spawn` and channel
primitives — multi-channel receive with non-deterministic fair
choice when multiple are ready.

---

# spawn expression

## Syntax

```
spawn_expr = "spawn" "{" statement_list "}"
```

## Semantics

`spawn { body }` wraps the body in a zero-argument closure and spawns it
as a new task. Returns an integer handle that can be passed to
`forge_thread_join(handle)` to wait for completion.

v1.0: tasks run on OS threads via pthreads. Future versions will use
cooperative green-thread scheduling per spec Axis 18.

## Examples

```avra
let h = spawn {
    println("hello from task")
}
forge_thread_join(h)
```

Captures from the enclosing scope work:

```avra
let msg = "world"
let h = spawn {
    println(msg)
}
forge_thread_join(h)
```

---

# spec / given / then (in-language test framework)

## Syntax

```
spec_block  = "spec" STRING_LITERAL "{" body "}"
given_block = "given" STRING_LITERAL "{" body "}"
then_block  = "then" STRING_LITERAL "{" expression "}"
```

`spec` outer blocks contain zero or more `given` setup blocks
and `then` assertions; `given` blocks contain zero or more
`then` assertions and may declare local setup state. The label
strings are free-form English.

## Semantics

Tests are first-class language constructs, not a separate
runner shape. A `*_test.av` file gets compiled into a shard
binary that:

1. Initialises the reporter state (C-side counters).
2. Walks the spec/given/then tree in source order.
3. Evaluates each `then` block as a boolean expression — true
   counts as PASS, false as FAIL.
4. Emits a `[shard-summary] pass=N fail=N total=N elapsed_ms=N`
   line at end-of-run.

The test runner orchestrator (`bs2 test` in `cli/main.av`)
spawns one shard per file, captures stdout, and aggregates.
Per-shard isolation via process boundary means a segfault in
one test file doesn't take down the rest of the run.

## Examples

Basic shape:

```avra
spec "addition" {
    then "1 + 1 == 2" {
        1 + 1 == 2
    }
    then "negative add" {
        let a = 0 - 5
        a + 5 == 0
    }
}
```

With a `given` setup:

```avra
spec "user creation" {
    given "fresh user" {
        let u = create_user("alice")
        then "id is positive" {
            u.id > 0
        }
        then "name matches" {
            u.name == "alice"
        }
    }
}
```

Test files live alongside source as `<feature>_test.av` —
either in `tests/` directories under a feature or at the
top-level `bootstrap/tests/` directory.

## Reporter

`features/spec_test/reporter.av` (inlined into every test
bundle) provides:

- `test_render_spec_start(name)` — prints the spec header.
- `test_render_given_start(name)` — prints the given subheader.
- `test_render_then(name, result, file, line)` — increments
  pass/fail, prints PASS/FAIL line + source location.
- `test_render_summary()` — prints the failure list + the
  summary line + the wall-clock total, also emits the
  machine-readable shard-summary marker.
- Optional structured outputs: writes a JSON file when
  `AVRA_TEST_RESULTS_PATH` is set; writes a 32-byte
  `@marshal`-compatible binary when `AVRA_TEST_RESULTS_BIN_PATH`
  is set (nce6.1.F).

## Failure tracking

When a `then` block evaluates false, the reporter records the
spec name, given name (if any), then label, source file, and
line into a C-side failure list (`avra_test_record_failure`).
At the end of the run, the failure list renders below the
PASS/FAIL summary so the user can jump to each failure's
source.

## Pipeline placement

- Parser produces `Stmt.SpecBlock(name, body)`,
  `Stmt.GivenBlock(name, body)`, `Stmt.ThenBlock(name, expr)`.
- The test_runner pass (`@std/avrac/test_runner`) walks the
  test file, wraps each then-block expression in a
  `test_render_then(name, expr, file, line)` call, and
  synthesises a top-level `fn main()` that calls the reporter
  begin/end functions plus every wrapped then.
- The synthesised main is what the shard binary actually runs.

## Discovery

Files ending in `_test.av` are picked up by `bs2 test`'s
discovery walker. Filter rules:

- Path must end in `_test.av`.
- File content must contain the literal `spec ` (a quick
  presence check — saves parsing files that aren't tests).
- File must not contain a top-level `fn main(`. Detection uses
  the `has_top_level_main` walker, which strips comments and
  leading whitespace so doc-comments mentioning `fn main()`
  don't accidentally exclude tests.

## Spec reference

Axis 27 (Testing as first-class).

---

# struct (type) — grammar fragment

```ebnf
TypeDecl    ::= 'type' Ident '=' '{' FieldList '}'
FieldList   ::= (Field (',' Field)*)?
Field       ::= 'mut'? Ident ':' Type

StructLit   ::= Ident '{' FieldInitList '}'
FieldInits  ::= (FieldInit (',' FieldInit)*)?
FieldInit   ::= Ident (':' Expr)?            (* shorthand: just `name` ≡ `name: name` *)
```

---

## Traits

```
<trait_decl>     ::= "trait" IDENTIFIER <type_params>? "{" <trait_methods> "}"
<trait_methods>  ::= ( "fn" IDENTIFIER "(" <params> ")" ( "->" <type> )? )*
<impl_for>       ::= "impl" IDENTIFIER "for" IDENTIFIER "{" <methods> "}"
```

---

## Tuples

```
<tuple_literal>    ::= "(" <expr> "," <expr> ( "," <expr> )* ")"
<tuple_index>      ::= <expr> "." NUMBER
<let_destructure>  ::= "let" "(" IDENTIFIER ( "," IDENTIFIER )* ")" "=" <expr>
```

---

# Union Types

## Syntax

```
// Type annotation
let x: int | string = 42
fn foo(val: int | string | bool) -> string { ... }

// Pattern matching
match val {
    int(n) -> string(n)
    string(s) -> s
    bool(b) -> string(b)
    _ -> "unknown"
}
```

## Semantics

Union types represent a value that can be one of several types. The compiler
wraps values into a discriminated layout `{i64 tag, ptr payload}` at assignment
and call sites. Tags are djb2 hashes of the type name.

Pattern matching uses `TypeName(binding)` syntax (without dot prefix) to
discriminate and extract the wrapped value. Wildcard `_` matches all remaining types.

## Runtime Layout

Same as enums: `{i64 tag, ptr payload}` (16 bytes). The `__union` LLVM struct
type is shared across all union types.

---

# while — grammar fragment

```ebnf
WhileStmt ::= 'while' Expr Block
```

---

# with expression (functional struct update)

## Syntax

```
with_expr  = expression "with" "{" field_init_list "}"
field_init = IDENT ":" expression
```

`field_init_list` is a comma-separated list of one-or-more
`field_init` pairs. Order doesn't matter; each name must refer
to an existing field of the source struct.

## Semantics

`obj with { field: new_val, ... }` evaluates to a fresh struct
that copies every field from `obj` *except* the named fields,
which take the override values instead. `obj` is not mutated.

This is the only way to "modify" a struct in Avra — there's no
field-assignment statement on by-value struct bindings.
`mut obj` allows reassigning the whole binding to a new struct
value, typically produced by `with`.

## Examples

```avra
type Point = { x: int, y: int, label: string }

let p = Point { x: 1, y: 2, label: "origin" }
let q = p with { x: 10 }
// p still has x=1; q has x=10, y=2, label="origin"
```

Multiple overrides in one update:

```avra
let r = p with { x: 100, label: "far" }
// r = Point { x: 100, y: 2, label: "far" }
```

Override expressions can reference the original:

```avra
let shifted = p with { x: p.x + 5 }
// shifted = Point { x: 6, y: 2, label: "origin" }
```

Chained updates (each produces a new struct, no shared
mutation):

```avra
let final_p = p with { x: 1 } with { y: 99 } with { label: "z" }
```

## Type rules

The source expression must have a struct type — the typechecker
rejects `with` on enums, primitives, or unknown-typed values.
Every override name must match an existing field of the source
struct's type. Override values must be assignable to the field's
declared type.

When a field is part of a `Result<T, E>`-style union — e.g.
`val: int | string` — the override's typecheck allows widening
to the union (matches the type-check for the original field
init).

## Codegen layout

`Expr.With(obj, overrides)` lowers to:

1. Evaluate `obj` (an `EmitValue` with the struct's named LLVM
   type).
2. Allocate a fresh struct buffer (or reuse the caller's stack
   target when this `with` is in tail-init position — spec
   9.12 Copy types).
3. Memcpy every field from the source into the new buffer.
4. For each override, evaluate the new value and store it at the
   field's GEP slot, overwriting the copy.
5. Return a pointer to the new buffer.

Union-typed fields with widening overrides route through
`emit_union_wrap` before the store.

## Pipeline placement

- Parser produces `Expr.With(obj, overrides: FieldInitList)`.
- Resolve walks `obj` then each override value in the current
  scope.
- Type-check pins the result type to `obj.ty` (the struct
  type), validating each override against its field's declared
  type.
- Codegen emits the copy-and-overwrite sequence above.

