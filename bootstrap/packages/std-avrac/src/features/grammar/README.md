# `features/grammar` — the grammar-DSL (L4, `ps3t.6.3`/`.4`)

A small EBNF-style **grammar DSL** and the machinery that turns it into an
**error-tolerant recursive-descent parser**. This is the parser half of Layer 4
(the derive framework): "the parser is derived too" — one grammar is the single
source of truth for world-class errors, partial-tree recovery, and (later)
incremental reparse.

Design: `docs/2026_07_15_L4_DERIVE_FRAMEWORK_DESIGN.md` §2 · notation +
worked proof slice: `docs/2026_06_14_GRAMMAR_DSL.md` · spine Layer 4:
`docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md`.

## The notation (~9 constructs)

```text
grammar Name {
    rule     = alternation
    alt      = seq ( "|" seq )*
    seq      = labelled+ ( "->" build | annot )*
    labelled = ( name ":" )? postfix        // name: = capture
    postfix  = primary ( "*" | "+" | "?" )?  // repetition
    primary  = NAME                          // UPPERCASE = named terminal (NUMBER)
             | ruleref                        // lowercase = nonterminal ref
             | "literal"                       // exact source text
             | "(" alt ")"                     // group
    build    = Ctor(a, b) | helper(a, b) | e  // -> constructs the node
    annot    = @expect("tok", "msg") | @recover(sync_to: "tok")
}
```

- **capture** `x:thing` binds a sub-result — a nonterminal binds its **node**, a
  terminal binds its **token**; inside `( … )*`/`+` captures collect into
  **parallel lists**.
- **build** `-> …` constructs the result from captures: a node constructor
  (`Unary(op, operand)`), a fixed helper (`fold_binary(l, op, r)` left-folds a
  repeated `(op rhs)*` into a left-associative chain), or a pass-through of a
  named capture (`-> e`). No `->` passes the single sub-result through.
- **errors** `@expect`/`@recover` lift Nystrom's by-hand `synchronize()` into
  the grammar: a missing required terminal reports the message and panic-mode
  synchronises to the recover target — yielding a partial tree + diagnostics,
  never a hard bail.

The gnarly 5% (string interpolation, newline-sensitivity, `~`, `<` generic-vs-
less-than) stays **out** of the notation — in the lexer or a hand-written
escape-hatch rule (`ps3t.6.7`).

## Modules

| file | role |
|---|---|
| `mod.av` | `ps3t.6.5` — registers the `grammar` **expression keyword** feature (the `grammar { … }` surface syntax) via the generic `Feature.expr_keyword` seam |
| `parser.av` | `ps3t.6.5` — the compiler-side block parser: captures the `grammar { … }` body verbatim and desugars it to a runtime `parse_grammar(<body>)` call (`impl Parser`) |
| `ast.av` | the grammar-AST (`Grammar`/`Rule`/`GNode`/`GSeq`/`GItem`/`GPrim`/`GRep`/`GBuild`/`GAnnot`) — the contract between the parser and the generator |
| `seed_parser.av` | `ps3t.6.3` — the hand-written RD **seed parser**: DSL scanner + RD parse of the grammar-of-grammars → a `Grammar` value. Reads grammar **text** (a string), so no new Avra surface syntax is needed (bootstrap-window clean). |
| `chars.av` | shared ASCII char classification for both scanners |
| `render.av` | render a `Grammar` back to canonical DSL text |
| `lex.av` | the target-language tokeniser (the "lexer" that feeds the generated parser) — the expression slice: numbers / strings / booleans / idents / punctuation |
| `executor.av` | `ps3t.6.4` — the **generator, executable form**: runs a `Grammar` as recursive descent over a token stream and produces real `Expr` nodes, with FIRST-set branch selection, `*`/`+`/`?`, panic-mode recovery, and pluggable semantic actions (the target-specific seam) |
| `emit.av` | `ps3t.6.4` — the **generator, source form**: renders the same lowering as `parse_<rule>` function source, per Nystrom's correspondence |

## Usage

```avra
use @std.avrac.features.grammar.{parse_grammar, run_grammar_expr, dump_expr}

let gp = parse_grammar("grammar Expr { … }")   // text -> Grammar
let r  = run_grammar_expr(gp.grammar, "1 + 2 * 3")   // run over source -> Expr AST
dump_expr(r.store, r.root)   // "(+ 1 (* 2 3))"
r.had_error                  // false; diagnostics in r.diags on malformed input
```

### `grammar { … }` surface syntax (`ps3t.6.5`, slice 1)

The unquoted block drops the string quotes — it is sugar for the exact same
`parse_grammar` call (byte-identical AST), so it yields the same `GrammarParse`:

```avra
use @std.avrac.features.grammar.{parse_grammar, run_grammar_expr, dump_expr}

let gp = grammar {                             // anonymous, bare rules
    expression = l:term ( op:("+" | "-") r:term )* -> fold_binary(l, op, r)
    term       = NUMBER
}
let r = run_grammar_expr(gp.grammar, "1 + 2 - 3")
dump_expr(r.store, r.root)   // "(- (+ 1 2) 3)"
```

The rule text between the braces is captured verbatim (balanced-brace raw
capture) and desugared to `parse_grammar("…")`; `parse_grammar` resolves via
the same `use` the string API already needs. Mechanism: the generic
`Feature.expr_keyword` / `Registry.expr_parsers` dispatch in
`core/registry.av` (the "registered `<keyword> { }` → package parser" seam
that future `sql { }` / `regex { }` sublanguages share), routed from
`parse_primary`; the block parser + desugar live in `parser.av`. No new AST
node and no seed cycle — the emitted tree flows through the existing passes.

## Status

**Landed** (this PR): the seed parser, the executable generator + error-tolerant
recovery, the source-form emitter, and the `@hand` escape-hatch. The whole
**expression family** is differential-tested byte-equivalent to the shipping
hand-written parser (`parse_expression_native_probe` as oracle): literals,
identifiers, strings, the full binary-operator precedence chain, prefix unary
(incl. `~`), grouping (`Grouping` preserved losslessly), and postfix
(field / index / call / method). ~54 specs green across `tests/`.

**Not yet** (future work, tracked on `ps3t.6.5` / `.6.7`):

- **Lexer-stream integration** — the executor uses its own `lex.av` + a fresh
  `NodeStore`; wiring it to the real lexer token stream + build store is `.6.5`.
- **`grammar { … }` surface syntax** — slice 1 **landed**: the anonymous
  `grammar { rules }` block is sugar for a runtime `parse_grammar(<body>)`
  call (see Usage above), bootstrap-window clean (no new AST node, no seed
  cycle). Still ahead: the named `grammar Name { }` form, and the
  **seed-gated** compile-time lowering (parse the grammar at compile time →
  emit the generated `parse_<rule>` functions) that lets the generated parser
  replace the hand-written one in `src/`.
- **Lexer modes** (`.6.7`) — string interpolation + newline-sensitivity as
  formal lexer modes. Only the `@hand` escape-hatch half of `.6.7` has landed.
- Other rule families (statements / patterns / types / declarations), and
  method-dispatch as a distinct node where the hand parser uses one.
