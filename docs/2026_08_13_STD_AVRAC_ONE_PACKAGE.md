# std-avrac: the feature-as-component architecture (t-kd4y)

Directive (2026-08-13): one package that's really easy to read. Ratified same
day via user Q&A: the sprawl is killed by making each feature ONE
self-describing definition — **not** by dissolving features into pass files.

> "Each feature is ideally an Avra component that defines a bunch of things
> and is collected together intelligently. It defines everything. Its
> grammars, its docs, etc."

## Ratified decisions

1. **Feature form**: an Avra **component instance**. Each feature is one file
   whose heart is a `LanguageFeature` instance — the std-cli cmdgen mechanism
   (component + expansion) turned on the compiler itself.
2. **AST**: core keeps it. `Expr`/`Stmt`/`Pattern` stay central in
   `core/ast.av`; features declare grammar + hooks referencing central
   variants. (ps3t's AST-as-single-source-of-truth is untouched.)
3. **Schema scope, complete up front** (schema churn costs decoder-bridge
   cycles): grammar + pass hooks, docs, diagnostics, editor surface.
   Consumers land incrementally.
4. **Sequencing**: prototype on `defer` (tiny) and `match` (hard) behind all
   gates. Nothing else migrates until the user ratifies the result.

## The schema (features/mod.av declares it; features/lang.av adapts it)

```avra
component LanguageFeature {
    config {
        title: string = "",            // one-line summary
        docs: string = "",             // reference doc (markdown), IN the definition
        gram: Grammar = no_grammar(),  // the rules this feature owns
        diags: List<DiagSpec> = [],    // owned F-codes for `avra explain`
        snippet: string = "",          // editor completion template
        expr_tag: Expr? = null,        // dispatch sentinels (central AST)
        stmt_tag: Stmt? = null,
        expr_keyword: string = "",     // `kw { }` sublanguage seam
        parse_expr / emit_* / resolve_* / check_* / eval_*   // pass hooks
    }
}
```

- `register_lang(reg, f)` adapts an instance onto the core `Feature` record
  while both forms coexist.
- `feature_keywords(f)` DERIVES the feature's keywords from its grammar
  (identifier-shaped literal terminals) — highlighting/docs never get a
  second keyword list to drift.
- A feature file = hooks (plain fns) + one definition per registered
  feature + `tests/` beside it. See `features/defer.av` — defer + errdefer
  in one file, replacing `defer_stmt/{mod,parser,grammar.md}`.

## What the prototype proved (2026-08-13)

- The full schema round-trips through the component system: fn-ref config
  values, `grammar { }` block values, docs/diag/snippet fields, `with`
  overrides. bs2 builds, defer tests 34/34, metadata lib probe exit 0.
- **Cross-file components required a real fix**: every Parser built a fresh
  registry, so a component declared in one file could not be instantiated
  from another — parse-time state was per-file. Fixed by putting the parse
  registry on the program-wide `NodeStore` (`parse_registry`, lazily
  installed, re-synced in `parse_program_source_shared` after the store
  swap). Guard: `component_decl/tests/cross_file_registry_test.av`.
- **Bootstrap window**: instance-block syntax (`LanguageFeature defer {…}`)
  in compiler src needs a SEED whose parser has that fix — so definitions
  use the expansion's factory form (`LanguageFeature_new("defer") with
  {…}`) until the fix rides the seed train, then flip to instance blocks.
  Same discipline as any new-surface dogfood.
- **Component type-safety holes found** (pre-existing, filed as t-bnyg):
  instance pair values are NOT typechecked against config field types
  (silent layout corruption — hit live with GrammarParse-into-Grammar), and
  top-level instances referenced from fns ICE. The prototype avoids both by
  construction; t-bnyg gates the wider migration.

## Assembly & derived surfaces (staged)

Today: `init_features` registers instances via `register_lang`; the grammar
views keep their own copies of migrated features' rules with a render-equality
drift guard (`defer_stmt/tests/lang_definition_test.av`). Next: grammar
composition consumes `gram` from the definitions (the t-47hc.8 rail), docs →
`avra lang`, diags → `avra explain`, editor surface → the t-47hc.6
multipliers. End state: `feature_grammar_fragments` and the registration
tables are folds over the definitions — "collected together intelligently."

## Non-feature areas

The stray-dir consolidation (14 single-file top-level dirs → tools/test/core
groupings) is REAL but unratified — parked in t-kd4y until the feature
migration settles. The dead-weight findings (zero-op registrations, empty
`impl Parser {}` husks, orphaned fixtures) are recorded on t-kd4y and remain
valid deletions under this architecture.
