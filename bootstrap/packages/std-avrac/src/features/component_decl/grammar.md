# component declarations + instantiation

## Syntax

```
component_decl   = "component" IDENT implements? "{" component_body "}"
implements       = "implements" ident_list

component_body   = config_block? children_block? method*

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
- methods,
- optional trait conformances (`implements Display`).

A `component_block` is an instantiation — it provides config
overrides and child instances, and the expansion pass splices
the result into the surrounding scope.

## Expansion

Every plain component is a **data component**. It expands to:

- A struct type (`type Foo = { name: string, …config fields…,
  …children slot fields… }`).
- A factory function (`fn foo_new(name: string) -> Foo`) that
  fills in config defaults + zeroed children lists.
- One prefixed free fn per method declared in the body
  (`fn describe` in `component user` becomes `fn user_describe`).
  No method name is special: construction is the factory,
  cleanup is the `Drop` trait, post-construction work is an
  explicit method call.

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

An instantiation `foo inst { … }` becomes
`let inst = foo_new("inst") with { overrides }` (a `mut` binding
when the component declares children slots, so auto-push
compiles), followed by the recursively expanded children and an
auto-push of each child into its parent's matching slot.

Anything richer — per-instance behaviour, generated trait impls,
custom dispatch — is library-authored via `@expand(macro)`:
annotated defs and their instance blocks pass through this pass
untouched and are consumed by the comptime macro pipeline
(`features/comptime/expand_macro.av`). The `cli`/`command`
blocks in `packages/cli/src/main.av` (macros in
`@std.cli.cmdgen`) are the canonical example.

The former **template flavour** — `fn init()` bodies inlined at
the instantiation site, `self.__parent`/`self.__parent_name`
accumulator threading, and `on <event>`/`event <name>` hooks —
is gone (Components V2 design §3.8). Data + `@expand` macros
cover every former use.

## Instance struct fields

The synthesized struct exposes:

- `.name` — the implicit instance-name string (always present).
- `.<config_field>` — resolved config value (user override or
  schema default).
- `.<children_slot>` — the list of nested-child instances.

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
  this pass — their instances route through
  `features/comptime/expand_macro.av` instead.

## Spec reference

Design doc: `docs/2026_05_08_COMPONENTS_V2_DESIGN.md`. The
epic `vez6` tracks all component-related work.
