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

```
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

## Status

Complete + tested on the **§2 Avra expression grammar** (the GRAMMAR_DSL.md §8
proof slice) — precedence, associativity, prefix-unary, comparison/equality
stratification, and partial-tree recovery (`(1 + 2`, `)`, `(1 + 2 * 3`). 25 specs
green across `tests/`.

**Next** (`ps3t.6.5`): scale the notation to Avra's full grammar rule-family by
rule-family behind the HRN differential test, and add the `grammar { … }` block
as Avra surface syntax (seed-gated) so the generated parser can splice
`Stmt.Function` AST into a real compile and replace the hand-written parser.
The gnarly-5% lexer modes + `@hand` escape-hatch are `ps3t.6.7`.
