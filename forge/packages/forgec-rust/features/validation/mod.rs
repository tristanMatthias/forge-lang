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
    category: "Special",
}

crate::builtin_fn! { name: "validate", feature: "validation", params: [Unknown, Unknown], ret: Custom("validate"), variadic: true }

// Runtime function declarations
crate::runtime_fn! { name: "forge_validate_email", feature: "validation", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_validate_url", feature: "validation", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_validate_uuid", feature: "validation", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_validate_pattern", feature: "validation", params: [ForgeString, ForgeString], ret: I64 }

pub mod checker;
pub mod codegen;

use crate::typeck::types::Type;

/// The FieldError struct type: { field: string, rule: string, message: string }
pub fn field_error_type() -> Type {
    Type::Struct {
        name: Some("FieldError".to_string()),
        fields: vec![
            ("field".to_string(), Type::String),
            ("rule".to_string(), Type::String),
            ("message".to_string(), Type::String),
        ],
    }
}

/// The ValidationError struct type: { fields: [FieldError] }
pub fn validation_error_type() -> Type {
    Type::Struct {
        name: Some("ValidationError".to_string()),
        fields: vec![
            ("fields".to_string(), Type::List(Box::new(field_error_type()))),
        ],
    }
}

/// Build Result<T, ValidationError> for a given ok type.
pub fn validation_result_type(ok_type: &Type) -> Type {
    Type::Result(
        Box::new(ok_type.clone()),
        Box::new(validation_error_type()),
    )
}
