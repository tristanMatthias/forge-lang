use inkwell::types::BasicType;
use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::{feature_codegen, feature_check};
use crate::typeck::types::Type;

use super::types::SliceData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a slice expression via the Feature dispatch system.
    pub(crate) fn compile_slice_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, SliceData, |data| self.compile_slice(
            &data.object,
            data.start.as_deref(),
            data.end.as_deref(),
        ))
    }

    /// Compile a slice operation on a list or string.
    fn compile_slice(
        &mut self,
        object: &crate::parser::ast::Expr,
        start: Option<&crate::parser::ast::Expr>,
        end: Option<&crate::parser::ast::Expr>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let obj_val = self.compile_expr(object)?;
        let obj_type = self.infer_type(object);

        match &obj_type {
            Type::List(inner) => self.compile_list_slice(obj_val, inner, start, end),
            Type::String => self.compile_string_slice(obj_val, start, end),
            _ => None,
        }
    }

    /// Compile list slicing: list[start..end] -> new list
    fn compile_list_slice(
        &mut self,
        list_val: BasicValueEnum<'ctx>,
        elem_type: &Type,
        start: Option<&crate::parser::ast::Expr>,
        end: Option<&crate::parser::ast::Expr>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let (data_ptr, list_len) = self.extract_list_fields(&list_val)?;

        let zero = self.context.i64_type().const_int(0, false);

        let start_val = if let Some(s) = start {
            self.compile_expr(s)?.into_int_value()
        } else {
            zero
        };

        let end_val = if let Some(e) = end {
            self.compile_expr(e)?.into_int_value()
        } else {
            list_len
        };

        // Calculate element size
        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let elem_size = elem_llvm_ty.size_of().unwrap();

        // Call forge_list_slice(data_ptr, list_len, start, end, elem_size)
        let result = self.call_runtime(
            "forge_list_slice",
            &[data_ptr.into(), list_len.into(), start_val.into(), end_val.into(), elem_size.into()],
            "slice_result",
        )?;

        // Result is a {ptr, i64} struct. Extract fields and build a proper list struct.
        let result_struct = result.into_struct_value();
        let new_data_ptr = self.builder.build_extract_value(result_struct, 0, "slice_data").ok()?.into_pointer_value();
        let new_len = self.builder.build_extract_value(result_struct, 1, "slice_len").ok()?.into_int_value();

        let new_list = self.build_list_struct(elem_type, new_data_ptr, new_len);
        Some(new_list.into())
    }

    /// Compile string slicing: string[start..end] -> new string
    fn compile_string_slice(
        &mut self,
        str_val: BasicValueEnum<'ctx>,
        start: Option<&crate::parser::ast::Expr>,
        end: Option<&crate::parser::ast::Expr>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let zero = self.context.i64_type().const_int(0, false);

        let start_val = if let Some(s) = start {
            self.compile_expr(s)?
        } else {
            zero.into()
        };

        let end_val = if let Some(e) = end {
            self.compile_expr(e)?
        } else {
            // Use the string length as the end
            let str_struct = str_val.into_struct_value();
            let len = self.builder.build_extract_value(str_struct, 1, "str_len").ok()?;
            len
        };

        // Reuse forge_string_substring(str, start, end)
        self.call_runtime(
            "forge_string_substring",
            &[str_val.into(), start_val.into(), end_val.into()],
            "str_slice",
        )
    }

    /// Infer the type of a slice expression via the Feature dispatch system.
    pub(crate) fn infer_slice_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, SliceData, |data| {
            let obj_type = self.infer_type(&data.object);
            match &obj_type {
                Type::List(inner) => Type::List(inner.clone()),
                Type::String => Type::String,
                _ => Type::Unknown,
            }
        })
    }
}
