crate::forge_feature! {
    name: "Function Types",
    id: "fn_types",
    status: Stable,
    depends: ["closures", "functions"],
    enables: [],
    tokens: ["fn"],
    ast_nodes: ["TypeExpr::Function"],
    description: "Function type annotations using fn(params) -> return syntax",
    syntax: ["fn(A, B) -> R", "fn(A)", "fn() -> R"],
    short: "fn(A) -> R — function type annotations for struct fields, params, and bindings",
    symbols: ["fn", "->"],
    long_description: "\
Function types let you declare the type of a function value — closures or named functions — \
anywhere a type is expected. The syntax is `fn(ParamType1, ParamType2) -> ReturnType`.

Use function types in struct fields to store callbacks:
```
type Handler = { process: fn(int) -> string }
let h = Handler { process: (x) -> string(x) }
println(h.process(42))
```

Use function types in function parameters for higher-order functions:
```
fn apply(f: fn(int) -> int, x: int) -> int { f(x) }
println(string(apply((x) -> x * 2, 21)))
```

Use function types in let bindings with explicit type annotations:
```
let f: fn(int) -> int = (x) -> x + 1
```

Function types without a return arrow are void: `fn(int)` means a function taking an int \
and returning nothing. Nullary functions use empty parens: `fn() -> int`.

Function types nest naturally for higher-order patterns:
```
type Middleware = { transform: fn(fn(int) -> int) -> fn(int) -> int }
```

Named functions can also be stored in function-typed fields — they are first-class values \
just like closures.",
    grammar: "<fn-type> ::= \"fn\" \"(\" <type-list> \")\" (\"->\" <type>)?",
    category: "Functions",
    category_order: Primary,
}
