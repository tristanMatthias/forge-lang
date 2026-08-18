# Embedded sub-languages — `grammar {}` as the product surface

**Status:** PROPOSED — unratified. Filed with the epic; no implementation until the
shape is ratified and the walking skeleton proves it.
**Driving example:** SQL, end-to-end.
**Owner epic:** `t-rq1o` — children: `.1` walking skeleton, `.2` author-typed
ASTs (§3.2), `.3` delimiter/registration (§3.1), `.4` typed splices (§3.3),
`.5` result typing + validation + diagnostics (§3.4/§3.5), `.6` package
metadata (§3.6), `.7` v2 lexical layer (§3.7, deferred), `.8` the SQL demo.

## 1. Vision, and one sharp non-goal

A package author defines a language — SQL, CSS, HTML, a query DSL, a config
format — as a `grammar {}` block plus ordinary Avra types and functions. A
consumer imports the package and writes that language *inline*, delimited by a
keyword block, with compile-time errors at their own file's line numbers, typed
values flowing in through splices, and a typed value coming out.

```avra
use @acme.sql

let q = sql { SELECT name, age FROM users WHERE id = ${user_id} }
// q: Select — malformed SQL is a compile error HERE, at this line;
// ${user_id} is type-checked against what the grammar declares it accepts.
```

**Non-goal (ratified by the user, 2026-08-18): extending Avra itself.** Grammar
blocks exist so user-defined languages can be *embedded in* Avra programs — an
SQL grammar, not new Avra statements. The compiler dogfoods the same engine for
Avra's own front end (t-47hc/t-kd4y), but that is bootstrap architecture, not
the product promise. Nothing in this design gives user code a path to add
syntax to Avra outside a delimited block, and the design should actively
preserve that boundary (the delimiter contract in §3.1).

This clarification also settles an architecture question: the grammar
EXECUTOR (the tree interpreter) is the *product runtime* for sub-languages —
consumer compiles meet grammars the compiler has never seen, so something must
interpret them. It is not a redundancy to be merged away. (A hot grammar can
later be emit+JIT specialized; the machinery exists, and it is an optimization,
not a requirement.)

## 2. The two-sided contract

### The author side (package `@acme/sql`)

```avra
// The AST is ordinary Avra types — the author's own. No standard node set.
export type Select = { cols: List<string>, from: string, where: SqlExpr? }
export enum SqlExpr { Eq(col: string, v: SqlVal), ... }

// Lowerings are ordinary typed fns — "the reference is the registration"
// (the t-kd4y.3 typed-builder surface, already proven for compiler features).
fn build_select(cols: List<Token>, t: Token, w: SqlExpr?) -> Select { ... }

export grammar Sql {
  select   = "SELECT" cols:column ("," cols:column)* "FROM" t:IDENT
             ("WHERE" w:sql_expr)? -> build_select(cols, t, w)
  sql_expr = c:IDENT "=" v:splice<SqlVal> -> build_eq(c, v)   // §3.3
  ...
}

// Optional: semantic validation over the built AST, run at comptime (§3.5).
export fn check_select(s: Select) -> List<Diag> { ... }
```

### The consumer side

```avra
use @acme.sql
let q = sql { SELECT name FROM users WHERE id = ${uid} }   // q: Select
```

The consumer never sees CapVal, PState, adapters, or the engine. The author
sees them only through two ordinary declarations: typed build fns and typed
splice terminals.

## 3. What exists today, and the six gaps

The substrate is further along than it looks, because the compiler's own
feature migration (t-kd4y.3) has been building exactly this machinery and
proving it against Avra's own front end:

- `grammar {}` blocks parse to first-class `Grammar` values (`parse_grammar`,
  `grammar_checked`), with the full marker set (`@try`/`@cut`/`@require`/
  `@expect`/`@peek`/`@bump`/`@onfail`/`@recover`) and startup validation of
  both the grammar and its builder manifest (`register_lang` — unresolved
  builds, orphans, arity drift, central shadows all die loudly at startup,
  never mid-parse).
