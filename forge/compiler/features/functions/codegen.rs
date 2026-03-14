use inkwell::AddressSpace;
use inkwell::IntPredicate;
use inkwell::types::BasicTypeEnum;
use inkwell::values::{BasicMetadataValueEnum, BasicValueEnum, FunctionValue};

use crate::codegen::codegen::{Codegen, GenericFnInfo};
use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::parser::ast::{CallArg, Expr, TypeExpr};
use crate::typeck::types::Type;

use super::types::{FnDeclData, ReturnData};

impl<'ctx> Codegen<'ctx> {
    /// Compile a function declaration or return statement via the Feature dispatch system.
    pub(crate) fn compile_functions_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "FnDecl" => {
                if let Some(data) = feature_data!(fe, FnDeclData) {
                    // Skip generic functions - they are monomorphized on demand
                    if !data.type_params.is_empty() {
                        return;
                    }
                    self.compile_fn(&data.name, &data.params, data.return_type.as_ref(), &data.body);
                }
            }
            "Return" => {
                if let Some(data) = feature_data!(fe, ReturnData) {
                    // Execute deferred statements before returning
                    self.execute_deferred_stmts();
                    if let Some(val) = &data.value {
                        let compiled = self.compile_expr(val);
                        if let Some(v) = compiled {
                            self.builder.build_return(Some(&v)).unwrap();
                        } else {
                            self.builder.build_return(None).unwrap();
                        }
                    } else if self.current_fn_name.as_deref() == Some("main") {
                        self.builder
                            .build_return(Some(&self.context.i32_type().const_zero()))
                            .unwrap();
                    } else {
                        self.builder.build_return(None).unwrap();
                    }
                }
            }
            _ => {}
        }
    }

    /// Handle function feature stmts in compile_program's first pass.
    pub(crate) fn compile_program_functions_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "FnDecl" => {
                if let Some(data) = feature_data!(fe, FnDeclData) {
                    if !data.type_params.is_empty() {
                        self.generic_fns.insert(data.name.clone(), GenericFnInfo {
                            type_params: data.type_params.clone(),
                            params: data.params.clone(),
                            return_type: data.return_type.clone(),
                            body: data.body.clone(),
                        });
                    }
                }
            }
            _ => {}
        }
    }

    /// Declare function in compile_program's declaration pass.
    pub(crate) fn declare_program_functions_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, FnDeclData) {
            if data.type_params.is_empty() {
                self.declare_function(&data.name, &data.params, data.return_type.as_ref());
            }
        }
    }

    /// Check if a feature stmt is an explicit main function.
    pub(crate) fn is_feature_main_fn(fe: &FeatureStmt) -> bool {
        if fe.feature_id == "functions" && fe.kind == "FnDecl" {
            if let Some(data) = feature_data!(fe, FnDeclData) {
                return data.name == "main";
            }
        }
        false
    }

    /// Check if a feature stmt is a declaration-only statement (for has_top_level_stmts detection).
    pub(crate) fn is_feature_declaration_only(fe: &FeatureStmt) -> bool {
        match fe.feature_id {
            "functions" => fe.kind == "FnDecl",
            "variables" => fe.kind == "Mut",
            "structs" => fe.kind == "TypeDecl",
            "traits" => fe.kind == "TraitDecl" || fe.kind == "ImplBlock",
            "imports" => fe.kind == "Use",
            _ => false,
        }
    }

    /// Compile module-level function features
    pub(crate) fn compile_module_functions_feature(&mut self, fe: &FeatureStmt, prefix: &str) {
        if let Some(data) = feature_data!(fe, FnDeclData) {
            let mangled = format!("{}_{}", prefix, data.name);
            self.compile_fn(&mangled, &data.params, data.return_type.as_ref(), &data.body);
        }
    }

    /// Declare module-level function features
    pub(crate) fn declare_module_functions_feature(&mut self, fe: &FeatureStmt, prefix: &str) {
        if let Some(data) = feature_data!(fe, FnDeclData) {
            let mangled = format!("{}_{}", prefix, data.name);
            self.declare_function(&mangled, &data.params, data.return_type.as_ref());
        }
    }

    pub(crate) fn compile_call(
        &mut self,
        callee: &Expr,
        args: &[CallArg],
        type_args: &[TypeExpr],
    ) -> Option<BasicValueEnum<'ctx>> {
        // Handle channel.tick(interval_ms) built-in
        if let Expr::MemberAccess { object, field, .. } = callee {
            if let Expr::Ident(obj_name, _) = object.as_ref() {
                if obj_name == "channel" && field == "tick" {
                    let interval_ms = self.compile_expr(&args[0].value)?;
                    return self.call_runtime_expect(
                        "forge_channel_tick_create", &[interval_ms.into()], "tick_ch",
                        "forge_channel_tick_create not declared",
                    );
                }
            }
        }

        // Handle special built-in functions
        if let Expr::Ident(name, _) = callee {
            match name.as_str() {
                "println" => return self.compile_println(args),
                "print" => return self.compile_print(args),
                "string" => return self.compile_string_conversion(args),
                "assert" => return self.compile_assert(args),
                "sleep" => return self.compile_sleep(args),
                "datetime_now" => return self.compile_datetime_now(),
                "process_uptime" => return self.compile_process_uptime(),
                "datetime_format" => return self.compile_datetime_format(args),
                "datetime_parse" => return self.compile_datetime_parse(args),
                "validate" => return self.compile_validate(args),
                "query_gt" => return self.compile_query_int1(args, "forge_query_gt"),
                "query_gte" => return self.compile_query_int1(args, "forge_query_gte"),
                "query_lt" => return self.compile_query_int1(args, "forge_query_lt"),
                "query_lte" => return self.compile_query_int1(args, "forge_query_lte"),
                "query_between" => return self.compile_query_between(args),
                "query_like" => return self.compile_query_like(args),
                "channel" => {
                    // channel(capacity) -> int (channel ID)
                    let capacity = if args.is_empty() {
                        self.context.i64_type().const_zero().into()
                    } else {
                        match self.compile_expr(&args[0].value) {
                            Some(v) => v.into(),
                            None => return None,
                        }
                    };
                    return self.call_runtime_expect(
                        "forge_channel_create", &[capacity], "ch",
                        "forge_channel_create not declared - did you `use @std.channel`?",
                    );
                }
                _ => {}
            }

            // Handle enum constructors: EnumName.variant(args)
            // Handle regular function calls
            if let Some(func) = self.functions.get(name).copied()
                .or_else(|| self.module.get_function(name))
            {
                // Get parameter types from type checker for struct target hints
                let param_types: Vec<Type> = if let Some(Type::Function { params, .. }) = self.type_checker.env.functions.get(name).cloned() {
                    params
                } else {
                    Vec::new()
                };
                let compiled_args = self.compile_call_args_with_types(args, func, &param_types)?;
                let result = self.builder.build_call(func, &compiled_args, "call").unwrap();
                return result.try_as_basic_value().left();
            }

            // Check if this is a generic function that needs monomorphization
            if self.generic_fns.contains_key(name.as_str()) {
                if let Some(type_args) = self.infer_type_args(name, args) {
                    let type_args_refs: Vec<(&str, Type)> = type_args.iter().map(|(n, t)| (n.as_str(), t.clone())).collect();
                    if let Some(mangled) = self.monomorphize_fn(name, &type_args_refs) {
                        if let Some(func) = self.functions.get(&mangled).copied() {
                            let compiled_args = self.compile_call_args(args, func)?;
                            let result = self.builder.build_call(func, &compiled_args, "call").unwrap();
                            return result.try_as_basic_value().left();
                        }
                    }
                }
                return None;
            }

            // Maybe it's a variable holding a function pointer
            if let Some((ptr, ty)) = self.lookup_var(name) {
                if let Type::Function { ref params, ref return_type } = &ty {
                    let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());
                    let fn_ptr = self.builder.build_load(ptr_type, ptr, "fn_ptr")
                        .unwrap().into_pointer_value();

                    // Build the LLVM function type from the Forge type
                    let llvm_params: Vec<inkwell::types::BasicMetadataTypeEnum<'ctx>> = params
                        .iter()
                        .map(|t| self.type_to_llvm_metadata(t))
                        .collect();

                    let ret_llvm = self.type_to_llvm_basic(return_type);
                    let fn_type = match ret_llvm {
                        inkwell::types::BasicTypeEnum::IntType(t) => t.fn_type(&llvm_params, false),
                        inkwell::types::BasicTypeEnum::FloatType(t) => t.fn_type(&llvm_params, false),
                        inkwell::types::BasicTypeEnum::StructType(t) => t.fn_type(&llvm_params, false),
                        inkwell::types::BasicTypeEnum::PointerType(t) => t.fn_type(&llvm_params, false),
                        inkwell::types::BasicTypeEnum::ArrayType(t) => t.fn_type(&llvm_params, false),
                        inkwell::types::BasicTypeEnum::VectorType(t) => t.fn_type(&llvm_params, false),
                    };

                    // Compile arguments
                    let mut compiled_args: Vec<inkwell::values::BasicMetadataValueEnum<'ctx>> = Vec::new();
                    for arg in args {
                        let val = self.compile_expr(&arg.value)?;
                        compiled_args.push(val.into());
                    }

                    let result = self.builder.build_indirect_call(
                        fn_type, fn_ptr, &compiled_args, "closure_call"
                    ).unwrap();
                    return result.try_as_basic_value().left();
                }
            }

            return None;
        }

        // Handle method calls: object.method(args) becomes method(object, args)
        if let Expr::MemberAccess { object, field, .. } = callee {
            return self.compile_method_call(object, field, args, type_args);
        }

        None
    }

    pub(crate) fn compile_call_args(
        &mut self,
        args: &[CallArg],
        function: FunctionValue<'ctx>,
    ) -> Option<Vec<BasicMetadataValueEnum<'ctx>>> {
        self.compile_call_args_with_types(args, function, &[])
    }

    pub(crate) fn compile_call_args_with_types(
        &mut self,
        args: &[CallArg],
        function: FunctionValue<'ctx>,
        param_types: &[Type],
    ) -> Option<Vec<BasicMetadataValueEnum<'ctx>>> {
        let param_count = function.count_params() as usize;
        let mut compiled = Vec::new();

        for (i, arg) in args.iter().enumerate() {
            // Set struct target type hint if the parameter is a struct type
            let old_hint = self.struct_target_type.take();
            if let Some(pt) = param_types.get(i) {
                if matches!(pt, Type::Struct { .. }) {
                    self.struct_target_type = Some(pt.clone());
                }
            }

            if let Some(val) = self.compile_expr(&arg.value) {
                // Type-match: if param expects different type, convert
                if i < param_count {
                    let param_type = function.get_nth_param(i as u32).unwrap().get_type();
                    let val = self.coerce_value(val, param_type);
                    compiled.push(val.into());
                } else {
                    compiled.push(val.into());
                }
            } else {
                self.struct_target_type = old_hint;
                return None;
            }
            self.struct_target_type = old_hint;
        }

        Some(compiled)
    }

    pub(crate) fn coerce_value(
        &self,
        val: BasicValueEnum<'ctx>,
        target_type: BasicTypeEnum<'ctx>,
    ) -> BasicValueEnum<'ctx> {
        // Simple coercions
        if val.get_type() == target_type {
            return val;
        }

        // i8 (bool) -> i64
        if val.is_int_value() && target_type.is_int_type() {
            let val_int = val.into_int_value();
            let target_int = target_type.into_int_type();
            if val_int.get_type().get_bit_width() < target_int.get_bit_width() {
                return self.builder.build_int_s_extend(val_int, target_int, "coerce").unwrap().into();
            } else if val_int.get_type().get_bit_width() > target_int.get_bit_width() {
                return self.builder.build_int_truncate(val_int, target_int, "coerce").unwrap().into();
            }
        }

        // int -> float
        if val.is_int_value() && target_type.is_float_type() {
            return self.builder
                .build_signed_int_to_float(val.into_int_value(), target_type.into_float_type(), "itof")
                .unwrap()
                .into();
        }

        // ForgeString struct → raw ptr (for extern fn calls expecting C strings)
        if val.is_struct_value() && target_type.is_pointer_type() {
            return self.builder
                .build_extract_value(val.into_struct_value(), 0, "str_to_ptr")
                .unwrap()
                .into();
        }

        val
    }

    pub(crate) fn compile_println(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() {
            let newline = self.build_string_literal("\n");
            self.call_runtime_void("forge_print_string", &[newline.into()]);
            return None;
        }
        self.compile_print_dispatch(args, "forge_println")
    }

    pub(crate) fn compile_print(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() {
            return None;
        }
        self.compile_print_dispatch(args, "forge_print")
    }

    /// Shared helper for compile_println and compile_print.
    /// `prefix` is either "forge_println" or "forge_print".
    fn compile_print_dispatch(&mut self, args: &[CallArg], prefix: &str) -> Option<BasicValueEnum<'ctx>> {
        let arg = &args[0];
        let val = self.compile_expr(&arg.value)?;
        let resolved = self.resolve_runtime_type(&arg.value, &val);

        let suffix = match resolved {
            Type::String => "_string",
            Type::Int => "_int",
            Type::Float => "_float",
            Type::Bool => "_bool",
            _ => {
                if val.is_struct_value() { "_string" } else { return None; }
            }
        };

        self.call_runtime_void(&format!("{}{}", prefix, suffix), &[val.into()]);
        None
    }

    pub(crate) fn compile_assert(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.len() < 2 { return None; }

        // Get the span of the assert call for source location
        let call_span = args[0].value.span();

        let cond_val = self.compile_expr(&args[0].value)?;
        let msg_val = self.compile_expr(&args[1].value)?;

        // Ensure cond is i8
        let cond_i8 = if cond_val.is_int_value() {
            let iv = cond_val.into_int_value();
            if iv.get_type().get_bit_width() == 8 {
                iv
            } else if iv.get_type().get_bit_width() == 1 {
                self.builder.build_int_z_extend(iv, self.context.i8_type(), "assert_ext").unwrap()
            } else {
                // Truncate i64 comparison result
                let cmp = self.builder.build_int_compare(
                    IntPredicate::NE, iv, iv.get_type().const_zero(), "assert_cmp",
                ).unwrap();
                self.builder.build_int_z_extend(cmp, self.context.i8_type(), "assert_ext").unwrap()
            }
        } else {
            return None;
        };

        // Get string ptr and len from ForgeString
        if msg_val.is_struct_value() {
            let msg_struct = msg_val.into_struct_value();
            let msg_ptr = self.builder.build_extract_value(msg_struct, 0, "msg_ptr").unwrap();
            let msg_len = self.builder.build_extract_value(msg_struct, 1, "msg_len").unwrap();

            // Build file name as a global string constant
            let file_str = &self.source_file;
            let file_global = self.builder.build_global_string_ptr(
                if file_str.is_empty() { "<unknown>" } else { file_str },
                "assert_file",
            ).unwrap();
            let file_len_val = self.context.i64_type().const_int(
                if file_str.is_empty() { 9 } else { file_str.len() as u64 },
                false,
            );
            let line_val = self.context.i64_type().const_int(call_span.line as u64, false);
            let col_val = self.context.i64_type().const_int(call_span.col as u64, false);

            let assert_fn = self.module.get_function("forge_assert").unwrap_or_else(|| {
                let i8t = self.context.i8_type();
                let ptrt = self.context.ptr_type(AddressSpace::default());
                let i64t = self.context.i64_type();
                let ft = self.context.void_type().fn_type(
                    &[i8t.into(), ptrt.into(), i64t.into(), ptrt.into(), i64t.into(), i64t.into(), i64t.into()],
                    false,
                );
                self.module.add_function("forge_assert", ft, None)
            });
            self.builder.build_call(assert_fn, &[
                cond_i8.into(), msg_ptr.into(), msg_len.into(),
                file_global.as_pointer_value().into(), file_len_val.into(),
                line_val.into(), col_val.into(),
            ], "").unwrap();
        }
        None
    }

    pub(crate) fn compile_sleep(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        // If the arg is an int, treat it as milliseconds
        if val.is_int_value() {
            self.call_runtime_void("forge_sleep_ms", &[val.into()]);
        }
        None
    }
}
