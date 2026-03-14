use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_method_call(
        &mut self,
        object: &Expr,
        method: &str,
        args: &[CallArg],
        type_args: &[TypeExpr],
    ) -> Option<BasicValueEnum<'ctx>> {
        // Handle json.parse() and json.stringify() intrinsics
        if let Expr::Ident(name, _) = object {
            if name == "json" {
                match method {
                    "parse" => {
                        let target = self.json_parse_hint.take()
                            .or_else(|| self.current_fn_return_type.as_ref().and_then(|t| match t {
                                Type::Nullable(inner) => Some(inner.as_ref().clone()),
                                Type::List(inner) => Some(Type::List(inner.clone())),
                                other => Some(other.clone()),
                            }));
                        return self.compile_json_parse_call(args, target.as_ref());
                    },
                    "stringify" => return self.compile_json_stringify_call(args),
                    _ => {}
                }
            }
        }

        // Handle static method calls via the static_methods registry
        if let Expr::Ident(name, _) = object {
            let key = (name.clone(), method.to_string());
            if let Some(fn_name) = self.static_methods.get(&key).cloned() {
                if let Some(func) = self.module.get_function(&fn_name) {
                    let param_count = func.count_params() as usize;
                    let string_type = self.string_type();
                    let mut compiled_args: Vec<BasicMetadataValueEnum<'ctx>> = Vec::new();
                    for (i, arg) in args.iter().enumerate() {
                        if let Some(val) = self.compile_expr(&arg.value) {
                            // Auto-stringify: if function expects ForgeString but arg is a different struct,
                            // serialize the struct to JSON via json.stringify
                            if i < param_count {
                                let param_type = func.get_nth_param(i as u32).unwrap().get_type();
                                let arg_type = self.infer_type(&arg.value);

                                // Auto-stringify list args to JSON when extern fn expects ptr or string
                                if let Type::List(_) = &arg_type {
                                    if val.is_struct_value() {
                                        let sv = val.into_struct_value();
                                        let list_ptr = self.builder.build_extract_value(sv, 0, "list_ptr").unwrap();
                                        let list_len = self.builder.build_extract_value(sv, 1, "list_len").unwrap();
                                        let json_str = self.call_runtime("forge_list_to_json", &[list_ptr.into(), list_len.into()], "list_json").unwrap();
                                        // If param expects ptr, extract the ptr from ForgeString
                                        if param_type.is_pointer_type() {
                                            let str_ptr = self.builder.build_extract_value(
                                                json_str.into_struct_value(), 0, "json_ptr"
                                            ).unwrap();
                                            compiled_args.push(str_ptr.into());
                                        } else {
                                            compiled_args.push(json_str.into());
                                        }
                                        continue;
                                    }
                                }

                                // Auto-stringify struct args to JSON
                                if val.is_struct_value()
                                    && param_type.is_struct_type()
                                    && param_type.into_struct_type() == string_type
                                    && val.into_struct_value().get_type() != string_type
                                {
                                    if let Type::Struct { fields, .. } = &arg_type {
                                        if let Some(json_str) =
                                            self.compile_json_stringify_struct(val, fields)
                                        {
                                            compiled_args.push(json_str.into());
                                            continue;
                                        }
                                    }
                                }
                                let val = self.coerce_value(val, param_type);
                                compiled_args.push(val.into());
                            } else {
                                compiled_args.push(val.into());
                            }
                        }
                    }
                    // Pad missing args with default "{}" string (for opts params)
                    while compiled_args.len() < param_count {
                        let default_str = self.build_string_literal("{}");
                        let param_type = func.get_nth_param(compiled_args.len() as u32).unwrap().get_type();
                        let val = self.coerce_value(default_str.into(), param_type);
                        compiled_args.push(val.into());
                    }
                    let result = self
                        .builder
                        .build_call(func, &compiled_args, "static_call")
                        .unwrap();
                    let raw = result.try_as_basic_value().left();
                    // If the extern fn returns ptr, wrap it as a ForgeString
                    if let Some(val) = raw {
                        if val.is_pointer_value() {
                            let ptr_val = val.into_pointer_value();

                            // If type_args present, parse JSON result into target struct
                            if let Some(type_arg) = type_args.first() {
                                if let TypeExpr::Named(type_name) = type_arg {
                                    if let Some(named_type) = self.named_types.get(type_name).cloned() {
                                        return self.parse_json_ptr_to_struct(ptr_val, &named_type);
                                    }
                                }
                            }

                            let len = self.call_runtime("strlen", &[ptr_val.into()], "slen").unwrap();
                            return self.call_runtime("forge_string_new", &[ptr_val.into(), len.into()], "fstr");
                        }
                    }
                    return raw;
                }
            }
        }

        // Handle EnumName.variant(args) constructor BEFORE compiling object
        if let Expr::Ident(name, _) = object {
            if let Some(Type::Enum { variants, .. }) = self.type_checker.env.enum_types.get(name).cloned() {
                return self.compile_enum_constructor(name, method, args, &variants);
            }
        }

        // Handle req.params.get("key") -> forge_params_get(params_json, "key")
        if method == "get" {
            if let Expr::MemberAccess { object: inner_obj, field: inner_field, .. } = object {
                if inner_field == "params" {
                    if let Expr::Ident(_, _) = inner_obj.as_ref() {
                        // Look up __req_params_json variable
                        if let Some((params_ptr, _)) = self.lookup_var("__req_params_json") {
                            let ptr_type = self.context.ptr_type(AddressSpace::default());
                            let params_json = self.builder.build_load(ptr_type, params_ptr, "params_json").unwrap().into_pointer_value();
                            if let Some(arg) = args.first() {
                                if let Expr::StringLit(key, _) = &arg.value {
                                    let key_str = self.builder.build_global_string_ptr(key, "param_key").unwrap();
                                    let raw_ptr = self.call_runtime(
                                        "forge_params_get",
                                        &[params_json.into(), key_str.as_pointer_value().into()],
                                        "param_val",
                                    ).unwrap().into_pointer_value();
                                    // Convert raw C string ptr to ForgeString
                                    let len = self.call_runtime("strlen", &[raw_ptr.into()], "slen").unwrap();
                                    return self.call_runtime("forge_string_new", &[raw_ptr.into(), len.into()], "fstr");
                                }
                            }
                        }
                    }
                }
            }
        }

        let obj_val = self.compile_expr(object)?;
        let obj_type = self.infer_type(object);

        match &obj_type {
            Type::String => match method {
                "length" => self.call_runtime("forge_string_length", &[obj_val.into()], "len"),
                "upper" => self.call_runtime("forge_string_upper", &[obj_val.into()], "upper"),
                "lower" => self.call_runtime("forge_string_lower", &[obj_val.into()], "lower"),
                "trim" => self.call_runtime("forge_string_trim", &[obj_val.into()], "trim"),
                "contains" => {
                    let arg_val = self.compile_expr(&args.first()?.value)?;
                    self.call_runtime("forge_string_contains", &[obj_val.into(), arg_val.into()], "contains")
                }
                "split" => {
                    self.compile_string_split(&obj_val, args)
                }
                "starts_with" => {
                    let arg_val = self.compile_expr(&args.first()?.value)?;
                    self.call_runtime("forge_string_starts_with", &[obj_val.into(), arg_val.into()], "starts_with")
                }
                "ends_with" => {
                    let arg_val = self.compile_expr(&args.first()?.value)?;
                    self.call_runtime("forge_string_ends_with", &[obj_val.into(), arg_val.into()], "ends_with")
                }
                "replace" => {
                    let find_val = self.compile_expr(&args.get(0)?.value)?;
                    let replace_val = self.compile_expr(&args.get(1)?.value)?;
                    self.call_runtime("forge_string_replace", &[obj_val.into(), find_val.into(), replace_val.into()], "replace")
                }
                "parse_int" => self.call_runtime("forge_string_parse_int", &[obj_val.into()], "parse_int"),
                "repeat" => {
                    let count_val = self.compile_expr(&args.first()?.value)?;
                    self.call_runtime("forge_string_repeat", &[obj_val.into(), count_val.into()], "repeat")
                }
                _ => None,
            },
            Type::List(inner) => match method {
                "push" => {
                    self.compile_list_push(object, &obj_val, &obj_type, args)
                }
                "clone" => {
                    Some(obj_val)
                }
                "filter" => {
                    self.compile_list_filter(&obj_val, inner, args)
                }
                "map" => {
                    self.compile_list_map(&obj_val, inner, args)
                }
                "sum" => {
                    self.compile_list_sum(&obj_val, inner)
                }
                "find" => {
                    self.compile_list_find(&obj_val, inner, args)
                }
                "any" => {
                    self.compile_list_any(&obj_val, inner, args)
                }
                "all" => {
                    self.compile_list_all(&obj_val, inner, args)
                }
                "enumerate" => {
                    self.compile_list_enumerate(&obj_val, inner)
                }
                "join" => {
                    self.compile_list_join(&obj_val, inner, args)
                }
                "reduce" => {
                    self.compile_list_reduce(&obj_val, inner, args)
                }
                "sorted" => {
                    self.compile_list_sorted(&obj_val, inner)
                }
                "each" => {
                    self.compile_list_each(&obj_val, inner, args)
                }
                _ => None,
            },
            Type::Map(key_type, val_type) => match method {
                "has" => {
                    self.compile_map_has(&obj_val, key_type, val_type, args)
                }
                "get" => {
                    self.compile_map_get(&obj_val, key_type, val_type, args)
                }
                "keys" => {
                    self.compile_map_keys(&obj_val, key_type, val_type)
                }
                _ => None,
            },
            _ => {
                // Handle channel method calls (channel is represented as int)
                // ch.close(), ch.drain()
                if obj_type == Type::Int || obj_type == Type::Unknown || matches!(obj_type, Type::Channel(_)) {
                    let channel_fn_name = match method {
                        "close" => Some("forge_channel_close"),
                        "drain" => Some("forge_channel_drain"),
                        _ => None,
                    };
                    if let Some(fn_name) = channel_fn_name {
                        if let Some(func) = self.module.get_function(fn_name) {
                            let result = self.builder.build_call(func, &[obj_val.into()], method).unwrap();
                            return result.try_as_basic_value().left();
                        }
                    }
                }

                // Check for trait method dispatch
                if let Some(type_name) = self.get_type_name(&obj_type) {
                    // Handle built-in clone for primitive types
                    if method == "clone" {
                        return Some(obj_val);
                    }

                    // Handle Display trait's display method
                    if method == "display" {
                        if let Some(mangled) = self.find_impl_method(&type_name, "display") {
                            if let Some(func) = self.functions.get(&mangled).copied() {
                                let mut call_args: Vec<BasicMetadataValueEnum> = vec![obj_val.into()];
                                for arg in args {
                                    if let Some(val) = self.compile_expr(&arg.value) {
                                        call_args.push(val.into());
                                    }
                                }
                                let result = self.builder.build_call(func, &call_args, "method_call").unwrap();
                                return result.try_as_basic_value().left();
                            }
                        }
                    }

                    // Look up trait method impl
                    if let Some(mangled) = self.find_impl_method(&type_name, method) {
                        if let Some(func) = self.functions.get(&mangled).copied() {
                            let mut call_args: Vec<BasicMetadataValueEnum> = vec![obj_val.into()];
                            for arg in args {
                                if let Some(val) = self.compile_expr(&arg.value) {
                                    call_args.push(val.into());
                                }
                            }
                            let result = self.builder.build_call(func, &call_args, "method_call").unwrap();
                            return result.try_as_basic_value().left();
                        }
                    }
                }
                None
            }
        }
    }

    pub(crate) fn compile_index_access(
        &mut self,
        object: &Expr,
        index: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        let obj_val = self.compile_expr(object)?;
        let idx_val = self.compile_expr(index)?;
        let obj_type = self.infer_type(object);

        match &obj_type {
            Type::List(inner) => {
                let elem_llvm_ty = self.type_to_llvm_basic(inner);
                if obj_val.is_struct_value() {
                    let struct_val = obj_val.into_struct_value();
                    let data_ptr = self.builder.build_extract_value(struct_val, 0, "list_data")
                        .ok()?.into_pointer_value();
                    let idx = idx_val.into_int_value();
                    let elem_ptr = unsafe {
                        self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "elem_ptr").unwrap()
                    };
                    Some(self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap())
                } else {
                    None
                }
            }
            _ => None,
        }
    }

    pub(crate) fn compile_closure_inline(
        &mut self,
        closure_arg: &CallArg,
        elem_val: BasicValueEnum<'ctx>,
        elem_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        // Extract params and body from either old Expr::Closure or new Feature("closures")
        let (params, body) = Self::extract_closure_parts(&closure_arg.value)?;
        self.push_scope();
        let param_name = &params[0].name;
        let alloca = self.create_entry_block_alloca(elem_type, param_name);
        self.builder.build_store(alloca, elem_val).unwrap();
        self.define_var(param_name.clone(), alloca, elem_type.clone());
        let result = self.compile_expr(body);
        self.pop_scope();
        result
    }

    /// Compile a 2-arg closure inline (for reduce)
    pub(crate) fn compile_closure_inline_2(
        &mut self,
        closure_arg: &CallArg,
        acc_val: BasicValueEnum<'ctx>,
        acc_type: &Type,
        elem_val: BasicValueEnum<'ctx>,
        elem_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let (params, body) = Self::extract_closure_parts(&closure_arg.value)?;
        self.push_scope();
        if params.len() >= 2 {
            let acc_name = &params[0].name;
            let elem_name = &params[1].name;
            let alloca1 = self.create_entry_block_alloca(acc_type, acc_name);
            self.builder.build_store(alloca1, acc_val).unwrap();
            self.define_var(acc_name.clone(), alloca1, acc_type.clone());
            let alloca2 = self.create_entry_block_alloca(elem_type, elem_name);
            self.builder.build_store(alloca2, elem_val).unwrap();
            self.define_var(elem_name.clone(), alloca2, elem_type.clone());
        }
        let result = self.compile_expr(body);
        self.pop_scope();
        result
    }

    /// Extract closure params and body from either old Expr::Closure or new Feature("closures")
    fn extract_closure_parts(expr: &Expr) -> Option<(&[Param], &Expr)> {
        match expr {
            Expr::Closure { params, body, .. } => Some((params.as_slice(), body.as_ref())),
            Expr::Feature(fe) if fe.feature_id == "closures" => {
                let data = fe.data.as_any().downcast_ref::<crate::features::closures::types::ClosureData>()?;
                Some((data.params.as_slice(), data.body.as_ref()))
            }
            _ => None,
        }
    }

    // compile_string_split: extracted to compiler/features/strings/codegen.rs

    // list/map method implementations extracted to compiler/features/collections/codegen.rs:
    // compile_list_push, compile_list_filter, compile_list_map, compile_list_sum,
    // compile_list_find, compile_list_any, compile_list_all, compile_list_enumerate,
    // compile_list_join, compile_list_reduce, compile_list_sorted, compile_list_each,
    // compile_map_has, compile_map_get, compile_map_keys, compile_key_eq

    /// Parse a raw JSON C-string pointer into a typed struct.
    /// Wraps the JSON object in `[...]` so forge_json_get_* can parse it at index 0.
    pub(crate) fn parse_json_ptr_to_struct(
        &mut self,
        raw_ptr: PointerValue<'ctx>,
        target_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let fields = match target_type {
            Type::Struct { fields, .. } => fields,
            _ => return None,
        };

        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        // Wrap raw JSON ptr in "[" ... "]" so forge_json_get_* works at index 0
        let strlen_fn = self.module.get_function("strlen").unwrap_or_else(|| {
            let ft = i64_type.fn_type(&[ptr_type.into()], false);
            self.module.add_function("strlen", ft, None)
        });
        let json_len = self.builder.build_call(strlen_fn, &[raw_ptr.into()], "json_len").unwrap()
            .try_as_basic_value().left().unwrap().into_int_value();

        let three = i64_type.const_int(3, false);
        let buf_len = self.builder.build_int_add(json_len, three, "buf_len").unwrap();
        let alloc_fn = self.module.get_function("forge_alloc").unwrap_or_else(|| {
            let ft = ptr_type.fn_type(&[i64_type.into()], false);
            self.module.add_function("forge_alloc", ft, None)
        });
        let buf = self.builder.build_call(alloc_fn, &[buf_len.into()], "json_buf").unwrap()
            .try_as_basic_value().left().unwrap().into_pointer_value();

        // snprintf(buf, buf_len, "[%s]", raw_ptr)
        let snprintf_fn = self.module.get_function("snprintf").unwrap_or_else(|| {
            let ft = i64_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], true);
            self.module.add_function("snprintf", ft, None)
        });
        let fmt = self.builder.build_global_string_ptr("[%s]", "wrap_fmt").unwrap();
        self.builder.build_call(
            snprintf_fn,
            &[buf.into(), buf_len.into(), fmt.as_pointer_value().into(), raw_ptr.into()],
            "",
        ).unwrap();

        // Parse fields from buf at index 0
        let llvm_type = self.type_to_llvm_basic(target_type);
        let struct_type = llvm_type.into_struct_type();
        let mut struct_val = struct_type.get_undef();

        for (i, (field_name, field_type)) in fields.iter().enumerate() {
            let field_name_str = self.builder.build_global_string_ptr(field_name, "fname").unwrap();
            let field_val: BasicValueEnum = match field_type {
                Type::Int => {
                    let get_fn = self.module.get_function("forge_json_get_int").unwrap();
                    self.builder.build_call(
                        get_fn,
                        &[buf.into(), i64_type.const_zero().into(), field_name_str.as_pointer_value().into()],
                        field_name,
                    ).unwrap().try_as_basic_value().left().unwrap()
                }
                Type::Bool => {
                    let get_fn = self.module.get_function("forge_json_get_bool").unwrap();
                    self.builder.build_call(
                        get_fn,
                        &[buf.into(), i64_type.const_zero().into(), field_name_str.as_pointer_value().into()],
                        field_name,
                    ).unwrap().try_as_basic_value().left().unwrap()
                }
                _ => {
                    // Default: string (ForgeString)
                    let get_fn = self.module.get_function("forge_json_get_string").unwrap();
                    self.builder.build_call(
                        get_fn,
                        &[buf.into(), i64_type.const_zero().into(), field_name_str.as_pointer_value().into()],
                        field_name,
                    ).unwrap().try_as_basic_value().left().unwrap()
                }
            };

            struct_val = self.builder
                .build_insert_value(struct_val, field_val, i as u32, field_name)
                .unwrap()
                .into_struct_value();
        }

        Some(struct_val.into())
    }
}
