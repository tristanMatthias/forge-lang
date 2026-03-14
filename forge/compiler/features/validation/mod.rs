crate::forge_feature! {
    name: "Validation",
    id: "validation",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "validate() intrinsic with annotation-based field validation, defaults, transforms, and named validators",
    syntax: ["validate(value)"],
    short: "validate() — runtime value validation",
    symbols: [],
    long_description: "\
Runtime validation in Forge provides structured checking of values against constraints. \
Validators can verify types, ranges, string patterns, and custom predicates. Validation errors \
are returned as structured data with field names and error descriptions, making them easy to \
present to users.

Validation integrates with the component system. Model components can declare named validators \
that run before create and update operations. The validation results are structured as \
field-level errors, compatible with form validation in frontend applications.

The validation system produces `ValidationError` values with `field` and `message` properties. \
Multiple validation errors can be collected and returned together, rather than failing on the \
first error. This gives users all the information they need to fix their input in one pass.

Unlike assertion-based validation that throws exceptions, Forge's validation returns errors as \
values. This fits with Forge's philosophy of making error paths explicit and visible in the \
type system.",
}

pub mod checker;
pub mod codegen;
