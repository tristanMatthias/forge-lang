# enum

`enum Foo { A, B(x: int), C(name: string) }` declares a tagged
union type with named variants and optional payloads. The parser
also owns the variant-list grammar and the paren-delimited
field-list (used for variant payloads).
