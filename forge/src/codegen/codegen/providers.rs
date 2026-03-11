use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn register_model(&mut self, name: &str, fields: &[ModelField]) {
        self.uses_model = true;

        // Build the Forge Type for this model
        let mut type_fields = Vec::new();
        let mut create_fields = Vec::new();
        let mut sql_types = Vec::new();

        for field in fields {
            let ty = self.type_checker.resolve_type_expr(&field.type_ann);
            type_fields.push((field.name.clone(), ty));

            let sql_type = match &field.type_ann {
                TypeExpr::Named(t) => match t.as_str() {
                    "int" => "INTEGER",
                    "float" => "REAL",
                    "bool" => "INTEGER",
                    "string" => "TEXT",
                    _ => "TEXT",
                },
                _ => "TEXT",
            };
            sql_types.push((field.name.clone(), sql_type.to_string()));

            let is_auto = field.annotations.iter().any(|a| a.name == "auto_increment");
            if !is_auto {
                create_fields.push(field.clone());
            }
        }

        // Register as named type
        let model_type = Type::Struct {
            name: Some(name.to_string()),
            fields: type_fields,
        };
        self.named_types.insert(name.to_string(), model_type);

        self.models.insert(name.to_string(), ModelInfo {
            name: name.to_string(),
            fields: fields.to_vec(),
            create_fields,
            sql_types,
        });
    }

    /// Generate CREATE TABLE SQL for a model
    pub(crate) fn model_create_table_sql(model: &ModelInfo) -> String {
        let mut cols = Vec::new();
        for field in &model.fields {
            let sql_type = model.sql_types.iter()
                .find(|(n, _)| n == &field.name)
                .map(|(_, t)| t.as_str())
                .unwrap_or("TEXT");

            let mut col = format!("{} {}", field.name, sql_type);

            for ann in &field.annotations {
                match ann.name.as_str() {
                    "primary" => col.push_str(" PRIMARY KEY"),
                    "auto_increment" => col.push_str(" AUTOINCREMENT"),
                    "unique" => col.push_str(" UNIQUE"),
                    "default" => {
                        if let Some(arg) = ann.args.first() {
                            match arg {
                                Expr::BoolLit(b, _) => col.push_str(&format!(" DEFAULT {}", if *b { 1 } else { 0 })),
                                Expr::IntLit(n, _) => col.push_str(&format!(" DEFAULT {}", n)),
                                Expr::StringLit(s, _) => col.push_str(&format!(" DEFAULT '{}'", s)),
                                _ => {}
                            }
                        }
                    }
                    _ => {}
                }
            }

            cols.push(col);
        }

        format!("CREATE TABLE IF NOT EXISTS {} ({})", model.name, cols.join(", "))
    }

    /// Compile declarations for all provider statements
    pub(crate) fn compile_provider_declarations(&mut self) {
        if !self.uses_model && !self.uses_http {
            return;
        }
        self.declare_provider_functions();
    }

    /// Emit provider init code at the start of main()
    pub(crate) fn emit_provider_init(&mut self) {
        if !self.uses_model {
            return;
        }

        // Call forge_model_init(":memory:")
        let init_fn = self.module.get_function("forge_model_init").unwrap();
        let db_path = self.builder.build_global_string_ptr(":memory:", "db_path").unwrap();
        self.builder.build_call(init_fn, &[db_path.as_pointer_value().into()], "").unwrap();

        // Execute CREATE TABLE for each model
        let exec_fn = self.module.get_function("forge_model_exec").unwrap();
        let models: Vec<ModelInfo> = self.models.values().cloned().collect();
        for model in &models {
            let sql = Self::model_create_table_sql(model);
            let sql_str = self.builder.build_global_string_ptr(&sql, "create_table_sql").unwrap();
            self.builder.build_call(exec_fn, &[sql_str.as_pointer_value().into()], "").unwrap();
        }
    }

    /// Emit server start code at the end of main() (before return)
    pub(crate) fn emit_server_start(&mut self) {
        if self.servers.is_empty() {
            return;
        }

        let servers = self.servers.clone();
        for server in &servers {
            // Register routes
            for child in &server.children {
                match child {
                    ServerChild::Route { method, path, handler, .. } => {
                        self.emit_http_route(method, path, handler);
                    }
                    ServerChild::Mount { service, path, .. } => {
                        self.emit_http_mount(service, path);
                    }
                }
            }

            // Call forge_http_serve(port)
            let serve_fn = self.module.get_function("forge_http_serve").unwrap();
            let port_val = self.context.i16_type().const_int(server.port as u64, false);
            self.builder.build_call(serve_fn, &[port_val.into()], "").unwrap();
        }
    }

    /// Emit a single HTTP route handler
    pub(crate) fn emit_http_route(&mut self, method: &str, path: &str, handler: &Expr) {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        // Generate a unique handler function name
        let handler_name = format!("__http_handler_{}_{}",
            method.to_lowercase(),
            path.replace('/', "_").replace(':', "p_")
        );

        // Create the handler function with the C ABI signature
        // int64_t handler(method, path, body, params_json, response_buf, response_buf_len)
        let handler_fn_type = i64_type.fn_type(
            &[ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), i64_type.into()],
            false,
        );
        let handler_fn = self.module.add_function(&handler_name, handler_fn_type, None);

        // Save current position
        let saved_block = self.builder.get_insert_block();

        // Build handler function body
        let entry = self.context.append_basic_block(handler_fn, "entry");
        self.builder.position_at_end(entry);
        self.push_scope();

        // Get params: method_ptr, path_ptr, body_ptr, params_json_ptr, response_buf, response_buf_len
        let _method_param = handler_fn.get_nth_param(0).unwrap().into_pointer_value();
        let _path_param = handler_fn.get_nth_param(1).unwrap().into_pointer_value();
        let _body_param = handler_fn.get_nth_param(2).unwrap().into_pointer_value();
        let params_json = handler_fn.get_nth_param(3).unwrap().into_pointer_value();
        let response_buf = handler_fn.get_nth_param(4).unwrap().into_pointer_value();
        let response_buf_len = handler_fn.get_nth_param(5).unwrap().into_int_value();

        // Check if handler is a closure with req param
        let json_val = match handler {
            Expr::Closure { params, body, .. } => {
                // Create a "req" object with params.get method support
                // For now, bind the params as a special variable
                if let Some(req_param) = params.first() {
                    // Store params_json pointer as a variable
                    let alloca = self.builder.build_alloca(ptr_type, "req_params_json").unwrap();
                    self.builder.build_store(alloca, params_json).unwrap();
                    // We'll use a special naming convention to detect req.params.get calls
                    self.define_var(format!("__req_params_json"), alloca, Type::String);
                }
                self.compile_expr(body)
            }
            _ => {
                // Direct struct literal expression
                self.compile_expr(handler)
            }
        };

        // Serialize the result struct to JSON into response_buf
        if let Some(val) = json_val {
            self.emit_struct_to_json(val, handler, response_buf, response_buf_len);
        }

        // Return 200
        self.builder.build_return(Some(&i64_type.const_int(200, false))).unwrap();
        self.pop_scope();

        // Restore position
        if let Some(block) = saved_block {
            self.builder.position_at_end(block);
        }

        // Register the route
        let add_route_fn = self.module.get_function("forge_http_add_route").unwrap();
        let method_str = self.builder.build_global_string_ptr(method, "http_method").unwrap();
        let path_str = self.builder.build_global_string_ptr(path, "http_path").unwrap();
        self.builder.build_call(
            add_route_fn,
            &[method_str.as_pointer_value().into(), path_str.as_pointer_value().into(), handler_fn.as_global_value().as_pointer_value().into()],
            "",
        ).unwrap();
    }

    /// Serialize a struct value to JSON in a response buffer
    pub(crate) fn emit_struct_to_json(
        &mut self,
        val: BasicValueEnum<'ctx>,
        expr: &Expr,
        buf: PointerValue<'ctx>,
        buf_len: IntValue<'ctx>,
    ) {
        let snprintf = self.module.get_function("snprintf").unwrap();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        // Get field info from the expression
        let fields: Vec<(String, Type)> = match expr {
            Expr::StructLit { fields, .. } => {
                fields.iter().map(|(name, e)| (name.clone(), self.infer_type(e))).collect()
            }
            Expr::Closure { body, .. } => {
                // The body should be a struct or block ending in struct
                match body.as_ref() {
                    Expr::StructLit { fields, .. } => {
                        fields.iter().map(|(name, e)| (name.clone(), self.infer_type(e))).collect()
                    }
                    Expr::Block(block) => {
                        if let Some(Statement::Expr(Expr::StructLit { fields, .. })) = block.statements.last() {
                            fields.iter().map(|(name, e)| (name.clone(), self.infer_type(e))).collect()
                        } else {
                            Vec::new()
                        }
                    }
                    _ => Vec::new(),
                }
            }
            _ => Vec::new(),
        };

        if fields.is_empty() {
            // Just write empty JSON
            let empty = self.builder.build_global_string_ptr("{}", "empty_json").unwrap();
            let fmt = self.builder.build_global_string_ptr("%s", "fmt_s").unwrap();
            self.builder.build_call(
                snprintf,
                &[buf.into(), buf_len.into(), fmt.as_pointer_value().into(), empty.as_pointer_value().into()],
                "",
            ).unwrap();
            return;
        }

        // Build JSON string manually using snprintf
        // Start with "{"
        let mut offset = self.context.i64_type().const_zero();
        let open_brace = self.builder.build_global_string_ptr("{", "open").unwrap();
        let fmt_s = self.builder.build_global_string_ptr("%s", "fmt_s").unwrap();

        let remaining = self.builder.build_int_sub(buf_len, offset, "rem").unwrap();
        let buf_offset = unsafe { self.builder.build_gep(self.context.i8_type(), buf, &[offset], "buf_off").unwrap() };
        let wrote = self.builder.build_call(
            snprintf,
            &[buf_offset.into(), remaining.into(), fmt_s.as_pointer_value().into(), open_brace.as_pointer_value().into()],
            "wrote",
        ).unwrap().try_as_basic_value().left().unwrap().into_int_value();
        let wrote_i64 = self.builder.build_int_z_extend(wrote, self.context.i64_type(), "w64").unwrap();
        offset = self.builder.build_int_add(offset, wrote_i64, "off").unwrap();

        let struct_val = if val.is_struct_value() { val.into_struct_value() } else { return; };

        for (i, (field_name, field_type)) in fields.iter().enumerate() {
            let comma = if i > 0 { "," } else { "" };

            let field_val = self.builder.build_extract_value(struct_val, i as u32, &field_name).unwrap();

            match field_type {
                Type::String => {
                    // "key":"value"
                    let fmt = format!("{}\"{}\":\"", comma, field_name);
                    let fmt_str = self.builder.build_global_string_ptr(&fmt, "kv_fmt").unwrap();
                    let remaining = self.builder.build_int_sub(buf_len, offset, "rem").unwrap();
                    let buf_off = unsafe { self.builder.build_gep(self.context.i8_type(), buf, &[offset], "off").unwrap() };
                    let wrote = self.builder.build_call(
                        snprintf,
                        &[buf_off.into(), remaining.into(), fmt_s.as_pointer_value().into(), fmt_str.as_pointer_value().into()],
                        "w",
                    ).unwrap().try_as_basic_value().left().unwrap().into_int_value();
                    let w64 = self.builder.build_int_z_extend(wrote, self.context.i64_type(), "w").unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();

                    // Copy string value
                    let str_val = field_val.into_struct_value();
                    let str_ptr = self.builder.build_extract_value(str_val, 0, "sp").unwrap().into_pointer_value();
                    let str_len = self.builder.build_extract_value(str_val, 1, "sl").unwrap().into_int_value();
                    let write_fn = self.module.get_function("forge_write_cstring").unwrap();
                    let remaining = self.builder.build_int_sub(buf_len, offset, "rem").unwrap();
                    let buf_off = unsafe { self.builder.build_gep(self.context.i8_type(), buf, &[offset], "off").unwrap() };
                    self.builder.build_call(write_fn, &[buf_off.into(), remaining.into(), str_ptr.into(), str_len.into()], "").unwrap();
                    offset = self.builder.build_int_add(offset, str_len, "off").unwrap();

                    // Close quote
                    let close = self.builder.build_global_string_ptr("\"", "cq").unwrap();
                    let remaining = self.builder.build_int_sub(buf_len, offset, "rem").unwrap();
                    let buf_off = unsafe { self.builder.build_gep(self.context.i8_type(), buf, &[offset], "off").unwrap() };
                    let wrote = self.builder.build_call(
                        snprintf,
                        &[buf_off.into(), remaining.into(), fmt_s.as_pointer_value().into(), close.as_pointer_value().into()],
                        "w",
                    ).unwrap().try_as_basic_value().left().unwrap().into_int_value();
                    let w64 = self.builder.build_int_z_extend(wrote, self.context.i64_type(), "w").unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();
                }
                Type::Int => {
                    let fmt = format!("{}\"{}\":%lld", comma, field_name);
                    let fmt_str = self.builder.build_global_string_ptr(&fmt, "kv_fmt").unwrap();
                    let remaining = self.builder.build_int_sub(buf_len, offset, "rem").unwrap();
                    let buf_off = unsafe { self.builder.build_gep(self.context.i8_type(), buf, &[offset], "off").unwrap() };
                    let wrote = self.builder.build_call(
                        snprintf,
                        &[buf_off.into(), remaining.into(), fmt_str.as_pointer_value().into(), field_val.into()],
                        "w",
                    ).unwrap().try_as_basic_value().left().unwrap().into_int_value();
                    let w64 = self.builder.build_int_z_extend(wrote, self.context.i64_type(), "w").unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();
                }
                Type::Bool => {
                    let fmt = format!("{}\"{}\":%s", comma, field_name);
                    let fmt_str = self.builder.build_global_string_ptr(&fmt, "kv_fmt").unwrap();
                    // Convert bool to "true"/"false"
                    let cond = self.builder.build_int_compare(
                        IntPredicate::NE,
                        field_val.into_int_value(),
                        self.context.i8_type().const_zero(),
                        "bool_cond",
                    ).unwrap();
                    let true_str = self.builder.build_global_string_ptr("true", "true_s").unwrap();
                    let false_str = self.builder.build_global_string_ptr("false", "false_s").unwrap();
                    let str_val = self.builder.build_select(cond, true_str.as_pointer_value(), false_str.as_pointer_value(), "bool_str").unwrap();
                    let remaining = self.builder.build_int_sub(buf_len, offset, "rem").unwrap();
                    let buf_off = unsafe { self.builder.build_gep(self.context.i8_type(), buf, &[offset], "off").unwrap() };
                    let wrote = self.builder.build_call(
                        snprintf,
                        &[buf_off.into(), remaining.into(), fmt_str.as_pointer_value().into(), str_val.into()],
                        "w",
                    ).unwrap().try_as_basic_value().left().unwrap().into_int_value();
                    let w64 = self.builder.build_int_z_extend(wrote, self.context.i64_type(), "w").unwrap();
                    offset = self.builder.build_int_add(offset, w64, "off").unwrap();
                }
                _ => {}
            }
        }

        // Close with "}"
        let close_brace = self.builder.build_global_string_ptr("}", "close").unwrap();
        let remaining = self.builder.build_int_sub(buf_len, offset, "rem").unwrap();
        let buf_off = unsafe { self.builder.build_gep(self.context.i8_type(), buf, &[offset], "off").unwrap() };
        self.builder.build_call(
            snprintf,
            &[buf_off.into(), remaining.into(), fmt_s.as_pointer_value().into(), close_brace.as_pointer_value().into()],
            "",
        ).unwrap();
    }

    /// Emit mount for a service at a path (generates CRUD endpoints)
    pub(crate) fn emit_http_mount(&mut self, _service_name: &str, _base_path: &str) {
        let svc_info = self.services.get(_service_name).cloned();
        if svc_info.is_none() { return; }
        let svc = svc_info.unwrap();
        let model_info = self.models.get(&svc.for_model).cloned();
        if model_info.is_none() { return; }
        let model = model_info.unwrap();

        // Generate list endpoint
        self.emit_http_mount_list(&model, _base_path);
        // Generate create endpoint
        self.emit_http_mount_create(&model, &svc, _base_path);
        // Generate get endpoint
        self.emit_http_mount_get(&model, _base_path);
        // Generate update endpoint
        self.emit_http_mount_update(&model, _base_path);
        // Generate delete endpoint
        self.emit_http_mount_delete(&model, _base_path);
    }

    /// Get comma-separated list of boolean field names for a model
    pub(crate) fn model_bool_fields_str(model: &ModelInfo) -> String {
        model.fields.iter()
            .filter(|f| matches!(&f.type_ann, TypeExpr::Named(t) if t == "bool"))
            .map(|f| f.name.as_str())
            .collect::<Vec<_>>()
            .join(",")
    }

    pub(crate) fn emit_http_mount_list(&mut self, model: &ModelInfo, base_path: &str) {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let handler_name = format!("__mount_list_{}", model.name.to_lowercase());

        let handler_fn_type = i64_type.fn_type(
            &[ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), i64_type.into()],
            false,
        );
        let handler_fn = self.module.add_function(&handler_name, handler_fn_type, None);

        let saved_block = self.builder.get_insert_block();
        let entry = self.context.append_basic_block(handler_fn, "entry");
        self.builder.position_at_end(entry);

        // Query all records
        let query_fn = self.module.get_function("forge_model_query").unwrap();
        let sql = format!("SELECT * FROM {}", model.name);
        let sql_str = self.builder.build_global_string_ptr(&sql, "list_sql").unwrap();
        let null_ptr = ptr_type.const_null();
        let zero = i64_type.const_zero();
        let json_ptr = self.builder.build_call(
            query_fn,
            &[sql_str.as_pointer_value().into(), null_ptr.into(), zero.into()],
            "json",
        ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();

        // Fix boolean fields in JSON
        let response_buf = handler_fn.get_nth_param(4).unwrap().into_pointer_value();
        let response_buf_len = handler_fn.get_nth_param(5).unwrap().into_int_value();
        let bool_fields = Self::model_bool_fields_str(model);
        let snprintf = self.module.get_function("snprintf").unwrap();
        let fmt = self.builder.build_global_string_ptr("%s", "fmt").unwrap();
        if !bool_fields.is_empty() {
            let fix_bools_fn = self.module.get_function("forge_json_fix_bools").unwrap();
            let bool_fields_str = self.builder.build_global_string_ptr(&bool_fields, "bfields").unwrap();
            let fixed_json = self.builder.build_call(
                fix_bools_fn,
                &[json_ptr.into(), bool_fields_str.as_pointer_value().into()],
                "fixed",
            ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();
            self.builder.build_call(
                snprintf,
                &[response_buf.into(), response_buf_len.into(), fmt.as_pointer_value().into(), fixed_json.into()],
                "",
            ).unwrap();
            let c_free = self.module.get_function("free").unwrap();
            self.builder.build_call(c_free, &[fixed_json.into()], "").unwrap();
        } else {
            self.builder.build_call(
                snprintf,
                &[response_buf.into(), response_buf_len.into(), fmt.as_pointer_value().into(), json_ptr.into()],
                "",
            ).unwrap();
        }

        // Free the JSON string
        let free_fn = self.module.get_function("forge_model_free_string").unwrap();
        self.builder.build_call(free_fn, &[json_ptr.into()], "").unwrap();

        self.builder.build_return(Some(&i64_type.const_int(200, false))).unwrap();

        if let Some(block) = saved_block { self.builder.position_at_end(block); }

        // Register route
        let add_route_fn = self.module.get_function("forge_http_add_route").unwrap();
        let method_str = self.builder.build_global_string_ptr("GET", "get_method").unwrap();
        let path_str = self.builder.build_global_string_ptr(base_path, "list_path").unwrap();
        self.builder.build_call(
            add_route_fn,
            &[method_str.as_pointer_value().into(), path_str.as_pointer_value().into(), handler_fn.as_global_value().as_pointer_value().into()],
            "",
        ).unwrap();
    }

    pub(crate) fn emit_http_mount_create(&mut self, model: &ModelInfo, _svc: &ServiceInfo, base_path: &str) {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let handler_name = format!("__mount_create_{}", model.name.to_lowercase());

        let handler_fn_type = i64_type.fn_type(
            &[ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), i64_type.into()],
            false,
        );
        let handler_fn = self.module.add_function(&handler_name, handler_fn_type, None);

        let saved_block = self.builder.get_insert_block();
        let entry = self.context.append_basic_block(handler_fn, "entry");
        self.builder.position_at_end(entry);

        let body_ptr = handler_fn.get_nth_param(2).unwrap().into_pointer_value();
        let response_buf = handler_fn.get_nth_param(4).unwrap().into_pointer_value();
        let response_buf_len = handler_fn.get_nth_param(5).unwrap().into_int_value();

        // Extract each create field from the body JSON and build params array
        let param_count = model.create_fields.len();
        let params_array_type = ptr_type.array_type(param_count as u32);
        let params_alloca = self.builder.build_alloca(params_array_type, "params").unwrap();

        for (idx, field) in model.create_fields.iter().enumerate() {
            let field_name_str = self.builder.build_global_string_ptr(&field.name, &format!("fn_{}", field.name)).unwrap();
            let extract_fn_name = match &field.type_ann {
                TypeExpr::Named(t) => match t.as_str() {
                    "int" => "forge_body_get_int_str",
                    "bool" => "forge_body_get_bool_str",
                    _ => "forge_body_get_string",
                },
                _ => "forge_body_get_string",
            };
            let extract_fn = self.module.get_function(extract_fn_name).unwrap();
            let val_ptr = self.builder.build_call(
                extract_fn,
                &[body_ptr.into(), field_name_str.as_pointer_value().into()],
                &format!("val_{}", field.name),
            ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();

            let idx_val = self.context.i32_type().const_int(idx as u64, false);
            let elem_ptr = unsafe {
                self.builder.build_gep(params_array_type, params_alloca, &[self.context.i32_type().const_zero(), idx_val], "param_ptr").unwrap()
            };
            self.builder.build_store(elem_ptr, val_ptr).unwrap();
        }

        // Build INSERT SQL
        let field_names: Vec<&str> = model.create_fields.iter().map(|f| f.name.as_str()).collect();
        let placeholders: Vec<&str> = field_names.iter().map(|_| "?").collect();
        let sql = format!(
            "INSERT INTO {} ({}) VALUES ({})",
            model.name,
            field_names.join(", "),
            placeholders.join(", ")
        );
        let sql_str = self.builder.build_global_string_ptr(&sql, "insert_sql").unwrap();

        // Call forge_model_insert
        let insert_fn = self.module.get_function("forge_model_insert").unwrap();
        let count_val = i64_type.const_int(param_count as u64, false);
        let insert_id = self.builder.build_call(
            insert_fn,
            &[sql_str.as_pointer_value().into(), params_alloca.into(), count_val.into()],
            "insert_id",
        ).unwrap().try_as_basic_value().left().unwrap().into_int_value();

        // Free the extracted strings
        let free_fn = self.module.get_function("free").unwrap();
        for idx in 0..param_count {
            let idx_val = self.context.i32_type().const_int(idx as u64, false);
            let elem_ptr = unsafe {
                self.builder.build_gep(params_array_type, params_alloca, &[self.context.i32_type().const_zero(), idx_val], "free_ptr").unwrap()
            };
            let val = self.builder.build_load(ptr_type, elem_ptr, "v").unwrap();
            self.builder.build_call(free_fn, &[val.into()], "").unwrap();
        }

        // Now fetch the created record: SELECT * FROM Model WHERE id = ?
        let select_sql = format!("SELECT * FROM {} WHERE id = ?", model.name);
        let select_sql_str = self.builder.build_global_string_ptr(&select_sql, "sel_sql").unwrap();

        // Convert insert_id to string for query param
        let snprintf = self.module.get_function("snprintf").unwrap();
        let id_buf = self.builder.build_array_alloca(self.context.i8_type(), i64_type.const_int(32, false), "id_buf").unwrap();
        let id_fmt = self.builder.build_global_string_ptr("%lld", "id_fmt").unwrap();
        self.builder.build_call(
            snprintf,
            &[id_buf.into(), i64_type.const_int(32, false).into(), id_fmt.as_pointer_value().into(), insert_id.into()],
            "",
        ).unwrap();

        let id_param = self.builder.build_alloca(ptr_type, "id_param").unwrap();
        self.builder.build_store(id_param, id_buf).unwrap();

        let query_fn = self.module.get_function("forge_model_query").unwrap();
        let json_ptr = self.builder.build_call(
            query_fn,
            &[select_sql_str.as_pointer_value().into(), id_param.into(), i64_type.const_int(1, false).into()],
            "json",
        ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();

        // Fix boolean fields and unwrap first object from the array
        let bool_fields = Self::model_bool_fields_str(model);
        let unwrap_fn = self.module.get_function("forge_json_unwrap_first").unwrap();
        if !bool_fields.is_empty() {
            let fix_bools_fn = self.module.get_function("forge_json_fix_bools").unwrap();
            let bool_fields_str = self.builder.build_global_string_ptr(&bool_fields, "bfields").unwrap();
            let fixed_json = self.builder.build_call(
                fix_bools_fn,
                &[json_ptr.into(), bool_fields_str.as_pointer_value().into()],
                "fixed",
            ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();
            self.builder.build_call(
                unwrap_fn,
                &[fixed_json.into(), response_buf.into(), response_buf_len.into()],
                "",
            ).unwrap();
            let c_free = self.module.get_function("free").unwrap();
            self.builder.build_call(c_free, &[fixed_json.into()], "").unwrap();
        } else {
            self.builder.build_call(
                unwrap_fn,
                &[json_ptr.into(), response_buf.into(), response_buf_len.into()],
                "",
            ).unwrap();
        }

        // Free the JSON string
        let free_str_fn = self.module.get_function("forge_model_free_string").unwrap();
        self.builder.build_call(free_str_fn, &[json_ptr.into()], "").unwrap();

        self.builder.build_return(Some(&i64_type.const_int(201, false))).unwrap();

        if let Some(block) = saved_block { self.builder.position_at_end(block); }

        let add_route_fn = self.module.get_function("forge_http_add_route").unwrap();
        let method_str = self.builder.build_global_string_ptr("POST", "post_method").unwrap();
        let path_str = self.builder.build_global_string_ptr(base_path, "create_path").unwrap();
        self.builder.build_call(
            add_route_fn,
            &[method_str.as_pointer_value().into(), path_str.as_pointer_value().into(), handler_fn.as_global_value().as_pointer_value().into()],
            "",
        ).unwrap();
    }

    pub(crate) fn emit_http_mount_get(&mut self, model: &ModelInfo, base_path: &str) {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let handler_name = format!("__mount_get_{}", model.name.to_lowercase());
        let path_with_id = format!("{}/:id", base_path);

        let handler_fn_type = i64_type.fn_type(
            &[ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), i64_type.into()],
            false,
        );
        let handler_fn = self.module.add_function(&handler_name, handler_fn_type, None);

        let saved_block = self.builder.get_insert_block();
        let entry = self.context.append_basic_block(handler_fn, "entry");
        self.builder.position_at_end(entry);

        // Get id from params, query
        let params_json = handler_fn.get_nth_param(3).unwrap().into_pointer_value();
        let response_buf = handler_fn.get_nth_param(4).unwrap().into_pointer_value();
        let response_buf_len = handler_fn.get_nth_param(5).unwrap().into_int_value();

        let query_fn = self.module.get_function("forge_model_query").unwrap();
        let sql = format!("SELECT * FROM {} WHERE id = ?", model.name);
        let sql_str = self.builder.build_global_string_ptr(&sql, "get_sql").unwrap();

        // Get id param
        let params_get_fn = self.module.get_function("forge_params_get").unwrap();
        let id_key = self.builder.build_global_string_ptr("id", "id_key").unwrap();
        let id_str = self.builder.build_call(
            params_get_fn,
            &[params_json.into(), id_key.as_pointer_value().into()],
            "id_val",
        ).unwrap().try_as_basic_value().left().unwrap();

        // Build params array with id
        let param_arr = self.builder.build_alloca(ptr_type, "params").unwrap();
        let id_ptr = self.builder.build_extract_value(id_str.into_struct_value(), 0, "id_ptr").unwrap();
        self.builder.build_store(param_arr, id_ptr).unwrap();

        let json_ptr = self.builder.build_call(
            query_fn,
            &[sql_str.as_pointer_value().into(), param_arr.into(), i64_type.const_int(1, false).into()],
            "json",
        ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();

        // Fix boolean fields and unwrap first object
        let bool_fields = Self::model_bool_fields_str(model);
        let unwrap_fn = self.module.get_function("forge_json_unwrap_first").unwrap();
        if !bool_fields.is_empty() {
            let fix_bools_fn = self.module.get_function("forge_json_fix_bools").unwrap();
            let bool_fields_str = self.builder.build_global_string_ptr(&bool_fields, "bfields").unwrap();
            let fixed_json = self.builder.build_call(
                fix_bools_fn,
                &[json_ptr.into(), bool_fields_str.as_pointer_value().into()],
                "fixed",
            ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();
            self.builder.build_call(
                unwrap_fn,
                &[fixed_json.into(), response_buf.into(), response_buf_len.into()],
                "",
            ).unwrap();
            let c_free = self.module.get_function("free").unwrap();
            self.builder.build_call(c_free, &[fixed_json.into()], "").unwrap();
        } else {
            self.builder.build_call(
                unwrap_fn,
                &[json_ptr.into(), response_buf.into(), response_buf_len.into()],
                "",
            ).unwrap();
        }

        let free_fn = self.module.get_function("forge_model_free_string").unwrap();
        self.builder.build_call(free_fn, &[json_ptr.into()], "").unwrap();

        self.builder.build_return(Some(&i64_type.const_int(200, false))).unwrap();

        if let Some(block) = saved_block { self.builder.position_at_end(block); }

        let add_route_fn = self.module.get_function("forge_http_add_route").unwrap();
        let method_str = self.builder.build_global_string_ptr("GET", "get_method").unwrap();
        let path_str = self.builder.build_global_string_ptr(&path_with_id, "get_path").unwrap();
        self.builder.build_call(
            add_route_fn,
            &[method_str.as_pointer_value().into(), path_str.as_pointer_value().into(), handler_fn.as_global_value().as_pointer_value().into()],
            "",
        ).unwrap();
    }

    pub(crate) fn emit_http_mount_update(&mut self, model: &ModelInfo, base_path: &str) {
        let i64_type = self.context.i64_type();
        let i8_type = self.context.i8_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let handler_name = format!("__mount_update_{}", model.name.to_lowercase());
        let path_with_id = format!("{}/:id", base_path);

        let handler_fn_type = i64_type.fn_type(
            &[ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), i64_type.into()],
            false,
        );
        let handler_fn = self.module.add_function(&handler_name, handler_fn_type, None);

        let saved_block = self.builder.get_insert_block();
        let entry = self.context.append_basic_block(handler_fn, "entry");
        self.builder.position_at_end(entry);

        let body_ptr = handler_fn.get_nth_param(2).unwrap().into_pointer_value();
        let params_json = handler_fn.get_nth_param(3).unwrap().into_pointer_value();
        let response_buf = handler_fn.get_nth_param(4).unwrap().into_pointer_value();
        let response_buf_len = handler_fn.get_nth_param(5).unwrap().into_int_value();

        // Get the updatable fields (non-primary, non-auto fields)
        let updatable_fields: Vec<&ModelField> = model.fields.iter()
            .filter(|f| {
                !f.annotations.iter().any(|a| a.name == "primary" || a.name == "auto_increment")
            })
            .collect();

        // First, get the current record from DB
        let params_get_fn = self.module.get_function("forge_params_get").unwrap();
        let id_key = self.builder.build_global_string_ptr("id", "id_key").unwrap();
        let id_str = self.builder.build_call(
            params_get_fn,
            &[params_json.into(), id_key.as_pointer_value().into()],
            "id_val",
        ).unwrap().try_as_basic_value().left().unwrap();
        let id_ptr = self.builder.build_extract_value(id_str.into_struct_value(), 0, "id_ptr").unwrap();

        // Fetch current record
        let select_sql = format!("SELECT * FROM {} WHERE id = ?", model.name);
        let select_sql_str = self.builder.build_global_string_ptr(&select_sql, "sel_sql").unwrap();
        let id_param = self.builder.build_alloca(ptr_type, "id_param").unwrap();
        self.builder.build_store(id_param, id_ptr).unwrap();

        let query_fn = self.module.get_function("forge_model_query").unwrap();
        let current_json = self.builder.build_call(
            query_fn,
            &[select_sql_str.as_pointer_value().into(), id_param.into(), i64_type.const_int(1, false).into()],
            "cur_json",
        ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();

        // Build UPDATE SQL: UPDATE Model SET f1=?, f2=?, ... WHERE id=?
        let set_clauses: Vec<String> = updatable_fields.iter()
            .map(|f| format!("{} = ?", f.name))
            .collect();
        let update_sql = format!(
            "UPDATE {} SET {} WHERE id = ?",
            model.name,
            set_clauses.join(", ")
        );
        let update_sql_str = self.builder.build_global_string_ptr(&update_sql, "upd_sql").unwrap();

        // Build params array: for each updatable field, use body value if present, else current DB value
        let total_params = updatable_fields.len() + 1; // +1 for id
        let params_array_type = ptr_type.array_type(total_params as u32);
        let params_alloca = self.builder.build_alloca(params_array_type, "params").unwrap();

        let body_has_fn = self.module.get_function("forge_body_has_field").unwrap();

        for (idx, field) in updatable_fields.iter().enumerate() {
            let field_name_str = self.builder.build_global_string_ptr(&field.name, &format!("fn_{}", field.name)).unwrap();

            // Check if field is in body
            let has_field = self.builder.build_call(
                body_has_fn,
                &[body_ptr.into(), field_name_str.as_pointer_value().into()],
                &format!("has_{}", field.name),
            ).unwrap().try_as_basic_value().left().unwrap().into_int_value();

            let cond = self.builder.build_int_compare(
                inkwell::IntPredicate::NE, has_field, i8_type.const_zero(), "cond",
            ).unwrap();

            let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
            let then_bb = self.context.append_basic_block(function, &format!("has_{}", field.name));
            let else_bb = self.context.append_basic_block(function, &format!("no_{}", field.name));
            let merge_bb = self.context.append_basic_block(function, &format!("merge_{}", field.name));

            self.builder.build_conditional_branch(cond, then_bb, else_bb).unwrap();

            // Then: extract from body
            self.builder.position_at_end(then_bb);
            let extract_fn_name = match &field.type_ann {
                TypeExpr::Named(t) => match t.as_str() {
                    "int" => "forge_body_get_int_str",
                    "bool" => "forge_body_get_bool_str",
                    _ => "forge_body_get_string",
                },
                _ => "forge_body_get_string",
            };
            let extract_fn = self.module.get_function(extract_fn_name).unwrap();
            let body_val = self.builder.build_call(
                extract_fn,
                &[body_ptr.into(), field_name_str.as_pointer_value().into()],
                "body_v",
            ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();
            self.builder.build_unconditional_branch(merge_bb).unwrap();

            // Else: extract from current DB record (JSON array)
            self.builder.position_at_end(else_bb);
            let db_val = match &field.type_ann {
                TypeExpr::Named(t) => match t.as_str() {
                    "int" => {
                        let get_fn = self.module.get_function("forge_json_get_int").unwrap();
                        let int_val = self.builder.build_call(
                            get_fn,
                            &[current_json.into(), i64_type.const_zero().into(), field_name_str.as_pointer_value().into()],
                            "db_int",
                        ).unwrap().try_as_basic_value().left().unwrap().into_int_value();
                        // Convert to string
                        let snprintf = self.module.get_function("snprintf").unwrap();
                        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
                        let buf = self.builder.build_call(
                            alloc_fn,
                            &[i64_type.const_int(32, false).into()],
                            "ibuf",
                        ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();
                        let fmt = self.builder.build_global_string_ptr("%lld", "ifmt").unwrap();
                        self.builder.build_call(
                            snprintf,
                            &[buf.into(), i64_type.const_int(32, false).into(), fmt.as_pointer_value().into(), int_val.into()],
                            "",
                        ).unwrap();
                        buf
                    }
                    "bool" => {
                        let get_fn = self.module.get_function("forge_json_get_bool").unwrap();
                        let bool_val = self.builder.build_call(
                            get_fn,
                            &[current_json.into(), i64_type.const_zero().into(), field_name_str.as_pointer_value().into()],
                            "db_bool",
                        ).unwrap().try_as_basic_value().left().unwrap().into_int_value();
                        let cond2 = self.builder.build_int_compare(
                            inkwell::IntPredicate::NE, bool_val, i8_type.const_zero(), "bc",
                        ).unwrap();
                        let one = self.builder.build_global_string_ptr("1", "one").unwrap();
                        let zero_s = self.builder.build_global_string_ptr("0", "zero").unwrap();
                        self.builder.build_select(cond2, one.as_pointer_value(), zero_s.as_pointer_value(), "bs").unwrap().into_pointer_value()
                    }
                    _ => {
                        // string
                        let get_fn = self.module.get_function("forge_json_get_string").unwrap();
                        let str_val = self.builder.build_call(
                            get_fn,
                            &[current_json.into(), i64_type.const_zero().into(), field_name_str.as_pointer_value().into()],
                            "db_str",
                        ).unwrap().try_as_basic_value().left().unwrap();
                        self.builder.build_extract_value(str_val.into_struct_value(), 0, "sp").unwrap().into_pointer_value()
                    }
                },
                _ => {
                    let get_fn = self.module.get_function("forge_json_get_string").unwrap();
                    let str_val = self.builder.build_call(
                        get_fn,
                        &[current_json.into(), i64_type.const_zero().into(), field_name_str.as_pointer_value().into()],
                        "db_str",
                    ).unwrap().try_as_basic_value().left().unwrap();
                    self.builder.build_extract_value(str_val.into_struct_value(), 0, "sp").unwrap().into_pointer_value()
                }
            };
            self.builder.build_unconditional_branch(merge_bb).unwrap();
            let else_end_bb = self.builder.get_insert_block().unwrap();

            // Merge: phi node
            self.builder.position_at_end(merge_bb);
            let phi = self.builder.build_phi(ptr_type, "val").unwrap();
            phi.add_incoming(&[(&body_val, then_bb), (&db_val, else_end_bb)]);
            let val_ptr = phi.as_basic_value().into_pointer_value();

            let idx_val = self.context.i32_type().const_int(idx as u64, false);
            let elem_ptr = unsafe {
                self.builder.build_gep(params_array_type, params_alloca, &[self.context.i32_type().const_zero(), idx_val], "pp").unwrap()
            };
            self.builder.build_store(elem_ptr, val_ptr).unwrap();
        }

        // Add id as last param
        let id_idx = self.context.i32_type().const_int(updatable_fields.len() as u64, false);
        let id_elem_ptr = unsafe {
            self.builder.build_gep(params_array_type, params_alloca, &[self.context.i32_type().const_zero(), id_idx], "id_pp").unwrap()
        };
        self.builder.build_store(id_elem_ptr, id_ptr).unwrap();

        // Execute UPDATE
        let update_fn = self.module.get_function("forge_model_update").unwrap();
        self.builder.build_call(
            update_fn,
            &[update_sql_str.as_pointer_value().into(), params_alloca.into(), i64_type.const_int(total_params as u64, false).into()],
            "upd_result",
        ).unwrap();

        // Free current_json
        let free_str_fn = self.module.get_function("forge_model_free_string").unwrap();
        self.builder.build_call(free_str_fn, &[current_json.into()], "").unwrap();

        // Fetch the updated record
        let id_param2 = self.builder.build_alloca(ptr_type, "id_param2").unwrap();
        self.builder.build_store(id_param2, id_ptr).unwrap();
        let updated_json = self.builder.build_call(
            query_fn,
            &[select_sql_str.as_pointer_value().into(), id_param2.into(), i64_type.const_int(1, false).into()],
            "upd_json",
        ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();

        // Fix boolean fields and unwrap first object
        let bool_fields = Self::model_bool_fields_str(model);
        let unwrap_fn = self.module.get_function("forge_json_unwrap_first").unwrap();
        if !bool_fields.is_empty() {
            let fix_bools_fn = self.module.get_function("forge_json_fix_bools").unwrap();
            let bool_fields_str = self.builder.build_global_string_ptr(&bool_fields, "bfields").unwrap();
            let fixed_json = self.builder.build_call(
                fix_bools_fn,
                &[updated_json.into(), bool_fields_str.as_pointer_value().into()],
                "fixed",
            ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();
            self.builder.build_call(
                unwrap_fn,
                &[fixed_json.into(), response_buf.into(), response_buf_len.into()],
                "",
            ).unwrap();
            let c_free = self.module.get_function("free").unwrap();
            self.builder.build_call(c_free, &[fixed_json.into()], "").unwrap();
        } else {
            self.builder.build_call(
                unwrap_fn,
                &[updated_json.into(), response_buf.into(), response_buf_len.into()],
                "",
            ).unwrap();
        }
        self.builder.build_call(free_str_fn, &[updated_json.into()], "").unwrap();

        self.builder.build_return(Some(&i64_type.const_int(200, false))).unwrap();

        if let Some(block) = saved_block { self.builder.position_at_end(block); }

        let add_route_fn = self.module.get_function("forge_http_add_route").unwrap();
        let method_str = self.builder.build_global_string_ptr("PUT", "put_method").unwrap();
        let path_str = self.builder.build_global_string_ptr(&path_with_id, "upd_path").unwrap();
        self.builder.build_call(
            add_route_fn,
            &[method_str.as_pointer_value().into(), path_str.as_pointer_value().into(), handler_fn.as_global_value().as_pointer_value().into()],
            "",
        ).unwrap();
    }

    pub(crate) fn emit_http_mount_delete(&mut self, model: &ModelInfo, base_path: &str) {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let handler_name = format!("__mount_delete_{}", model.name.to_lowercase());
        let path_with_id = format!("{}/:id", base_path);

        let handler_fn_type = i64_type.fn_type(
            &[ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), ptr_type.into(), i64_type.into()],
            false,
        );
        let handler_fn = self.module.add_function(&handler_name, handler_fn_type, None);

        let saved_block = self.builder.get_insert_block();
        let entry = self.context.append_basic_block(handler_fn, "entry");
        self.builder.position_at_end(entry);

        let params_json = handler_fn.get_nth_param(3).unwrap().into_pointer_value();

        // Get id from params
        let params_get_fn = self.module.get_function("forge_params_get").unwrap();
        let id_key = self.builder.build_global_string_ptr("id", "id_key").unwrap();
        let id_str = self.builder.build_call(
            params_get_fn,
            &[params_json.into(), id_key.as_pointer_value().into()],
            "id_val",
        ).unwrap().try_as_basic_value().left().unwrap();

        // Build params array with id
        let param_arr = self.builder.build_alloca(ptr_type, "params").unwrap();
        let id_ptr = self.builder.build_extract_value(id_str.into_struct_value(), 0, "id_ptr").unwrap();
        self.builder.build_store(param_arr, id_ptr).unwrap();

        // Execute DELETE SQL
        let sql = format!("DELETE FROM {} WHERE id = ?", model.name);
        let sql_str = self.builder.build_global_string_ptr(&sql, "del_sql").unwrap();
        let update_fn = self.module.get_function("forge_model_update").unwrap();
        self.builder.build_call(
            update_fn,
            &[sql_str.as_pointer_value().into(), param_arr.into(), i64_type.const_int(1, false).into()],
            "del_result",
        ).unwrap();

        self.builder.build_return(Some(&i64_type.const_int(204, false))).unwrap();

        if let Some(block) = saved_block { self.builder.position_at_end(block); }

        let add_route_fn = self.module.get_function("forge_http_add_route").unwrap();
        let method_str = self.builder.build_global_string_ptr("DELETE", "del_method").unwrap();
        let path_str = self.builder.build_global_string_ptr(&path_with_id, "del_path").unwrap();
        self.builder.build_call(
            add_route_fn,
            &[method_str.as_pointer_value().into(), path_str.as_pointer_value().into(), handler_fn.as_global_value().as_pointer_value().into()],
            "",
        ).unwrap();
    }

    /// Infer the return type of a model method
    pub(crate) fn infer_model_method_type(&self, model: &ModelInfo, method: &str) -> Type {
        let model_type = self.named_types.get(&model.name).cloned().unwrap_or(Type::Unknown);
        match method {
            "create" | "get" => {
                // get returns nullable
                if method == "get" {
                    Type::Nullable(Box::new(model_type))
                } else {
                    // create returns i64 (id)
                    Type::Int
                }
            }
            "list" => Type::List(Box::new(model_type)),
            "count" => Type::Int,
            "update" => Type::Int,
            "delete" => Type::Void,
            _ => Type::Unknown,
        }
    }

    /// Compile a model static method call: Task.create({...}), Task.get(id), etc.
    pub(crate) fn compile_model_method_call(
        &mut self,
        model_name: &str,
        method: &str,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let model = self.models.get(model_name)?.clone();

        match method {
            "create" => self.compile_model_create(&model, args),
            "get" => self.compile_model_get(&model, args),
            "list" => self.compile_model_list(&model),
            "count" => self.compile_model_count(&model),
            "update" => self.compile_model_update(&model, args),
            "delete" => self.compile_model_delete(&model, args),
            _ => None,
        }
    }

    /// Compile Service.method() calls - delegates to model with hooks
    pub(crate) fn compile_service_method_call(
        &mut self,
        service_name: &str,
        method: &str,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let svc = self.services.get(service_name)?.clone();
        let model = self.models.get(&svc.for_model)?.clone();

        // Check for custom service methods
        for m in &svc.methods {
            if let Statement::FnDecl { name, params, return_type, body, .. } = m {
                if name == method {
                    // Compile and call the service method
                    let mangled = format!("{}_{}", service_name, method);
                    if self.module.get_function(&mangled).is_none() {
                        let saved_block = self.builder.get_insert_block();
                        self.declare_function(&mangled, params, return_type.as_ref());
                        self.compile_fn(&mangled, params, return_type.as_ref(), body);
                        if let Some(block) = saved_block {
                            self.builder.position_at_end(block);
                        }
                    }
                    if let Some(func) = self.functions.get(&mangled).copied() {
                        let mut compiled_args = Vec::new();
                        for arg in args {
                            if let Some(val) = self.compile_expr(&arg.value) {
                                compiled_args.push(val.into());
                            }
                        }
                        let result = self.builder.build_call(func, &compiled_args, "svc_call").unwrap();
                        return result.try_as_basic_value().left();
                    }
                }
            }
        }

        // For CRUD operations, run hooks before/after
        match method {
            "create" => {
                // Run before create hooks
                let before_hooks: Vec<_> = svc.hooks.iter()
                    .filter(|h| h.timing == HookTiming::Before && h.operation == "create")
                    .cloned().collect();
                let after_hooks: Vec<_> = svc.hooks.iter()
                    .filter(|h| h.timing == HookTiming::After && h.operation == "create")
                    .cloned().collect();

                // Compile the struct arg and bind it for hooks
                if let Some(arg) = args.first() {
                    let arg_val = self.compile_expr(&arg.value)?;
                    let arg_type = self.infer_type(&arg.value);

                    // Run before hooks
                    for hook in &before_hooks {
                        self.push_scope();
                        let alloca = self.create_entry_block_alloca(&arg_type, &hook.param);
                        self.builder.build_store(alloca, arg_val).unwrap();
                        self.define_var(hook.param.clone(), alloca, arg_type.clone());
                        for stmt in &hook.body.statements {
                            self.compile_statement(stmt);
                        }
                        self.pop_scope();
                    }

                    // Do the actual create
                    let id_val = self.compile_model_create_with_val(&model, arg_val, &arg.value)?;

                    // Run after hooks - need to get the created record
                    if !after_hooks.is_empty() {
                        // Get the created record by id
                        let record = self.emit_model_get_by_id(&model, id_val)?;
                        let model_type = self.named_types.get(&model.name).cloned().unwrap_or(Type::Unknown);
                        for hook in &after_hooks {
                            self.push_scope();
                            let alloca = self.create_entry_block_alloca(&model_type, &hook.param);
                            self.builder.build_store(alloca, record).unwrap();
                            self.define_var(hook.param.clone(), alloca, model_type.clone());
                            for stmt in &hook.body.statements {
                                self.compile_statement(stmt);
                            }
                            self.pop_scope();
                        }
                    }

                    return Some(id_val);
                }
                None
            }
            "list" => self.compile_model_list(&model),
            "get" => self.compile_model_get(&model, args),
            "update" => self.compile_model_update(&model, args),
            "delete" => self.compile_model_delete(&model, args),
            "count" => self.compile_model_count(&model),
            _ => None,
        }
    }

    /// Compile Task.create({ title: "Buy groceries" })
    pub(crate) fn compile_model_create(
        &mut self,
        model: &ModelInfo,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let arg = args.first()?;
        let arg_val = self.compile_expr(&arg.value)?;
        self.compile_model_create_with_val(model, arg_val, &arg.value)
    }

    pub(crate) fn compile_model_create_with_val(
        &mut self,
        model: &ModelInfo,
        arg_val: BasicValueEnum<'ctx>,
        arg_expr: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        // Get field names and values from the struct literal
        let field_info: Vec<(String, Expr)> = match arg_expr {
            Expr::StructLit { fields, .. } => fields.clone(),
            _ => Vec::new(),
        };

        // Build SQL: INSERT INTO Task (title, done) VALUES (?, ?)
        let field_names: Vec<&str> = model.create_fields.iter().map(|f| f.name.as_str()).collect();
        let placeholders: Vec<&str> = field_names.iter().map(|_| "?").collect();
        let sql = format!(
            "INSERT INTO {} ({}) VALUES ({})",
            model.name,
            field_names.join(", "),
            placeholders.join(", ")
        );

        let sql_str = self.builder.build_global_string_ptr(&sql, "insert_sql").unwrap();

        // Build params array - convert each field to a C string
        let param_count = model.create_fields.len();
        let params_array_type = ptr_type.array_type(param_count as u32);
        let params_alloca = self.builder.build_alloca(params_array_type, "params").unwrap();

        let struct_val = if arg_val.is_struct_value() { arg_val.into_struct_value() } else { return None; };

        // Map from field_info order to create_fields order
        for (cf_idx, cf) in model.create_fields.iter().enumerate() {
            // Find this field in the struct literal
            let field_idx = field_info.iter().position(|(name, _)| name == &cf.name);
            let param_val: BasicValueEnum<'ctx>;
            let field_type: Type;

            if let Some(fi) = field_idx {
                param_val = self.builder.build_extract_value(struct_val, fi as u32, &cf.name).unwrap();
                field_type = self.infer_type(&field_info[fi].1);
            } else {
                // Use default value from annotation
                let default_ann = cf.annotations.iter().find(|a| a.name == "default");
                if let Some(ann) = default_ann {
                    if let Some(default_expr) = ann.args.first() {
                        param_val = self.compile_expr(default_expr)?;
                        field_type = self.infer_type(default_expr);
                    } else {
                        continue;
                    }
                } else {
                    continue;
                }
            }

            // Convert to C string
            let c_str = self.value_to_cstring(param_val, &field_type);

            // Store in params array using array GEP
            let idx_val = self.context.i32_type().const_int(cf_idx as u64, false);
            let elem_ptr = unsafe {
                self.builder.build_gep(params_array_type, params_alloca, &[self.context.i32_type().const_zero(), idx_val], "param_ptr").unwrap()
            };
            self.builder.build_store(elem_ptr, c_str).unwrap();
        }

        // Call forge_model_insert
        let insert_fn = self.module.get_function("forge_model_insert").unwrap();
        let count_val = i64_type.const_int(param_count as u64, false);
        let result = self.builder.build_call(
            insert_fn,
            &[sql_str.as_pointer_value().into(), params_alloca.into(), count_val.into()],
            "insert_id",
        ).unwrap();

        result.try_as_basic_value().left()
    }

    /// Convert a Forge value to a C string pointer (for SQL params)
    pub(crate) fn value_to_cstring(&mut self, val: BasicValueEnum<'ctx>, ty: &Type) -> PointerValue<'ctx> {
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        match ty {
            Type::String => {
                // ForgeString { ptr, len } - ptr is already null-terminated
                if val.is_struct_value() {
                    let str_val = val.into_struct_value();
                    self.builder.build_extract_value(str_val, 0, "str_ptr").unwrap().into_pointer_value()
                } else {
                    ptr_type.const_null()
                }
            }
            Type::Int => {
                // Convert int to string using snprintf
                let buf_size = 32u64;
                let alloc_fn = self.module.get_function("forge_alloc").unwrap();
                let buf = self.builder.build_call(
                    alloc_fn,
                    &[self.context.i64_type().const_int(buf_size, false).into()],
                    "int_buf",
                ).unwrap().try_as_basic_value().left().unwrap().into_pointer_value();
                let fmt = self.builder.build_global_string_ptr("%lld", "int_fmt").unwrap();
                let snprintf = self.module.get_function("snprintf").unwrap();
                self.builder.build_call(
                    snprintf,
                    &[buf.into(), self.context.i64_type().const_int(buf_size, false).into(), fmt.as_pointer_value().into(), val.into()],
                    "",
                ).unwrap();
                buf
            }
            Type::Bool => {
                // "0" or "1"
                let cond = self.builder.build_int_compare(
                    IntPredicate::NE,
                    val.into_int_value(),
                    self.context.i8_type().const_zero(),
                    "bool_cond",
                ).unwrap();
                let one = self.builder.build_global_string_ptr("1", "one").unwrap();
                let zero = self.builder.build_global_string_ptr("0", "zero").unwrap();
                self.builder.build_select(cond, one.as_pointer_value(), zero.as_pointer_value(), "bool_str").unwrap().into_pointer_value()
            }
            _ => ptr_type.const_null(),
        }
    }

    /// Compile Task.get(id) -> Nullable<Task>
    pub(crate) fn compile_model_get(
        &mut self,
        model: &ModelInfo,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let arg = args.first()?;
        let id_val = self.compile_expr(&arg.value)?;
        self.emit_model_get_nullable(model, id_val)
    }

    /// Get a model record by id, return nullable struct
    pub(crate) fn emit_model_get_nullable(
        &mut self,
        model: &ModelInfo,
        id_val: BasicValueEnum<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        let sql = format!("SELECT * FROM {} WHERE id = ?", model.name);
        let sql_str = self.builder.build_global_string_ptr(&sql, "get_sql").unwrap();

        // Convert id to string param
        let id_cstr = self.value_to_cstring(id_val, &Type::Int);
        let params_alloca = self.builder.build_alloca(ptr_type, "params").unwrap();
        self.builder.build_store(params_alloca, id_cstr).unwrap();

        // Call forge_model_query
        let query_fn = self.module.get_function("forge_model_query").unwrap();
        let json_ptr = self.builder.build_call(
            query_fn,
            &[sql_str.as_pointer_value().into(), params_alloca.into(), i64_type.const_int(1, false).into()],
            "json",
        ).unwrap().try_as_basic_value().left()?.into_pointer_value();

        // Check if we got results
        let count_fn = self.module.get_function("forge_json_array_count").unwrap();
        let count = self.builder.build_call(count_fn, &[json_ptr.into()], "count").unwrap()
            .try_as_basic_value().left()?.into_int_value();

        let has_result = self.builder.build_int_compare(
            IntPredicate::SGT, count, i64_type.const_zero(), "has_result",
        ).unwrap();

        let model_type = self.named_types.get(&model.name)?.clone();
        let nullable_type = Type::Nullable(Box::new(model_type.clone()));
        let nullable_llvm = self.type_to_llvm_basic(&nullable_type);

        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
        let then_bb = self.context.append_basic_block(function, "get_found");
        let else_bb = self.context.append_basic_block(function, "get_null");
        let merge_bb = self.context.append_basic_block(function, "get_merge");

        self.builder.build_conditional_branch(has_result, then_bb, else_bb).unwrap();

        // Found: parse JSON into struct, wrap in nullable
        self.builder.position_at_end(then_bb);
        let struct_val = self.emit_json_to_model_struct(model, json_ptr, i64_type.const_zero());
        let wrapped = self.wrap_in_nullable(struct_val, &nullable_type);
        let then_end = self.builder.get_insert_block().unwrap();
        self.builder.build_unconditional_branch(merge_bb).unwrap();

        // Not found: null
        self.builder.position_at_end(else_bb);
        let null_val = self.create_null_value(&nullable_type);
        let else_end = self.builder.get_insert_block().unwrap();
        self.builder.build_unconditional_branch(merge_bb).unwrap();

        self.builder.position_at_end(merge_bb);
        let phi = self.builder.build_phi(nullable_llvm, "get_result").unwrap();
        phi.add_incoming(&[(&wrapped, then_end), (&null_val, else_end)]);

        // Free json
        let free_fn = self.module.get_function("forge_model_free_string").unwrap();
        self.builder.build_call(free_fn, &[json_ptr.into()], "").unwrap();

        Some(phi.as_basic_value())
    }

    /// Get a model record by id (non-nullable, for after hooks)
    pub(crate) fn emit_model_get_by_id(
        &mut self,
        model: &ModelInfo,
        id_val: BasicValueEnum<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        let sql = format!("SELECT * FROM {} WHERE id = ?", model.name);
        let sql_str = self.builder.build_global_string_ptr(&sql, "get_sql").unwrap();

        let id_cstr = self.value_to_cstring(id_val, &Type::Int);
        let params_alloca = self.builder.build_alloca(ptr_type, "params").unwrap();
        self.builder.build_store(params_alloca, id_cstr).unwrap();

        let query_fn = self.module.get_function("forge_model_query").unwrap();
        let json_ptr = self.builder.build_call(
            query_fn,
            &[sql_str.as_pointer_value().into(), params_alloca.into(), i64_type.const_int(1, false).into()],
            "json",
        ).unwrap().try_as_basic_value().left()?.into_pointer_value();

        let struct_val = self.emit_json_to_model_struct(model, json_ptr, i64_type.const_zero());

        let free_fn = self.module.get_function("forge_model_free_string").unwrap();
        self.builder.build_call(free_fn, &[json_ptr.into()], "").unwrap();

        Some(struct_val)
    }

    /// Parse a JSON object at the given index into a model struct
    pub(crate) fn emit_json_to_model_struct(
        &mut self,
        model: &ModelInfo,
        json_ptr: PointerValue<'ctx>,
        index: IntValue<'ctx>,
    ) -> BasicValueEnum<'ctx> {
        let model_type = self.named_types.get(&model.name).unwrap().clone();
        let model_llvm = self.type_to_llvm_basic(&model_type);
        let struct_type = model_llvm.into_struct_type();
        let mut struct_val = struct_type.get_undef();

        for (i, field) in model.fields.iter().enumerate() {
            let field_name_str = self.builder.build_global_string_ptr(&field.name, "field_name").unwrap();
            let field_type = match &field.type_ann {
                TypeExpr::Named(t) => t.as_str(),
                _ => "string",
            };

            let field_val: BasicValueEnum = match field_type {
                "int" => {
                    let get_fn = self.module.get_function("forge_json_get_int").unwrap();
                    self.builder.build_call(
                        get_fn,
                        &[json_ptr.into(), index.into(), field_name_str.as_pointer_value().into()],
                        &field.name,
                    ).unwrap().try_as_basic_value().left().unwrap()
                }
                "bool" => {
                    let get_fn = self.module.get_function("forge_json_get_bool").unwrap();
                    self.builder.build_call(
                        get_fn,
                        &[json_ptr.into(), index.into(), field_name_str.as_pointer_value().into()],
                        &field.name,
                    ).unwrap().try_as_basic_value().left().unwrap()
                }
                _ => {
                    // string
                    let get_fn = self.module.get_function("forge_json_get_string").unwrap();
                    self.builder.build_call(
                        get_fn,
                        &[json_ptr.into(), index.into(), field_name_str.as_pointer_value().into()],
                        &field.name,
                    ).unwrap().try_as_basic_value().left().unwrap()
                }
            };

            struct_val = self.builder
                .build_insert_value(struct_val, field_val, i as u32, &field.name)
                .unwrap()
                .into_struct_value();
        }

        struct_val.into()
    }

    /// Compile Task.list() -> List<Task>
    pub(crate) fn compile_model_list(&mut self, model: &ModelInfo) -> Option<BasicValueEnum<'ctx>> {
        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        let sql = format!("SELECT * FROM {}", model.name);
        let sql_str = self.builder.build_global_string_ptr(&sql, "list_sql").unwrap();

        // Call forge_model_query
        let query_fn = self.module.get_function("forge_model_query").unwrap();
        let json_ptr = self.builder.build_call(
            query_fn,
            &[sql_str.as_pointer_value().into(), ptr_type.const_null().into(), i64_type.const_zero().into()],
            "json",
        ).unwrap().try_as_basic_value().left()?.into_pointer_value();

        // Get count
        let count_fn = self.module.get_function("forge_json_array_count").unwrap();
        let count = self.builder.build_call(count_fn, &[json_ptr.into()], "count").unwrap()
            .try_as_basic_value().left()?.into_int_value();

        // Allocate array of model structs
        let model_type = self.named_types.get(&model.name)?.clone();
        let model_llvm = self.type_to_llvm_basic(&model_type);
        let elem_size = model_llvm.size_of().unwrap();
        let total_size = self.builder.build_int_mul(elem_size, count, "total").unwrap();
        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let data_ptr = self.builder.build_call(alloc_fn, &[total_size.into()], "list_data").unwrap()
            .try_as_basic_value().left()?.into_pointer_value();

        // Loop to parse each object
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
        let idx_alloca = self.create_entry_block_alloca(&Type::Int, "__list_idx");
        self.builder.build_store(idx_alloca, i64_type.const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "list_loop");
        let body_bb = self.context.append_basic_block(function, "list_body");
        let end_bb = self.context.append_basic_block(function, "list_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(i64_type, idx_alloca, "idx").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, count, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let struct_val = self.emit_json_to_model_struct(model, json_ptr, idx);
        let elem_ptr = unsafe {
            self.builder.build_gep(model_llvm, data_ptr, &[idx], "elem").unwrap()
        };
        self.builder.build_store(elem_ptr, struct_val).unwrap();

        let next_idx = self.builder.build_int_add(idx, i64_type.const_int(1, false), "next").unwrap();
        self.builder.build_store(idx_alloca, next_idx).unwrap();
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);

        // Free json
        let free_fn = self.module.get_function("forge_model_free_string").unwrap();
        self.builder.build_call(free_fn, &[json_ptr.into()], "").unwrap();

        // Build list struct {ptr, len}
        let list_type = Type::List(Box::new(model_type));
        let list_llvm = self.type_to_llvm_basic(&list_type);
        let list_struct_type = list_llvm.into_struct_type();
        let mut list_val = list_struct_type.get_undef();
        list_val = self.builder.build_insert_value(list_val, data_ptr, 0, "data").unwrap().into_struct_value();
        list_val = self.builder.build_insert_value(list_val, count, 1, "len").unwrap().into_struct_value();

        Some(list_val.into())
    }

    /// Compile Task.count() -> int
    pub(crate) fn compile_model_count(&mut self, model: &ModelInfo) -> Option<BasicValueEnum<'ctx>> {
        let sql = format!("SELECT COUNT(*) FROM {}", model.name);
        let sql_str = self.builder.build_global_string_ptr(&sql, "count_sql").unwrap();
        let count_fn = self.module.get_function("forge_model_count").unwrap();
        let result = self.builder.build_call(count_fn, &[sql_str.as_pointer_value().into()], "count").unwrap();
        result.try_as_basic_value().left()
    }

    /// Compile Task.update(id, { done: true })
    pub(crate) fn compile_model_update(
        &mut self,
        model: &ModelInfo,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        if args.len() < 2 { return None; }

        let id_val = self.compile_expr(&args[0].value)?;
        let updates_val = self.compile_expr(&args[1].value)?;

        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        // Get update field names from the struct literal
        let update_fields: Vec<(String, Expr)> = match &args[1].value {
            Expr::StructLit { fields, .. } => fields.clone(),
            _ => Vec::new(),
        };

        if update_fields.is_empty() { return None; }

        // Build SQL: UPDATE Task SET done = ? WHERE id = ?
        let set_clauses: Vec<String> = update_fields.iter()
            .map(|(name, _)| format!("{} = ?", name))
            .collect();
        let sql = format!("UPDATE {} SET {} WHERE id = ?", model.name, set_clauses.join(", "));
        let sql_str = self.builder.build_global_string_ptr(&sql, "update_sql").unwrap();

        // Build params: field values + id
        let param_count = update_fields.len() + 1;
        let params_array_type = ptr_type.array_type(param_count as u32);
        let params_alloca = self.builder.build_alloca(params_array_type, "params").unwrap();

        let updates_struct = if updates_val.is_struct_value() { updates_val.into_struct_value() } else { return None; };

        for (i, (_, expr)) in update_fields.iter().enumerate() {
            let field_val = self.builder.build_extract_value(updates_struct, i as u32, "upd_field").unwrap();
            let field_type = self.infer_type(expr);
            let c_str = self.value_to_cstring(field_val, &field_type);
            let idx_val = self.context.i32_type().const_int(i as u64, false);
            let elem_ptr = unsafe {
                self.builder.build_gep(params_array_type, params_alloca, &[self.context.i32_type().const_zero(), idx_val], "p").unwrap()
            };
            self.builder.build_store(elem_ptr, c_str).unwrap();
        }

        // Last param is the id
        let id_cstr = self.value_to_cstring(id_val, &Type::Int);
        let last_idx = self.context.i32_type().const_int(update_fields.len() as u64, false);
        let last_ptr = unsafe {
            self.builder.build_gep(params_array_type, params_alloca, &[self.context.i32_type().const_zero(), last_idx], "id_p").unwrap()
        };
        self.builder.build_store(last_ptr, id_cstr).unwrap();

        let update_fn = self.module.get_function("forge_model_update").unwrap();
        let result = self.builder.build_call(
            update_fn,
            &[sql_str.as_pointer_value().into(), params_alloca.into(), i64_type.const_int(param_count as u64, false).into()],
            "updated",
        ).unwrap();

        result.try_as_basic_value().left()
    }

    /// Compile Task.delete(id)
    pub(crate) fn compile_model_delete(
        &mut self,
        model: &ModelInfo,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let arg = args.first()?;
        let id_val = self.compile_expr(&arg.value)?;

        let i64_type = self.context.i64_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        let sql = format!("DELETE FROM {} WHERE id = ?", model.name);
        let sql_str = self.builder.build_global_string_ptr(&sql, "delete_sql").unwrap();

        let id_cstr = self.value_to_cstring(id_val, &Type::Int);
        let params_alloca = self.builder.build_alloca(ptr_type, "params").unwrap();
        self.builder.build_store(params_alloca, id_cstr).unwrap();

        let update_fn = self.module.get_function("forge_model_update").unwrap();
        let result = self.builder.build_call(
            update_fn,
            &[sql_str.as_pointer_value().into(), params_alloca.into(), i64_type.const_int(1, false).into()],
            "deleted",
        ).unwrap();

        result.try_as_basic_value().left()
    }
}
