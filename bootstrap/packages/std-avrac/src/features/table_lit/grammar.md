# table literals

A `table` literal is row-oriented data-entry sugar: an aligned header row
of field names followed by one data row per record. It desugars to a
`List<RowStruct>` of struct literals — ordinary statically-typed structs,
not opaque maps. Parsing lives in `parse/mod.av` (`parse_table_literal`);
row-type inference lives in `desugar/mod.av`.

## Syntax

```
table_literal = "table" [ "<" type_name ">" ] "{" header row* "}"
header        = field_name ( "|" field_name )*          // one line
row           = cell ( "|" cell )*                      // one line per record
cell          = expression                              // parsed up to `|`
```

- `field_name` is an identifier naming a field of the row struct.
- A `cell` is an expression parsed up to **comparison** precedence
  (`parse_bitwise_xor`), so the column separator `|` is never swallowed.
  Arithmetic, bitwise/shift, comparisons, unary, calls, indexing, field
  access, string interpolation, list/map/struct literals, and lambdas all
  work as cells. Lower-precedence operators — `&&`, `||`, `??`, `|>`, the
  `?` propagation operator, and ternary `if`-expressions — must be
  **parenthesized**: `(y ?? 0)`, `(a || b)`, `(5 |> f)`.
- A `|` inside a string/interpolation cell is part of the string, not a
  separator (`"a|b|c"` is one cell).
- The header occupies a single source line; each data row occupies a
  single line and must have exactly one cell per column (a row with too
  few or too many cells, or a duplicate column name, is a parse error).
- A leading `|` (markdown-table style) is not accepted.

## Examples

```
type Extern = { name: string, arity: int }

// Explicit row type.
let xs = table<Extern> {
    name              | arity
    "avra_summary"    | 0
    "avra_run"        | 2
}

// Row type inferred from the binding / return type.
fn externs() -> List<Extern> {
    table {
        name              | arity
        "avra_summary"    | 0
        "avra_run"        | 2
    }
}

let ys: List<Extern> = table {        // inferred from the let annotation
    name | arity
    "x"  | 1
}
```

Each row becomes `Extern { name: ..., arity: ... }`; the whole table is a
`List<Extern>`. Fields are statically typed and accessible (`xs[0].name`),
pattern-matchable, and assignable to any `List<Extern>` position.

## Semantics

- **Desugar:** `table<Row> { cols\n vals... }` lowers to
  `[ Row { col0: v00, col1: v01, ... }, Row { col0: v10, ... }, ... ]`.
  Row order is preserved.
- **Row-type inference:** when `<Row>` is omitted, the row type is taken
  from the surrounding context:
  - a `let`/`mut`/`const` `: List<Row>` annotation;
  - the enclosing function's `-> List<Row>` return type (the tail
    expression, a `return`, and tail `if`/`match`/`when` branches);
  - a call argument whose matching parameter is declared `List<Row>`
    (e.g. `take_rows(table { ... })`).

  The desugar pass stamps the inferred struct name onto each row.
- **No weak fallback:** a `table { ... }` whose row type cannot be
  inferred is a compile error (`F1042`) rather than a weakly-typed
  `List<Map>`. The fix is to write `table<Row> { ... }` or annotate the
  binding.
- **Header-only table:** a table with a header but no data rows is the
  empty list `[]`.

## Pipeline placement

```
parse  → table<Row>{...}  becomes ListLit[ StructLit("Row", ...) , ... ]
       → table{...}        becomes ListLit[ StructLit("",    ...) , ... ]
desugar → stamp the inferred row name onto anonymous StructLit("") rows
resolve / typeck / codegen → ordinary List<Struct> handling
typeck  → a surviving anonymous row reports F1042 (TableRowTypeMissing)
```

## Spec reference

Spec Axis 28 (syntax); ticket forge-crafting-intepreters-c080.