- The EXECUTOR runs user grammars in production today (`run_grammar_expr`,
  `run_grammar_stmt_toks`) over the shipping lexer's tokens, building into a
  caller-provided store, with byte-positioned diagnostics that merge at the
  host boundary.
- Typed build fns with comptime-synthesized adapters are proven ("the
  reference is the registration" — the adapter derives name/arity/kind from
  the fn signature; a signature mismatch is a compile error in the feature
  file, not a runtime surprise).
- `Feature.expr_keyword` is *already documented in-tree* as "the generic
  `<keyword> { }` → package parser seam for embedded sublanguages" — the
  consumer-side hook exists; `rawbrace_scan` already solves brace-delimited
  block capture for `grammar`/`table` literals.
- The differential oracle (emit vs exec) and the malformed-recovery corpus
  apply to user grammars exactly as they do to Avra's own — a sub-language
  gets the same error-recovery discipline for free.

Six gaps stand between that substrate and the §2 contract. Each rides an
existing mechanism; none requires new theory.

### 3.1 The delimiter + registration contract (consumer-side keyword blocks)

`sql { … }` must (a) be reachable by importing a package, (b) capture its body
raw up to the balanced closing brace (`rawbrace_scan` — the sub-language's
tokens must not be pre-chewed by Avra's parser beyond brace balancing), and
(c) be the ONLY way user syntax enters a program — the non-goal boundary.
Mechanism: the `expr_keyword` registry seam, generalized from compiled-in
features to package-registered grammars. Acceptance: a package exports a
grammar under a keyword; an importing file uses the block; a NON-importing
file gets a plain "unknown identifier," proving no global namespace pollution.

### 3.2 Author-typed ASTs through the capture pipeline — the load-bearing gap

Today `CapVal` and the marshalling tables carry only *Avra's* node shapes
(`ExprId`/`StmtId`/patterns/tokens). An SQL grammar needs captures,
accumulators, and build results in the *author's* types (`Select`, `SqlExpr?`,
`List<Col>`). Decision embedded here (answering the open question directly):
**no standard node set** — the author's `type`/`enum` declarations ARE the
AST; what must be standardized is the plumbing contract (captures, spans,
diagnostics), not the nodes. Mechanism: extend the typed-builder synthesis —
already signature-directed — with a user-value carrier (a boxed/erased CapVal
arm or per-grammar synthesized capture records; the `derive_marshal` machinery
is the precedent for type-directed marshalling tables). The engine-side risk
to design around: CapVal is matched pervasively in seed-compiled code, so a
new variant takes the Phase A/B enum dance (`make seed-patch-traps`).

### 3.3 Typed splices — information flowing IN

`${expr}` inside the block is a *declared* seam: a splice terminal with a type
(`v:splice<SqlVal>`), so the host expression type-checks against the grammar's
expectation and arrives in the build fn as a typed hole — for SQL, a bind
parameter by construction, never string concatenation. Mechanism: the quote/
template splice machinery (`~x`, `${}` desugar, the `quote_depth` counter) is
engine-internal today; this promotes it to a declarable grammar surface.
Acceptance: a wrong-typed splice is an F1xxx at the host expression; the build
fn receives the value typed.

### 3.4 The block's result type — information flowing OUT

Running a grammar is a manual call today. The product form: the block IS an
expression whose static type is the start rule's build result (declared or
derived — `sql { … } : Select`). Mechanism: the registered keyword carries
"produces `T`" into typeck. Acceptance: `let q: Select = sql { … }` checks;
assigning to the wrong type is an ordinary F1000 at the block.

### 3.5 Comptime validation hooks + the diagnostics contract

