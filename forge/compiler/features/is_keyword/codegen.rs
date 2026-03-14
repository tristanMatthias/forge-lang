use inkwell::values::BasicValueEnum;
use inkwell::IntPredicate;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::IsData;

impl<'ctx> Codegen<'ctx> {
    /// Compile an `is` expression via the Feature dispatch system.
    pub(crate) fn compile_is_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, IsData) {
            self.compile_is(&data.value, &data.pattern, data.negated)
        } else {
            None
        }
    }

    pub(crate) fn compile_is(
        &mut self,
        value: &Expr,
        pattern: &Pattern,
        negated: bool,
    ) -> Option<BasicValueEnum<'ctx>> {
        let subject_val = self.compile_expr(value)?;
        let subject_type = self.infer_type(value);

        let matched = match (&subject_type, pattern) {
            // Result type: check tag for Ok (0) or Err (1)
            (Type::Result(_, _), Pattern::Enum { variant, .. }) => {
                let tag_val = if variant == "Ok" {
                    0u64
                } else if variant == "Err" {
                    1u64
                } else {
                    return None;
                };

                if subject_val.is_struct_value() {
                    let struct_val = subject_val.into_struct_value();
                    let tag = self.builder.build_extract_value(struct_val, 0, "tag").ok()?;
                    let expected = self.context.i8_type().const_int(tag_val, false);
                    Some(
                        self.builder
                            .build_int_compare(IntPredicate::EQ, tag.into_int_value(), expected, "is_result")
                            .unwrap(),
                    )
                } else {
                    None
                }
            }
            // Nullable type: check tag for null (0) or present (1)
            (Type::Nullable(_), Pattern::Literal(expr)) if matches!(expr.as_ref(), Expr::NullLit(_)) => {
                // Check if tag == 0 (null)
                if subject_val.is_struct_value() {
                    let struct_val = subject_val.into_struct_value();
                    let tag = self.builder.build_extract_value(struct_val, 0, "tag").ok()?;
                    let zero = self.context.i8_type().const_zero();
                    Some(
                        self.builder
                            .build_int_compare(IntPredicate::EQ, tag.into_int_value(), zero, "is_null")
                            .unwrap(),
                    )
                } else {
                    None
                }
            }
            // Nullable type: check if value is a specific type (not null)
            (Type::Nullable(_), Pattern::Ident(name, _)) if is_type_name(name) => {
                // Check if tag != 0 (not null = has value)
                if subject_val.is_struct_value() {
                    let struct_val = subject_val.into_struct_value();
                    let tag = self.builder.build_extract_value(struct_val, 0, "tag").ok()?;
                    let zero = self.context.i8_type().const_zero();
                    Some(
                        self.builder
                            .build_int_compare(IntPredicate::NE, tag.into_int_value(), zero, "is_type")
                            .unwrap(),
                    )
                } else {
                    None
                }
            }
            // Default: delegate to existing pattern check
            _ => self.compile_pattern_check(pattern, &subject_val, &subject_type),
        };

        let result = if let Some(cond) = matched {
            cond
        } else {
            // Pattern always matches (wildcard/ident) → true
            self.context.i8_type().const_int(1, false)
        };

        // Widen i1 to i8 if needed
        let result_i8 = if result.get_type().get_bit_width() == 1 {
            self.builder
                .build_int_z_extend(result, self.context.i8_type(), "is_ext")
                .unwrap()
        } else {
            result
        };

        let final_val = if negated {
            let zero = self.context.i8_type().const_zero();
            let is_zero = self.builder
                .build_int_compare(IntPredicate::EQ, result_i8, zero, "is_neg")
                .unwrap();
            self.builder
                .build_int_z_extend(is_zero, self.context.i8_type(), "is_not")
                .unwrap()
        } else {
            result_i8
        };

        Some(final_val.into())
    }
}

/// Check if a name looks like a type name (for `x is string`, `x is int`, etc.)
fn is_type_name(name: &str) -> bool {
    matches!(name, "string" | "int" | "float" | "bool")
        || name.chars().next().map_or(false, |c| c.is_uppercase())
}
