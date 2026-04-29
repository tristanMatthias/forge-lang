# struct (type declaration)

`type Foo = { x: int, y: string }` declares a record type. The
parser also owns the field-list grammar (used by the type
declaration) and the field-init-list grammar (used by struct
literal expressions like `Foo { x: 1, y: "hi" }`).

Bootstrap uses `type Foo = { ... }` rather than `struct Foo { ... }`
because `struct` was never made a keyword in the bootstrap parser.
