; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Node = type { i64, ptr }

@nodes = global i64 0
@result = global i64 0
@lookup = global i64 0
@cmp = global i64 0
@.str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"d\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@fld_name.4 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.5 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.6 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.7 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@sty_name.8 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.9 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@fld_name.10 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.11 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.12 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@fld_name.15 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.16 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.17 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@fld_name.18 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.19 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.20 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@fld_name.21 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.22 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.23 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@.str.24 = private unnamed_addr constant [13 x i8] c"first bigger\00", align 1
@fld_name.25 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.26 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.27 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@fld_name.28 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.29 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.30 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@.str.31 = private unnamed_addr constant [6 x i8] c"equal\00", align 1
@.str.32 = private unnamed_addr constant [14 x i8] c"second bigger\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@fld_name.33 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@sty_name.34 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.35 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@.str.36 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@fld_name.37 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.38 = private unnamed_addr constant [5 x i8] c"Node\00", align 1
@src_file.39 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_deeply_nested.av\00", align 1
@.i2s_fmt.40 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare void @avra_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @avra_rc_alloc(i64)

declare void @avra_rc_retain(ptr)

declare void @avra_rc_release(ptr)

declare i64 @avra_rc_should_free(ptr)

declare void @avra_rc_free(ptr)

declare void @avra_rc_suspect(ptr)

declare void @avra_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare i64 @avra_parse_int(ptr)

declare void @exit(i32)

declare void @avra_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @avra_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @avra_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @avra_array_new()

declare void @avra_array_push(ptr, i64)

declare i64 @avra_array_get(ptr, i64)

declare i64 @avra_array_len(ptr)

declare void @avra_array_set(ptr, i64, i64)

declare i64 @avra_array_pop(ptr)

declare ptr @avra_array_slice(ptr, i64, i64)

declare i64 @avra_closure_get_fn(i64)

declare i64 @avra_closure_num_captures(i64)

declare i64 @avra_closure_get_capture(ptr, i64)

declare i64 @avra_closure_call_0(i64)

declare i64 @avra_closure_call_1(i64, i64)

declare i64 @avra_closure_call_2(i64, i64, i64)

declare i64 @avra_closure_call_3(i64, i64, i64, i64)

declare i64 @avra_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @avra_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @avra_array_map(ptr, i64)

declare ptr @avra_array_filter(ptr, i64)

declare void @avra_array_foreach(ptr, i64)

declare i64 @avra_array_reduce(ptr, i64, i64)

declare i64 @avra_array_contains(ptr, i64)

declare i64 @avra_array_index_of(ptr, i64)

declare ptr @avra_array_reverse(ptr)

declare i64 @avra_str_contains(ptr, ptr)

declare i64 @avra_str_starts_with(ptr, ptr)

declare i64 @avra_str_ends_with(ptr, ptr)

declare i64 @avra_str_index_of(ptr, ptr)

declare ptr @avra_str_split(ptr, ptr)

declare ptr @avra_str_replace(ptr, ptr, ptr)

declare ptr @avra_str_trim(ptr)

declare ptr @avra_str_to_upper(ptr)

declare ptr @avra_str_to_lower(ptr)

declare ptr @avra_str_join(ptr, ptr)

declare ptr @avra_str_char_at(ptr, i64)

declare ptr @avra_str_substring(ptr, i64, i64)

declare ptr @avra_str_repeat(ptr, i64)

declare ptr @avra_str_reverse(ptr)

declare ptr @avra_map_new_cstr()

declare void @avra_map_set_cstr(ptr, ptr, i64)

declare i64 @avra_map_get_cstr(ptr, ptr)

declare i64 @avra_map_has_cstr(ptr, ptr)

declare i64 @avra_map_len_cstr(ptr)

declare ptr @avra_map_keys_cstr(ptr)

declare ptr @avra_map_values_cstr(ptr)

