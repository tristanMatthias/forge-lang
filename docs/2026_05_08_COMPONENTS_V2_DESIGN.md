# Components V2 — AST Macros, Traits, and the Declarative Layer

**Status:** Design accepted, implementation pending
**Owner:** Tristan Mathias
**Companion:** `2026_04_18_FULL_SPEC.md` (Axes referenced inline)
**Replaces:** Existing `component_decl/expand.av` template-flavor expansion

---

## 1. Why this exists

Avra's spec promises P7 (visible magic) + P8 (escape hatches everywhere). Today's `component` feature delivers a partial version of that — data components compile to `type + impl + factory`, template components inline init bodies via a `__parent` accumulator. But:

- **Template components aren't classes.** `cli avra { … }` produces `mut avra = 0`, not an `avra` value. You can't write `avra.run()`.
- **There's no library-authorable expansion.** The compiler hardwires the data/template behavior in `component_decl/expand.av`. Libraries can't ship custom expansion logic — std-cli must inject CLI-specific code into the core compiler.
- **Children are untyped.** A parent doesn't know what kinds of nested instantiations are valid; validation is ad-hoc per macro author (today: not at all).
- **Method bodies per instance need a clean home.** `command build { run() { … } }` needs each command to carry a different `run` body. Closure-typed fields work but feel un-idiomatic. Per-instance subtypes via the trait system fit Avra's mental model better.

This design replaces the template/data split with a single mechanism — **components are types implementing traits, expansion is library-authored via `@comptime` AST macros**. The compiler gains one foundational primitive (compile-time function evaluation with quasi-quotation), and everything else — including std-cli, std-test, future `@derive Model` — becomes library code.

---

## 2. Design summary

Three concepts, one new primitive:

