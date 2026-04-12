# Pluggable Feature Architecture

## Status: IMPLEMENTED

Adding a language feature requires **zero edits to core files**.
Create `features/<name>/`, register it, done.

## How to add a feature

```forge
// features/my_feature/mod.fg
mod parser
mod codegen

fn kw_parse_my(p: Parser) -> Stmt? { p.parse_my_statement() }

export fn init_my_feature(reg: Registry) {
    register(reg, feature_new("my_feature") with {
        stmt_tag: Stmt.MyStmt(Expr.Null),
        stmt_keyword: "kw_my",
        parse_stmt: kw_parse_my,
        emit_stmt: my_emit_stmt,
    })
}
```

Then add two lines to `features/mod.fg`:
```forge
mod my_feature
// ... in init_features():
init_my_feature(reg)
```

## API

- `feature_new(name)` — Feature with all noop defaults
- `with { ... }` — override only the handlers you need
- `register(reg, feature)` — wires tag dispatch + keyword dispatch

## Known limitations

- **Named functions required for handlers** — bootstrap can't match/call methods inside lambdas. Use named wrapper functions.
- **Resolver/typechecker arms not yet extracted** — dispatch catch-alls are wired, extraction is incremental.
