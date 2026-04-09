# fn declaration

`fn name(params) -> Type { body }` — top-level function. Methods
inside `impl` blocks are also a function form (desugared to
`Type__method`). The parameter list and the basic param parser
live here because they are owned by the function declaration
syntax.