Two layers. The *grammar* is already validated at registration. The *embedded
program* gets: (a) parse errors at compile time with host-file positions —
works mechanically today via the executor + boundary merge, needs to be a
stated public contract with spans mapped through the block's offset; (b)
author-defined semantic checks — the grammar names an ordinary fn
(`check: fn(Select) -> List<Diag>`) run at comptime over the built value
("column does not exist"), its diagnostics flowing through the same mapping.
Mechanism: comptime evaluation (`@comptime`/eval) + `GDiag` byte positions.
Acceptance: a semantic error in embedded SQL renders exactly like a native
Avra error, pointing INTO the block at the right column.

### 3.6 Package distribution — the metadata registration gap

`use @acme.sql` must register keyword + grammar + builders from package
METADATA, including on the fast path. Known live edge (documented in-tree):
"a test shard sees the component only through package metadata, which does
not register its instance-block parse form." Same family as the
synthesis-vs-metadata-replay reconciliation noted on t-kd4y.3. This is
plumbing, not design — but it is the gap that turns "works in one repo" into
"works as a published package."

### 3.7 (Deferred) Per-grammar lexical layer

SQL and query/config DSLs are token-compatible with Avra's lexer — v1 targets
exactly that class and says so honestly. CSS (`#id`, `--var`) and HTML (raw
text, not tokens) are not; they need a declarable `tokens {}` lexical layer
compiled to the same scanner machinery as the generated keyword/operator/run
scanners, with Avra's lexer as the default. Deferred to v2 by design: it is
the largest gap, and nothing in v1's contract forecloses it — the lexer is
already an input (`run_grammar_stmt_toks` takes tokens).

## 4. Sequencing — walking skeleton first

Per the t-kd4y playbook (design → skeleton → ratify → slices), and the
mechanism-vs-mechanics PR discipline:

1. **Walking skeleton** (one PR): a toy grammar in one package, consumed in
   another file through its keyword block, producing ONE author-typed value,
   with ONE parse error at the host line and ONE typed splice. Every gap
   touched shallowly — §3.1 minimal registration, §3.2 for a single struct,
   §3.3 for one splice type, §3.4 for one produces-type, §3.5 parse errors
   only. Nothing deep until this proves the shape end-to-end.
2. **Slice per gap** (§3.2 first — it is load-bearing for everything), each
   its own PR: mechanism first and byte-identical where possible, then usage.
3. **SQL as the acceptance demo**: a small real `@acme/sql` package lands as
   the integration test and the documentation example.
4. Gates throughout: the existing differential harness runs the toy/SQL
   grammars through BOTH engines (emit-gen-check accepts stamped user
   manifests already); malformed-corpus discipline applies from day one.

## 5. Open decisions to ratify before the skeleton

1. **Splice spelling** — `${expr}` (template-consistent) vs `~expr`
   (quote-consistent) inside blocks; and the terminal spelling
   (`splice<T>` vs `$T` vs an annotation).
2. **Produces-type declaration** — derived from the start rule's build fn
   return (zero ceremony, needs signature visibility at registration) vs
   declared on the grammar (`grammar Sql -> Select`), explicit and cheap.
3. **Validation hooks** — one `check` fn vs an ordered pass list (the
   LanguageFeature pass-hook shape); v1 recommendation: one fn.
4. **CapVal user-value carrier** — new boxed variant (seed dance, uniform)
   vs per-grammar synthesized capture types (no seed dance, more comptime
   machinery). Recommendation: decide in the skeleton with a spike of each.
5. **Raw-block capture semantics** — v1 keyword blocks capture raw text and
   re-lex with Avra's lexer; is `${}` recognized by the block scanner itself
   (template-style, two-byte lead) or by the grammar? Recommendation:
   scanner-level, matching string interpolation.

## 6. What this is NOT (scope fences)

- Not macros over Avra syntax, not user-defined Avra statements/operators —
  the §1 non-goal, structurally enforced by the delimiter contract.
- Not a parser-generator product: authors never see the emit engine, PState,
  or CapVal; those remain engine internals.
- Not a v1 lexer framework (§3.7 deferred, explicitly).
