# Getting to CLI V2

The path from where we are now → fully migrated `packages/cli/src/main.av`
running on Components V2 (declarative components + macro-authored expansion).

Each stage gates the next. Don't skip ahead.

---

## The destination — what the user actually writes

This is the surface we're building toward. The whole stack of stages
below exists so that the following code "just works." (See
`docs/2026_05_08_COMPONENTS_V2_DESIGN.md §4` for the canonical
articulation.)

```avra
cli avra {
    description "Avra compiler"
    version "0.1.0"

    flag verbose { short "v", description "Verbose output" }

    command build {
        description "Build a project"
        flag foobar { short "f", description "Do a thing" }
        arg target { description "Target name", required true }

        run(self) {
            if self.flag.foobar { println("foobar set") }
            if self.cli.flag.verbose { println("verbose from parent") }
            println("building ${self.arg.target}")
            0
        }
    }

    command clean {
        description "Clean artifacts"
        run(self) {
            println("cleaning")
            0
        }
    }
}

avra.run()
```

**What's load-bearing about this shape:**

1. **`run(self)` is a normal method on a typed struct.** The macro
   generates a per-command type (`Command_build`) with one nested
   accessor struct per child component type — `self.flag` for
   flags, `self.arg` for args, `self.option` for options, etc.
   Each accessor has one named field per declared instance:
   `self.flag.foobar: bool`, `self.arg.target: string`. Real
   struct fields, type-checked at compile time, no string lookups,
   no naked-name magic.
2. **`self.flag.X` / `self.arg.X` mirrors the source structure.**
   The body's `command build { flag foobar { … } arg target { … } }`
   maps directly to access shape: child `flag foobar` → `self.flag.foobar`.
   No reordering, no flattening, no surprises.
3. **This generalizes — not cli-specific.** Any component with
   `children { flags: List<Flag>, args: List<Arg> }` gets the same
   treatment: nested accessor struct per child slot, typed field per
   instance. An HTTP server with `endpoint home { … }` would access
   it as `self.endpoint.home`. A sql schema with `table users { … }`
   would access it as `self.table.users`. The macro author writes
   the schema once; the access pattern follows.
4. **Parent state via back-ref.** `self.cli` points to the enclosing
   cli instance, so `self.cli.flag.verbose` reads the parent's flag.
   Explicit and visible — no implicit scope walking.
5. **Implicit name binding.** `command build { … }` sets
   `name: "build"`; no `name = "build"` assignment needed.
6. **Child auto-push.** `command build { … }` and `command clean { … }`
   inside `cli avra { … }` push themselves into `avra.commands`.
   No `add_command(...)` calls.
7. **No template macros, no `__parent`, no `match command { ... }`.**
   `avra.run()` is a regular method call going through the trait
   vtable on `commands: List<dyn Runnable>`.

### What it desugars to

The macro `expand_command` (library-authored, lives in std-cli) lowers
each `command <inst> { … }` block into a generated subtype + trait impl:

```avra
// Per-instance accessor structs, one per child component type
type Command_build_Flags = { foobar: bool }
type Command_build_Args  = { target: string }

// Per-command type with the accessor structs as nested fields
type Command_build = {
    description: string,
    cli: Cli,                   // back-ref to parent
    flag: Command_build_Flags,  // ← `flag foobar { ... }` maps here
    arg:  Command_build_Args,   // ← `arg target { ... }` maps here
}

impl Runnable for Command_build {
    fn name(self) -> string { "build" }
    fn run(self) -> int {
        // ↓ user's body verbatim, references typed nested fields:
        if self.flag.foobar { println("foobar set") }
        if self.cli.flag.verbose { println("verbose from parent") }
        println("building ${self.arg.target}")
        0
    }
}
```

…and the cli block becomes a struct literal with auto-pushed children:

```avra
type Cli_Flags = { verbose: bool }

let avra = Cli {
    name: "avra",
    description: "Avra compiler",
    version: "0.1.0",
    flag: Cli_Flags { verbose: false },  // populated by argv parsing
    commands: [
        Command_build {
            cli: <back-ref>,
            flag: Command_build_Flags { foobar: false },
            arg:  Command_build_Args  { target: "" },
        } as dyn Runnable,
        Command_clean { cli: <back-ref> } as dyn Runnable,
    ],
}
```

The cli's dispatcher (also generated, or shipped on `impl Cli`) parses
argv, populates the matching command's `flag` / `arg` accessor structs,
then calls `cmd.run()` via the dyn-Runnable vtable. Static typing
throughout.

