use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::*;
use crate::typeck::types::Type;

/// AST data for null coalesce: `left ?? right`
#[derive(Debug, Clone)]
pub struct NullCoalesceData {
    pub left: Box<Expr>,
    pub right: Box<Expr>,
}

impl crate::feature::FeatureNode for NullCoalesceData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(NullCoalesceData {
            left: Box::new((fns.sub_expr)(&self.left)),
            right: Box::new((fns.sub_expr)(&self.right)),
        })
    }
}

/// AST data for null propagate: `object?.field`
#[derive(Debug, Clone)]
pub struct NullPropagateData {
    pub object: Box<Expr>,
    pub field: String,
}

impl crate::feature::FeatureNode for NullPropagateData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(NullPropagateData {
            object: Box::new((fns.sub_expr)(&self.object)),
            field: self.field.clone(),
        })
    }
}

/// AST data for force unwrap: `expr!`
#[derive(Debug, Clone)]
pub struct ForceUnwrapData {
    pub operand: Box<Expr>,
}

impl crate::feature::FeatureNode for ForceUnwrapData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(ForceUnwrapData {
            operand: Box::new((fns.sub_expr)(&self.operand)),
        })
    }
}

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a null coalesce expression via Feature dispatch.
    pub(crate) fn infer_null_coalesce_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, NullCoalesceData, |data| self.infer_type(&data.right))
    }

    /// Infer the type of a null propagate expression via Feature dispatch.
    pub(crate) fn infer_null_propagate_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, NullPropagateData, |data| self.infer_null_propagate_type_inner(&data.object, &data.field))
    }

    /// Infer the type of a force unwrap expression: `expr!`
    pub(crate) fn infer_force_unwrap_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, ForceUnwrapData, |data| {
            let inner_type = self.infer_type(&data.operand);
            match inner_type {
                Type::Nullable(inner) => *inner,
                other => other,
            }
        })
    }

    /// Infer the type of a null propagate expression: `object?.field`
    pub(crate) fn infer_null_propagate_type_inner(&self, object: &Expr, field: &str) -> Type {
        let ot = self.infer_type(object);
        let inner = match &ot {
            Type::Nullable(inner) => inner.as_ref(),
            _ => &ot,
        };
        match inner {
            Type::Struct { fields, .. } => {
                fields.iter().find(|(n, _)| n == field)
                    .map(|(_, ty)| Type::Nullable(Box::new(ty.clone())))
                    .unwrap_or(Type::Unknown)
            }
            Type::String => match field {
                "length" | "parse_int" => Type::Nullable(Box::new(Type::Int)),
                "upper" | "lower" | "trim" | "replace" => Type::Nullable(Box::new(Type::String)),
                "contains" | "starts_with" | "ends_with" => Type::Nullable(Box::new(Type::Bool)),
                _ => Type::Unknown,
            },
            _ => Type::Unknown,
        }
    }
}
