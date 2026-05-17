# component declarations + instantiation

## Syntax

```
component_decl   = "component" IDENT implements? "{" component_body "}"
implements       = "implements" ident_list

component_body   = config_block? children_block? init_or_methods

config_block     = "config" "{" config_field ("," config_field)* "}"
config_field     = IDENT ":" type_expr ("=" expression)?

children_block   = "children" "{" children_field ("," children_field)* "}"
children_field   = IDENT ":" "List" "<" IDENT ">"

component_block  = IDENT IDENT? "{" component_block_body "}"
                                       # `<comp_name> <instance>? { config, … }`
```

## Semantics

Components are the declarative-layer primitive of Components V2
(`vez6`). A `component foo { … }` declaration combines:

- a typed config schema (with optional defaults),
- a child-slot schema (which other component types can nest
  inside this one),
- methods or init logic,
- optional trait conformances (`implements Display`).

A `component_block` is an instantiation — it provides config
overrides and child instances, and the expansion pass splices
the result into the surrounding scope.

## Two flavours of component

### Data component (no `init`)

A component without an `init` function expands to:

- A struct type (`type Foo = { name: string, …config fields…,
  …children slot fields… }`).
- A factory function (`fn foo_new(name: string) -> Foo`) that
  fills in config defaults + zeroed children lists.
- One impl method per non-init method declared in the body.

```avra
component user {
    config {
        admin: bool = false,
        role: string = "guest",
    }

    fn describe(self) -> string {
        "${self.name} (${self.role})"
    }
}

let alice = user "alice" { admin: true, role: "admin" }
println(alice.describe())
```

### Template component (with `init`)

A component with an `init` function expands by inlining the
init body into the surrounding scope at instantiation sites,
rewriting `self.config.*` references to the supplied values.
Templates exist for the declarative-builder pattern (cli
commands, lsp handlers) where the "object" isn't really an
object — it's a piece of imperative setup parameterised by
config.

Phase 10 (`vez6.10`) deletes the template path; all current
template uses migrate to the data + `@expand` macro shape.

## Self-referenced fields

Inside a component body, the receiver `self` exposes:

- `self.name` — the implicit instance-name string (always
  present).
- `self.<config_field>` — resolved config value (user override
  or schema default).
- `self.<children_slot>` — the list of nested-child instances.
- (template only) `self.__parent`, `self.__parent_name` — the
  enclosing accumulator and its instance name. Goes away with
  vez6.10.

## Examples

Children + multi-component layout:

```avra
component menu {
    children {
        items: List<menu_item>,
    }
}

component menu_item {
    config {
        label: string,
        kind: string = "action",
    }
}

let m = menu "file" {
    menu_item "open"  { label: "Open…" },
    menu_item "save"  { label: "Save"   },
    menu_item "quit"  { label: "Quit", kind: "exit" },
}
```

The expansion produces:
- `type Menu = { name: string, items: List<MenuItem> }`
- `type MenuItem = { name: string, label: string, kind: string }`
- `fn menu_new(name) -> Menu` + `fn menu_item_new(name) -> MenuItem`
- A construction sequence that creates each child instance and
  pushes it onto its parent's slot.

## Pipeline placement

- Parser produces `Stmt.ComponentDef(name, implements, config,
  children, body, ...)` for declarations and
  `Stmt.ComponentBlock(comp_name, instance, config_pairs,
  body)` for instantiations.
- `expand_components` (in `features/component_decl/expand.av`)
  is the first non-resolver pass:
  1. `collect_component_defs` walks once, registering every
     def's schema + body.
  2. `expand_stmt_list` walks the program splicing in the
     synthesised struct + factory + methods at every def site,
     and the construction sequence at every block site.
- @expand-annotated component defs (vez6.8.5) are SKIPPED by
  the legacy expander — their instances route through
  `features/comptime/expand_macro.av` instead.

## Spec reference

Design doc: `docs/2026_05_08_COMPONENTS_V2_DESIGN.md`. The
epic `vez6` tracks all component-related work; phases 1–10
cover the design surface.