declare i64 @avra_map_remove_cstr(ptr, ptr)

declare ptr @avra_file_read(ptr)

declare i64 @avra_file_write(ptr, ptr)

declare i64 @avra_file_exists(ptr)

declare ptr @avra_intmap_new()

declare void @avra_intmap_set(ptr, i64, i64)

declare i64 @avra_intmap_get(ptr, i64)

declare i64 @avra_intmap_has(ptr, i64)

declare i64 @avra_float_parse(ptr)

declare i64 @avra_float_to_string(i64)

declare ptr @avra_format_float(i64, ptr)

declare ptr @avra_format_int(i64, ptr)

declare void @avra_ptr_store_byte(ptr, i64, i64)

declare i64 @avra_string_from_ptr(ptr, i64)

declare i64 @avra_trait_object_new(ptr, i64)

declare i64 @avra_trait_object_value(ptr)

declare ptr @avra_trait_object_vtable(ptr)

declare i64 @avra_datetime_now()

declare i64 @avra_datetime_format(ptr, i64)

declare i64 @avra_datetime_year(ptr)

declare i64 @avra_datetime_month(ptr)

declare i64 @avra_datetime_day(ptr)

declare i64 @avra_datetime_hour(ptr)

declare i64 @avra_datetime_minute(ptr)

declare i64 @avra_datetime_second(ptr)

declare ptr @avra_json_stringify_int(ptr)

declare ptr @avra_json_stringify_string(ptr)

declare ptr @avra_json_stringify_bool(ptr)

declare i64 @avra_json_get_int(ptr, i64)

declare i64 @avra_json_get_string(ptr, i64)

declare i64 @avra_json_get_bool(ptr, i64)

declare i64 @avra_semver_major(ptr)

declare i64 @avra_semver_minor(ptr)

declare i64 @avra_semver_patch(ptr)

declare i64 @avra_semver_compare(ptr, i64)

declare i64 @avra_validate_not_null(ptr, i64)

declare i64 @avra_validate_positive(ptr, i64)

declare i64 @avra_validate_not_empty(ptr, i64)

declare i64 @avra_toml_get_string(ptr, i64)

declare i64 @avra_toml_get_int(ptr, i64)

declare i64 @avra_toml_get_bool(ptr, i64)

declare i64 @avra_toml_get_section_string(ptr, i64, i64)

declare i64 @avra_toml_has_section(ptr, i64)

declare i64 @avra_spawn(ptr)

declare i64 @avra_task_await(ptr)

declare i32 @avra_thread_join(ptr)

declare void @avra_yield()

declare void @avra_scheduler_run()

declare ptr @avra_task_group_new()

declare void @avra_task_group_add(ptr, ptr)

declare void @avra_task_group_await_all(ptr)

declare ptr @avra_channel_new()

declare void @avra_channel_send(ptr, i64)

declare i64 @avra_channel_recv(ptr)

declare i32 @avra_channel_close(ptr)

declare i32 @avra_parallel_run(ptr)

declare i64 @avra_select(ptr, i64)

declare i64 @avra_select_index(ptr)

declare i64 @avra_select_value(ptr)

declare i32 @avra_test_start_spec(ptr)

declare i32 @avra_test_end_spec(ptr)

declare i32 @avra_test_start_given(ptr)

declare i32 @avra_test_end_given(ptr)

declare i64 @avra_test_run_then(ptr, i64)

declare i32 @avra_test_skip(ptr)

declare i32 @avra_test_todo(ptr)

declare i32 @avra_test_summary()

declare void @avra_test_flush()

declare ptr @avra_arena_new()

declare ptr @avra_arena_alloc(ptr, i64)

declare void @avra_arena_destroy(ptr)

declare void @avra_match_unreachable(ptr, i64, ptr, i64)

declare i32 @avra_llvm_is_ptr_value(ptr)

declare ptr @avra_llvm_typeof(ptr)

