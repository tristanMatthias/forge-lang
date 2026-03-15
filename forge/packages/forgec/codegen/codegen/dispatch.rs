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
                                    if let Some((list_ptr, list_len)) = self.extract_list_fields(&val) {
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

                            return self.wrap_ptr_as_string(ptr_val);
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
                                    return self.wrap_ptr_as_string(raw_ptr);
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
            Type::String => self.compile_string_method(obj_val, method, args),
            Type::List(inner) => match method {
                "push" => self.compile_list_push(object, &obj_val, &obj_type, args),
                "clone" => Some(obj_val),
                "filter" => self.compile_list_filter(&obj_val, inner, args),
                "map" => self.compile_list_map(&obj_val, inner, args),
                "sum" => self.compile_list_sum(&obj_val, inner),
                "find" => self.compile_list_find(&obj_val, inner, args),
                "any" => self.compile_list_any(&obj_val, inner, args),
                "all" => self.compile_list_all(&obj_val, inner, args),
                "enumerate" => self.compile_list_enumerate(&obj_val, inner),
                "join" => self.compile_list_join(&obj_val, inner, args),
                "reduce" => self.compile_list_reduce(&obj_val, inner, args),
                "sorted" => self.compile_list_sorted(&obj_val, inner),
                "each" => self.compile_list_each(&obj_val, inner, args),
                _ => None,
            },
            Type::Map(key_type, val_type) => match method {
                "has" => self.compile_map_has(&obj_val, key_type, val_type, args),
                "get" => self.compile_map_get(&obj_val, key_type, val_type, args),
                "keys" => self.compile_map_keys(&obj_val, key_type, val_type),
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
                        if let Some(result) = self.call_impl_method(&type_name, "display", obj_val, args) {
                            return Some(result);
                        }
                    }

                    // Look up trait method impl
                    if let Some(result) = self.call_impl_method(&type_name, method, obj_val, args) {
                        return Some(result);
                    }
                }
                None
            }
        }
    }

    /// Look up an impl method by type name and method name, compile the call with
    /// obj_val as self and the given args, and return the result.
    pub(crate) fn call_impl_method(
        &mut self,
        type_name: &str,
        method_name: &str,
        obj_val: BasicValueEnum<'ctx>,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let mangled = self.find_impl_method(type_name, method_name)?;
        let func = self.functions.get(&mangled).copied()?;
        let mut call_args: Vec<BasicMetadataValueEnum> = vec![obj_val.into()];
        for arg in args {
            if let Some(val) = self.compile_expr(&arg.value) {
                call_args.push(val.into());
            }
        }
        let result = self.builder.build_call(func, &call_args, "method_call").unwrap();
        result.try_as_basic_value().left()
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
                let (data_ptr, _) = self.extract_list_fields(&obj_val)?;
                let idx = idx_val.into_int_value();
                let elem_ptr = unsafe {
                    self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "elem_ptr").unwrap()
                };
                Some(self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap())
            }
            Type::Map(key_type, val_type) => {
                // Map index access returns nullable — same as map.get(key)
                let args = vec![crate::parser::ast::CallArg {
                    name: None,
                    value: index.clone(),
                }];
                self.compile_map_get(&obj_val, key_type, val_type, &args)
            }
            Type::Ptr => {
                let ptr_val = obj_val.into_pointer_value();
                self.compile_ptr_index_read(ptr_val, index)
            }
            _ => None,
        }
    }
}