**Three concepts run the whole show:** `@comptime`, `@expand`,
`component`. Everything else (cli, command, flag, arg, the nested
accessor structs, parent back-refs, child auto-push, typed-field
generation) is library code that ANY user can write — std-cli is
just the first user. The same pattern applies unchanged to
HTTP routers, SQL schemas, GUI widget trees, plugin DAGs — any
declarative tree-shaped DSL.

---

## Stage 1 — Fix `wd48`: bundled-test resolver leak (P2 bug)

**Bead:** `forge-crafting-intepreters-wd48`

When a new module appears under `@std/avrac/src/` AND a sibling test
file imports it, the bundled `bs2 test` compile fails to resolve
unrelated `use sibling.{...}` imports in OTHER test files (e.g.
`docs/gen_test.av`'s `use gen.{...}` breaks even though gen.av is
right there).

Why this blocks the rest: Stage 2 wants to add `@std.avrac.check.{check_source}`
in a new module. wd48 makes any new top-level module a regression
risk for the whole test suite.

**Workaround if you want to skip:** put the new fn in an existing
module (e.g. `diagnostics/mod.av`) instead of a new dir. Avoids the
trigger but doesn't fix the underlying bug — future module additions
will hit it again.

**Acceptance:** adding a new `@std/avrac/src/<X>/mod.av` + a sibling
test that imports it doesn't break other test files' relative imports
in the bundled compile.

**Why it's first:** unblocks Stage 2's natural shape AND removes a
foundational pipeline bug that will keep biting otherwise.

---

## Stage 2 — Finish `4szi`: in-process test harness

**Bead:** `forge-crafting-intepreters-4szi` (in_progress)

The premise: ~169 fixture tests fork `bs2` to compile a string + grep
its stdout. Each fork costs 50ms-1s. Replacing with in-process
function calls eliminates the fork cost entirely AND makes failure
messages cleaner.

### Step 1 — `avra_capture_stdout` primitive ✅ done

Shipped in commit `1bcfcc60`. `extern fn avra_capture_stdout(closure: fn() -> void) -> string`
runs `closure` with stdout redirected to a tmpfile, returns the
captured bytes. 6 spec tests pass.

### Step 2 — `check_source` for diagnostic capture (TODO)

For tests that assert specific F-codes appear in compile errors. Today
they fork `bs2 check`/`bs2 compile` and grep stderr. With `check_source(src)
-> DiagnosticBag`, they call it directly and inspect the bag.

Implementation runs the same pipeline `bs2 check` does (parse → resolve_module_files
→ desugar → expand_components → resolve_names → expand_macros → run_comptime
→ typecheck_program), returns the accumulated DiagnosticBag.

**Sub-tasks:**
- Add `check_source(source: string) -> DiagnosticBag` somewhere reachable.
  EITHER fix wd48 first and put it in a new `check/` module (cleanest),
  OR add it to an existing module (e.g. `diagnostics/mod.av`) to dodge wd48.
- 5-6 spec tests covering: valid program → no errors; syntax error → bag has errors;
  undefined var → bag has errors; type mismatch → bag has errors; round-trip
  with valid let + arithmetic.

### Step 3 — Sweep migration (TODO)

Migrate fixture tests from shell-out to in-process. Find every test
matching the pattern `avra_shell_exec("./build/bs2 (compile|check|expand) ...")`
or `avra_shell_exec("bash scripts/diagnose.sh --run ...")` and decide:

- Tests that just want "what does this print?" → use `capture_stdout`
- Tests that want "what's the compile error?" → use `check_source`
- Tests that genuinely test the bs2 CLI subprocess shape (build_driver_test
  et al.) → leave as shell-outs

Estimated migratable: ~30-40 of the 44 shell-out tests. Each migration
saves the per-fork overhead (50ms-1s).

**Cleanup tickets:** `vez6.4szi.cleanupA/B/C` (perf, DRY, red-team) under
`4szi`. Open after migration sweep lands.

**Why it gates Stage 3:** vez6.8 has tests that NEED in-process compile-error
inspection (testing that `@expand(no_such_macro)` produces the right
F-code). Today those go through shell-outs; the in-process path is
cleaner and eliminates a class of test isolation issues we just hit
during `grgg`.

---

## Stage 3 — Finish Components V2 metaprogramming + `vez6.8`

**Epic:** `forge-crafting-intepreters-vez6` (9/14 phases complete)

### 3a. Verify the metaprogramming foundation (DOUBLE CHECK)

Phases 1–7 + 13 + 14 are closed. Before pushing on Stage 3b, run
through these to confirm they actually work as advertised — the bead
notes claim done but real-world usage is what tells us:

| Phase | Status | Verify by |
|---|---|---|
| `vez6.2` `@comptime` evaluator | ✅ closed | `bs2 test -f comptime` should be green |
| `vez6.3` `quote { ... }` syntax | ✅ closed | `bs2 test -f quote` should be green |
| `vez6.4` `~name` / `~(expr)` splice | ✅ closed | bundled in quote tests |
| `vez6.5` Hygienic identifiers + `@unhygienic` | ✅ closed | hygiene tests |
| `vez6.6` `@expand(fn)` attribute + expand-pass | ✅ closed | `expand_macro_test.av` passes |
| `vez6.6.4` Eval Value AST extension | ✅ closed | comptime fold tests |
| `vez6.6.5` Expr decoder produces source-form EnumCtor | ✅ closed | comptime fold tests |
| `vez6.7` `children { ... }` schema + auto-push | ✅ closed | `children_*_test.av` |
| `vez6.8.4` `@expand` passes wrapped Stmt to 1-arg macros | ✅ closed | argful macro tests |
| `vez6.8.5` `@expand` on ComponentDef rewrites every instance | ✅ closed | per-instance @expand tests |
| `vez6.13` UAP for fn-typed struct fields | ✅ closed | `uap_*_test.av` |
| `vez6.14` `bs2 expand` CLI prints post-expansion source | ✅ closed | `expand_command_test.av` |

**The "ideal" articulated in earlier conversations:** a user writes
declarative cli/component blocks; the compiler auto-generates the
struct types + trait impls + dispatch via a library-authored macro
(`@expand(expand_command)`). Three concepts total: `@comptime`,
`@expand`, `component`. Everything else is library code. No template
engines, no special compiler-side knowledge of cli/command/flag.

**Design doc:** `docs/2026_05_08_COMPONENTS_V2_DESIGN.md`

### 3b. Finish `vez6.8`: implements Trait + typeck integration

**Bead:** `forge-crafting-intepreters-vez6.8` (in_progress)

Phase A+B (parser + AST schema for `implements TraitA, TraitB`) shipped
in `30b3c0c0`. The phase-8 bead also has follow-up children
(`vez6.8.4` argful @expand, `vez6.8.5` instance routing) — both closed.

**Three blockers from prior session — all CLOSED 2026-05-10:**

- ✅ **`ty5v`** (commit `dfb5f1cd`) — Tree-walk evaluator now supports
  `match`. 13 spec tests cover int / string literal patterns, variant
  payload binding, or-patterns, nested variants, wildcard, and Block
  bodies with `return`.

- ✅ **`swgx`** (commit `bbccf605`) — `~ident` accepted in `type` name
  slot inside `quote stmt { ... }`. Parser tags the resulting TypeDecl
  name with a `~` prefix; lower emits `Expr.Ident(rest)` instead of
  a string literal so the runtime splice resolves the local at
  expansion time.

- ✅ **`dkfa`** (commit `ac175900`) — F3105 duplicate-decl diagnostic
  for top-level types. Scoped to bare-name TypeDecl / NewtypeDecl /
  ShapeDecl / EnumDecl; qualified names (`pkg::mod::Foo`) bypass
  (bundling can legitimately re-register the same qualified name).
  `Result` intrinsic is silently de-duped vs stdlib's.

**Still open before vez6.8 closes:**
- Trait method resolution at typeck — verify every required trait
  method has a body. Bead filed.
- `dyn Trait` list field handling — children get boxed correctly.
  Bead filed.
- End-to-end cli case — **partly works** with let-binding workaround:
  `@expand(expand_cmd) component command {}` + `command build {}`
  produces `type Command_build = {...}` end-to-end. Inline
  `match s { .Variant -> return quote stmt {...} }` silently fails
  (bead `b85m` filed). Field types lower to `<unknown>` (bead filed).
- `vez6.8.3` cleanup C (red-team + edge-case pass) — last cleanup ticket

**Acceptance per the bead:** `command build { run() { /* body */ } }`
produces `type Command_build` + `impl Runnable for Command_build { fn run(...) { /* body */ } }`,
and `cli avra { ... }.run()` dispatches via trait vtable.

**Recommended order to fix:**
1. `ty5v` first (P1, biggest unblocker — once eval can match, the
   macro pattern is unblocked)
2. `swgx` next (lets macros emit clean per-instance code)
3. `dkfa` (correctness backstop — should NEVER silently accept duplicates)
4. Then trait method resolution + dyn Trait list handling
5. Then the end-to-end cli case
6. Then vez6.8.3 cleanup C

### 3c. `vez6.9` `body: TokenStream` (P2 — optional for cli rewrite)

Free-form DSL escape hatch for sql/regex/html-style components. Not
strictly required for the cli case, but completes the design.

**Skip-if-time-pressed?** Maybe. Phase 10 (delete templates) deps_on
both 8 + 9. If we want to skip 9, we either (a) keep templates around
for sql-style use cases, or (b) un-block 10 from 9.

