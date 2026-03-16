use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::CallArg;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// int(value) — convert to int from string, float, or bool
    pub(crate) fn compile_int_conversion(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() {
            return None;
        }

        let val = self.compile_expr(&args[0].value)?;
        let arg_type = self.resolve_runtime_type(&args[0].value, &val);

        match arg_type {
            Type::Int => Some(val),
            Type::Float => {
                let float_val = val.into_float_value();
                let int_val = self.builder.build_float_to_signed_int(
                    float_val,
                    self.context.i64_type(),
                    "float_to_int",
                ).unwrap();
                Some(int_val.into())
            }
            Type::Bool => {
                let bool_val = val.into_int_value();
                let int_val = self.builder.build_int_z_extend(
                    bool_val,
                    self.context.i64_type(),
                    "bool_to_int",
                ).unwrap();
                Some(int_val.into())
            }
            Type::String => {
                self.call_runtime("forge_string_parse_int", &[val.into()], "str_to_int")
            }
            _ => Some(self.context.i64_type().const_zero().into()),
        }
    }

    /// float(value) — convert to float from string, int, or bool
    pub(crate) fn compile_float_conversion(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() {
            return None;
        }

        let val = self.compile_expr(&args[0].value)?;
        let arg_type = self.resolve_runtime_type(&args[0].value, &val);

        match arg_type {
            Type::Float => Some(val),
            Type::Int => {
                let int_val = val.into_int_value();
                let float_val = self.builder.build_signed_int_to_float(
                    int_val,
                    self.context.f64_type(),
                    "int_to_float",
                ).unwrap();
                Some(float_val.into())
            }
            Type::Bool => {
                let bool_val = val.into_int_value();
                let int_val = self.builder.build_int_z_extend(
                    bool_val,
                    self.context.i64_type(),
                    "bool_to_int",
                ).unwrap();
                let float_val = self.builder.build_signed_int_to_float(
                    int_val,
                    self.context.f64_type(),
                    "int_to_float",
                ).unwrap();
                Some(float_val.into())
            }
            Type::String => {
                self.call_runtime("forge_string_parse_float", &[val.into()], "str_to_float")
            }
            _ => Some(self.context.f64_type().const_float(0.0).into()),
        }
    }
}
