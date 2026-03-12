use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the return type of a closure given its input element type.
    ///
    /// Used by list.map, list.filter, list.reduce, etc. to determine the output element type.
    pub(crate) fn infer_closure_return_type(&self, closure_arg: &CallArg, input_type: &Type) -> Type {
        if let Expr::Closure { params, body, .. } = &closure_arg.value {
            match body.as_ref() {
                Expr::Binary { op, .. } => {
                    match op {
                        BinaryOp::Add | BinaryOp::Sub | BinaryOp::Mul | BinaryOp::Div | BinaryOp::Mod => {
                            if *input_type == Type::Int { return Type::Int; }
                            if *input_type == Type::Float { return Type::Float; }
                        }
                        BinaryOp::Eq | BinaryOp::NotEq | BinaryOp::Lt | BinaryOp::LtEq |
                        BinaryOp::Gt | BinaryOp::GtEq | BinaryOp::And | BinaryOp::Or => {
                            return Type::Bool;
                        }
                        _ => {}
                    }
                }
                Expr::Call { callee, args, .. } => {
                    if let Expr::Ident(name, _) = callee.as_ref() {
                        match name.as_str() {
                            "string" => return Type::String,
                            "int" => return Type::Int,
                            "float" => return Type::Float,
                            _ => {}
                        }
                    }
                    // Method call on the element
                    if let Expr::MemberAccess { object, field, .. } = callee.as_ref() {
                        let obj_type = if matches!(object.as_ref(), Expr::Ident(n, _) if params.first().map_or(false, |p| p.name == *n)) {
                            input_type.clone()
                        } else {
                            self.infer_type(object)
                        };
                        match &obj_type {
                            Type::String => match field.as_str() {
                                "upper" | "lower" => return Type::String,
                                "contains" => return Type::Bool,
                                "length" => return Type::Int,
                                "split" => return Type::List(Box::new(Type::String)),
                                _ => {}
                            },
                            _ => {}
                        }
                    }
                }
                Expr::MemberAccess { object, field, .. } => {
                    // e.g., x -> x.length
                    let obj_type = if matches!(object.as_ref(), Expr::Ident(n, _) if params.first().map_or(false, |p| p.name == *n)) {
                        input_type.clone()
                    } else {
                        self.infer_type(object)
                    };
                    match &obj_type {
                        Type::String => match field.as_str() {
                            "length" => return Type::Int,
                            _ => {}
                        },
                        _ => {}
                    }
                }
                _ => {}
            }
            input_type.clone()
        } else {
            input_type.clone()
        }
    }
}