| Concept | What it does | Status (as of vez6.11) |
|---|---|---|
| **`@comptime fn`** | Function callable at compile time. Returns AST values. | ✅ shipped |
| **`quote { … }`** | Build AST values via familiar syntax instead of constructor calls. | ✅ shipped — incl. repeating `~list` (#722) + computed `~(expr)` (#723) splice |
| **`@expand(macro_fn)`** | Attribute that registers a `@comptime fn` to rewrite the declaration it's attached to. | ✅ shipped |
| **`component`** (extended) | Block-syntax registration; declares accepted children + traits implemented. | ✅ shipped (children schema + `implements Trait`) |

Every block-syntax DSL Avra ships (cli, test, http routes, sql, html, …) is a `component` whose expansion is implemented by a `@comptime fn` invoked through `@expand`. Core knows about `@comptime` and `component`; it knows nothing about std-cli.

### As shipped (vez6.11, 2026-07)

The declarative cli layer is **implemented and consumer-complete** (`@std.cli` + `@std.cli.cmdgen`; Phase 11 done, merged). Two things diverge from the §4 worked example, which predates the implementation:

- **Runtime shape — data/behaviour split.** The trait is ONE method — `trait Runnable { fn run(self, args: CliResult) -> int }`, not the two-method `name()/run()` of §4.2. A command's identity + parse schema are DATA in a `CommandSpec { name, description, flags, args, options }`, paired with the `dyn Runnable` behaviour in a `Subcommand { meta, body }`. The container is `App` holding `List<Subcommand>` (not `Cli` holding `List<dyn Runnable>`); `App.run` / `run_argv` / `dispatch` read the schema by DIRECT field access (`c.meta.name`) rather than trait accessors. Deliberate improvement — homogeneous schema as data, heterogeneous behaviour behind `dyn`; this is what §4.2/4.3 would show if rewritten.
- **Macros use direct AST construction, not quote/splice.** `expand_command` / `expand_cli` (`cmdgen/mod.av`) build output via `Expr.StructLit` / `synth_expr_id` / … in a single body-walk, not the elegant `quote decl { … ~bindings ~user_run }` of §4.2. Historical: the shape predates the quote foundation. Its blockers are now resolved — repeating/computed splice landed (#722/#723), and the "second child-walk trips the evaluator" F4005 was an executed wildcard arm's `{}` body (an empty map literal the evaluator couldn't eval; fixed with @comptime map support, rmzs). The §4.2 quote-splice rewrite of cmdgen is unblocked (znl0 / vez6.12).

Feature status against §3:

| §3 feature | Status |
|---|---|
| 3.1 `@comptime`, 3.5 `@expand`, 3.6.1 `config` | ✅ shipped |
| 3.6.2 `children { }` schema + validation ("not a valid child" errors) | ✅ shipped |
| 3.6.3 `implements Trait` | ✅ shipped (1-method, see above) |
| 3.3 / 3.4 quote / splice | ✅ shipped — repeating `~list` (#722), computed `~(expr)` (#723); evaluator `{}` map-lit gap fixed (rmzs) |
| 3.2 rich inspection (`children_of_type` / `method_body` / `parent_chain_flags`) | ❌ macros walk manually via `comp_children` / `match` |
| 3.7 hygiene / `@unhygienic` | ❌ not implemented |
| 3.6.4 `body: TokenStream` | ❌ not implemented |

Beyond §4.2, flag `short` + option `default` config are read into the schema (`-v` dispatches, defaults apply). Proven at scale: a 16-command CLI mirroring `main.av` expands + dispatches correctly. Phase 12 (main.av migration) is the remaining consumer work.

---

## 3. Detailed design

### 3.1 `@comptime` functions

A `@comptime` annotation marks a function as callable at compile time. The compiler can evaluate calls to `@comptime` functions during the expand pass.

```avra
@comptime
fn expand_command(decl: ComponentDecl) -> List<Decl> { … }
```

Rules:
- A `@comptime fn` can be called from anywhere — at compile time when arguments are comptime-known, at runtime otherwise (subject to body restrictions).
- Body restrictions for compile-time use: no I/O effects (no file/network), no nondeterminism. Pure transformation only.
- The bootstrap evaluator (`features/eval/`) is repurposed as the compile-time interpreter.

### 3.2 AST values

AST node types from `core/ast.av` become a stable public surface accessible to `@comptime` functions:

```avra
use @std.avra.ast.{Stmt, Expr, ValueType, Decl, ComponentDecl, …}
```

Every node type provides:
- Constructor calls (already supported as enum variants).
- Inspection methods (`block.children_of_type<T>()`, `decl.method_body("run")`, `decl.instance_name`, etc.).
- Identity (each AST value carries a stable id for hygiene).

A stability contract over these types (`@stable` or similar) is deferred — added once macro authors start shipping libraries that depend on the AST shape. Until then, AST refactors are fair game.

### 3.3 Quote syntax

`quote` builds AST values via familiar Avra syntax. Keyword after `quote` selects the AST kind; default is `Expr`.

```avra
quote { x + y }                     // → Expr (default)
quote stmt { let x = 5 }            // → Stmt
quote stmts { let a = 1; let b = 2 } // → StmtList
quote type { (int, int) -> int }     // → ValueType
quote decl { fn foo() { … } }       // → Decl
```

The kind keyword sits in keyword position right after `quote`, parses by reusing the existing grammar for that production.

### 3.4 Splicing — `~`

Inside a `quote { … }` body, `~name` and `~(expr)` interpolate AST values from the surrounding scope:

| Form | Where | Behavior |
|---|---|---|
| `~name` | Identifier slot | The string `name` becomes an `Identifier` AST node |
| `~name` | Expression slot | `name` is a string → `String` literal expr; or already an `Expr` → spliced as-is |
| `~(expr)` | Any slot | `expr` evaluated at expansion time; result must match slot's expected type |
| `~list_value` | Repeating slot (e.g. statement-list) | Each element of `list_value` spliced in turn |

The compiler picks the interpretation based on which AST hole the splice sits in. Splicing a wrong-typed value into a hole is a compile-time error at macro-expansion time (e.g. splicing a `Stmt` into an expression slot).

### 3.5 `@expand(macro_fn)` attribute

`@expand(f)` registers a `@comptime fn f` to rewrite the declaration immediately following it.

```avra
@expand(expand_command)
component command { … }

@expand(derive_show)
type User = { name: string }

@expand(memoize)
fn fib(n: int) -> int { … }
```

The compiler's expand pass:
1. Sees `@expand(f)` on a declaration.
2. Parses the declaration into its AST node.
3. Calls `f(decl_ast)` at compile time.
4. Replaces the original declaration with `f`'s return value (a `List<Decl>` or single `Decl`).

`@expand` is **the** generic mechanism. `@derive(Trait)` is sugar over `@expand` (registers a `derive_<trait>` function). Future macros for caching, retry, etc. all flow through `@expand`.

### 3.6 Components, extended

Component declarations register a block syntax keyword, declare expected children, and declare implemented traits.

```avra
component command implements Runnable {
    config { description: string = "" }
    children {
        flags: List<Flag>
        args: List<Arg>
    }
}
```

#### 3.6.1 `config { … }` — top-level fields

Already exists. Each `config { key: type = default }` entry becomes a struct field on the component's generated type, settable at instantiation via `key value` or `key = expr`.

#### 3.6.2 `children { … }` — accepted nested instantiations

New. Declares which child component types this component accepts and into which list field each is collected. Validation: every nested instantiation inside a `command <inst> { … }` block must match a declared child type (or implement a trait listed in a `dyn Trait` field). Mismatch → compile error.

```avra
cli avra {
    command build { … }    // ✓ matches `commands: List<dyn Runnable>` (Command implements Runnable)
    flag verbose { … }     // ✓ matches `global_flags: List<Flag>`
    type Wat = { x: int }  // ✗ "type Wat is not a valid child of cli; expected Command or Flag"
}
```

#### 3.6.3 `implements Trait` — trait conformance

New. Component implements one or more traits. The macro author's `@expand` function is responsible for emitting per-instance impl bodies (using user-supplied method bodies as content).

```avra
component command implements Runnable {
    config { … }
    children { … }
}

trait Runnable {
    fn name(self) -> string
    fn run(self, args: CliResult) -> int
}
```

Each `command <inst> { run() { body } }` block desugars (via the `@expand` macro) to:

```avra
type Command_<inst> = { name: string, …config_fields, flags: List<Flag>, args: List<Arg> }
impl Runnable for Command_<inst> {
    fn name(self) -> string { self.name }
    fn run(self, args: CliResult) -> int { <user body> }
}
let <inst> = Command_<inst> { … }
```

The cli's `commands: List<dyn Runnable>` field stores `dyn Runnable` boxes, one per command instance. Trait dispatch (vtable) handles the polymorphic call in the cli's `run` loop.

#### 3.6.4 `body: TokenStream` — free-form DSL escape hatch

For SQL/regex/HTML-style components where the body isn't structured Avra:

```avra
@expand(parse_sql)
component sql {
    body: TokenStream
}

let q = sql {
    SELECT * FROM users WHERE age > 18
}
```

The compiler parses up to balanced `}` (counting `{`/`}` literals) and hands the raw token stream to the macro, which parses it as it sees fit.

Components can have either `children { … }` or `body: TokenStream`, not both. Plain leaf components (e.g. `flag foobar { short "f" }`) have neither.

### 3.7 Hygiene

Hygienic by default. Identifiers introduced inside `quote { … }` bodies are renamed to fresh symbols at expansion time so they don't collide with names in the caller's scope.

Opt-out: `@unhygienic` annotation on the `@comptime fn` — useful for `for_each`-style macros that intentionally introduce loop variables visible to user-supplied bodies.

```avra
@unhygienic
@comptime
fn for_each(items: Expr, body: Stmt) -> Stmt {
    quote stmt {
        for item in ~items {  // `item` deliberately captured
            ~body
        }
    }
}
```

### 3.8 What gets deleted

- **Template components** (init-body inlined into caller scope via `__parent` accumulator). All current users (`cli`, `command`, `flag`, `option`, `arg` in `packages/cli/src/main.av`) migrate to data components with macros.
- **`__parent` / `__parent_name` mechanism.** No longer needed — children are pushed into typed list fields by the macro.
- **`__on_after_children`, `__on_*` event hooks.** Replaced by trait methods + macro-emitted impl bodies.
- **`fn init()` as a special component method.** Construction is via factory `fn new(…)` or struct literal. If post-construction work is needed, write a method and call it explicitly.

---

## 4. Worked example: the cli case end-to-end

### 4.1 What the user writes

```avra
cli avra {
    description "Avra compiler"
    version "0.1.0"

    flag verbose { short "v", description "Verbose output" }

    command build {
        description "Build a project"
        flag foobar { short "f", description "Do a thing" }
        arg target { description "Target name", required true }

        run() {
            if foobar { println("foobar set") }
            if verbose { println("verbose from parent") }
            println("building ${target}")
            0
        }
    }

    command clean {
        description "Clean artifacts"
        run() {
            println("cleaning")
            0
        }
    }
}

avra.run()
```

### 4.2 What std-cli ships

```avra
type Flag = { name: string, short: string, description: string }
type Arg = { name: string, description: string, required: bool }

trait Runnable {
    fn name(self) -> string
    fn run(self, args: CliResult) -> int
}

@expand(expand_command)
component command implements Runnable {
    config { description: string = "" }
    children { flags: List<Flag>, args: List<Arg> }
}

@expand(expand_cli)
component cli {
    config { description: string = "", version: string = "0.1.0" }
    children { commands: List<dyn Runnable>, global_flags: List<Flag> }
}

impl Cli {
    fn run(self) -> int {
        let parsed = parse_argv(self)
        for cmd in self.commands {
            if cmd.name() == parsed.command {
                return cmd.run(parsed)
            }
        }
        print_help(self); 1
    }
}

@comptime
fn expand_command(decl: ComponentDecl) -> List<Decl> {
    let cmd_name = decl.instance_name
    let flags = decl.children_of_type(Flag)
    let args = decl.children_of_type(Arg)
    let user_run = decl.method_body("run")
    let inherited_flags = decl.parent_chain_flags()  // walks up to cli for global flags

    let bindings = (flags + inherited_flags).map(f -> quote stmt {
        let ~(f.name) = result_has_flag(args, ~(f.name))
    }) + args.map(a -> quote stmt {
        let ~(a.name) = result_get_arg(args, ~(a.name))
    })

    let type_name = "Command_" + cmd_name
    quote decl {
        type ~type_name = {
            name: string,
            description: string,
            flags: List<Flag>,
            args: List<Arg>,
        }
        impl Runnable for ~type_name {
            fn name(self) -> string { self.name }
            fn run(self, args: CliResult) -> int {
                ~bindings
                ~user_run
            }
        }
    }
}
```

### 4.3 What the compiler produces

```avra
type Command_build = { name: string, description: string, flags: List<Flag>, args: List<Arg> }
impl Runnable for Command_build {
    fn name(self) -> string { self.name }
    fn run(self, args: CliResult) -> int {
        let foobar = result_has_flag(args, "foobar")
        let verbose = result_has_flag(args, "verbose")
        let target = result_get_arg(args, "target")
        if foobar { println("foobar set") }
        if verbose { println("verbose from parent") }
        println("building ${target}")
        0
    }
}

type Command_clean = { … }
impl Runnable for Command_clean { … }

let avra = Cli {
    name: "avra",
    description: "Avra compiler",
    version: "0.1.0",
    global_flags: [Flag { name: "verbose", short: "v", description: "Verbose output" }],
    commands: [
        Command_build { … } as dyn Runnable,
        Command_clean { … } as dyn Runnable,
    ],
}

avra.run()
```

### 4.4 Magic visibility (P7)

`bs2 expand <file>` prints the post-macro AST. Users can inspect every generated `type`, `impl`, and binding. No surprises.

### 4.5 Escape hatches (P8)

Don't want the macro? Skip the components — write the structs and impls by hand:

```avra
type MyCommand = { … }
impl Runnable for MyCommand { … }
let cli = Cli { commands: [MyCommand { … }] }
cli.run()
```

Same runtime, zero magic. Always available.

---

## 5. Implementation plan

Phased so each phase ships independently and the bootstrap stays green throughout.

### Phase 1 — AST as public surface
- Audit `core/ast.av` types and expose them via a curated public path.
- Add inspection helpers (`children_of_type`, `method_body`, `parent_chain`) to `ComponentDecl`-shaped types.
- Document invariants per node type.
- No language changes; pure library work.
- **Deferred:** stability contract / `@stable` annotation. Revisit when macro authors start depending on these types in published libraries.

### Phase 2 — Compile-time evaluator
- Repurpose `features/eval/` as the compile-time interpreter.
- Define what subset of Avra is comptime-safe (no I/O, no concurrency, no random).
- Add `@comptime` annotation parsing + typeck flag.
- Add expand-pass hook to evaluate `@comptime` fns.
- Test: write a `@comptime fn add(x, y)` that returns a constant; verify it runs at compile time.

### Phase 3 — Quote syntax
- Lexer: recognize `quote` as keyword in expression position.
- Parser: `quote { … }` with optional kind keyword (`stmt`, `stmts`, `type`, `decl`, `expr`).
- Lower quote bodies to AST-construction expressions (e.g. `Expr.Binary(Op.Add, Expr.Ident("x"), Expr.Ident("y"))`).
- Test: `let e = quote { x + y }` produces an `Expr` value matching the constructor form.

### Phase 4 — Splice syntax
- Parser: recognize `~name` and `~(expr)` inside `quote { … }` bodies.
- Type-check splices against the AST hole's expected type.
- Lower splices to insertions in the AST-construction expression.
- Test: `quote { ~name + 1 }` substitutes the runtime value of `name` at the identifier slot.

### Phase 5 — Hygiene
- Rename pass: every identifier introduced inside a `quote { … }` body gets a fresh suffix at expansion time.
- `@unhygienic` annotation suppresses the rename.
- Test: macro-introduced `let x = …` doesn't shadow caller's `x`; `@unhygienic` version does.

### Phase 6 — `@expand` attribute
- Parser: `@expand(macro_fn_name)` annotation on declarations.
- Expand pass: when seen, parse the declaration to its AST value, evaluate `macro_fn(decl)`, splice the result.
- Test: trivial `@expand(double)` on a fn doubles its body — verifies plumbing.

### Phase 7 — Component children schema
- Parser: `children { name: List<T>, … }` block in component definitions.
- Validation: every nested instantiation must match a declared child type (or trait).
- Auto-push: children get inserted into the matching parent list field at construction.
- Test: nested `flag foobar` inside `command build` lands in the command's `flags` field; mismatched child errors out.

### Phase 8 — Component `implements Trait`
- Parser: `component foo implements TraitA, TraitB { … }`.
- Generate one `impl TraitA for Foo_<inst>` per instantiation. Macro author's `@expand` fn provides the bodies.
- Trait method resolution at typeck checks every required method has a body (user-supplied or trait default).
- Test: cli case from §4 compiles end-to-end.

### Phase 9 — Component `body: TokenStream`
- Parser: balanced-brace token-stream body mode.
- Macro receives raw `TokenStream`.
- Test: trivial `sql { hello world }` macro that returns a string of the token text.

### Phase 10 — Delete template components
- Remove init-body inlining + `__parent` accumulator from `expand.av`.
- Delete `__on_after_children` / `__on_*` event hooks.
- Migrate any remaining template-flavor users to data + macro form.
- Test: `make test` fully green.

### Phase 11 — std-cli rewrite ✅ DONE (vez6.11)
- Rewrote `cli`/`command`/`flag`/`option`/`arg` as data components with macros.
- Shipped the `Runnable` trait (1-method) + `CommandSpec`/`Subcommand`/`App` dispatcher (data/behaviour split — see "As shipped" above), plus flag `short` + option `default` (5az8).
- `packages/std-cli/src/{cli.av,cmdgen/mod.av}`.
- Tested: toy CLIs (dispatch, argv parse, help/version, inheritance, shorts/defaults) + a 16-command scale check.

### Phase 12 — main.av (avra CLI) rewrite 🚧 IN PROGRESS (vez6.12)
- Convert every `if cmd0 == "X" { run_X_command() }` and `match command { … }` into `command X { run() { … } }`.
- Single `avra.run()` at end; rip out manual dispatch helpers (`run_test_command`, `run_build_command`, `run_docs_command`, etc.).
- Target line count for `main.av`: ~300 lines (down from 2,652).
- Test: `make test`, all pre-existing CLI invocations still work.

### Phase 13 — Optional follow-ups
- **UAP** (`expr.field(args)` for fn-typed fields): generic Avra ergonomic, not load-bearing for cli.
- **Full `@derive`**: now a special case of `@expand`. Document the derive convention.
- **Macro caching**: incremental compilation cache for macro outputs (perf).
- **`bs2 expand`**: command to dump post-macro AST. P7 visible-magic tool.

---

## 6. Open questions deferred to implementation

- **Reflection depth**: how much can a `@comptime fn` introspect about types beyond their declared shape? Field iteration is required; method introspection might be too.
- **Cross-package macros**: ~~a macro defined in std-cli used in user code — how does the build pipeline order this?~~ **Resolved.** Both build modes work: source mode compiles the producer package first (dep ordering), and the metadata fast-path ships `@comptime` fn bodies in `unit.meta.bin` as fmt-rendered source that rehydrates lazily on the consumer side. The load-bearing invariant is that **fmt output is valid Avra source** — the renderer keeps enum-ctor type qualifiers and re-escapes string literals, and the parser accepts fully-qualified `@pkg::mod::name` references in expression and type position (a lone `@ident` stays annotation syntax). The std-cli cmdgen test suite runs entirely through the fast-path as regression coverage.
- **Macro debugging**: stack traces inside macros, breakpoints, "trace this expansion" mode. P7 again — needs first-class tooling.
- **Recursion limits**: macro can call macro can call macro. Cap depth, error gracefully on infinite loops.
- **Hygiene with type-level identifiers**: do generated type names get hygiene treatment too? (Probably yes, with explicit opt-out for "I want this type to be referable from outside.")

---

## 7. Risks

- **Compile-time evaluator scope creep.** `features/eval` was built for runtime; using it at compile time may surface bugs. Mitigation: comprehensive comptime test suite; fallback "interpret subset of Avra" approach if full eval reuse proves brittle.
- **AST type churn breaks macros.** Once macro libraries ship, AST refactors become breaking changes. Add a stability contract (`@stable` or similar) before that point — not load-bearing for the cli rewrite, but needed before external macro libraries ship.
- **Migration complexity.** 2,652-line `main.av` rewrite is a chunk of work. Mitigation: phased — std-cli changes are usable for any other consumer the moment Phase 11 lands; main.av rewrite (Phase 12) is a separate self-contained effort.
- **Spec drift.** The spec mentions `@derive` and lifted functions in the abstract; this design pins them to specific syntax/semantics. Mitigation: feed back into spec — propose this as the formal implementation of those concepts.

---

## 8. Why this is the right thing

The cli rewrite was the trigger but the win is much bigger:

- **One mechanism** (`@comptime` + `quote` + `@expand` + `component`) covers cli, std-test, future `@derive Model`, custom DSLs, every declarative layer.
- **Library-authored magic** — Avra's "magic-first, escape-everywhere" promise becomes real, deliverable by anyone who can write `@comptime` code.
- **Visible** — `bs2 expand` shows the generation. P7 satisfied.
- **Escapable** — write the structs/impls by hand, skip the magic. P8 satisfied.
- **Self-bootstrapping** — once this lands, `@derive Model`, `@derive Serialize`, etc. are just library code, not compiler features.

This is the foundational primitive Avra needs to deliver on its declarative promises. Everything we've talked about doing in the language for the next two years (model framework, http routing, test framework, GraphQL schema, …) is downstream of this primitive.