declare ptr @avra_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @avra_llvm_is_void_value(ptr)

declare void @avra_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @avra_llvm_verify_function(ptr)

declare i64 @avra_llvm_type_kind(ptr)

declare i64 @avra_llvm_int_type_width(ptr)

declare ptr @avra_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @avra_test_roughly(double, double, double)

define i64 @main() {
entry:
  %n75 = alloca i64, align 8
  %forin_i74 = alloca i64, align 8
  %forin_len73 = alloca i64, align 8
  %pmatch_result = alloca i64, align 8
  %second35 = alloca i64, align 8
  %first34 = alloca i64, align 8
  %n = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Node, ptr %1, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Node, ptr %1, i32 0, i32 1
  store ptr @.str, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %2 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr2 = getelementptr inbounds nuw %Node, ptr %2, i32 0, i32 0
  store i64 2, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Node, ptr %2, i32 0, i32 1
  store ptr @.str.1, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %0, i64 %cast4)
  %3 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr5 = getelementptr inbounds nuw %Node, ptr %3, i32 0, i32 0
  store i64 3, ptr %fld_ptr5, align 8
  %fld_ptr6 = getelementptr inbounds nuw %Node, ptr %3, i32 0, i32 1
  store ptr @.str.2, ptr %fld_ptr6, align 8
  %cast7 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %0, i64 %cast7)
  %4 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr8 = getelementptr inbounds nuw %Node, ptr %4, i32 0, i32 0
  store i64 4, ptr %fld_ptr8, align 8
  %fld_ptr9 = getelementptr inbounds nuw %Node, ptr %4, i32 0, i32 1
  store ptr @.str.3, ptr %fld_ptr9, align 8
  %cast10 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %0, i64 %cast10)
  store ptr %0, ptr @nodes, align 8
  %nodes = load ptr, ptr @nodes, align 8
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 -559038737)
  call void @avra_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast11 = ptrtoint ptr %5 to i64
  %6 = call ptr @avra_array_filter(ptr %nodes, i64 %cast11)
  %7 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %7, i64 -559038737)
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast12 = ptrtoint ptr %7 to i64
  %8 = call ptr @avra_array_map(ptr %6, i64 %cast12)
  %9 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %9, i64 -559038737)
  call void @avra_array_push(ptr %9, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast13 = ptrtoint ptr %9 to i64
  %10 = call i64 @avra_array_reduce(ptr %8, i64 0, i64 %cast13)
  store i64 %10, ptr @result, align 8
  %result = load i64, ptr @result, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt, i64 %result)
  %widen = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen14 = sext i32 %13 to i64
  %14 = call ptr @avra_map_new_cstr()
  store ptr %14, ptr @lookup, align 8
  %nodes15 = load ptr, ptr @nodes, align 8
  %15 = call i64 @avra_array_len(ptr %nodes15)
  store i64 %15, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %16 = call i64 @avra_array_get(ptr %nodes15, i64 %forin_i_val)
  store i64 %16, ptr %n, align 8
  %lookup = load ptr, ptr @lookup, align 8
  %n16 = load ptr, ptr %n, align 8
  %cast17 = ptrtoint ptr %n16 to i64
  %null_chk = icmp eq i64 %cast17, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 5, ptr @sty_name.8, i64 4, i64 %null_ext, ptr @src_file.9, i64 105, i64 21)
  %label_ptr = getelementptr inbounds nuw %Node, ptr %n16, i32 0, i32 1
  %label = load ptr, ptr %label_ptr, align 8
  %n18 = load ptr, ptr %n, align 8
  %cast19 = ptrtoint ptr %n18 to i64
  %null_chk20 = icmp eq i64 %cast19, 0
  %null_ext21 = zext i1 %null_chk20 to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 5, ptr @sty_name.11, i64 4, i64 %null_ext21, ptr @src_file.12, i64 105, i64 21)
  %value_ptr = getelementptr inbounds nuw %Node, ptr %n18, i32 0, i32 0
  %value = load i64, ptr %value_ptr, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.13, i64 %value)
  %widen22 = sext i32 %18 to i64
  %cast23 = ptrtoint ptr %17 to i64
  call void @avra_map_set_cstr(ptr %lookup, ptr %label, i64 %cast23)
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %lookup24 = load ptr, ptr @lookup, align 8
  %19 = call i64 @avra_map_get_cstr(ptr %lookup24, ptr @.str.14)
  %cast25 = inttoptr i64 %19 to ptr
  %20 = call i32 @puts(ptr %cast25)
  %widen26 = sext i32 %20 to i64
  %21 = call ptr @avra_rc_alloc(i64 16)
  %nodes27 = load ptr, ptr @nodes, align 8
  %22 = call i64 @avra_array_get(ptr %nodes27, i64 0)
  %slot_base = ptrtoint ptr %21 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %22, ptr %slot, align 8
  %nodes28 = load ptr, ptr @nodes, align 8
  %23 = call i64 @avra_array_get(ptr %nodes28, i64 1)
  %slot_base29 = ptrtoint ptr %21 to i64
  %slot_addr30 = add i64 %slot_base29, 8
  %slot31 = inttoptr i64 %slot_addr30 to ptr
  store i64 %23, ptr %slot31, align 8
  %cast32 = ptrtoint ptr %21 to i64
  %cast33 = inttoptr i64 %cast32 to ptr
  %first_slot_base = ptrtoint ptr %cast33 to i64
  %first_slot_addr = add i64 %first_slot_base, 0
  %first_slot = inttoptr i64 %first_slot_addr to ptr
  %first = load i64, ptr %first_slot, align 8
  store i64 %first, ptr %first34, align 8
  %second_slot_base = ptrtoint ptr %cast33 to i64
  %second_slot_addr = add i64 %second_slot_base, 8
  %second_slot = inttoptr i64 %second_slot_addr to ptr
  %second = load i64, ptr %second_slot, align 8
  store i64 %second, ptr %second35, align 8
  %first36 = load ptr, ptr %first34, align 8
  %cast37 = ptrtoint ptr %first36 to i64
  %null_chk38 = icmp eq i64 %cast37, 0
  %null_ext39 = zext i1 %null_chk38 to i64
  call void @avra_null_deref_trap(ptr @fld_name.15, i64 5, ptr @sty_name.16, i64 4, i64 %null_ext39, ptr @src_file.17, i64 105, i64 27)
  %value_ptr40 = getelementptr inbounds nuw %Node, ptr %first36, i32 0, i32 0
  %value41 = load i64, ptr %value_ptr40, align 8
  store i64 0, ptr %pmatch_result, align 8
  %first42 = load ptr, ptr %first34, align 8
  %cast43 = ptrtoint ptr %first42 to i64
  %null_chk44 = icmp eq i64 %cast43, 0
  %null_ext45 = zext i1 %null_chk44 to i64
  call void @avra_null_deref_trap(ptr @fld_name.18, i64 5, ptr @sty_name.19, i64 4, i64 %null_ext45, ptr @src_file.20, i64 105, i64 27)
  %value_ptr46 = getelementptr inbounds nuw %Node, ptr %first42, i32 0, i32 0
  %value47 = load i64, ptr %value_ptr46, align 8
  %second48 = load ptr, ptr %second35, align 8
  %cast49 = ptrtoint ptr %second48 to i64
  %null_chk50 = icmp eq i64 %cast49, 0
  %null_ext51 = zext i1 %null_chk50 to i64
  call void @avra_null_deref_trap(ptr @fld_name.21, i64 5, ptr @sty_name.22, i64 4, i64 %null_ext51, ptr @src_file.23, i64 105, i64 27)
  %value_ptr52 = getelementptr inbounds nuw %Node, ptr %second48, i32 0, i32 0
  %value53 = load i64, ptr %value_ptr52, align 8
  %sgt = icmp sgt i64 %value47, %value53
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body69, %parm_body54, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  store i64 %pmatch_val, ptr @cmp, align 8
  %cmp = load ptr, ptr @cmp, align 8
  %24 = call i32 @puts(ptr %cmp)
  %widen71 = sext i32 %24 to i64
  %nodes72 = load ptr, ptr @nodes, align 8
  %25 = call ptr @avra_array_slice(ptr %nodes72, i64 1, i64 3)
  %26 = call i64 @avra_array_len(ptr %25)
  store i64 %26, ptr %forin_len73, align 8
  store i64 0, ptr %forin_i74, align 8
  br label %forin.cond76

