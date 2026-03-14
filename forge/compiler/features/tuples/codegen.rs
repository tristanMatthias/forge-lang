use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::parser::ast::Expr;
use crate::{feature_codegen, feature_check};
use crate::typeck::types::Type;

use super::types::TupleLitData;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_tuple_lit(
        &mut self,
        elements: &[Expr],
    ) -> Option<BasicValueEnum<'ctx>> {
        if elements.is_empty() {
            return None;
        }

        let mut elem_types = Vec::new();
        let mut elem_vals = Vec::new();

        for expr in elements {
            let val = self.compile_expr(expr)?;
            let ty = self.infer_type(expr);
            elem_types.push(self.type_to_llvm_basic(&ty));
            elem_vals.push(val);
        }

        let tuple_type = self.context.struct_type(
            &elem_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
            false,
        );

        let mut tuple_val = tuple_type.get_undef();
        for (i, val) in elem_vals.iter().enumerate() {
            tuple_val = self.builder
                .build_insert_value(tuple_val, *val, i as u32, "elem")
                .unwrap()
                .into_struct_value();
        }

        Some(tuple_val.into())
    }

    /// Compile a tuple literal expression via the Feature dispatch system.
    pub(crate) fn compile_tuple_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, TupleLitData, |data| self.compile_tuple_lit(&data.elements))
    }

    /// Infer the type of a tuple literal expression.
    pub(crate) fn infer_tuple_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, TupleLitData, |data| {
            Type::Tuple(data.elements.iter().map(|e| self.infer_type(e)).collect())
        })
    }
}
