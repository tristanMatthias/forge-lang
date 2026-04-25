# impl

`impl Type { fn method(self) { ... } }` adds methods to a type.
Each method is desugared to a top-level function named
`Type__method`. The first parameter (conventionally `self`) is
typed as the impl's owner type.

Multiple `impl Type { ... }` blocks for the same type are allowed
and merged at link time. The bootstrap migration relies on this:
features/<X>/parser.fg adds methods to `Parser` from outside
parser.fg.
