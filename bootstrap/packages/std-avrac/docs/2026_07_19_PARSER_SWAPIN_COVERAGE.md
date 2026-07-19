# Parser swap-in coverage map (ps3t.6.5.12 prep)

**Purpose.** ps3t.6.5.12 (the terminal step of ps3t.6.5) replaces the
hand-written recursive-descent parser in `src/parse/mod.av` with the
grammar-DSL parser, *family by family*, each swap gated behind the HRN
differential test (byte-identical IR) + the selfhost fixed point. Because the
compiler parses **itself**, a family cannot be swapped until its DSL grammar
covers **100% of the surface the compiler's own source uses** — a subset of the
full language, but a hard bar.

This document is the prep artifact: for each family, exactly what stands between
the current grammar and its swap-in. It is the output of three read-only gap
analyses (type / pattern / expr-stmt-decl) plus the existing differential
oracles. It does **not** perform the swap (that needs the blockers below to
land first); it defines the path.

## Verdict at a glance

| Family | Swap-in readiness | Gating blocker |
|---|---|---|
| **Type** | Ready (real usage) | none — `@pkg::T` already served by `@hand(qualified_type)` |
| **Declaration** | Near — most gaps plain-addable | `@annotations`/doc-comments; `component` |
| **Statement** | Near-ish — core covered | `let`/`return` (`@hand`, done); `match`-stmt struct-lit mode; annotations |
| **Pattern** | Ready (real usage) | none — optional-match gap now closed |
| **Expression** | Far | **ps3t.6.7 lexer modes** + parser modes (struct-lit / map-vs-block) |

**Bottom line:** the *type* and *declaration* families are the realistic first
swap-in candidates. The *expression* family — and therefore the whole-program
swap — is gated on **ps3t.6.7 (lexer modes)** for string interpolation and
doc-comment tokens, plus the `allow_struct_lit` / `is_map_literal` **parser
modes**. Until those land, the unified grammar can only grow along the
"plain-addable" rows and keeps leaning on `@hand` for the newline / struct-lit /
template-sensitive core. No amount of grammar-only work reaches self-host
fidelity for expressions without the mode infrastructure.

## Diagnostic equivalence (ps3t.6.5.9)

The swap-in requires "same AST **and same errors**." AST equivalence is proven
by the `*_equivalence_test` + `composed_program_test` oracles. Accept/reject
equivalence is now proven by `diagnostic_equivalence_test.av`: the DSL and hand
parser agree on rejecting missing-required-terminal malformations (fail-fast
parity), and the hand parser's **lenient edges** (e.g. `type X =` with an empty
RHS, which it tolerates and a clean grammar rejects) are *pinned* as documented,
tested boundary facts. Per the 6.5.9 finding, the lenient edges reconcile only
on the emitted parser (both fail-fast there), so they are deferred to validation
*during* the swap-in, not before.

## Type family — READY (for real usage)

The whole-program DSL type rules (`avra_program_grammar`, the `type_expr` /
`type_atom` / `fn_type` / `dyn_type` / `list_type` / `paren_type` / `named_type`
rules) cover **every type-expression form the compiler's own source uses**.
Representation is identical: both build a surface `TypeExpr` lowered by the
shared `type_expr_to_vtype`. The one selfhost-critical form — qualified
`@pkg::mod::T` (from re-emitted `@comptime` bodies) — is already served by
`@hand(qualified_type)` → `run_hand_type`. Residual hand-parser-only forms
(dotted `a.b.C` paths, nullable `dyn T?`, `~`-splice-in-type) have **0
occurrences** in selfhost source or are quote-only (never routed through the
DSL), so they are fidelity-only, not blockers.

**Swap-in shape (deferred):** an inverse-`@hand` runner — the hand parser
delegates a whole type expression to the DSL `type_expr` rule over a shared
store, resyncing its cursor by byte position (the mirror of `run_hand_type`).
The one real cost is performance: the hand `Parser` is a byte-streaming lexer
with no token list, so a naive delegation re-lexes the file per annotation
(O(n²)). An efficient swap needs a lex-once/token-sharing layer on the Parser.

## Pattern family — READY (gap closed in this prep)

