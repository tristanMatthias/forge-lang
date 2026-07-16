# Grammar-DSL ↔ Embedded Sublanguages — the shared foundation

**Status:** design note (2026-07-16) · links `ps3t.6` (L4 grammar-DSL) to the
embedded-sublanguage vision.

**One line:** the grammar-DSL built in `ps3t.6` is the *same engine* the
embedded-sublanguage plan (`sql { … }`, `html"…"`, `regex { … }`) was designed to
sit on. Building it for the compiler's own parser yields their foundation for free
— "the grammar is a value the compiler runs" applies to Avra *and* to any package.

## The plan it connects to

- `docs/spec.md §12 "Embedded Sublanguages"` — `sql { … }` / `regex { … }` /
  `sh { … }`, and the mechanism (§12.4): the outer parser sees a **registered**
  `<keyword> { … }`, brace-matches, hands the raw inner text to **the package's
  parser**, which returns typed AST nodes the compiler then lowers.
- `docs/2026_06_30_STRINGS_FROM_THE_FUTURE.md §5` — `syntax sql = grammar { … }`
  ("add SQL-as-syntax as a typed package"). The `grammar { }` here IS the
  `ps3t.6.5` construct.

## What ps3t.6 already provides them

| Embedded-DSL need | ps3t.6 piece |
|---|---|
| "the package's parser" (§12.4 step 3–4) | the generator/executor — a grammar → an error-tolerant RD parser producing typed AST |
| good errors + a usable tree on a half-typed block (LSP/compile-validate) | `@expect`/`@recover` → partial-tree recovery (`Expr.Error`/`Missing`) |
| switching how you lex on entering `sql { … }` / `html"…{x}…"` | lexer modes (`ps3t.6.7`) — the SAME machinery as string interpolation |
| a sublanguage's gnarly corners without bloating its grammar | the `@hand(fn)` escape-hatch |
| authoring a sublanguage as data, not hand-rolled code | the seed parser + `grammar { }` surface (`ps3t.6.5`) |

## What is NOT covered by the grammar-DSL (separate stories)

1. **Non-Avra AST targets** — the executor's build actions are Avra-`Expr`-specific
   today, behind a *pluggable seam* (proven only on `Expr`). A `SqlAst`/`HtmlNode`
   target implements that package's actions — the seam is designed for it, but it's
   real work.
2. **Block registration** — "parser sees a registered keyword, brace-matches, hands
   off" is a distinct mechanism; a shipped path already exists in
   `body: TokenStream` components (`vez6.9`, token-balanced raw capture →
   macro parses via `token_body_text`). The grammar-DSL is what makes that macro's
   parser tractable rather than hand-written.
3. **Per-package semantics** — SQL columns vs model defs, return-type inference, IR
   lowering: each package's typechecker/codegen, orthogonal to parsing.
4. **`sql"…"` / `html"…"` typed strings** — a related but distinct
   provenance/tainting feature (a value that has been through an escaping
   boundary), not a parsing concern.

## Takeaway

The grammar-DSL is the **shared parsing substrate**, and lexer modes are the shared
**entry mechanism**, for embedded sublanguages. The per-language semantics,
registration glue, and typed-string safety sit on top. So the `ps3t.6` work isn't
just the compiler's parser — it's the substrate `@std.sql` / `@std.html` were
always going to be authored against.
