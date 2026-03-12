use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_method_call(
        &mut self,
        object: &Expr,
        method: &str,
        args: &[CallArg],
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
                                        let to_json_fn = self.module.get_function("forge_list_to_json").unwrap();
                                        let json_str = self.builder.build_call(
                                            to_json_fn, &[list_ptr.into(), list_len.into()], "list_json"
                                        ).unwrap().try_as_basic_value().left().unwrap();
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
                            let ptr_type = self.context.ptr_type(AddressSpace::default());
                            let strlen_fn = self.module.get_function("strlen").unwrap_or_else(|| {
                                let ft = self.context.i64_type().fn_type(&[ptr_type.into()], false);
                                self.module.add_function("strlen", ft, None)
                            });
                            let len = self.builder.build_call(strlen_fn, &[ptr_val.into()], "slen")
                                .unwrap().try_as_basic_value().left().unwrap();
                            let str_new_fn = self.module.get_function("forge_string_new").unwrap();
                            let forge_str = self.builder.build_call(
                                str_new_fn, &[ptr_val.into(), len.into()], "fstr",
                            ).unwrap().try_as_basic_value().left();
                            return forge_str;
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
                                    let params_get_fn = self.module.get_function("forge_params_get").unwrap();
                                    let raw_ptr = self.builder.build_call(
                                        params_get_fn,
                                        &[params_json.into(), key_str.as_pointer_value().into()],
                                        "param_val",
                                    ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();
                                    // Convert raw C string ptr to ForgeString
                                    let strlen_fn = self.module.get_function("strlen").unwrap_or_else(|| {
                                        let ft = self.context.i64_type().fn_type(&[ptr_type.into()], false);
                                        self.module.add_function("strlen", ft, None)
                                    });
                                    let len = self.builder.build_call(strlen_fn, &[raw_ptr.into()], "slen")
                                        .unwrap().try_as_basic_value().left().unwrap().into_int_value();
                                    let str_new_fn = self.module.get_function("forge_string_new").unwrap();
                                    let forge_str = self.builder.build_call(
                                        str_new_fn, &[raw_ptr.into(), len.into()], "fstr",
                                    ).unwrap();
                                    return forge_str.try_as_basic_value().left();
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
                "length" => {
                    let len_fn = self.module.get_function("forge_string_length").unwrap();
                    let result = self.builder.build_call(len_fn, &[obj_val.into()], "len").unwrap();
                    result.try_as_basic_value().left()
                }
                "upper" => {
                    let upper_fn = self.module.get_function("forge_string_upper").unwrap();
                    let result = self.builder.build_call(upper_fn, &[obj_val.into()], "upper").unwrap();
                    result.try_as_basic_value().left()
                }
                "lower" => {
                    let lower_fn = self.module.get_function("forge_string_lower").unwrap();
                    let result = self.builder.build_call(lower_fn, &[obj_val.into()], "lower").unwrap();
                    result.try_as_basic_value().left()
                }
                "trim" => {
                    let trim_fn = self.module.get_function("forge_string_trim").unwrap();
                    let result = self.builder.build_call(trim_fn, &[obj_val.into()], "trim").unwrap();
                    result.try_as_basic_value().left()
                }
                "contains" => {
                    if let Some(arg) = args.first() {
                        let arg_val = self.compile_expr(&arg.value)?;
                        let contains_fn = self.module.get_function("forge_string_contains").unwrap();
                        let result = self.builder.build_call(
                            contains_fn,
                            &[obj_val.into(), arg_val.into()],
                            "contains",
                        ).unwrap();
                        result.try_as_basic_value().left()
                    } else {
                        None
                    }
                }
                "split" => {
                    self.compile_string_split(&obj_val, args)
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
                if obj_type == Type::Int || obj_type == Type::Unknown {
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

    /// Compile list.push(item) - reallocates and appends
    pub(crate) fn compile_list_push(
        &mut self,
        list_expr: &Expr,
        list_val: &BasicValueEnum<'ctx>,
        list_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let elem_type = match list_type {
            Type::List(inner) => inner.as_ref().clone(),
            _ => return None,
        };
        let new_val = self.compile_expr(&args.first()?.value)?;
        let elem_llvm_ty = self.type_to_llvm_basic(&elem_type);

        // Extract current data ptr and len
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "list_data").ok()?.into_pointer_value();
        let old_len = self.builder.build_extract_value(struct_val, 1, "list_len").ok()?.into_int_value();

        // New length = old_len + 1
        let new_len = self.builder.build_int_add(
            old_len,
            self.context.i64_type().const_int(1, false),
            "new_len",
        ).unwrap();

        // Allocate new buffer
        let elem_size = elem_llvm_ty.size_of().unwrap();
        let new_total = self.builder.build_int_mul(elem_size, new_len, "new_total").unwrap();
        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let new_ptr = self.builder.build_call(alloc_fn, &[new_total.into()], "new_data").unwrap()
            .try_as_basic_value().left()?.into_pointer_value();

        // Copy old data: memcpy old_len * elem_size bytes
        let old_total = self.builder.build_int_mul(elem_size, old_len, "old_total").unwrap();
        // Simple byte copy via llvm.memcpy
        self.builder.build_memcpy(
            new_ptr, 1, data_ptr, 1, old_total
        ).ok();

        // Store new element at index old_len
        let new_elem_ptr = unsafe {
            self.builder.build_gep(elem_llvm_ty, new_ptr, &[old_len], "new_elem_ptr").unwrap()
        };
        self.builder.build_store(new_elem_ptr, new_val).unwrap();

        // Build new list struct
        let list_llvm_ty = self.type_to_llvm_basic(list_type);
        let list_struct_type = list_llvm_ty.into_struct_type();
        let mut new_list = list_struct_type.get_undef();
        new_list = self.builder.build_insert_value(new_list, new_ptr, 0, "new_list_ptr").unwrap().into_struct_value();
        new_list = self.builder.build_insert_value(new_list, new_len, 1, "new_list_len").unwrap().into_struct_value();

        // Update the mutable variable
        if let Expr::Ident(name, _) = list_expr {
            if let Some((ptr, _)) = self.lookup_var(name) {
                self.builder.build_store(ptr, new_list).unwrap();
            }
        }

        None // push returns void
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
        if let Expr::Closure { params, body, .. } = &closure_arg.value {
            self.push_scope();
            let param_name = &params[0].name;
            let alloca = self.create_entry_block_alloca(elem_type, param_name);
            self.builder.build_store(alloca, elem_val).unwrap();
            self.define_var(param_name.clone(), alloca, elem_type.clone());
            let result = self.compile_expr(body);
            self.pop_scope();
            result
        } else {
            None
        }
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
        if let Expr::Closure { params, body, .. } = &closure_arg.value {
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
        } else {
            None
        }
    }

    /// list.filter(closure) -> new list
    pub(crate) fn compile_list_filter(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        // Allocate result buffer (max size = list_len)
        let elem_size = elem_llvm_ty.size_of().unwrap();
        let total = self.builder.build_int_mul(elem_size, list_len, "total").unwrap();
        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let result_ptr = self.builder.build_call(alloc_fn, &[total.into()], "filter_buf").unwrap()
            .try_as_basic_value().left()?.into_pointer_value();

        // Index and result count allocas
        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "filter_idx").unwrap();
        let count_alloca = self.builder.build_alloca(self.context.i64_type(), "filter_count").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();
        self.builder.build_store(count_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "filter_loop");
        let body_bb = self.context.append_basic_block(function, "filter_body");
        let store_bb = self.context.append_basic_block(function, "filter_store");
        let next_bb = self.context.append_basic_block(function, "filter_next");
        let end_bb = self.context.append_basic_block(function, "filter_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        let pred_result = self.compile_closure_inline(closure_arg, elem_val, elem_type)?;
        let pred_bool = self.to_i1(pred_result);
        self.builder.build_conditional_branch(pred_bool, store_bb, next_bb).unwrap();

        // Store element
        self.builder.position_at_end(store_bb);
        let count = self.builder.build_load(self.context.i64_type(), count_alloca, "c").unwrap().into_int_value();
        let dest_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, result_ptr, &[count], "dp").unwrap() };
        self.builder.build_store(dest_ptr, elem_val).unwrap();
        let new_count = self.builder.build_int_add(count, self.context.i64_type().const_int(1, false), "nc").unwrap();
        self.builder.build_store(count_alloca, new_count).unwrap();
        self.builder.build_unconditional_branch(next_bb).unwrap();

        // Next
        self.builder.position_at_end(next_bb);
        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        // End: build result list
        self.builder.position_at_end(end_bb);
        let final_count = self.builder.build_load(self.context.i64_type(), count_alloca, "fc").unwrap();
        let list_type = self.type_to_llvm_basic(&Type::List(Box::new(elem_type.clone())));
        let list_struct_type = list_type.into_struct_type();
        let mut result_list = list_struct_type.get_undef();
        result_list = self.builder.build_insert_value(result_list, result_ptr, 0, "rp").unwrap().into_struct_value();
        result_list = self.builder.build_insert_value(result_list, final_count, 1, "rl").unwrap().into_struct_value();
        Some(result_list.into())
    }

    /// list.map(closure) -> new list
    pub(crate) fn compile_list_map(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);

        // Infer the output element type from the closure body
        let out_type = self.infer_closure_return_type(closure_arg, elem_type);
        let out_llvm_ty = self.type_to_llvm_basic(&out_type);

        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        // Allocate result buffer
        let out_size = out_llvm_ty.size_of().unwrap();
        let total = self.builder.build_int_mul(out_size, list_len, "total").unwrap();
        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let result_ptr = self.builder.build_call(alloc_fn, &[total.into()], "map_buf").unwrap()
            .try_as_basic_value().left()?.into_pointer_value();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "map_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "map_loop");
        let body_bb = self.context.append_basic_block(function, "map_body");
        let end_bb = self.context.append_basic_block(function, "map_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        let mapped = self.compile_closure_inline(closure_arg, elem_val, elem_type)?;
        let dest_ptr = unsafe { self.builder.build_gep(out_llvm_ty, result_ptr, &[idx], "dp").unwrap() };
        self.builder.build_store(dest_ptr, mapped).unwrap();

        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        // End
        self.builder.position_at_end(end_bb);
        let list_type = self.type_to_llvm_basic(&Type::List(Box::new(out_type.clone())));
        let list_struct_type = list_type.into_struct_type();
        let mut result_list = list_struct_type.get_undef();
        result_list = self.builder.build_insert_value(result_list, result_ptr, 0, "rp").unwrap().into_struct_value();
        result_list = self.builder.build_insert_value(result_list, list_len, 1, "rl").unwrap().into_struct_value();
        Some(result_list.into())
    }

    /// list.sum() -> int
    pub(crate) fn compile_list_sum(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let sum_alloca = self.builder.build_alloca(self.context.i64_type(), "sum").unwrap();
        self.builder.build_store(sum_alloca, self.context.i64_type().const_zero()).unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "sum_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "sum_loop");
        let body_bb = self.context.append_basic_block(function, "sum_body");
        let end_bb = self.context.append_basic_block(function, "sum_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        let acc = self.builder.build_load(self.context.i64_type(), sum_alloca, "acc").unwrap().into_int_value();
        let elem_i64 = if elem_val.is_int_value() {
            let iv = elem_val.into_int_value();
            if iv.get_type().get_bit_width() < 64 {
                self.builder.build_int_s_extend(iv, self.context.i64_type(), "ext").unwrap()
            } else {
                iv
            }
        } else {
            elem_val.into_int_value()
        };
        let new_acc = self.builder.build_int_add(acc, elem_i64, "nacc").unwrap();
        self.builder.build_store(sum_alloca, new_acc).unwrap();

        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(self.context.i64_type(), sum_alloca, "sum_result").unwrap();
        Some(result)
    }

    /// list.find(predicate) -> nullable elem
    pub(crate) fn compile_list_find(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let nullable_type = Type::Nullable(Box::new(elem_type.clone()));
        let nullable_llvm_ty = self.type_to_llvm_basic(&nullable_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        // Result alloca
        let result_alloca = self.builder.build_alloca(nullable_llvm_ty, "find_result").unwrap();
        self.builder.build_store(result_alloca, nullable_llvm_ty.into_struct_type().const_zero()).unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "find_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "find_loop");
        let body_bb = self.context.append_basic_block(function, "find_body");
        let found_bb = self.context.append_basic_block(function, "find_found");
        let next_bb = self.context.append_basic_block(function, "find_next");
        let end_bb = self.context.append_basic_block(function, "find_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        let pred_result = self.compile_closure_inline(closure_arg, elem_val, elem_type)?;
        let pred_bool = self.to_i1(pred_result);
        self.builder.build_conditional_branch(pred_bool, found_bb, next_bb).unwrap();

        // Found: store nullable with tag=1
        self.builder.position_at_end(found_bb);
        let wrapped = self.wrap_in_nullable(elem_val, &nullable_type);
        self.builder.build_store(result_alloca, wrapped).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        // Next
        self.builder.position_at_end(next_bb);
        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(nullable_llvm_ty, result_alloca, "find_val").unwrap();
        Some(result)
    }

    /// list.any(predicate) -> bool
    pub(crate) fn compile_list_any(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let result_alloca = self.builder.build_alloca(self.context.i8_type(), "any_result").unwrap();
        self.builder.build_store(result_alloca, self.context.i8_type().const_zero()).unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "any_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "any_loop");
        let body_bb = self.context.append_basic_block(function, "any_body");
        let found_bb = self.context.append_basic_block(function, "any_found");
        let next_bb = self.context.append_basic_block(function, "any_next");
        let end_bb = self.context.append_basic_block(function, "any_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        let pred_result = self.compile_closure_inline(closure_arg, elem_val, elem_type)?;
        let pred_bool = self.to_i1(pred_result);
        self.builder.build_conditional_branch(pred_bool, found_bb, next_bb).unwrap();

        self.builder.position_at_end(found_bb);
        self.builder.build_store(result_alloca, self.context.i8_type().const_int(1, false)).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        self.builder.position_at_end(next_bb);
        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(self.context.i8_type(), result_alloca, "any_val").unwrap();
        Some(result)
    }

    /// list.all(predicate) -> bool
    pub(crate) fn compile_list_all(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let result_alloca = self.builder.build_alloca(self.context.i8_type(), "all_result").unwrap();
        self.builder.build_store(result_alloca, self.context.i8_type().const_int(1, false)).unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "all_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "all_loop");
        let body_bb = self.context.append_basic_block(function, "all_body");
        let fail_bb = self.context.append_basic_block(function, "all_fail");
        let next_bb = self.context.append_basic_block(function, "all_next");
        let end_bb = self.context.append_basic_block(function, "all_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        let pred_result = self.compile_closure_inline(closure_arg, elem_val, elem_type)?;
        let pred_bool = self.to_i1(pred_result);
        self.builder.build_conditional_branch(pred_bool, next_bb, fail_bb).unwrap();

        self.builder.position_at_end(fail_bb);
        self.builder.build_store(result_alloca, self.context.i8_type().const_zero()).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        self.builder.position_at_end(next_bb);
        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(self.context.i8_type(), result_alloca, "all_val").unwrap();
        Some(result)
    }

    /// list.enumerate() -> list of (int, T) tuples
    pub(crate) fn compile_list_enumerate(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let tuple_type = Type::Tuple(vec![Type::Int, elem_type.clone()]);
        let tuple_llvm_ty = self.type_to_llvm_basic(&tuple_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        // Allocate result buffer
        let tuple_size = tuple_llvm_ty.size_of().unwrap();
        let total = self.builder.build_int_mul(tuple_size, list_len, "total").unwrap();
        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let result_ptr = self.builder.build_call(alloc_fn, &[total.into()], "enum_buf").unwrap()
            .try_as_basic_value().left()?.into_pointer_value();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "enum_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "enum_loop");
        let body_bb = self.context.append_basic_block(function, "enum_body");
        let end_bb = self.context.append_basic_block(function, "enum_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        // Build tuple (idx, elem)
        let tuple_struct_ty = tuple_llvm_ty.into_struct_type();
        let mut tuple_val = tuple_struct_ty.get_undef();
        tuple_val = self.builder.build_insert_value(tuple_val, idx, 0, "t0").unwrap().into_struct_value();
        tuple_val = self.builder.build_insert_value(tuple_val, elem_val, 1, "t1").unwrap().into_struct_value();

        let dest_ptr = unsafe { self.builder.build_gep(tuple_llvm_ty, result_ptr, &[idx], "dp").unwrap() };
        self.builder.build_store(dest_ptr, tuple_val).unwrap();

        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result_list_type = Type::List(Box::new(tuple_type));
        let result_list_llvm = self.type_to_llvm_basic(&result_list_type);
        let list_struct_type = result_list_llvm.into_struct_type();
        let mut result_list = list_struct_type.get_undef();
        result_list = self.builder.build_insert_value(result_list, result_ptr, 0, "rp").unwrap().into_struct_value();
        result_list = self.builder.build_insert_value(result_list, list_len, 1, "rl").unwrap().into_struct_value();
        Some(result_list.into())
    }

    /// list.join(separator) -> string
    pub(crate) fn compile_list_join(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        _elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let sep_val = self.compile_expr(&args.first()?.value)?;
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let string_llvm_ty = self.string_type();
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        // Result string alloca
        let result_alloca = self.builder.build_alloca(string_llvm_ty, "join_result").unwrap();
        let empty_str = self.build_string_literal("");
        self.builder.build_store(result_alloca, empty_str).unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "join_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let concat_fn = self.module.get_function("forge_string_concat").unwrap();

        let loop_bb = self.context.append_basic_block(function, "join_loop");
        let body_bb = self.context.append_basic_block(function, "join_body");
        let end_bb = self.context.append_basic_block(function, "join_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let string_basic_ty: BasicTypeEnum = string_llvm_ty.into();
        let elem_ptr = unsafe {
            self.builder.build_gep(string_llvm_ty, data_ptr, &[idx], "ep").unwrap()
        };
        let elem_val = self.builder.build_load(string_basic_ty, elem_ptr, "elem").unwrap();

        // Add separator if not first element
        let is_first = self.builder.build_int_compare(IntPredicate::EQ, idx, self.context.i64_type().const_zero(), "first").unwrap();
        let current = self.builder.build_load(string_basic_ty, result_alloca, "cur").unwrap();

        let sep_block = self.context.append_basic_block(function, "join_sep");
        let nosep_block = self.context.append_basic_block(function, "join_nosep");
        let merge_block = self.context.append_basic_block(function, "join_merge");

        self.builder.build_conditional_branch(is_first, nosep_block, sep_block).unwrap();

        // With separator
        self.builder.position_at_end(sep_block);
        let with_sep = self.builder.build_call(concat_fn, &[current.into(), sep_val.into()], "ws").unwrap()
            .try_as_basic_value().left().unwrap();
        let with_elem = self.builder.build_call(concat_fn, &[with_sep.into(), elem_val.into()], "we").unwrap()
            .try_as_basic_value().left().unwrap();
        let sep_end = self.builder.get_insert_block().unwrap();
        self.builder.build_unconditional_branch(merge_block).unwrap();

        // Without separator (first element)
        self.builder.position_at_end(nosep_block);
        let just_elem = self.builder.build_call(concat_fn, &[current.into(), elem_val.into()], "je").unwrap()
            .try_as_basic_value().left().unwrap();
        let nosep_end = self.builder.get_insert_block().unwrap();
        self.builder.build_unconditional_branch(merge_block).unwrap();

        self.builder.position_at_end(merge_block);
        let phi = self.builder.build_phi(string_llvm_ty, "merged").unwrap();
        phi.add_incoming(&[(&with_elem, sep_end), (&just_elem, nosep_end)]);
        self.builder.build_store(result_alloca, phi.as_basic_value()).unwrap();

        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(string_basic_ty, result_alloca, "join_val").unwrap();
        Some(result)
    }

    /// list.reduce(init, closure) -> value
    pub(crate) fn compile_list_reduce(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        if args.len() < 2 { return None; }
        let init_val = self.compile_expr(&args[0].value)?;
        let closure_arg = &args[1];

        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let acc_type = self.infer_type(&args[0].value);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let acc_alloca = self.builder.build_alloca(init_val.get_type(), "reduce_acc").unwrap();
        self.builder.build_store(acc_alloca, init_val).unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "reduce_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "reduce_loop");
        let body_bb = self.context.append_basic_block(function, "reduce_body");
        let end_bb = self.context.append_basic_block(function, "reduce_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();
        let acc_val = self.builder.build_load(init_val.get_type(), acc_alloca, "acc").unwrap();

        let new_acc = self.compile_closure_inline_2(closure_arg, acc_val, &acc_type, elem_val, elem_type)?;
        self.builder.build_store(acc_alloca, new_acc).unwrap();

        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(init_val.get_type(), acc_alloca, "reduce_val").unwrap();
        Some(result)
    }
    // infer_closure_return_type: extracted to features/

    /// map.has(key) -> bool
    pub(crate) fn compile_map_has(
        &mut self,
        map_val: &BasicValueEnum<'ctx>,
        key_type: &Type,
        _val_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let search_key = self.compile_expr(&args.first()?.value)?;
        let struct_val = map_val.into_struct_value();
        let keys_ptr = self.builder.build_extract_value(struct_val, 0, "keys").ok()?.into_pointer_value();
        let map_len = self.builder.build_extract_value(struct_val, 2, "len").ok()?.into_int_value();

        let key_llvm_ty = self.type_to_llvm_basic(key_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let result_alloca = self.builder.build_alloca(self.context.i8_type(), "has_result").unwrap();
        self.builder.build_store(result_alloca, self.context.i8_type().const_zero()).unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "has_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "has_loop");
        let body_bb = self.context.append_basic_block(function, "has_body");
        let found_bb = self.context.append_basic_block(function, "has_found");
        let next_bb = self.context.append_basic_block(function, "has_next");
        let end_bb = self.context.append_basic_block(function, "has_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, map_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let kp = unsafe { self.builder.build_gep(key_llvm_ty, keys_ptr, &[idx], "kp").unwrap() };
        let key_val = self.builder.build_load(key_llvm_ty, kp, "key").unwrap();

        let eq = self.compile_key_eq(key_val, search_key, key_type);
        self.builder.build_conditional_branch(eq, found_bb, next_bb).unwrap();

        self.builder.position_at_end(found_bb);
        self.builder.build_store(result_alloca, self.context.i8_type().const_int(1, false)).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        self.builder.position_at_end(next_bb);
        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(self.context.i8_type(), result_alloca, "has_val").unwrap();
        Some(result)
    }

    /// map.get(key) -> nullable value
    pub(crate) fn compile_map_get(
        &mut self,
        map_val: &BasicValueEnum<'ctx>,
        key_type: &Type,
        val_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let search_key = self.compile_expr(&args.first()?.value)?;
        let struct_val = map_val.into_struct_value();
        let keys_ptr = self.builder.build_extract_value(struct_val, 0, "keys").ok()?.into_pointer_value();
        let vals_ptr = self.builder.build_extract_value(struct_val, 1, "vals").ok()?.into_pointer_value();
        let map_len = self.builder.build_extract_value(struct_val, 2, "len").ok()?.into_int_value();

        let key_llvm_ty = self.type_to_llvm_basic(key_type);
        let val_llvm_ty = self.type_to_llvm_basic(val_type);
        let nullable_type = Type::Nullable(Box::new(val_type.clone()));
        let nullable_llvm_ty = self.type_to_llvm_basic(&nullable_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let result_alloca = self.builder.build_alloca(nullable_llvm_ty, "get_result").unwrap();
        self.builder.build_store(result_alloca, nullable_llvm_ty.into_struct_type().const_zero()).unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "get_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "get_loop");
        let body_bb = self.context.append_basic_block(function, "get_body");
        let found_bb = self.context.append_basic_block(function, "get_found");
        let next_bb = self.context.append_basic_block(function, "get_next");
        let end_bb = self.context.append_basic_block(function, "get_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, map_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let kp = unsafe { self.builder.build_gep(key_llvm_ty, keys_ptr, &[idx], "kp").unwrap() };
        let key_val = self.builder.build_load(key_llvm_ty, kp, "key").unwrap();

        let eq = self.compile_key_eq(key_val, search_key, key_type);
        self.builder.build_conditional_branch(eq, found_bb, next_bb).unwrap();

        self.builder.position_at_end(found_bb);
        let vp = unsafe { self.builder.build_gep(val_llvm_ty, vals_ptr, &[idx], "vp").unwrap() };
        let found_val = self.builder.build_load(val_llvm_ty, vp, "val").unwrap();
        let wrapped = self.wrap_in_nullable(found_val, &nullable_type);
        self.builder.build_store(result_alloca, wrapped).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        self.builder.position_at_end(next_bb);
        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(nullable_llvm_ty, result_alloca, "get_val").unwrap();
        Some(result)
    }

    /// map.keys() -> list of keys
    pub(crate) fn compile_map_keys(
        &mut self,
        map_val: &BasicValueEnum<'ctx>,
        key_type: &Type,
        _val_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let struct_val = map_val.into_struct_value();
        let keys_ptr = self.builder.build_extract_value(struct_val, 0, "keys").ok()?.into_pointer_value();
        let map_len = self.builder.build_extract_value(struct_val, 2, "len").ok()?.into_int_value();

        // Return a list {keys_ptr, length}
        let list_type = Type::List(Box::new(key_type.clone()));
        let list_llvm_ty = self.type_to_llvm_basic(&list_type);
        let list_struct_type = list_llvm_ty.into_struct_type();
        let mut result = list_struct_type.get_undef();
        result = self.builder.build_insert_value(result, keys_ptr, 0, "rp").unwrap().into_struct_value();
        result = self.builder.build_insert_value(result, map_len, 1, "rl").unwrap().into_struct_value();
        Some(result.into())
    }

    /// Compare two keys for equality
    pub(crate) fn compile_key_eq(
        &mut self,
        a: BasicValueEnum<'ctx>,
        b: BasicValueEnum<'ctx>,
        key_type: &Type,
    ) -> IntValue<'ctx> {
        match key_type {
            Type::String => {
                let eq_fn = self.module.get_function("forge_string_eq").unwrap();
                let result = self.builder.build_call(eq_fn, &[a.into(), b.into()], "str_eq").unwrap();
                let val = result.try_as_basic_value().left().unwrap().into_int_value();
                self.builder.build_int_compare(IntPredicate::NE, val, self.context.i8_type().const_zero(), "eq_bool").unwrap()
            }
            Type::Int => {
                self.builder.build_int_compare(IntPredicate::EQ, a.into_int_value(), b.into_int_value(), "int_eq").unwrap()
            }
            _ => {
                self.context.bool_type().const_int(0, false)
            }
        }
    }

    /// string.split(separator) -> list<string>
    pub(crate) fn compile_string_split(
        &mut self,
        obj_val: &BasicValueEnum<'ctx>,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let sep_val = self.compile_expr(&args.first()?.value)?;
        let string_type = self.string_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let i64_type = self.context.i64_type();

        let split_fn = self.module.get_function("forge_string_split").unwrap_or_else(|| {
            let ft = i64_type.fn_type(
                &[string_type.into(), string_type.into(), ptr_type.into()],
                false,
            );
            self.module.add_function("forge_string_split", ft, None)
        });

        // Allocate output pointer on stack
        let out_ptr = self.builder.build_alloca(ptr_type, "split_out").unwrap();

        // Call split: returns count, writes data ptr to out_ptr
        let count = self.builder
            .build_call(split_fn, &[(*obj_val).into(), sep_val.into(), out_ptr.into()], "split_count")
            .unwrap()
            .try_as_basic_value()
            .left()?
            .into_int_value();

        let data_ptr = self.builder
            .build_load(ptr_type, out_ptr, "split_data")
            .unwrap()
            .into_pointer_value();

        // Build list struct { ptr, i64 }
        let list_type = self.type_to_llvm_basic(&Type::List(Box::new(Type::String)));
        let list_struct_type = list_type.into_struct_type();
        let mut result_list = list_struct_type.get_undef();
        result_list = self.builder.build_insert_value(result_list, data_ptr, 0, "sp").unwrap().into_struct_value();
        result_list = self.builder.build_insert_value(result_list, count, 1, "sl").unwrap().into_struct_value();
        Some(result_list.into())
    }

    /// list.sorted() -> new sorted list (int only for now)
    pub(crate) fn compile_list_sorted(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let elem_size = elem_llvm_ty.size_of().unwrap();
        let total = self.builder.build_int_mul(elem_size, list_len, "total").unwrap();

        // Clone the list data
        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let new_ptr = self.builder
            .build_call(alloc_fn, &[total.into()], "sort_buf")
            .unwrap()
            .try_as_basic_value()
            .left()?
            .into_pointer_value();
        self.builder.build_memcpy(new_ptr, 1, data_ptr, 1, total).ok();

        // Sort in place
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let sort_fn = self.module.get_function("forge_list_sort_int").unwrap_or_else(|| {
            let ft = self.context.void_type().fn_type(
                &[ptr_type.into(), self.context.i64_type().into()],
                false,
            );
            self.module.add_function("forge_list_sort_int", ft, None)
        });
        self.builder.build_call(sort_fn, &[new_ptr.into(), list_len.into()], "").unwrap();

        // Build new list struct
        let list_type = self.type_to_llvm_basic(&Type::List(Box::new(elem_type.clone())));
        let list_struct_type = list_type.into_struct_type();
        let mut result_list = list_struct_type.get_undef();
        result_list = self.builder.build_insert_value(result_list, new_ptr, 0, "sorted_p").unwrap().into_struct_value();
        result_list = self.builder.build_insert_value(result_list, list_len, 1, "sorted_l").unwrap().into_struct_value();
        Some(result_list.into())
    }

    /// list.each(closure) -> void (side-effect iteration)
    pub(crate) fn compile_list_each(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "each_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "each_loop");
        let body_bb = self.context.append_basic_block(function, "each_body");
        let next_bb = self.context.append_basic_block(function, "each_next");
        let end_bb = self.context.append_basic_block(function, "each_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        self.compile_closure_inline(closure_arg, elem_val, elem_type);

        // Ensure we have a terminator before building next branch
        let current_bb = self.builder.get_insert_block().unwrap();
        if current_bb.get_terminator().is_none() {
            self.builder.build_unconditional_branch(next_bb).unwrap();
        }

        self.builder.position_at_end(next_bb);
        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let next_idx = self.builder.build_int_add(idx, self.context.i64_type().const_int(1, false), "ni").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        None // each returns void
    }
}
