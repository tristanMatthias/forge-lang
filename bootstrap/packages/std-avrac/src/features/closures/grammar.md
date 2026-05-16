# closures (lambdas)

## Syntax

```
lambda           = lambda_params "->" lambda_body
lambda_params    = "(" param_list? ")"
param_list       = param ("," param)*
param            = IDENT (":" type_expr)?
lambda_body      = expression | "{" statement_list "}"

it_lambda        = expression           # any expr containing `it` in method-call
                                        # arg position is implicitly wrapped
                                        # in `(it) -> expression`
```

## Examples

```avra
let inc = (x: int) -> x + 1
let pair = (a, b) -> (a, b)
let id = () -> 42
let block_form = (x) -> {
    let y = x * 2
    y + 1
}
```

Implicit `it` parameter — Avra recognises a bare expression
containing `it` in method-call argument position and wraps it
in a single-arg lambda automatically:

```avra
let doubled = [1, 2, 3].map(it * 2)
// equivalent to
let doubled = [1, 2, 3].map((it) -> it * 2)
```

`it`-wrapping is detected by `expr_contains_it` in
`features/closures/parser.av`. It walks every container Expr
variant (Binary / Unary / Call / Block / etc.) so an `it`
nested arbitrarily deep still triggers the lambda wrap.

## Semantics

Closures capture their enclosing scope by-value. Captured
bindings travel inside the closure's environment struct
(sized at codegen time by `Closure(num_captures, ret)` in
`ValueType`). The runtime represents a closure as an array:
`[CLOSURE_MARKER, fn_ptr, capture_1, capture_2, ...]`.

Lambda types are inferred from usage when not annotated. A
lambda passed to `fn(int) -> int` has both parameter and
return type pinned by the call site.

## `it` pronoun availability

`it` is only auto-bound when the lambda appears as a method-call
argument (`xs.map(it * 2)`, `xs.filter(it > 0)`). In other
positions you must write the explicit param list — `(it) -> it
* 2` works anywhere but bare `it * 2` outside a method-call arg
parses as a normal expression referencing an `it` binding (which
will fail if no such binding is in scope).

## Pipeline placement

- Parser produces `Expr.Lambda(params, body)`.
- The `it`-wrap pass runs inline in the parser during method-call
  argument parsing (see `wrap_in_it_lambda` + the call sites that
  consult `expr_contains_it`).
- Resolve walks the body in a child scope where the params bind
  the names.
- Type-check infers param types from the call site if not
  annotated.
- Codegen emits a function (mangled with a synthesised name) plus
  the closure-array allocation at the lambda site.
