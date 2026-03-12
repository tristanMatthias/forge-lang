use super::*;

impl<'ctx> Codegen<'ctx> {
    /// Compile json.parse(json_string) with a target type.
    /// Parses a JSON string into a struct value using the runtime's forge_json_get_* functions.
    pub(crate) fn compile_json_parse_call(
        &mut self,
        args: &[CallArg],
        target_type: Option<&Type>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let arg = args.first()?;
        let json_val = self.compile_expr(&arg.value)?;

        let target = target_type?;

        match target {
            Type::Struct { name, fields } => {
                self.compile_json_parse_struct(json_val, name.as_deref(), fields)
            }
            Type::List(inner) => {
                if let Type::Struct { name, fields } = inner.as_ref() {
                    self.compile_json_parse_list(json_val, name.as_deref(), fields)
                } else {
                    Some(json_val)
                }
            }
            _ => {
                // For non-struct types, just return the string value
                Some(json_val)
            }
        }
    }

    /// Parse a JSON c-string pointer into a struct.
    /// The json_ptr should be a ptr to a C string containing a JSON object.
    pub(crate) fn compile_json_parse_struct(
        &mut self,
        json_val: BasicValueEnum<'ctx>,
        _name: Option<&str>,
        fields: &[(String, Type)],
    ) -> Option<BasicValueEnum<'ctx>> {
        self.ensure_json_functions_declared();

        let i64_type = self.context.i64_type();

        // json_val is a ForgeString (ptr, len) — we need the raw C pointer
        // Extract the ptr field from the ForgeString struct
        let json_ptr = if json_val.is_struct_value() {
            self.builder
                .build_extract_value(json_val.into_struct_value(), 0, "json_ptr")
                .unwrap()
                .into_pointer_value()
        } else {
            json_val.into_pointer_value()
        };

        let index = i64_type.const_zero();

        // Build the struct type
        let field_types: Vec<BasicTypeEnum<'ctx>> = fields
            .iter()
            .map(|(_, ty)| self.type_to_llvm_basic(ty))
            .collect();
        let struct_type = self.context.struct_type(&field_types, false);
        let mut struct_val = struct_type.get_undef();