parm_body:                                        ; preds = %forin.exit
  store i64 ptrtoint (ptr @.str.24 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %forin.exit
  %first56 = load ptr, ptr %first34, align 8
  %cast57 = ptrtoint ptr %first56 to i64
  %null_chk58 = icmp eq i64 %cast57, 0
  %null_ext59 = zext i1 %null_chk58 to i64
  call void @avra_null_deref_trap(ptr @fld_name.25, i64 5, ptr @sty_name.26, i64 4, i64 %null_ext59, ptr @src_file.27, i64 105, i64 27)
  %value_ptr60 = getelementptr inbounds nuw %Node, ptr %first56, i32 0, i32 0
  %value61 = load i64, ptr %value_ptr60, align 8
  %second62 = load ptr, ptr %second35, align 8
  %cast63 = ptrtoint ptr %second62 to i64
  %null_chk64 = icmp eq i64 %cast63, 0
  %null_ext65 = zext i1 %null_chk64 to i64
  call void @avra_null_deref_trap(ptr @fld_name.28, i64 5, ptr @sty_name.29, i64 4, i64 %null_ext65, ptr @src_file.30, i64 105, i64 27)
  %value_ptr66 = getelementptr inbounds nuw %Node, ptr %second62, i32 0, i32 0
  %value67 = load i64, ptr %value_ptr66, align 8
  %eq = icmp eq i64 %value61, %value67
  %eq_ext = zext i1 %eq to i64
  %pguard68 = icmp ne i64 %eq_ext, 0
  br i1 %pguard68, label %parm_body54, label %parm_next55

parm_body54:                                      ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.31 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next55:                                      ; preds = %parm_next
  br label %parm_body69

parm_body69:                                      ; preds = %parm_next55
  store i64 ptrtoint (ptr @.str.32 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next70:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 27)
  unreachable

forin.cond76:                                     ; preds = %forin.incr78, %pmatch_end
  %forin_i_val80 = load i64, ptr %forin_i74, align 8
  %forin_len_val81 = load i64, ptr %forin_len73, align 8
  %forin_cmp82 = icmp slt i64 %forin_i_val80, %forin_len_val81
  br i1 %forin_cmp82, label %forin.body77, label %forin.exit79

forin.body77:                                     ; preds = %forin.cond76
  %27 = call i64 @avra_array_get(ptr %25, i64 %forin_i_val80)
  store i64 %27, ptr %n75, align 8
  %n83 = load ptr, ptr %n75, align 8
  %cast84 = ptrtoint ptr %n83 to i64
  %null_chk85 = icmp eq i64 %cast84, 0
  %null_ext86 = zext i1 %null_chk85 to i64
  call void @avra_null_deref_trap(ptr @fld_name.33, i64 5, ptr @sty_name.34, i64 4, i64 %null_ext86, ptr @src_file.35, i64 105, i64 36)
  %label_ptr87 = getelementptr inbounds nuw %Node, ptr %n83, i32 0, i32 1
  %label88 = load ptr, ptr %label_ptr87, align 8
  %28 = call i64 @strlen(ptr %label88)
  %29 = call i64 @strlen(ptr @.str.36)
  %concat_total = add i64 %28, %29
  %concat_size = add i64 %concat_total, 1
  %30 = call ptr @avra_rc_alloc(i64 %concat_size)
  %31 = call ptr @memcpy(ptr %30, ptr %label88, i64 %28)
  %cast89 = ptrtoint ptr %30 to i64
  %dst2_int = add i64 %cast89, %28
  %cast90 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %29, 1
  %32 = call ptr @memcpy(ptr %cast90, ptr @.str.36, i64 %rhs_len_p1)
  %n91 = load ptr, ptr %n75, align 8
  %cast92 = ptrtoint ptr %n91 to i64
  %null_chk93 = icmp eq i64 %cast92, 0
  %null_ext94 = zext i1 %null_chk93 to i64
  call void @avra_null_deref_trap(ptr @fld_name.37, i64 5, ptr @sty_name.38, i64 4, i64 %null_ext94, ptr @src_file.39, i64 105, i64 36)
  %value_ptr95 = getelementptr inbounds nuw %Node, ptr %n91, i32 0, i32 0
  %value96 = load i64, ptr %value_ptr95, align 8
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.40, i64 %value96)
  %widen97 = sext i32 %34 to i64
  %35 = call i64 @strlen(ptr %30)
  %36 = call i64 @strlen(ptr %33)
  %concat_total98 = add i64 %35, %36
  %concat_size99 = add i64 %concat_total98, 1
  %37 = call ptr @avra_rc_alloc(i64 %concat_size99)
  %38 = call ptr @memcpy(ptr %37, ptr %30, i64 %35)
  %cast100 = ptrtoint ptr %37 to i64
  %dst2_int101 = add i64 %cast100, %35
  %cast102 = inttoptr i64 %dst2_int101 to ptr
  %rhs_len_p1103 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast102, ptr %33, i64 %rhs_len_p1103)
  %40 = call i32 @puts(ptr %37)
  %widen104 = sext i32 %40 to i64
  br label %forin.incr78

