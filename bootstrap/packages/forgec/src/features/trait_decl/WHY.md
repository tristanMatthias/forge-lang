# Traits

Trait declarations define a set of methods a type must implement.
`impl Trait for Type { ... }` desugars to `Type__method` functions,
same as plain `impl Type { ... }` blocks.

In the bootstrap, traits are metadata only — no dynamic dispatch.
Method resolution is static, via name mangling.
