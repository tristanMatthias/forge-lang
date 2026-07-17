# The gnarly-5% catalogue (ps3t.6.5.10)

The grammar-DSL notation (GRAMMAR_DSL.md §1–§4) expresses ~95% of Avra's
surface. The remaining ~5% are places the hand-written parser does something a
stateless token-grammar structurally can't — context-sensitive disambiguations,
hygienic desugars, stateful side-effects, and lexer-level modes. Per the design
(§2.4/§2.5), each of these stays in hand-written code the grammar reaches by
name via the **`@hand(fn)`** escape hatch, or in a **lexer mode** (ps3t.6.7).

This file is the catalogue: for each case — what the hand parser does, why the
pure grammar can't express it, and how the DSL routes it.

The `@hand` statement/declaration delegation mechanism is `run_hand_stmt`
(executor.av): it builds a real `Parser` over the original source, **sharing the
DSL's `NodeStore`** (the `parse_program_source_shared` pattern), positions it at
the rule's first token (advancing token-by-token so line/column stay accurate),
calls the real hand-parser entry, and resyncs the DSL token cursor past what it
consumed. This is the executor's mini swap-in — the store-sharing hand-off that
ps3t.6.5.12 generalises. Adding a case is: an `is_stmt_hand` name, a
`hand_starts` FIRST-token, and a `run_hand_stmt` dispatch arm.

## Routed — `@hand` (done)

| Case | Hand parser | Why not pure grammar | Route | Landed |
|---|---|---|---|---|
| **`component`** | `parse_component_decl` | Stateful: `register_component_def` MUTATES the parser's feature registry (so later `name inst { … }` parses keyword-free); char-level `peek_after_ident_*` lookahead; `body: TokenStream` raw bodies | `@hand(component_decl)` | #835 |
| **`let … else`** | `parse_let_statement` → `build_let_else` | Hygienic block-expr DESUGAR minting a fresh gensym temp (`$letelse$N`); a stateless grammar can't reproduce a gensym-named tree byte-identically | `@hand(let_stmt)` | #839 |
| **bare `return` (newline)** | `parse_return_statement` | Newline-sensitive: `return\n<expr>` is `ReturnEmpty` + a separate statement (`current_line != prev_line`); the grammar's `?`-optional is greedy on FIRST-set alone and can't see the line boundary | `@hand(return_stmt)` | #840 |
| **`>>`-split in generics** | `maybe_split_shr` | The lexer merges two adjacent `>` into one `>>` (Tk.Shr); a nested generic close (`List<List<T>>`) presents its two `>` as one shift token, which a `">"` terminal can't match | `PState.split_gt` — the executor's terminal matcher splits a `>>` when a single `>` is expected (consume the first half, leave the second, no advance) | #841 |
| **`@pkg::T` qualified types** | `parse_type_atom`'s `@` branch | A package-qualified type name (`@std::core::Foo`, + generic / nullable suffixes) has no pure-grammar production (`named_type` is a bare IDENT); `::` paths interact with the enum-ctor-vs-method disambiguation | `@hand(qualified_type)` via **`run_hand_type`** — the TYPE analogue of `run_hand_stmt`: delegates a type ATOM to `parse_type_atom`, returns a `TypeExpr` VALUE (no arena → no store-sharing), routed to `CapVal.TExpr`. Composes as one `type_atom` alternative, so it nests inside pure-grammar generics and stacks with `>>`-split | this slice |

Note: the pure-DSL `MkReturn(re?)` build (ps3t.6.5.4) already handles `return` /
`return expr` where the boundary is `}` / EOF (FIRST-set rejects those tokens);
`@hand(return_stmt)` is the escape for the residual `return\n<expr>` split. The
`>>`-split is NOT `@hand` — it's a token-level fix in the executor's terminal
matcher (the interpreter/emitter both apply it), so nested generics parse purely
in the grammar; deeper nesting works because `>>>` lexes as `>> >` and each `>>`
splits once.

## To route (remaining)

| Case | Hand parser | Why not pure grammar | Planned route |
|---|---|---|---|
| **string interpolation `"…{e}…"`** | lexer emits `Tk.Template`; parser desugars to concat | A lexer MODE (the string body re-enters expression lexing at `{`). `lex_real` surfaces `Tk.Template` but no grammar terminal matches it. | Lexer mode (ps3t.6.7) + an `@hand` template-expr builder. |
| **`~` prefix (splice vs bitnot)** | `quote_depth`-gated: inside `quote { }` a leading `~` is `Expr.Splice`, else bitwise-NOT | Context-sensitive on a parser mode counter the grammar doesn't carry. | `@hand` for the unary-prefix position, or a mode. |
| **struct-lit-in-header** | `allow_struct_lit=false` in control-flow headers | `if Ident { … }` — the `{` is the loop/if body, NOT a struct literal; the hand parser flips a mode flag while parsing the header. A grammar can't carry that mode. | A grammar mode annotation / `@hand` for the control-header expression. |

## Status

Five cases are routed and proven byte-equivalent to the hand parser: the
stateful `component`, the hygienic `let … else` desugar, `return`
newline-sensitivity (via `@hand` / `run_hand_stmt`), nested-generic `>>`-split
(via `PState.split_gt`, a token-level fix), and `@pkg::T` qualified types (via
`@hand` / `run_hand_type`, the TYPE analogue of `run_hand_stmt`). Differential
tests: `decl_component_hand_test.av`, `stmt_return_letelse_test.av`,
`gnarly_return_newline_test.av`, `gnarly_nested_generics_test.av`,
`gnarly_qualified_type_test.av`.

The `@hand` delegation now spans all three node kinds: `run_hand_stmt` (→ StmtId,
store-sharing), `run_hand_type` (→ TypeExpr value), and `run_hand` (→ ExprId, the
original ident/number). The remaining three entries are the open work of
ps3t.6.5.10: `~` prefix needs an EXPRESSION `run_hand` analogue that delegates to
the hand parser (or a `quote_depth` mode); string interpolation and
struct-lit-in-header need lexer/parser MODE support (coordinated with ps3t.6.7).
