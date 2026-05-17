# modules + `use` / `mod`

## Syntax

```
mod_stmt   = "mod" IDENT             # sibling-file stub form
           | "mod" IDENT "{" stmts "}"  # inline-body form

use_stmt   = "use" path "." "{" name_list "}"
           | "use" path "." name
           | "use" "@" package_name dot_path "." "{" name_list "}"
path       = IDENT ("." IDENT)*
name_list  = name ("," name)*
name       = IDENT                   # plain import
           | IDENT "as" IDENT        # aliased import
```

## Semantics

A `mod foo` statement declares a sub-module. There are two
forms:

1. **Stub** (`mod foo`): the module resolver reads
   `./foo.av` relative to the declaring file and attaches the
   parsed body. Used for splitting large modules across files.
2. **Inline** (`mod foo { … }`): the body is right there in
   the source — no file I/O.

`use` statements bring names from another module / package
into the current scope. Three flavours:

- `use module.path.{name1, name2}` — relative module-tree
  navigation; `module.path` is a dot-separated chain of `mod`
  names rooted at the current package.
- `use @pkg.module.path.{...}` — cross-package import; `@pkg`
  resolves via the package manifest (`avra.toml`).
- `name as alias` — local rename for collision avoidance.

## Examples

Split-file module:

```avra
// foo.av
mod bar
mod baz

fn from_foo() { ... }
```

```avra
// foo/bar.av
fn from_bar() { ... }
```

Inline module:

```avra
mod helpers {
    fn shared() -> int { 42 }
}

fn caller() -> int {
    helpers.shared()
}
```

Cross-package import:

```avra
use @std.process.{bytes_builder, bytes_reader}
use @std.json.{json_str, json_object}
```

Aliased import:

```avra
use @std.process.{IsolatedError as IErr}
```

## Resolution pipeline

1. **Parser** produces `Stmt.Module(name, body)` for inline
   forms and `Stmt.Module(name, .End)` for stubs.
2. **resolve_module_files** (the only I/O pass in the
   pipeline) walks for stub modules, reads the corresponding
   `.av` files, parses each, and attaches the body. Stops on
   first error per file. Tracked under `LoadedPaths` to dedupe
   transitive imports.
3. **resolve_names** processes the now-complete AST: every
   `use` statement registers an alias from the bare name to
   its qualified form (`@std::process::bytes_builder`); every
   reference to a `use`d name is rewritten to
   `Expr.QualifiedIdent(canonical_path)`.

## Dir-as-module (g2eo.1)

A directory containing `mod.av` is also a module — its body is
the concatenation of `mod.av` + every sibling `.av` file in
the directory. This is how `@std/avrac/features/marshal/`
exposes `derive.av` alongside `mod.av` without an explicit
`mod derive` statement.

The resolver auto-loads siblings only when the entry lives
inside a real package's `src/` (parent dir has `avra.toml`).
Bare /tmp fixtures or ad-hoc files don't trigger sibling
loading — keeps test fixtures clean.

## Package layout

```
<package_root>/
    avra.toml              # manifest: name, version, deps
    src/
        <package_name>.av  # entry — or `mod.av` for dir-form
        <sibling1>.av
        <sibling2>.av
        <subdir>/
            mod.av         # nested module via dir-form
            <leaf>.av
```

Cross-package `use @pkg.…` resolves `@pkg` against:
- The current package's `avra.toml` `[dependencies]` table.
- The well-known `@std/*` packages bundled with the compiler.

## Pipeline placement

The whole module pipeline runs early — before name resolution
itself can complete — because every later pass needs the full
AST. Subsequent passes (`expand_components`, `derive_marshal`,
`resolve_names`, …) see a single flat tree with every module's
body inlined under its `Stmt.Module` wrapper.
