# impl

`impl Type { fn method(self) { ... } }` adds methods to a type.
Each method is desugared to a top-level function named
`Type__method`. The first parameter (conventionally `self`) is
typed as the impl's owner type.

Multiple `impl Type { ... }` blocks for the same type are allowed
and merged at link time. The bootstrap migration relies on this:
features/<X>/parser.av adds methods to `Parser` from outside
parser.av.

The lowering lives here too (t-kd4y.3.3.4): `lowering/mod.av` carries the
`MkImpl` / `MkMethod` builds — the name mangling and the `self` retyping —
as manifest rows, so the grammar engine holds no impl-shaped code. The row
names are the gram references, which is why the flip touched no rule text.