forin.incr78:                                     ; preds = %forin.body77
  %forin_i_old105 = load i64, ptr %forin_i74, align 8
  %forin_next106 = add i64 %forin_i_old105, 1
  store i64 %forin_next106, ptr %forin_i74, align 8
  br label %forin.cond76

forin.exit79:                                     ; preds = %forin.cond76
  %41 = call i32 @avra_test_summary()
  %widen107 = sext i32 %41 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Node(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_label_ptr = getelementptr inbounds nuw %Node, ptr %0, i32 0, i32 1
  %rel_label = load ptr, ptr %rel_label_ptr, align 8
  %is_null_label = icmp eq ptr %rel_label, null
  br i1 %is_null_label, label %rel_label_skip, label %rel_label_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_label_skip
  ret i64 0

rel_label_skip:                                   ; preds = %rel_label_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_label_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_label)
  br label %rel_label_skip
}

define i64 @__lambda_0(ptr %0) {
entry:
  %n = alloca ptr, align 8
  store ptr %0, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %cast = ptrtoint ptr %n1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 105, i64 12)
  %value_ptr = getelementptr inbounds nuw %Node, ptr %n1, i32 0, i32 0
  %value = load i64, ptr %value_ptr, align 8
  %sgt = icmp sgt i64 %value, 1
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_1(ptr %0) {
entry:
  %n = alloca ptr, align 8
  store ptr %0, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %cast = ptrtoint ptr %n1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 5, ptr @sty_name.5, i64 4, i64 %null_ext, ptr @src_file.6, i64 105, i64 12)
  %value_ptr = getelementptr inbounds nuw %Node, ptr %n1, i32 0, i32 0
  %value = load i64, ptr %value_ptr, align 8
  %mul = mul i64 %value, 10
  ret i64 %mul
}

define i64 @__lambda_2(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %acc1, %x2
  ret i64 %add
}
