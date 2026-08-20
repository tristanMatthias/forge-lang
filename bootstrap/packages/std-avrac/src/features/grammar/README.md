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
               ( "{" "#" name "}" )?          // ...capped by a capture's length
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
- **commit** `@cut` (the PEG cut) marks the point a `@try` branch stops
  speculating: `@try "for" v:IDENT "in" lo:expression ".." @cut hi:expression …`.
  Before it, a reported diagnostic means "wrong alternative, roll back"; after
  it, the branch is committed and the diagnostic is a real parse error the branch
  owns. That conflation is why a speculative branch could not hold its own error
  messages, and why ambiguous statement forms needed an `@hand(*_edge)` sibling
  purely to carry diagnostics. Only legal inside `@try` (a predictive branch has
  nothing to commit) and it fires only while the branch has reported nothing —
  both enforced at grammar-parse time.
- **bound** `x{#cap}` caps a `*`/`+` at the LENGTH of a capture list already
  collected in the same branch: "repeat `x`, at most `#cap` times". This is what a
  COLUMNAR sub-language needs and a plain `*` cannot say — a table's body rows take
  as many cells as the header declared, so the count is not a constant in the
  grammar but a property of something already parsed. Captures inside `( … )*`
  already collect into parallel lists, so the count is already in hand as a
  capture's length; binding it needs no integer expressions in the DSL and no
  attribute-evaluation engine, just the name. It is an UPPER bound, not a
  requirement (a short row is not an error), and it is rejected at grammar-parse
  time when it could not mean anything: on `?` or a non-repetition, or naming a
  capture that is unbound, bound later, scalar, or written by the repetition
  itself. `match … table` is the first spender — its cell loop is literally
  `while i < value_count`, a bound, NOT the row-width VALIDATION it was long
  recorded as (that check belongs to the separate `table { }` literal).
- **raw capture** `body:@rawbrace(tag)` consumes every token up to the `}` that
  balances an already-consumed `{` and binds the verbatim source slice between
  them (trimmed) — the DSL spelling of the hand parser's
  `capture_balanced_brace_body`, for a feature block whose body is NOT Avra
  syntax and is handed to a runtime engine as a string (`grammar { … }` →
  `parse_grammar("…")`). Depth counting is token-level, so a `{` inside a
  string literal never miscounts; the cursor stops AT the balancing `}` so the
  rule's own trailing `"}"` literal owns that token and its diagnostics. `tag`
  names the construct in the unterminated-EOF message. Must be labelled, takes
  no repetition suffix, and both engines lower to the one shared
  `rawbrace_scan` (executor.av).
- **abort** `@require` (`@cut`'s dual) marks a terminal whose absence STOPS the
  rule: `"for" v:IDENT @require "in" …`. By default both engines are
  error-tolerant — a missing token reports and the sequence keeps building a
  partial node — which lets a malformed header run away and swallow whatever
  follows. `@require` is the grammar's way to say what the hand parser says with
  `return .Err`. It carries no message of its own: the diagnostic still comes from
  `@expect`, so control flow and diagnostics stay separate seams. Inside a `@try`
  branch before a `@cut` it degrades to plain reporting, because the rollback
  already is the abort.

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
the GRAMMAR (`grammar_expr`, `grammar/mod.av`), whose generated
`parse_grammar_expr` uses `rawbrace_scan`. The hand block parser that used to
live in `parser.av` is gone — it was reached only through a `parse_expr`
registry slot nothing could invoke, and `parse_primary` itself was deleted in
t-47hc. No new AST
node and no seed cycle — the emitted tree flows through the existing passes.

## Validating a leaf migration (the gate order)

A Phase-3 slice replaces an `@hand` leaf with real alternatives. That changes
FIRST sets **globally**, not just in the rule you edited — so the feature's own
tests are not sufficient. Run these, in this order:

1. `make build-quick`
2. **Regenerate the family's parser and READ THE DIFF** (`diagnose.sh
   --emit-regen-{expr,decl,pat,type}`). This has caught every silent bug in this
   area and no test has. Look for `while false { …_list.push(…) }` (an
   undeclared external FIRST, silently dropping a whole repetition) and for
   `capval_to_expr` where a typed coercion belongs (an external rule also loses
   its result KIND, not just its FIRST).
3. `diagnose.sh --emit-gen-check` — GENPASS across all five families.
4. **`bs2 test features/grammar/tests/grammar_ambiguity_guard_test.av`** — the
   one most easily forgotten, because it lives outside the feature you touched.
   An `@hand` leaf is OPAQUE to the FIRST/FIRST analysis; making it native turns
   its lead tokens concrete and can EXPOSE a pre-existing ordered-choice shadow
   elsewhere in the grammar. That is usually intended (the ordered choice already
   resolved that way), but it must be confirmed against the hand parser and then
   allowlisted by exact rule + branch pair in `is_intended_shadow` — never by
   loosening the predicate. Missing this is what turned #1029 red in CI.
5. `features/grammar/tests/error_recovery_diff_*_test.av` — the recovery
   TREE oracle, not just F-codes. One corpus, split per scenario
   (t-kdyj.13 — as a single file its unit process measured 8.4GB);
   the shared oracle helpers live in `parse/differential.av`.
6. Isolate-run any negative/diagnostic test you touched: **diff-test does not
   cover the error text of invalid programs**. Note also that once the DSL
   errors, the flip falls back to the authoritative hand parser, which then owns
   the reporting — so at whole-program level a grammar's own `@expect` message is
   generally NOT observable. Assert F-code agreement against the hand oracle plus
   a structural check on the emitted parser instead.
7. CI's cold `diff-test` is the authority on byte-identity; a local `PREBUILT=1`
   run reuses caches that can mask real breakage.

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
