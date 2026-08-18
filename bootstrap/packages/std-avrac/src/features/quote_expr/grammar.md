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

`stmts`-quote captures multiple stmts:

```avra
let sl: List<StmtId> = quote stmts {
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

## Ownership (t-kd4y.3.4)

The three rules — `quote_expr`, `quote_type_expr`, `quote_arm_expr` —
are declared ONCE, in `mod.av`'s `quote_lang()` gram, and reach every
composed expression view through `feature_expr_grammar_fragments`
(`gram_family = "expr"`). The engine's expression *ladder* still owns
the DISPATCH — `unary`'s `@peek(quote_arm)` / `@peek(quote_type)`
alternatives and the unguarded catch-all, in that order — because which
primaries the ladder tries, and in what order, is engine structure.

The lowerings live in `lowering/`: `mk_quote` / `mk_quote_type` /
`mk_quote_arm` plus their ABI adapters and three `spanned` manifest rows
under the existing `MkQuote` / `MkQuoteType` / `MkQuoteArm` build names.
The engine's central executor arms, emit templates, and `central_build_kind`
rows for those names are gone; the generated parser calls the adapters
through `call_with_build_sp` and derives its `use
features.quote_expr.lowering.{…}` import from the manifest.

`lowering/` imports ONLY `features.grammar` + `core` — the generated
parser imports it, and widening the parse closure (e.g. by importing the
feature module itself, which pulls in `lower.av`'s typeck/codegen edges)
re-enters modules whose derives already ran and F4012s on the metadata
library path.

The splice builds (`MkSplice`, `MkSpliceStruct`, `MkSpliceType`,
`MkSpliceName`, `MkSpliceArm`, `MkPlainName`) are still engine-central:
their rules are branches of `unary` and `type_atom`, which did not move,
and a feature may only supply builders its own gram references.

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
| `stmts`  | statement list   | `List<StmtId>`  |
| `type`   | type expression  | `ValueType`     |
