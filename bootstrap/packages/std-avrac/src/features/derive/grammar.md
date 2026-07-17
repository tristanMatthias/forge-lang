# derive — the unified derive engine

No new surface syntax: derives ride the existing 2-arg `@expand` macro form.

```text
@expand(derive_walker)        // six walker methods on an AST enum
enum Expr { ... }

@expand(derive_eq)            // structural equality on an enum OR struct
enum Tree { Leaf(v: int), Node(l: Tree, r: Tree) }

@expand(derive_eq)
type Pt = { x: int, y: int }
```

Design doc: `docs/2026_07_15_L4_DERIVE_FRAMEWORK_DESIGN.md` §1. The
`@derive(Walk, Eq, …)` surface + capability registry is `ps3t.6.6`; until it
lands, each emitter exports a 2-arg macro shim (`derive_walker`, `derive_eq`).

## What a derive emits

For a decl `T`, each plan method emits one top-level fn with the
parser-style mangled method name, so `value.method(...)` dispatches through
the standard method-lookup path:

| macro | methods |
|---|---|
| `derive_walker` | `T__children`, `T__all_children_spanned`, `T__visit`, `T__any`, `T__find`, `T__map` |
| `derive_eq` | `T__eq` (`a.eq(b) -> bool`) |

Consumer contract: generated code references @std helpers by bare name —
walker methods need core's `unwrap_node_list` family in scope (automatic for
the AST enums, which live beside them); a `derive_eq` over a list-carrying
enum needs `use @std.avrac.list_ops.{list_eq_by}`.

## The engine contract (for emitter authors)

An emitter is an `EmitPlan`: an ordered list of methods, each either

- `PerVariant` — the engine classifies every field of every variant into a
  `FieldShape` (`classify.av`), names bindings via the method's `bind` hook,
  and builds `match self { … }` (enum) or `let b = self.f` projections
  (struct) around the `arm_body` hook's per-variant expression;
- `WholeFn` — the `build` hook returns the entire fn (recursive shapes like
  visit/any/find that delegate to `children()`).

Hooks are named `@comptime` fns carried as fn-typed struct fields; the
engine (`emit.av`) owns decl reading, classification, binding, fn assembly,
`DeclSymbol` registration, and `MacroProvenance`. Adding an emitter is
writing hooks — never traversal.

`FieldShape` is structural and target-carrying (`Node(target)`,
`NodeList(target)`, `Wrapper(target, wrapper)`, …): "is this field a child
of the derived type?" is per-emitter policy (`cross_type: false` classifies
against the parent only; `true` probes all four AST node kinds), not baked
into classification.
