use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::types::Type;

/// AST data for a closure expression: `(params) -> body`
#[derive(Debug, Clone)]
pub struct ClosureData {
    pub params: Vec<Param>,
    pub body: Box<Expr>,
}

crate::impl_feature_node!(ClosureData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a closure via Feature dispatch.
    pub(crate) fn infer_closure_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, ClosureData) {
            let param_types: Vec<Type> = data.params
                .iter()
                .map(|p| {
                    p.type_ann
                        .as_ref()
                        .map(|t| self.type_checker.resolve_type_expr(t))
                        .unwrap_or(Type::Unknown)
                })
                .collect();
            let param_map: std::collections::HashMap<String, Type> = data.params
                .iter()
                .zip(param_types.iter())
                .map(|(p, t)| (p.name.clone(), t.clone()))
                .collect();
            let ret_type = self.infer_closure_body_type(&data.body, &param_map);
            Type::Function {
                params: param_types,
                return_type: Box::new(ret_type),
            }
        } else {
            Type::Unknown
        }
    }

    /// Infer the return type of a closure given its input element type.
    ///
    /// Used by list.map, list.filter, list.reduce, etc. to determine the output element type.
    pub(crate) fn infer_closure_return_type(&self, closure_arg: &CallArg, input_type: &Type) -> Type {
        // Check both old Expr::Closure and new Feature variant
        let (params, body) = match &closure_arg.value {
            Expr::Closure { params, body, .. } => (params.as_slice(), body.as_ref()),
            Expr::Feature(fe) if fe.feature_id == "closures" => {
                if let Some(data) = feature_data!(fe, ClosureData) {
                    (data.params.as_slice(), data.body.as_ref())
                } else {
                    return input_type.clone();
                }
            }
            _ => return input_type.clone(),
        };

        match body {
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
                    Type::Struct { fields, .. } => {
                        if let Some((_, ty)) = fields.iter().find(|(n, _)| n == field) {
                            return ty.clone();
                        }
                    },
                    _ => {}
                }
            }
            Expr::TemplateLit { .. } | Expr::StringLit(_, _) => {
                return Type::String;
            }
            Expr::IntLit(_, _) => return Type::Int,
            Expr::FloatLit(_, _) => return Type::Float,
            Expr::BoolLit(_, _) => return Type::Bool,
            _ => {}
        }
        // Fallback: use general type inference, but only if it gives a
        // concrete, non-default result (Int is the default fallback and unreliable
        // since closure params aren't in infer_type's scope).
        let inferred = self.infer_type(body);
        if inferred != Type::Unknown && inferred != Type::Int {
            return inferred;
        }
        input_type.clone()
    }
}
