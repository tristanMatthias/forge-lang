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
            Expr::Pipe { left, right, .. } => {
                Self::expr_contains_it(left) || Self::expr_contains_it(right)
            }
            Expr::NullCoalesce { left, right, .. } => {
                Self::expr_contains_it(left) || Self::expr_contains_it(right)
            }
            Expr::NullPropagate { object, .. } => Self::expr_contains_it(object),
            Expr::ErrorPropagate { operand, .. } => Self::expr_contains_it(operand),
            // Don't look inside closures - `it` there is already bound
            Expr::Closure { .. } => false,
            _ => false,
        }
    }
}