        for (i, (field_name, field_type)) in fields.iter().enumerate() {
            let field_name_str = self
                .builder
                .build_global_string_ptr(field_name, "field_name")
                .unwrap();

            let field_val: BasicValueEnum = match field_type {
                Type::Int => {
                    let get_fn = self.module.get_function("forge_json_get_int").unwrap();
                    self.builder
                        .build_call(
                            get_fn,
                            &[
                                json_ptr.into(),
                                index.into(),
                                field_name_str.as_pointer_value().into(),
                            ],
                            field_name,
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                }
                Type::Bool => {
                    let get_fn = self.module.get_function("forge_json_get_bool").unwrap();
                    self.builder
                        .build_call(
                            get_fn,
                            &[
                                json_ptr.into(),
                                index.into(),
                                field_name_str.as_pointer_value().into(),
                            ],
                            field_name,
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                }
                _ => {
                    // Default to string
                    let get_fn = self.module.get_function("forge_json_get_string").unwrap();
                    self.builder
                        .build_call(
                            get_fn,
                            &[
                                json_ptr.into(),
                                index.into(),
                                field_name_str.as_pointer_value().into(),
                            ],
                            field_name,
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                }
            };

            struct_val = self
                .builder
                .build_insert_value(struct_val, field_val, i as u32, field_name)
                .unwrap()
                .into_struct_value();
        }

        Some(struct_val.into())
    }

    /// Compile json.stringify(value) — serializes a struct value to a JSON ForgeString.
    pub(crate) fn compile_json_stringify_call(
        &mut self,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let arg = args.first()?;
        let val = self.compile_expr(&arg.value)?;
        let val_type = self.infer_type(&arg.value);

        match &val_type {
            Type::Struct { fields, .. } => {
                self.compile_json_stringify_struct(val, fields)
            }
            _ => {
                // For non-struct types, convert to string
                Some(val)
            }
        }
    }

    /// Serialize a struct value to a JSON string (returned as ForgeString).
    /// Uses snprintf to build the JSON in a stack buffer.
    pub(crate) fn compile_json_stringify_struct(
        &mut self,
        val: BasicValueEnum<'ctx>,
        fields: &[(String, Type)],
    ) -> Option<BasicValueEnum<'ctx>> {
        self.ensure_snprintf_declared();

        let i64_type = self.context.i64_type();
        let i8_type = self.context.i8_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let snprintf = self.module.get_function("snprintf").unwrap();

        // Allocate a buffer on the stack (4KB should be enough for JSON)
        let buf_size = i64_type.const_int(4096, false);
        let buf = self
            .builder
            .build_array_alloca(i8_type, buf_size, "json_buf")
            .unwrap();

        let struct_val = if val.is_struct_value() {
            val.into_struct_value()
        } else {
            return None;
        };

        let mut offset = i64_type.const_zero();
        let fmt_s = self
            .builder
            .build_global_string_ptr("%s", "fmt_s")
            .unwrap();

        // Write opening brace
        let open_brace = self
            .builder
            .build_global_string_ptr("{", "open")
            .unwrap();
        let remaining = self
            .builder
            .build_int_sub(buf_size, offset, "rem")
            .unwrap();
        let buf_offset = unsafe {
            self.builder
                .build_gep(i8_type, buf, &[offset], "buf_off")
                .unwrap()
        };
        let wrote = self
            .builder
            .build_call(
                snprintf,
                &[
                    buf_offset.into(),
                    remaining.into(),
                    fmt_s.as_pointer_value().into(),
                    open_brace.as_pointer_value().into(),
                ],
                "wrote",
            )
            .unwrap()
            .try_as_basic_value()
            .left()
            .unwrap()
            .into_int_value();
        let wrote_i64 = self
            .builder
            .build_int_z_extend(wrote, i64_type, "w64")
            .unwrap();
        offset = self.builder.build_int_add(offset, wrote_i64, "off").unwrap();

        for (i, (field_name, field_type)) in fields.iter().enumerate() {
            let comma = if i > 0 { "," } else { "" };
            let field_val = self
                .builder
                .build_extract_value(struct_val, i as u32, field_name)
                .unwrap();

            match field_type {
                Type::String => {
                    let fmt = format!("{}\"{}\":\"", comma, field_name);
                    let fmt_str = self
                        .builder
                        .build_global_string_ptr(&fmt, "kv_fmt")
                        .unwrap();
                    let remaining = self
                        .builder
                        .build_int_sub(buf_size, offset, "rem")
                        .unwrap();
                    let buf_off = unsafe {
                        self.builder
                            .build_gep(i8_type, buf, &[offset], "off")
                            .unwrap()
                    };
                    let wrote = self
                        .builder
                        .build_call(
                            snprintf,
                            &[
                                buf_off.into(),
                                remaining.into(),
                                fmt_str.as_pointer_value().into(),
                            ],
                            "",
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                        .into_int_value();
                    let w64 = self
                        .builder
                        .build_int_z_extend(wrote, i64_type, "w64")
                        .unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();

                    // Write the string value using forge_write_cstring
                    let write_fn = self.module.get_function("forge_write_cstring").unwrap();
                    let remaining = self
                        .builder
                        .build_int_sub(buf_size, offset, "rem")
                        .unwrap();
                    let buf_off = unsafe {
                        self.builder
                            .build_gep(i8_type, buf, &[offset], "off")
                            .unwrap()
                    };
                    // Extract ptr and len from ForgeString
                    let str_struct = field_val.into_struct_value();
                    let str_ptr = self.builder
                        .build_extract_value(str_struct, 0, "str_ptr")
                        .unwrap();
                    let str_len = self.builder
                        .build_extract_value(str_struct, 1, "str_len")
                        .unwrap();
                    self.builder
                        .build_call(
                            write_fn,
                            &[buf_off.into(), remaining.into(), str_ptr.into(), str_len.into()],
                            "",
                        )
                        .unwrap();
                    // Advance offset by the string length
                    offset = self.builder.build_int_add(offset, str_len.into_int_value(), "off").unwrap();

                    // Write closing quote
                    let close_q = self
                        .builder
                        .build_global_string_ptr("\"", "close_q")
                        .unwrap();
                    let remaining = self
                        .builder
                        .build_int_sub(buf_size, offset, "rem")
                        .unwrap();
                    let buf_off = unsafe {
                        self.builder
                            .build_gep(i8_type, buf, &[offset], "off")
                            .unwrap()
                    };
                    let wrote = self
                        .builder
                        .build_call(
                            snprintf,
                            &[
                                buf_off.into(),
                                remaining.into(),
                                fmt_s.as_pointer_value().into(),
                                close_q.as_pointer_value().into(),
                            ],
                            "",
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                        .into_int_value();
                    let w64 = self
                        .builder
                        .build_int_z_extend(wrote, i64_type, "w64")
                        .unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();
                }
                Type::Int => {
                    let fmt = format!("{}\"{}\":%lld", comma, field_name);
                    let fmt_str = self
                        .builder
                        .build_global_string_ptr(&fmt, "kv_fmt")
                        .unwrap();
                    let remaining = self
                        .builder
                        .build_int_sub(buf_size, offset, "rem")
                        .unwrap();
                    let buf_off = unsafe {
                        self.builder
                            .build_gep(i8_type, buf, &[offset], "off")
                            .unwrap()
                    };
                    let wrote = self
                        .builder
                        .build_call(
                            snprintf,
                            &[
                                buf_off.into(),
                                remaining.into(),
                                fmt_str.as_pointer_value().into(),
                                field_val.into(),
                            ],
                            "",
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                        .into_int_value();
                    let w64 = self
                        .builder
                        .build_int_z_extend(wrote, i64_type, "w64")
                        .unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();
                }
                Type::Bool => {
                    // Bools are i8, write as 0 or 1
                    let fmt = format!("{}\"{}\":%d", comma, field_name);
                    let fmt_str = self
                        .builder
                        .build_global_string_ptr(&fmt, "kv_fmt")
                        .unwrap();
                    let remaining = self
                        .builder
                        .build_int_sub(buf_size, offset, "rem")
                        .unwrap();
                    let buf_off = unsafe {
                        self.builder
                            .build_gep(i8_type, buf, &[offset], "off")
                            .unwrap()
                    };
                    let int_val = self
                        .builder
                        .build_int_z_extend(field_val.into_int_value(), self.context.i32_type(), "bool_i32")
                        .unwrap();
                    let wrote = self
                        .builder
                        .build_call(
                            snprintf,
                            &[
                                buf_off.into(),
                                remaining.into(),
                                fmt_str.as_pointer_value().into(),
                                int_val.into(),
                            ],
                            "",
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                        .into_int_value();
                    let w64 = self
                        .builder
                        .build_int_z_extend(wrote, i64_type, "w64")
                        .unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();
                }
                Type::Float => {
                    let fmt = format!("{}\"{}\":%f", comma, field_name);
                    let fmt_str = self
                        .builder
                        .build_global_string_ptr(&fmt, "kv_fmt")
                        .unwrap();
                    let remaining = self
                        .builder
                        .build_int_sub(buf_size, offset, "rem")
                        .unwrap();
                    let buf_off = unsafe {
                        self.builder
                            .build_gep(i8_type, buf, &[offset], "off")
                            .unwrap()
                    };
                    let wrote = self
                        .builder
                        .build_call(
                            snprintf,
                            &[
                                buf_off.into(),
                                remaining.into(),
                                fmt_str.as_pointer_value().into(),
                                field_val.into(),
                            ],
                            "",
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                        .into_int_value();
                    let w64 = self
                        .builder
                        .build_int_z_extend(wrote, i64_type, "w64")
                        .unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();
                }
                _ => {}
            }
        }

        // Write closing brace
        let close_brace = self
            .builder
            .build_global_string_ptr("}", "close")
            .unwrap();
        let remaining = self
            .builder
            .build_int_sub(buf_size, offset, "rem")
            .unwrap();
        let buf_off = unsafe {
            self.builder
                .build_gep(i8_type, buf, &[offset], "off")
                .unwrap()
        };
        self.builder
            .build_call(
                snprintf,
                &[
                    buf_off.into(),
                    remaining.into(),
                    fmt_s.as_pointer_value().into(),
                    close_brace.as_pointer_value().into(),
                ],
                "",
            )
            .unwrap();

        // Convert the C buffer to a ForgeString
        let string_new = self.module.get_function("forge_string_new").unwrap();
        let str_len = self
            .builder
            .build_call(
                self.module.get_function("forge_string_length").unwrap(),
                &[self
                    .builder
                    .build_call(string_new, &[buf.into(), buf_size.into()], "tmp_str")
                    .unwrap()
                    .try_as_basic_value()
                    .left()
                    .unwrap()
                    .into()],
                "json_len",
            )
            .unwrap()
            .try_as_basic_value()
            .left();

        // Actually, simpler: use forge_string_new with strlen-equivalent
        // Just call forge_string_new(buf, strlen) where strlen is implicit via the runtime
        let result = self
            .builder
            .build_call(string_new, &[buf.into(), buf_size.into()], "json_str")
            .unwrap();
        result.try_as_basic_value().left()
    }

    /// Parse a JSON array string into a List<Struct>.
    /// Returns a {ptr, count} list struct.
    pub(crate) fn compile_json_parse_list(
        &mut self,
        json_val: BasicValueEnum<'ctx>,
        name: Option<&str>,
        fields: &[(String, Type)],
    ) -> Option<BasicValueEnum<'ctx>> {
        self.ensure_json_functions_declared();

        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        // Extract raw C pointer from ForgeString
        let json_ptr = if json_val.is_struct_value() {
            self.builder
                .build_extract_value(json_val.into_struct_value(), 0, "json_ptr")
                .unwrap()
                .into_pointer_value()
        } else {
            json_val.into_pointer_value()
        };

        // Get array count
        let count_fn = self.module.get_function("forge_json_array_count").unwrap();
        let count = self.builder
            .build_call(count_fn, &[json_ptr.into()], "count")
            .unwrap()
            .try_as_basic_value()
            .left()
            .unwrap()
            .into_int_value();

        // Build the struct type for elements
        let field_types: Vec<BasicTypeEnum<'ctx>> = fields
            .iter()
            .map(|(_, ty)| self.type_to_llvm_basic(ty))
            .collect();
        let struct_type = self.context.struct_type(&field_types, false);
        let struct_size = struct_type.size_of().unwrap();

        // Allocate: count * struct_size
        let total_size = self.builder.build_int_mul(count, struct_size, "total_size").unwrap();
        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let data_ptr = self.builder
            .build_call(alloc_fn, &[total_size.into()], "data")
            .unwrap()
            .try_as_basic_value()
            .left()
            .unwrap()
            .into_pointer_value();

        // Loop: for i in 0..count, parse each object
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
        let loop_bb = self.context.append_basic_block(function, "parse_loop");
        let body_bb = self.context.append_basic_block(function, "parse_body");
        let done_bb = self.context.append_basic_block(function, "parse_done");

        // i = 0
        let i_alloca = self.builder.build_alloca(i64_type, "i").unwrap();
        self.builder.build_store(i_alloca, i64_type.const_zero()).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        // Loop condition
        self.builder.position_at_end(loop_bb);
        let i_val = self.builder.build_load(i64_type, i_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, i_val, count, "cmp").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, done_bb).unwrap();

        // Loop body
        self.builder.position_at_end(body_bb);
        let i_val = self.builder.build_load(i64_type, i_alloca, "i").unwrap().into_int_value();

        // Parse fields for index i
        let mut struct_val = struct_type.get_undef();
        for (fi, (field_name, field_type)) in fields.iter().enumerate() {
            let field_name_str = self.builder
                .build_global_string_ptr(field_name, "field_name")
                .unwrap();

            let field_val: BasicValueEnum = match field_type {
                Type::Int => {
                    let get_fn = self.module.get_function("forge_json_get_int").unwrap();
                    self.builder
                        .build_call(get_fn, &[json_ptr.into(), i_val.into(), field_name_str.as_pointer_value().into()], field_name)
                        .unwrap()
                        .try_as_basic_value().left().unwrap()
                }
                Type::Bool => {
                    let get_fn = self.module.get_function("forge_json_get_bool").unwrap();
                    self.builder
                        .build_call(get_fn, &[json_ptr.into(), i_val.into(), field_name_str.as_pointer_value().into()], field_name)
                        .unwrap()
                        .try_as_basic_value().left().unwrap()
                }
                _ => {
                    let get_fn = self.module.get_function("forge_json_get_string").unwrap();
                    self.builder
                        .build_call(get_fn, &[json_ptr.into(), i_val.into(), field_name_str.as_pointer_value().into()], field_name)
                        .unwrap()
                        .try_as_basic_value().left().unwrap()
                }
            };

            struct_val = self.builder
                .build_insert_value(struct_val, field_val, fi as u32, field_name)
                .unwrap()
                .into_struct_value();
        }

        // Store struct at data[i]
        let elem_ptr = unsafe {
            self.builder.build_gep(struct_type, data_ptr, &[i_val], "elem_ptr").unwrap()
        };
        self.builder.build_store(elem_ptr, struct_val).unwrap();

        // i++
        let next_i = self.builder.build_int_add(i_val, i64_type.const_int(1, false), "next_i").unwrap();
        self.builder.build_store(i_alloca, next_i).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        // Done
        self.builder.position_at_end(done_bb);

        // Build list struct {ptr, count}
        let list_type = self.context.struct_type(
            &[ptr_type.into(), i64_type.into()],
            false,
        );
        let mut list_val = list_type.get_undef();
        list_val = self.builder
            .build_insert_value(list_val, data_ptr, 0, "list_data")
            .unwrap()
            .into_struct_value();
        list_val = self.builder
            .build_insert_value(list_val, count, 1, "list_count")
            .unwrap()
            .into_struct_value();

        Some(list_val.into())
    }

    /// Ensure JSON parsing runtime functions are declared.
    pub(crate) fn ensure_json_functions_declared(&mut self) {
        let i64_type = self.context.i64_type();
        let i8_type = self.context.i8_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let string_type = self.string_type();

        if self.module.get_function("forge_json_array_count").is_none() {
            let ft = i64_type.fn_type(&[ptr_type.into()], false);
            self.module.add_function("forge_json_array_count", ft, None);
        }
        if self.module.get_function("forge_json_get_string").is_none() {
            let ft = string_type.fn_type(
                &[ptr_type.into(), i64_type.into(), ptr_type.into()],
                false,
            );
            self.module
                .add_function("forge_json_get_string", ft, None);
        }
        if self.module.get_function("forge_json_get_int").is_none() {
            let ft =
                i64_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], false);
            self.module.add_function("forge_json_get_int", ft, None);
        }
        if self.module.get_function("forge_json_get_bool").is_none() {
            let ft =
                i8_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], false);
            self.module.add_function("forge_json_get_bool", ft, None);
        }
        if self.module.get_function("forge_json_is_null").is_none() {
            let ft = i8_type.fn_type(&[ptr_type.into()], false);
            self.module.add_function("forge_json_is_null", ft, None);
        }
    }

    /// Ensure snprintf is declared.
    pub(crate) fn ensure_snprintf_declared(&mut self) {
        let i32_type = self.context.i32_type();
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        if self.module.get_function("snprintf").is_none() {
            let ft = i32_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], true);
            self.module.add_function("snprintf", ft, None);
        }
        if self.module.get_function("forge_write_cstring").is_none() {
            let void_type = self.context.void_type();
            let ft = void_type.fn_type(
                &[
                    ptr_type.into(),
                    i64_type.into(),
                    ptr_type.into(),
                    i64_type.into(),
                ],
                false,
            );
            self.module
                .add_function("forge_write_cstring", ft, None);
        }
    }
}