---

## Stage 4 — `vez6.10` Delete template components

**Bead:** `forge-crafting-intepreters-vez6.10` (depends on 8 + 9)

Removes the template-flavor expansion from `features/component_decl/expand.av`:
- `splice_template_block` (~300 lines)
- `__parent` / `__parent_name` accumulator threading
- `__on_after_children` / `__on_*` event hook handling
- `has_fn(body, "init")` template detection

Audit current users (cli/command/flag/option/arg in main.av — should
already be migrated by Stage 5 below; if any remain, fix them first).

**Acceptance:** `make test` green; expand.av only handles data
components + delegates to `@expand` macros for everything else.

---

## Stage 5 — `vez6.11` Rewrite `std-cli` on Components V2

**Bead:** `forge-crafting-intepreters-vez6.11` (depends on 8 + 5)

Where the actual user-facing payoff lands. `std-cli` becomes pure
library code with zero compiler-internal knowledge.

**Tasks (per the bead):**
- Define `Runnable` trait: `fn name(self) -> string`, `fn run(self, args: CliResult) -> int`
- `cli` component as data with `impl Cli { fn run(...) }`
- `command` as `component command implements Runnable { children { flags: List<Flag>, args: List<Arg> } }`
- `flag`, `option`, `arg` as plain leaf components
- `expand_command` `@comptime fn` generating per-instance `Command_<inst>` + Runnable impl
  with declared flags/args bound as locals in the `run` body
- `expand_cli` `@comptime fn` generating the cli's struct literal with
  auto-pushed children
- `Cli::run` dispatcher walking `self.commands: List<dyn Runnable>`,
  matching argv → calling impl

**Acceptance:** A 5-command toy cli compiles + runs correctly. std-cli
has zero references to compiler internals.

---

## Stage 6 — `vez6.12` Rewrite `packages/cli/src/main.av` on std-cli V2

**Bead:** `forge-crafting-intepreters-vez6.12` (depends on 11)

The big payoff. main.av drops from ~2,652 lines (lots of `if cmd0 == "lsp"`
and helper-fn-per-subcommand chains) → ~300 lines of `command X { ... run() { ... } }`
blocks ending in a single `avra.run()`.

**Tasks (per the bead):**
- Convert each subcommand handler (compile, check, run, build, clean,
  cache, test, expr, program, eval, fix, fmt, lsp, lang, features,
  docs, metadata_show) to a `command X { ... run() { ... } }` block
- Move declared flags into `flag X { description "..." }` blocks; user
  code references them as bare identifiers (`if json { ... }` instead
  of `result_has_flag(args, "json")`)
- Single `avra.run()` at end of `main()`
- Delete: `run_test_command`, `run_build_command`, `run_docs_command`,
  `run_lang_command`, `run_clean_command`, `run_cache_command`,
  `run_per_mod_with_progress`, `run_pre_deps_with_progress`,
  `parse_docs_args`, `parse_test_args`, `parse_build_args`,
  `has_argv_flag`, `read_kv_value`, `matches_kv_flag`, etc.
- Bodies of subcommand handlers stay intact — they're moved into the
  `run()` blocks unchanged

**Acceptance:** All existing CLI invocations still work byte-identically
(regression test against `make test`); main.av drops to ~300 lines
from 2,652; selfhost fixed point holds.

---

## Dependency chain (one-line view)

```
wd48 (P2 bug)
  └─→ 4szi step 2 + step 3 (in-process harness)
        └─→ vez6.8.3 + vez6.8 typeck (finish implements)
              └─→ vez6.9 (TokenStream — optional)
                    └─→ vez6.10 (delete templates)
                          └─→ vez6.11 (rewrite std-cli)
                                └─→ vez6.12 (rewrite main.av)
```

You can short-circuit `wd48` by putting `check_source` in an existing
module. You can short-circuit `vez6.9` if templates can stay around
for sql-style DSLs (un-block 10 from 9).

The serial path is why the order matters. Each stage's acceptance
test is the quality gate for the next.

---

## Working with this document

- Each `/loop` iteration: `bd ready` → pick the lowest-stage open
  ticket → drive it to its acceptance criteria → run the cleanup
  tickets (perf/DRY/red-team) per `ticket-inner` formula → close it →
  move on.
- "Double check" the metaprogramming work in 3a before pushing on 3b.
  Run `bs2 test` on each closed phase's test files; if anything's
  flaky or wrong, fix BEFORE assuming the foundation is sound.
- ZERO hacks per existing project policy (CLAUDE.md). If you discover
  a missing language feature or pipeline gap, file a bead and address
  it before continuing.
- After every successful change: `git add` + commit + push. Do NOT
  batch (CLAUDE.md rule 8).
