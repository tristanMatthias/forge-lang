# Sel — the AST selection API (t-6iee)

**Status: RFC — deliberately deferred.** Nothing here is committed (user directive
2026-08-17). The full first-principles design session happens when its real consumers
exist — avra-server (LSP+MCP), the linter, plugins/lifted user code — and after the
LanguageFeature component schema settles, since feature-declared structural contracts
will reshape what typed views should be. This document captures the analysis so that
session starts from forces, not from scratch; the three fork answers recorded below
(fluent Sel / typed decl views / lazy Db parent index) are provisional inputs, not
decisions.

**What ships NOW is only §"The thin slice"** at the bottom: a minimal test-infrastructure
Sel (five verbs over the B-final arena edges — the one substrate that won't move) to stop
the emit-shape tests' text-pin tax from compounding through the feature migration.

**Eventual consumers:** emit-shape tests (first), linter rules, `avra-server` (LSP+MCP)
query compute fns, lifted user code / `@derive` authors / providers, and progressively
the compiler's own passes.

## Why this exists

Three forces converge on one API:

1. **The spec already promises it.** Axis 1.2(c): the binary is erased, the *compiler*
   is introspectable — reflection IS "ask the compiler about the AST." Axis 1.3(e):
   there is no separate metaprogramming language — lifted code, derives, and providers
   use "the same Avra functions operating on Avra data." Axis 21.2(c): `avra-server`
   (LSP+MCP, one process) serves type-at-span / cross-ref / semantic search — all
   queries over this surface. So the AST query API is **user-facing language surface**,
   not compiler internals, and its UX quality matters the way syntax quality matters.

2. **ps3t forbids the alternative.** The AST epic names the ~12 hand-rolled walkers as
   the disease (L4's thesis); every new "walk the tree looking for X" helper is
   walker #13. The sanctioned substrate exists: `derive_walker` materializes every
   node's cross-type children into the arena (`NodeEdges` via `all_children_spanned`,
   read back through `children_of(id) -> List<NodeRef>`), in field order — so pre-order
   traversal over `NodeRef`s IS document-order traversal, with zero per-variant code.

3. **The tests measured the cost of not having it.** The emit-shape tests assert
   structural properties of the generated parser by grepping its TEXT. Two failure
   modes, both measured in the t-47hc.8 slices: ~30 files of pin updates across two
   days for zero-behavior emitter changes (the brittleness tax), and text oracles that
   go silently green when the property drifts (the t-bw9s vacuity class — three
   engine-differential files were vacuous in production).

## The three layers

```text
L-edges   arena NodeRef graph (exists)         children_of / all_children_spanned
L-sel     THIS DESIGN — pure selection values   ast(store, ids) -> Sel, chainable
L-db      L6 named queries (exists, grows)      memoized indexes: parents, fn-by-name,
                                                node-at-position — LSP-incremental
```

L-sel is pure over `(store, refs)` — query-shaped from day one per the L6 rule — so
any L-sel composition can be lifted into an L-db family without rework. L-db is where
cost lives (indexes, memoization, invalidation by store fingerprint); L-sel is where
*vocabulary* lives.

## The Sel value

```text
type Sel = { store: NodeStore, refs: List<NodeRef>, desc: string }
fn ast(store: NodeStore, ids: List<StmtId>) -> Sel      // a program selection
```

Chainable, eager, immutable — each combinator returns a new Sel. `desc` is the
breadcrumb: every combinator appends its own step (`fns() -> named("parse_unary")`),
so failure messages name the query, not the internals.

### Navigation

- `children()` / `descendants()` — one step / transitive, pre-order, cross-type
- `stmts()` / `exprs()` / `pats()` — kind filters over the current selection
- `nth(i)` / `first()` — positional
- `ancestors()` — **L-db backed** (see below); absent until its first consumer lands

### Declaration views (typed)

- `fns() -> List<FnView>` / `fn_decl(name) -> FnView` — annotation wrappers peeled
- `FnView = { name, params, ret, body: Sel, id }` with accessors; `types()` / `enums()`
  follow the same pattern when a consumer needs them
- Typed views are the autocomplete surface the LSP/linter want; generic Sel remains
  underneath for everything else

### Extraction

- `callees() -> List<string>` — every named call under the selection, document order
  (Ident + QualifiedIdent callees; computed callees record nothing)
- `locals() -> List<string>` — `let`/`mut` binding names, document order
- `tail_callee() -> string` — the body's last statement when it is a bare call, else `""`
- `spans()` / `at_byte(n)` — positional entry (at_byte joins with L-db node-at-position
  for LSP-scale use; a linear scan version serves tests immediately)

### Predicates & the anti-vacuity discipline

- `exists()` / `count()` — explicit gates
- `must() -> Sel` — **panics on an empty selection**, message = the desc breadcrumb.
  A spec test that asserts through `must()` crashes loudly on a renamed fn instead of
  passing vacuously — the t-bw9s lesson made structural, API-wide. LSP/linter paths
  use `exists()` and never `must()`.
- Extractors on empty selections return values that cannot satisfy an equality
  (`""`, `0`, `false`) — the second net under the first.
- `calls_before(a, b)` — true iff both appear and a precedes b (absent endpoints are
  failure, not vacuous truth)

## L-db integration (the LSP story)

Expensive derived facts register as `QueryKey` families in the existing `Db`
(`query/passes.av` pattern): `parents_index` (reverse edges, keyed on the store
fingerprint — resolves the fork: no arena format change, no ingest-path cost,
invalidation for free), `fn_by_name`, `node_at_byte`. `Sel.ancestors()` and
LSP-scale `at_byte` fetch through a db handle; tests that don't hold a db use the
linear fallbacks. avra-server's shared services (21.2) are compositions of these
families plus resolver/typeck side-tables — out of scope here, but this is the
vocabulary they will be written in.

## What this replaces, and what it deliberately does not

Migrating (waves, per t-6iee): the nine tail assertions → `fn_decl(x).must().tail_callee()`;
`emitted_rule_speculates` and the scaffold-local pins → `locals()`/`calls_before`;
dispatch-order and guard-shape pins → callee-order and (later) shape combinators.

**Byte contracts stay byte-exact:** the regen guard (file == emission), diff-test
(IR equality), F-code signatures. Those are contracts ABOUT bytes; the shape tests
were never about bytes.

## Bootstrap placement

`src/core/sel.av` (+ `core/tests/sel_test.av`) — core because it is generic AST
infrastructure (arena + ast types only; no parse import, so no cycle: callers parse).
The features/grammar `emitted_query.av` spike is absorbed by this module.

## FINDING (2026-08-17, measured): there is no generic id-crossing traversal yet

The layering above assumed `children_of` walks the tree. **It does not, on parser
output.** On the B-final id-native enums the derive_walker classifier treats id
fields (ExprId/StmtId/…) as leaves: the value walker and the arena's stored edges
both cover only INLINE children (ValueType and friends), the faithfulness oracle
holds trivially at zero, and every id-crossing consumer today (render_*,
fingerprints, typeck) is per-variant code. Measured: `children_of` on a parsed fn
body's `Stmt.Expr` rows is empty while the calls are plainly reachable by direct
field reads. Consequence: **subtree verbs (descendants/callees/locals/at_byte)
require substrate work first** — either the classifier learns id-children (edges
become complete on the parse path) or traversal derives on demand. That is L4's
unfinished business and the design session's first work item; building the
recursion by hand inside Sel would be walker #13.

## The thin slice (ships now — the ONLY part that ships before the design session)

Test infrastructure, not "the introspection API": `Sel`/`FnView` with the verbs that
work on DIRECT FIELD READS today — `fns`/`fn_decl` (annotation-peeled), `body`,
`tail_callee`, `exists`/`count`/`must`/`found` sentinels — plus
`test_runner.sel_of_source` (the parse entry; test_runner already imports parse).
Subtree verbs ship with the traversal substrate, not before: a `calls()` built on the
partial edges would answer false-because-blind, which is the vacuous-guard failure
this whole effort exists to kill. Rationale for shipping the remainder now: the
LanguageFeature migration churns emitter output continuously, and the tail-assertion
class alone cost a nine-file sweep this week; converting what CAN be structural now
stops that portion of the tax, and thin-Sel call sites migrate mechanically to the
eventual real API.