The DSL pattern grammar (`avra_pat_grammar`) reproduces the entire pattern
surface `parse_pattern` accepts with byte-identical trees (wildcard / rest /
literals incl. negatives / type patterns `int(n)` / bare + bound + nested
variants / right-assoc or-patterns). The one real gap the analysis found — the
**optional-match arm surface** `let <name> ->` (→ `.Some(name)`) and `none` /
`null ->` (→ `.None`), used in the test suite's optional matches — is **closed
here**: two pure-grammar alternatives (`opt_present = "let" name:IDENT`,
`opt_absent = ( "none" | "null" )`) delegating to the SHARED reducer cores
`pattern_optional_present` / `pattern_optional_absent` the hand parser already
uses. No lexer/parser mode needed (the lexer emits `KwLet`/`KwNone`/`KwNull` and
the executor matches keyword literals). Proven by `pattern_equivalence_test`
(executor path) + `--emit-gen-check` (generated path). The only residual is the
UNUSED typed variant-payload binding `.Variant(x: T)` (fidelity-only, 0
selfhost occurrences). Guards `pat if cond ->` live on the match ARM, not the
pattern, so they are orthogonal to the pattern-parser swap.

## Expression family — FAR (gated on ps3t.6.7)

The *isolated* `avra_expr_grammar()` nails the full operator-precedence spine
(logical → bitwise → shift → comparison → additive → multiplicative → unary →
postfix) with field/index/call suffixes and grouping. But the *unified*
`avra_program_grammar()` that 6.5.12 swaps in is far thinner (its `expression`
bottoms out at `equality`; its `suffix` is field+call only; its `primary` is
`NUMBER/STRING/true/false/@hand(quote)/@hand(ident)`).

**Plain-addable now** (regular syntax, no modes): enum ctors `.Variant(..)`,
tuples, list + comprehension literals, `??`, `?.`, `catch`, `when`, `spawn` /
`isolated` / `channel<T>(..)`, pipe `|>`, `is` / `in` / `with`, ranges, slices,
assignment, `and`/`or`/`not` aliases, `float` + `none` terminals.

**Blocked** (need modes / @hand):
- **string interpolation** `"..{e}.."` + tagged templates — the `Tk.Template`
  lexer token → **ps3t.6.7 lexer modes**.
- **struct literals** `Foo{..}`, control-flow-header braces, block-vs-map — the
  `allow_struct_lit` + `is_map_literal` **parser modes**.
- **table literals**, `it`-sugar, match-arm dot-suppression — contextual modes.
- **generic call** `f<int>()` — speculative `<` backtracking (gnarly-5%).
- **`quote`/splice**, qualified `@pkg::T` — the `@hand` escape hatch.

## Statement family — NEAR-ISH

COVERED: `while` / `for` / `if` / `break` / `continue` / block / expr-stmt /
`use`. Plain-addable: `mut` / `const` / destructure / `defer` / `errdefer` /
`spec`-`given`-`then` / `select` / `parallel` / `export`. Blocked: `let` +
`return` (deliberately `@hand` — let-else desugar + newline-sensitivity, already
routed, ps3t.6.5.10); `match`-statement (struct-lit mode on the subject);
`@annotations` + doc-comments (`@`-disambiguation + the `DocComment` lexer token,
ps3t.6.7); `component` instantiation (off-DSL feature).

## Declaration family — MOST COMPLETE

COVERED: `fn` / `type`(struct) / `enum` / `trait` / `impl` / `mod` / `use`.
Plain-addable: generics `<T: Bound>` + `where`, `extern fn`, `export` prefix,
newtype / union / shape / type-operator (`without`/`only`) aliases, in-`impl`
assoc types. Blocked: `@annotations` / `@comptime` / doc-comments (shared with
statements); the whole `component` subsystem (char-level config peeking, dynamic
name registration, raw `TokenStream` brace-capture — no DSL surface).

## Sequencing implication

1. **ps3t.6.7 (lexer modes)** is the critical-path dependency for the
   expression family and thus the whole-program swap. It must land first.
2. The **parser-mode** infrastructure (`allow_struct_lit`, map-vs-block) is the
   second gate — struct literals and brace-disambiguation are pervasive.
3. In the meantime the **type**, **pattern**, and **declaration** families are
   the realistic first swap-in slices (type first — smallest, fully covered;
   pattern next — now fully covered), each needing the inverse-`@hand` runner +
   the lex-once token-sharing layer.
4. Diagnostic equivalence (6.5.9) is best finished *on the emitted parser*
   during each family's swap, where both parsers share the fail-fast model.
