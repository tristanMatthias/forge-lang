use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn build_string_literal(&mut self, s: &str) -> BasicValueEnum<'ctx> {
        let string_new = self.module.get_function("forge_string_new").unwrap();
        let str_val = self.builder.build_global_string_ptr(s, "str").unwrap();
        let len = self.context.i64_type().const_int(s.len() as u64, false);
        let result = self.builder.build_call(
            string_new,
            &[str_val.as_pointer_value().into(), len.into()],
            "str",
        ).unwrap();
        result.try_as_basic_value().left().unwrap()
    }

    pub(crate) fn compile_struct_lit(
        &mut self,
        fields: &[(String, Expr)],
    ) -> Option<BasicValueEnum<'ctx>> {
        // If we have a target type with more fields (e.g., partial structs),
        // build the struct according to the target type, filling missing nullable fields with null
        if let Some(Type::Struct { fields: target_fields, .. }) = &self.struct_target_type.clone() {
            if target_fields.len() > fields.len() {
                let provided: std::collections::HashMap<&str, &Expr> =
                    fields.iter().map(|(n, e)| (n.as_str(), e)).collect();

                let mut all_field_types = Vec::new();
                let mut all_field_vals = Vec::new();

                for (fname, ftype) in target_fields {
                    if let Some(expr) = provided.get(fname.as_str()) {
                        let val = self.compile_expr(expr)?;
                        let ty = self.infer_type(expr);
                        // Wrap in nullable if target is nullable but value isn't
                        if matches!(ftype, Type::Nullable(_)) && !matches!(&ty, Type::Nullable(_)) {
                            let inner_llvm = self.type_to_llvm_basic(&ty);
                            let nullable_type = self.context.struct_type(
                                &[self.context.i8_type().into(), inner_llvm.into()],
                                false,
                            );
                            let mut nullable_val = nullable_type.get_undef();
                            nullable_val = self.builder
                                .build_insert_value(nullable_val, self.context.i8_type().const_int(1, false), 0, "has")
                                .unwrap().into_struct_value();
                            nullable_val = self.builder
                                .build_insert_value(nullable_val, val, 1, "val")
                                .unwrap().into_struct_value();
                            all_field_types.push(self.type_to_llvm_basic(ftype));
                            all_field_vals.push(nullable_val.into());
                        } else {
                            all_field_types.push(self.type_to_llvm_basic(&ty));
                            all_field_vals.push(val);
                        }
                    } else {
                        // Missing field — must be nullable, fill with null (tag=0)
                        let llvm_ty = self.type_to_llvm_basic(ftype);
                        let null_val = llvm_ty.into_struct_type().const_zero();
                        all_field_types.push(llvm_ty);
                        all_field_vals.push(null_val.into());
                    }
                }

                let struct_type = self.context.struct_type(
                    &all_field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                    false,
                );
                let mut struct_val = struct_type.get_undef();
                for (i, val) in all_field_vals.iter().enumerate() {
                    struct_val = self.builder
                        .build_insert_value(struct_val, *val, i as u32, "field")
                        .unwrap()
                        .into_struct_value();
                }
                return Some(struct_val.into());
            }
        }

        let mut field_types = Vec::new();
        let mut field_vals = Vec::new();
        let mut type_fields = Vec::new();

        for (name, expr) in fields {
            let val = self.compile_expr(expr)?;
            let ty = self.infer_type(expr);
            field_types.push(self.type_to_llvm_basic(&ty));
            field_vals.push(val);
            type_fields.push((name.clone(), ty));
        }

        let struct_type = self.context.struct_type(
            &field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
            false,
        );

        let mut struct_val = struct_type.get_undef();
        for (i, val) in field_vals.iter().enumerate() {
            struct_val = self.builder
                .build_insert_value(struct_val, *val, i as u32, "field")
                .unwrap()
                .into_struct_value();
        }

        Some(struct_val.into())
    }

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

    pub(crate) fn compile_list_lit(
        &mut self,
        elements: &[Expr],
    ) -> Option<BasicValueEnum<'ctx>> {
        if elements.is_empty() {
            // Empty list: {null, 0}
            let list_type = self.context.struct_type(
                &[
                    self.context.ptr_type(AddressSpace::default()).into(),
                    self.context.i64_type().into(),
                ],
                false,
            );
            let mut list_val = list_type.get_undef();
            list_val = self.builder
                .build_insert_value(
                    list_val,
                    self.context.ptr_type(AddressSpace::default()).const_null(),
                    0,
                    "null_ptr",
                )
                .unwrap()
                .into_struct_value();
            list_val = self.builder
                .build_insert_value(
                    list_val,
                    self.context.i64_type().const_zero(),
                    1,
                    "zero_len",
                )
                .unwrap()
                .into_struct_value();
            return Some(list_val.into());
        }

        // Compile all elements
        let mut elem_vals = Vec::new();
        let mut elem_type = Type::Unknown;
        for expr in elements {
            let val = self.compile_expr(expr)?;
            if elem_type == Type::Unknown {
                elem_type = self.infer_type(expr);
            }
            elem_vals.push(val);
        }

        let elem_llvm_ty = self.type_to_llvm_basic(&elem_type);
        let count = elem_vals.len() as u64;

        // Allocate memory: forge_alloc(count * sizeof(elem))
        let elem_size = elem_llvm_ty.size_of().unwrap();
        let total_size = self.builder
            .build_int_mul(
                elem_size,
                self.context.i64_type().const_int(count, false),
                "total_size",
            )
            .unwrap();

        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let data_ptr = self.builder
            .build_call(alloc_fn, &[total_size.into()], "list_data")
            .unwrap()
            .try_as_basic_value()
            .left()?
            .into_pointer_value();

        // Store each element
        for (i, val) in elem_vals.iter().enumerate() {
            let idx = self.context.i64_type().const_int(i as u64, false);
            let elem_ptr = unsafe {
                self.builder.build_gep(
                    elem_llvm_ty,
                    data_ptr,
                    &[idx],
                    &format!("elem_{}_ptr", i),
                ).unwrap()
            };
            self.builder.build_store(elem_ptr, *val).unwrap();
        }

        // Build list struct {ptr, len}
        let list_type = self.context.struct_type(
            &[
                self.context.ptr_type(AddressSpace::default()).into(),
                self.context.i64_type().into(),
            ],
            false,
        );
        let mut list_val = list_type.get_undef();
        list_val = self.builder
            .build_insert_value(list_val, data_ptr, 0, "list_ptr")
            .unwrap()
            .into_struct_value();
        list_val = self.builder
            .build_insert_value(
                list_val,
                self.context.i64_type().const_int(count, false),
                1,
                "list_len",
            )
            .unwrap()
            .into_struct_value();

        Some(list_val.into())
    }

    pub(crate) fn compile_enum_constructor(
        &mut self,
        _enum_name: &str,
        variant_name: &str,
        args: &[CallArg],
        variants: &[crate::typeck::types::EnumVariantType],
    ) -> Option<BasicValueEnum<'ctx>> {
        let variant_idx = variants.iter().position(|v| v.name == variant_name)?;

        // Use the canonical enum LLVM type (same for all variants)
        let enum_type = Type::Enum {
            name: _enum_name.to_string(),
            variants: variants.to_vec(),
        };
        let enum_llvm_type = self.type_to_llvm_basic(&enum_type);
        let enum_struct_type = enum_llvm_type.into_struct_type();

        let mut struct_val = enum_struct_type.const_zero();

        // Set tag
        struct_val = self.builder
            .build_insert_value(
                struct_val,
                self.context.i8_type().const_int(variant_idx as u64, false),
                0,
                "tag",
            )
            .unwrap()
            .into_struct_value();

        // Set fields
        for (i, arg) in args.iter().enumerate() {
            if let Some(val) = self.compile_expr(&arg.value) {
                struct_val = self.builder
                    .build_insert_value(struct_val, val, (i + 1) as u32, "field")
                    .unwrap()
                    .into_struct_value();
            }
        }

        Some(struct_val.into())
    }

    pub(crate) fn compile_map_lit(&mut self, entries: &[(Expr, Expr)]) -> Option<BasicValueEnum<'ctx>> {
        if entries.is_empty() {
            let map_type = self.context.struct_type(
                &[
                    self.context.ptr_type(AddressSpace::default()).into(),
                    self.context.ptr_type(AddressSpace::default()).into(),
                    self.context.i64_type().into(),
                ],
                false,
            );
            return Some(map_type.const_zero().into());
        }

        let count = entries.len() as u64;

        // Infer key and value types
        let key_type = self.infer_type(&entries[0].0);
        let val_type = self.infer_type(&entries[0].1);
        let key_llvm_ty = self.type_to_llvm_basic(&key_type);
        let val_llvm_ty = self.type_to_llvm_basic(&val_type);

        let alloc_fn = self.module.get_function("forge_alloc").unwrap();

        // Allocate keys array
        let key_size = key_llvm_ty.size_of().unwrap();
        let keys_total = self.builder.build_int_mul(
            key_size,
            self.context.i64_type().const_int(count, false),
            "keys_total",
        ).unwrap();
        let keys_ptr = self.builder.build_call(alloc_fn, &[keys_total.into()], "keys_ptr").unwrap()
            .try_as_basic_value().left()?.into_pointer_value();

        // Allocate values array
        let val_size = val_llvm_ty.size_of().unwrap();
        let vals_total = self.builder.build_int_mul(
            val_size,
            self.context.i64_type().const_int(count, false),
            "vals_total",
        ).unwrap();
        let vals_ptr = self.builder.build_call(alloc_fn, &[vals_total.into()], "vals_ptr").unwrap()
            .try_as_basic_value().left()?.into_pointer_value();

        // Store entries
        for (i, (key_expr, val_expr)) in entries.iter().enumerate() {
            let key_val = self.compile_expr(key_expr)?;
            let val_val = self.compile_expr(val_expr)?;

            let idx = self.context.i64_type().const_int(i as u64, false);
            let kp = unsafe { self.builder.build_gep(key_llvm_ty, keys_ptr, &[idx], "kp").unwrap() };
            self.builder.build_store(kp, key_val).unwrap();

            let vp = unsafe { self.builder.build_gep(val_llvm_ty, vals_ptr, &[idx], "vp").unwrap() };
            self.builder.build_store(vp, val_val).unwrap();
        }

        // Build map struct {keys_ptr, vals_ptr, length}
        let map_struct_ty = self.context.struct_type(
            &[
                self.context.ptr_type(AddressSpace::default()).into(),
                self.context.ptr_type(AddressSpace::default()).into(),
                self.context.i64_type().into(),
            ],
            false,
        );
        let mut map_val = map_struct_ty.get_undef();
        map_val = self.builder.build_insert_value(map_val, keys_ptr, 0, "mp_keys").unwrap().into_struct_value();
        map_val = self.builder.build_insert_value(map_val, vals_ptr, 1, "mp_vals").unwrap().into_struct_value();
        map_val = self.builder.build_insert_value(map_val, self.context.i64_type().const_int(count, false), 2, "mp_len").unwrap().into_struct_value();

        Some(map_val.into())
    }
}
