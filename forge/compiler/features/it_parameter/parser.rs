use crate::feature_data;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Check whether an expression tree contains a reference to the implicit `it` parameter.
    ///
    /// When `it` is found in a call argument, `parse_call_arg` wraps the expression
    /// in `Expr::Closure { params: [it], body: <expr> }` so downstream compilation
    /// sees a normal closure.
    pub(crate) fn expr_contains_it(expr: &Expr) -> bool {
        match expr {
            Expr::Ident(name, _) => name == "it",
            Expr::Binary { left, right, .. } => {
                Self::expr_contains_it(left) || Self::expr_contains_it(right)
            }
            Expr::Unary { operand, .. } => Self::expr_contains_it(operand),
            Expr::Call { callee, args, .. } => {
                Self::expr_contains_it(callee)
                    || args.iter().any(|a| Self::expr_contains_it(&a.value))
            }
            Expr::MemberAccess { object, .. } => Self::expr_contains_it(object),
            Expr::Index { object, index, .. } => {
                Self::expr_contains_it(object) || Self::expr_contains_it(index)
            }
            Expr::NullCoalesce { left, right, .. } => {
                Self::expr_contains_it(left) || Self::expr_contains_it(right)
            }
            Expr::NullPropagate { object, .. } => Self::expr_contains_it(object),
            Expr::ErrorPropagate { operand, .. } => Self::expr_contains_it(operand),
            Expr::TemplateLit { parts, .. } => {
                parts.iter().any(|part| {
                    if let TemplatePart::Expr(e) = part {
                        Self::expr_contains_it(e)
                    } else {
                        false
                    }
                })
            }
            Expr::StructLit { fields, .. } => {
                fields.iter().any(|(_, e)| Self::expr_contains_it(e))
            }
            Expr::ListLit { elements, .. } | Expr::TupleLit { elements, .. } => {
                elements.iter().any(|e| Self::expr_contains_it(e))
            }
            Expr::If { condition, then_branch, else_branch, .. } => {
                Self::expr_contains_it(condition)
                    || then_branch.statements.iter().any(|s| {
                        if let Statement::Expr(e) = s { Self::expr_contains_it(e) } else { false }
                    })
                    || else_branch.as_ref().map_or(false, |eb| {
                        eb.statements.iter().any(|s| {
                            if let Statement::Expr(e) = s { Self::expr_contains_it(e) } else { false }
                        })
                    })
            }
            Expr::Block(block) => {
                block.statements.iter().any(|s| {
                    if let Statement::Expr(e) = s { Self::expr_contains_it(e) } else { false }
                })
            }
            // Don't look inside closures - `it` there is already bound
            Expr::Closure { .. } => false,
            // Handle Feature variants
            Expr::Feature(fe) => {
                match fe.feature_id {
                    "null_safety" => {
                        if let Some(data) = feature_data!(fe, crate::features::null_safety::types::NullCoalesceData) {
                            return Self::expr_contains_it(&data.left) || Self::expr_contains_it(&data.right);
                        }
                        if let Some(data) = feature_data!(fe, crate::features::null_safety::types::NullPropagateData) {
                            return Self::expr_contains_it(&data.object);
                        }
                        false
                    }
                    "error_propagation" => {
                        if let Some(data) = feature_data!(fe, crate::features::error_propagation::types::ErrorPropagateData) {
                            return Self::expr_contains_it(&data.operand);
                        }
                        false
                    }
                    "closures" => false, // Don't look inside closures
                    "pipe_operator" => {
                        if let Some(data) = feature_data!(fe, crate::features::pipe_operator::types::PipeData) {
                            return Self::expr_contains_it(&data.left) || Self::expr_contains_it(&data.right);
                        }
                        false
                    }
                    _ => false,
                }
            }
            _ => false,
        }
    }
}
