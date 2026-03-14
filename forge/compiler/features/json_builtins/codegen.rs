use inkwell::values::{BasicMetadataValueEnum, BasicValueEnum, IntValue, PointerValue};
use inkwell::types::BasicTypeEnum;
use inkwell::AddressSpace;
use inkwell::IntPredicate;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::{CallArg, Expr};
use crate::typeck::types::Type;

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
                Type::Float => {
                    // Float fields: get as string, then parse (no forge_json_get_float yet)
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
                Type::Struct { name: nested_name, fields: nested_fields } => {
                    // Nested struct: get the raw JSON object pointer, then recursively parse
                    let get_obj_fn = self.module.get_function("forge_json_get_object").unwrap();
                    let nested_json_ptr = self.builder
                        .build_call(
                            get_obj_fn,
                            &[
                                json_ptr.into(),
                                index.into(),
                                field_name_str.as_pointer_value().into(),
                            ],
                            &format!("{}_json", field_name),
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap();

                    // Recursively parse the nested struct using the raw pointer
                    let nested_fields_clone = nested_fields.clone();
                    let nested_name_clone = nested_name.clone();
                    self.compile_json_parse_struct_from_ptr(
                        nested_json_ptr.into_pointer_value(),
                        nested_name_clone.as_deref(),
                        &nested_fields_clone,
                    ).unwrap_or_else(|| self.type_to_llvm_basic(field_type).const_zero().into())
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

    /// Parse a JSON c-string pointer (raw ptr, not ForgeString) into a struct.
    /// Used for nested struct parsing where the pointer is already extracted.
    fn compile_json_parse_struct_from_ptr(
        &mut self,
        json_ptr: inkwell::values::PointerValue<'ctx>,
        _name: Option<&str>,
        fields: &[(String, Type)],
    ) -> Option<BasicValueEnum<'ctx>> {
        self.ensure_json_functions_declared();

        let i64_type = self.context.i64_type();
        let index = i64_type.const_zero();

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
                        .build_call(get_fn, &[json_ptr.into(), index.into(), field_name_str.as_pointer_value().into()], field_name)
                        .unwrap().try_as_basic_value().left().unwrap()
                }
                Type::Bool => {
                    let get_fn = self.module.get_function("forge_json_get_bool").unwrap();
                    self.builder
                        .build_call(get_fn, &[json_ptr.into(), index.into(), field_name_str.as_pointer_value().into()], field_name)
                        .unwrap().try_as_basic_value().left().unwrap()
                }
                Type::Struct { name: nested_name, fields: nested_fields } => {
                    let get_obj_fn = self.module.get_function("forge_json_get_object").unwrap();
                    let nested_json_ptr = self.builder
                        .build_call(get_obj_fn, &[json_ptr.into(), index.into(), field_name_str.as_pointer_value().into()], &format!("{}_json", field_name))
                        .unwrap().try_as_basic_value().left().unwrap();
                    let nested_fields_clone = nested_fields.clone();
                    let nested_name_clone = nested_name.clone();
                    self.compile_json_parse_struct_from_ptr(
                        nested_json_ptr.into_pointer_value(),
                        nested_name_clone.as_deref(),
                        &nested_fields_clone,
                    ).unwrap_or_else(|| self.type_to_llvm_basic(field_type).const_zero().into())
                }
                _ => {
                    let get_fn = self.module.get_function("forge_json_get_string").unwrap();
                    self.builder
                        .build_call(get_fn, &[json_ptr.into(), index.into(), field_name_str.as_pointer_value().into()], field_name)
                        .unwrap().try_as_basic_value().left().unwrap()
                }
            };

            struct_val = self.builder
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
        let mut val_type = self.infer_type(&arg.value);

        // If infer_type couldn't resolve the struct (e.g., variable from a popped block scope),
        // try looking up the variable's stored type directly.
        if !matches!(&val_type, Type::Struct { .. }) {
            if let Expr::Ident(name, _) = &arg.value {
                if let Some((_, ty)) = self.lookup_var(name) {
                    if matches!(&ty, Type::Struct { .. }) {
                        val_type = ty;
                    }
                }
            }
        }

        // If we still don't have struct info but the LLVM value is a struct,
        // try to reconstruct field types from the LLVM type.
        if !matches!(&val_type, Type::Struct { .. } | Type::List(_) | Type::Nullable(_)) && val.is_struct_value() {
            if let Some(fields) = self.infer_struct_fields_from_llvm(val) {
                val_type = Type::Struct { name: None, fields };
            }
        }

        // Also check for List/Nullable type with same fallback logic
        if !matches!(&val_type, Type::Struct { .. } | Type::List(_) | Type::Nullable(_)) {
            if let Expr::Ident(name, _) = &arg.value {
                if let Some((_, ty)) = self.lookup_var(name) {
                    if matches!(&ty, Type::List(_) | Type::Nullable(_)) {
                        val_type = ty;
                    }
                }
            }
        }

        match &val_type {
            Type::Struct { fields, .. } => {
                self.compile_json_stringify_struct(val, fields)
            }
            Type::List(inner) => {
                if let Type::Struct { fields, .. } = inner.as_ref() {
                    self.compile_json_stringify_list(val, fields)
                } else {
                    Some(val)
                }
            }
            Type::Nullable(inner) => {
                if let Type::Struct { fields, .. } = inner.as_ref() {
                    self.compile_json_stringify_nullable_struct(val, fields)
                } else {
                    Some(val)
                }
            }
            _ => {
                // For non-struct types, convert to string
                Some(val)
            }
        }
    }

    /// Attempt to reconstruct field types from an LLVM struct value.
    /// This is a fallback for when type inference fails (e.g., block scope issues).
    fn infer_struct_fields_from_llvm(&self, val: BasicValueEnum<'ctx>) -> Option<Vec<(String, Type)>> {
        if !val.is_struct_value() {
            return None;
        }
        let struct_val = val.into_struct_value();
        let struct_type = struct_val.get_type();
        let count = struct_type.count_fields();
        let i64_type = self.context.i64_type();
        let i8_type = self.context.i8_type();
        let f64_type = self.context.f64_type();
        let string_type = self.string_type();

        let mut fields = Vec::new();
        for i in 0..count {
            let field_type = struct_type.get_field_type_at_index(i)?;
            let ty = if field_type == i64_type.into() {
                Type::Int
            } else if field_type == f64_type.into() {
                Type::Float
            } else if field_type == i8_type.into() {
                Type::Bool
            } else if field_type == string_type.into() {
                Type::String
            } else {
                Type::Unknown
            };
            fields.push((format!("field_{}", i), ty));
        }
        Some(fields)
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
                    // Bools are i8, write as true/false (proper JSON)
                    let true_str = self
                        .builder
                        .build_global_string_ptr(&format!("{}\"{}\":true", comma, field_name), "bool_true")
                        .unwrap();
                    let false_str = self
                        .builder
                        .build_global_string_ptr(&format!("{}\"{}\":false", comma, field_name), "bool_false")
                        .unwrap();
                    let bool_val = field_val.into_int_value();
                    let is_true = self
                        .builder
                        .build_int_compare(
                            IntPredicate::NE,
                            bool_val,
                            i8_type.const_zero(),
                            "is_true",
                        )
                        .unwrap();
                    let selected = self
                        .builder
                        .build_select(
                            is_true,
                            true_str.as_pointer_value(),
                            false_str.as_pointer_value(),
                            "bool_str",
                        )
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
                                selected.into(),
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
                Type::List(inner) if matches!(inner.as_ref(), Type::String) => {
                    // List<String> field → call forge_list_to_json(data, count) → write result
                    let list_to_json = self.module.get_function("forge_list_to_json").unwrap();

                    // Write key: ,"field_name":
                    let key_fmt = format!("{}\"{}\":", comma, field_name);
                    let key_str = self
                        .builder
                        .build_global_string_ptr(&key_fmt, "kv_fmt")
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
                                key_str.as_pointer_value().into(),
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

                    // Extract list data_ptr and count from the struct field
                    let list_struct = field_val.into_struct_value();
                    let data_ptr_val = self
                        .builder
                        .build_extract_value(list_struct, 0, "list_data")
                        .unwrap();
                    let count_val = self
                        .builder
                        .build_extract_value(list_struct, 1, "list_count")
                        .unwrap();

                    // Call forge_list_to_json(data, count) → ForgeString
                    let json_str_val = self
                        .builder
                        .build_call(
                            list_to_json,
                            &[data_ptr_val.into(), count_val.into()],
                            "list_json",
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                        .into_struct_value();

                    // Extract ptr and len from the result ForgeString
                    let json_ptr = self
                        .builder
                        .build_extract_value(json_str_val, 0, "json_ptr")
                        .unwrap();
                    let json_len = self
                        .builder
                        .build_extract_value(json_str_val, 1, "json_len")
                        .unwrap();

                    // Write the JSON array string into the buffer
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
                    self.builder
                        .build_call(
                            write_fn,
                            &[buf_off.into(), remaining.into(), json_ptr.into(), json_len.into()],
                            "",
                        )
                        .unwrap();
                    offset = self.builder.build_int_add(offset, json_len.into_int_value(), "off").unwrap();
                }
                Type::List(inner) if matches!(inner.as_ref(), Type::Int) => {
                    // List<Int> field → call forge_list_int_to_json(data, count)
                    let list_to_json = self.module.get_function("forge_list_int_to_json").unwrap();

                    // Write key
                    let key_fmt = format!("{}\"{}\":", comma, field_name);
                    let key_str = self
                        .builder
                        .build_global_string_ptr(&key_fmt, "kv_fmt")
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
                                key_str.as_pointer_value().into(),
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

                    // Extract list data_ptr and count
                    let list_struct = field_val.into_struct_value();
                    let data_ptr_val = self
                        .builder
                        .build_extract_value(list_struct, 0, "list_data")
                        .unwrap();
                    let count_val = self
                        .builder
                        .build_extract_value(list_struct, 1, "list_count")
                        .unwrap();

                    let json_str_val = self
                        .builder
                        .build_call(
                            list_to_json,
                            &[data_ptr_val.into(), count_val.into()],
                            "list_json",
                        )
                        .unwrap()
                        .try_as_basic_value()
                        .left()
                        .unwrap()
                        .into_struct_value();

                    let json_ptr = self
                        .builder
                        .build_extract_value(json_str_val, 0, "json_ptr")
                        .unwrap();
                    let json_len = self
                        .builder
                        .build_extract_value(json_str_val, 1, "json_len")
                        .unwrap();

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
                    self.builder
                        .build_call(
                            write_fn,
                            &[buf_off.into(), remaining.into(), json_ptr.into(), json_len.into()],
                            "",
                        )
                        .unwrap();
                    offset = self.builder.build_int_add(offset, json_len.into_int_value(), "off").unwrap();
                }
                Type::Struct { fields: inner_fields, .. } => {
                    // Nested struct field → recursively stringify, then write into parent buffer
                    // Write key: ,"field_name":
                    let key_fmt = format!("{}\"{}\":", comma, field_name);
                    let key_str = self
                        .builder
                        .build_global_string_ptr(&key_fmt, "kv_fmt")
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
                                key_str.as_pointer_value().into(),
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

                    // Recursively stringify the nested struct
                    let inner_fields_clone = inner_fields.clone();
                    if let Some(nested_json) = self.compile_json_stringify_struct(field_val, &inner_fields_clone) {
                        // Extract ptr and len from the result ForgeString
                        let nested_struct = nested_json.into_struct_value();
                        let json_ptr = self
                            .builder
                            .build_extract_value(nested_struct, 0, "nested_ptr")
                            .unwrap();
                        let json_len = self
                            .builder
                            .build_extract_value(nested_struct, 1, "nested_len")
                            .unwrap();

                        // Write the nested JSON into the parent buffer
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
                        self.builder
                            .build_call(
                                write_fn,
                                &[buf_off.into(), remaining.into(), json_ptr.into(), json_len.into()],
                                "",
                            )
                            .unwrap();
                        offset = self.builder.build_int_add(offset, json_len.into_int_value(), "off").unwrap();
                    }
                }
                Type::List(inner) if matches!(inner.as_ref(), Type::Struct { .. }) => {
                    // List<Struct> field → call compile_json_stringify_list
                    if let Type::Struct { fields: inner_fields, .. } = inner.as_ref() {
                        // Write key
                        let key_fmt = format!("{}\"{}\":", comma, field_name);
                        let key_str = self
                            .builder
                            .build_global_string_ptr(&key_fmt, "kv_fmt")
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
                                    key_str.as_pointer_value().into(),
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

                        // Stringify the list
                        let inner_fields_clone = inner_fields.clone();
                        if let Some(list_json) = self.compile_json_stringify_list(field_val, &inner_fields_clone) {
                            let list_struct = list_json.into_struct_value();
                            let json_ptr = self
                                .builder
                                .build_extract_value(list_struct, 0, "list_json_ptr")
                                .unwrap();
                            let json_len = self
                                .builder
                                .build_extract_value(list_struct, 1, "list_json_len")
                                .unwrap();

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
                            self.builder
                                .build_call(
                                    write_fn,
                                    &[buf_off.into(), remaining.into(), json_ptr.into(), json_len.into()],
                                    "",
                                )
                                .unwrap();
                            offset = self.builder.build_int_add(offset, json_len.into_int_value(), "off").unwrap();
                        }
                    }
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
        let wrote = self.builder
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

        // Convert the C buffer to a ForgeString using the actual content length
        let string_new = self.module.get_function("forge_string_new").unwrap();
        let result = self
            .builder
            .build_call(string_new, &[buf.into(), offset.into()], "json_str")
            .unwrap();
        result.try_as_basic_value().left()
    }

    /// Serialize a List<Struct> to a JSON array string (returned as ForgeString).
    /// Iterates elements, stringifying each struct inline into a shared buffer.
    pub(crate) fn compile_json_stringify_list(
        &mut self,
        val: BasicValueEnum<'ctx>,
        fields: &[(String, Type)],
    ) -> Option<BasicValueEnum<'ctx>> {
        self.ensure_snprintf_declared();

        let i64_type = self.context.i64_type();
        let i8_type = self.context.i8_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        // Extract list data ptr and count
        let list_struct = val.into_struct_value();
        let data_ptr = self
            .builder
            .build_extract_value(list_struct, 0, "data_ptr")
            .unwrap()
            .into_pointer_value();
        let count = self
            .builder
            .build_extract_value(list_struct, 1, "count")
            .unwrap()
            .into_int_value();

        // Build element struct type
        let field_types: Vec<BasicTypeEnum<'ctx>> = fields
            .iter()
            .map(|(_, ty)| self.type_to_llvm_basic(ty))
            .collect();
        let struct_type = self.context.struct_type(&field_types, false);

        // Allocate output buffer (64KB) and offset alloca
        let buf_size = i64_type.const_int(65536, false);
        let buf = self
            .builder
            .build_array_alloca(i8_type, buf_size, "json_buf")
            .unwrap();
        let offset_alloca = self.builder.build_alloca(i64_type, "off_ptr").unwrap();
        self.builder
            .build_store(offset_alloca, i64_type.const_zero())
            .unwrap();

        // Write '['
        self.buf_write_literal(buf, buf_size, offset_alloca, "[");

        // Loop setup
        let function = self
            .builder
            .get_insert_block()
            .unwrap()
            .get_parent()
            .unwrap();
        let loop_bb = self.context.append_basic_block(function, "list_loop");
        let body_bb = self.context.append_basic_block(function, "list_body");
        let done_bb = self.context.append_basic_block(function, "list_done");

        let i_alloca = self.builder.build_alloca(i64_type, "i").unwrap();
        self.builder
            .build_store(i_alloca, i64_type.const_zero())
            .unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        // Loop condition: i < count
        self.builder.position_at_end(loop_bb);
        let i_val = self
            .builder
            .build_load(i64_type, i_alloca, "i")
            .unwrap()
            .into_int_value();
        let cond = self
            .builder
            .build_int_compare(IntPredicate::SLT, i_val, count, "cmp")
            .unwrap();
        self.builder
            .build_conditional_branch(cond, body_bb, done_bb)
            .unwrap();

        // Loop body
        self.builder.position_at_end(body_bb);
        let i_val = self
            .builder
            .build_load(i64_type, i_alloca, "i")
            .unwrap()
            .into_int_value();

        // If i > 0, write ','
        let comma_bb = self.context.append_basic_block(function, "comma");
        let no_comma_bb = self.context.append_basic_block(function, "no_comma");
        let after_comma_bb = self.context.append_basic_block(function, "after_comma");
        let is_first = self
            .builder
            .build_int_compare(IntPredicate::EQ, i_val, i64_type.const_zero(), "first")
            .unwrap();
        self.builder
            .build_conditional_branch(is_first, no_comma_bb, comma_bb)
            .unwrap();

        self.builder.position_at_end(comma_bb);
        self.buf_write_literal(buf, buf_size, offset_alloca, ",");
        self.builder
            .build_unconditional_branch(after_comma_bb)
            .unwrap();

        self.builder.position_at_end(no_comma_bb);
        self.builder
            .build_unconditional_branch(after_comma_bb)
            .unwrap();

        self.builder.position_at_end(after_comma_bb);

        // Load struct element at data[i]
        let elem_ptr = unsafe {
            self.builder
                .build_gep(struct_type, data_ptr, &[i_val], "elem_ptr")
                .unwrap()
        };
        let elem_basic_type: BasicTypeEnum = struct_type.into();
        let elem = self
            .builder
            .build_load(elem_basic_type, elem_ptr, "elem")
            .unwrap();

        // Write '{' and each field
        self.buf_write_literal(buf, buf_size, offset_alloca, "{");

        for (fi, (field_name, field_type)) in fields.iter().enumerate() {
            let comma_str = if fi > 0 { "," } else { "" };
            let field_val = self
                .builder
                .build_extract_value(elem.into_struct_value(), fi as u32, field_name)
                .unwrap();

            match field_type {
                Type::String => {
                    let prefix = format!("{}\"{}\":\"", comma_str, field_name);
                    self.buf_write_literal(buf, buf_size, offset_alloca, &prefix);

                    // Write string value via forge_write_cstring
                    let str_struct = field_val.into_struct_value();
                    let str_ptr = self
                        .builder
                        .build_extract_value(str_struct, 0, "str_ptr")
                        .unwrap();
                    let str_len = self
                        .builder
                        .build_extract_value(str_struct, 1, "str_len")
                        .unwrap();

                    let offset = self
                        .builder
                        .build_load(i64_type, offset_alloca, "off")
                        .unwrap()
                        .into_int_value();
                    let remaining = self
                        .builder
                        .build_int_sub(buf_size, offset, "rem")
                        .unwrap();
                    let buf_off = unsafe {
                        self.builder
                            .build_gep(i8_type, buf, &[offset], "off")
                            .unwrap()
                    };
                    let write_fn = self.module.get_function("forge_write_cstring").unwrap();
                    self.builder
                        .build_call(
                            write_fn,
                            &[buf_off.into(), remaining.into(), str_ptr.into(), str_len.into()],
                            "",
                        )
                        .unwrap();
                    let new_off = self
                        .builder
                        .build_int_add(offset, str_len.into_int_value(), "off")
                        .unwrap();
                    self.builder.build_store(offset_alloca, new_off).unwrap();

                    self.buf_write_literal(buf, buf_size, offset_alloca, "\"");
                }
                Type::Int => {
                    let fmt = format!("{}\"{}\":%lld", comma_str, field_name);
                    self.buf_write_formatted(buf, buf_size, offset_alloca, &fmt, &[field_val.into()]);
                }
                Type::Float => {
                    let fmt = format!("{}\"{}\":%f", comma_str, field_name);
                    self.buf_write_formatted(buf, buf_size, offset_alloca, &fmt, &[field_val.into()]);
                }
                Type::Bool => {
                    let fmt = format!("{}\"{}\":%d", comma_str, field_name);
                    let int_val = self
                        .builder
                        .build_int_z_extend(
                            field_val.into_int_value(),
                            self.context.i32_type(),
                            "bool_i32",
                        )
                        .unwrap();
                    self.buf_write_formatted(buf, buf_size, offset_alloca, &fmt, &[int_val.into()]);
                }
                _ => {}
            }
        }

        // Write '}'
        self.buf_write_literal(buf, buf_size, offset_alloca, "}");

        // i++
        let next_i = self
            .builder
            .build_int_add(i_val, i64_type.const_int(1, false), "next_i")
            .unwrap();
        self.builder.build_store(i_alloca, next_i).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        // Done — write ']'
        self.builder.position_at_end(done_bb);
        self.buf_write_literal(buf, buf_size, offset_alloca, "]");

        // Build ForgeString from buffer
        let final_offset = self
            .builder
            .build_load(i64_type, offset_alloca, "final_off")
            .unwrap();
        let string_new = self.module.get_function("forge_string_new").unwrap();
        let result = self
            .builder
            .build_call(string_new, &[buf.into(), final_offset.into()], "json_str")
            .unwrap();
        result.try_as_basic_value().left()
    }

    /// Serialize a nullable struct to JSON. Returns "null" if null, or the struct JSON if present.
    /// Nullable layout: {i8 flag, field1, field2, ...} where flag 0 = null, 1 = some.
    pub(crate) fn compile_json_stringify_nullable_struct(
        &mut self,
        val: BasicValueEnum<'ctx>,
        fields: &[(String, Type)],
    ) -> Option<BasicValueEnum<'ctx>> {
        let nullable_struct = val.into_struct_value();

        // Extract null flag (field 0)
        let flag = self
            .builder
            .build_extract_value(nullable_struct, 0, "null_flag")
            .unwrap()
            .into_int_value();
        let is_null = self
            .builder
            .build_int_compare(
                IntPredicate::EQ,
                flag,
                self.context.i8_type().const_zero(),
                "is_null",
            )
            .unwrap();

        let function = self
            .builder
            .get_insert_block()
            .unwrap()
            .get_parent()
            .unwrap();
        let null_bb = self.context.append_basic_block(function, "null_case");
        let some_bb = self.context.append_basic_block(function, "some_case");
        let merge_bb = self.context.append_basic_block(function, "merge");

        self.builder
            .build_conditional_branch(is_null, null_bb, some_bb)
            .unwrap();

        // Null case: return "null" string
        self.builder.position_at_end(null_bb);
        let null_str = self
            .builder
            .build_global_string_ptr("null", "null_str")
            .unwrap();
        let string_new = self.module.get_function("forge_string_new").unwrap();
        let null_result = self
            .builder
            .build_call(
                string_new,
                &[
                    null_str.as_pointer_value().into(),
                    self.context.i64_type().const_int(4, false).into(),
                ],
                "null_json",
            )
            .unwrap()
            .try_as_basic_value()
            .left()
            .unwrap();
        self.builder.build_unconditional_branch(merge_bb).unwrap();
        let null_bb_end = self.builder.get_insert_block().unwrap();

        // Some case: extract inner struct (field 1 of nullable) and stringify
        self.builder.position_at_end(some_bb);
        // Nullable layout is {i8, inner_type} — field 1 is the whole inner struct
        let inner_val = self
            .builder
            .build_extract_value(nullable_struct, 1, "inner")
            .unwrap();
        let some_result = self
            .compile_json_stringify_struct(inner_val, fields)
            .unwrap();
        self.builder.build_unconditional_branch(merge_bb).unwrap();
        let some_bb_end = self.builder.get_insert_block().unwrap();

        // Merge: phi between null and some results
        self.builder.position_at_end(merge_bb);
        let phi = self
            .builder
            .build_phi(null_result.get_type(), "json_result")
            .unwrap();
        phi.add_incoming(&[(&null_result, null_bb_end), (&some_result, some_bb_end)]);

        Some(phi.as_basic_value())
    }

    /// Write a literal string into a buffer at the current offset (stored via alloca).
    fn buf_write_literal(
        &mut self,
        buf: PointerValue<'ctx>,
        buf_size: IntValue<'ctx>,
        offset_alloca: PointerValue<'ctx>,
        literal: &str,
    ) {
        let i64_type = self.context.i64_type();
        let i8_type = self.context.i8_type();
        let snprintf = self.module.get_function("snprintf").unwrap();
        let fmt_s = self
            .builder
            .build_global_string_ptr("%s", "fmt_s")
            .unwrap();
        let str_val = self
            .builder
            .build_global_string_ptr(literal, "lit")
            .unwrap();

        let offset = self
            .builder
            .build_load(i64_type, offset_alloca, "off")
            .unwrap()
            .into_int_value();
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
                    str_val.as_pointer_value().into(),
                ],
                "wrote",
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
        let new_off = self
            .builder
            .build_int_add(offset, w64, "off")
            .unwrap();
        self.builder.build_store(offset_alloca, new_off).unwrap();
    }

    /// Write a formatted value into a buffer at the current offset (stored via alloca).
    fn buf_write_formatted(
        &mut self,
        buf: PointerValue<'ctx>,
        buf_size: IntValue<'ctx>,
        offset_alloca: PointerValue<'ctx>,
        fmt: &str,
        args: &[BasicMetadataValueEnum<'ctx>],
    ) {
        let i64_type = self.context.i64_type();
        let i8_type = self.context.i8_type();
        let snprintf = self.module.get_function("snprintf").unwrap();
        let fmt_str = self
            .builder
            .build_global_string_ptr(fmt, "fmt")
            .unwrap();

        let offset = self
            .builder
            .build_load(i64_type, offset_alloca, "off")
            .unwrap()
            .into_int_value();
        let remaining = self
            .builder
            .build_int_sub(buf_size, offset, "rem")
            .unwrap();
        let buf_off = unsafe {
            self.builder
                .build_gep(i8_type, buf, &[offset], "off")
                .unwrap()
        };

        let mut call_args: Vec<BasicMetadataValueEnum<'ctx>> = vec![
            buf_off.into(),
            remaining.into(),
            fmt_str.as_pointer_value().into(),
        ];
        call_args.extend_from_slice(args);

        let wrote = self
            .builder
            .build_call(snprintf, &call_args, "wrote")
            .unwrap()
            .try_as_basic_value()
            .left()
            .unwrap()
            .into_int_value();
        let w64 = self
            .builder
            .build_int_z_extend(wrote, i64_type, "w64")
            .unwrap();
        let new_off = self
            .builder
            .build_int_add(offset, w64, "off")
            .unwrap();
        self.builder.build_store(offset_alloca, new_off).unwrap();
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
        if self.module.get_function("forge_json_get_object").is_none() {
            let ft = ptr_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], false);
            self.module.add_function("forge_json_get_object", ft, None);
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
