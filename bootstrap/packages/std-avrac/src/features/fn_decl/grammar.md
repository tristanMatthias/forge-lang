# fn — grammar fragment

```ebnf
FnDecl    ::= 'fn' Ident '(' Params ')' ('->' Type)? Block
Params    ::= (Param (',' Param)*)?
Param     ::= Ident (':' Type)?
```

## Nested declarations (closure sugar)

A `FnDecl` in statement position inside a function or lambda body is
sugar for a let-bound closure:

```
fn helper(n: int) -> int { n + 1 }
// ≡
let helper: fn(int) -> int = (n: int) -> { n + 1 }
```

The desugar runs before name resolution, so the name is an ordinary
local binding: it shadows like a `let`, captures enclosing locals like
any closure, and `return` inside the body returns from the nested fn
only. Limits (v1, by design):

- The name is not in scope inside its own body — self- and mutual
  recursion resolve as undefined names (F3000). Lift recursive helpers
  to the top level.
- Generic nested fns are rejected (F1044): closures take no type
  parameters, so `fn f<T>(…)` has no closure lowering.

Top-level and module-level declarations are unaffected.
