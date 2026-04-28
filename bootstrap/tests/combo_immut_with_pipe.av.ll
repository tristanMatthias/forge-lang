; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Vec = type { i64, i64 }

@v = global i64 0
@v2 = global i64 0
@values = global i64 0
@labels = global i64 0
@base = global i64 0
@moved = global i64 0
@v3 = global i64 0
@.str = private unnamed_addr constant [5 x i8] c"huge\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Vec\00", align 1
@src_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@fld_name.5 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.6 = private unnamed_addr constant [4 x i8] c"Vec\00", align 1
@src_file.7 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@fld_name.8 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.9 = private unnamed_addr constant [4 x i8] c"Vec\00", align 1
@src_file.10 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.11 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.12 = private unnamed_addr constant [4 x i8] c"Vec\00", align 1
@src_file.13 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.15 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.16 = private unnamed_addr constant [4 x i8] c"Vec\00", align 1
@src_file.17 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c",\00", align 1
@fld_name.20 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.21 = private unnamed_addr constant [4 x i8] c"Vec\00", align 1
@src_file.22 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.24 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.25 = private unnamed_addr constant [4 x i8] c"Vec\00", align 1
@src_file.26 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@.i2s_fmt.27 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.28 = private unnamed_addr constant [2 x i8] c",\00", align 1
@fld_name.29 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.30 = private unnamed_addr constant [4 x i8] c"Vec\00", align 1
@src_file.31 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_with_pipe.av\00", align 1
@.i2s_fmt.32 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @classify(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  store i64 0, ptr %pmatch_result, align 8
  %n2 = load i64, ptr %n, align 8
  %sgt = icmp sgt i64 %n2, 100
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body19, %parm_body15, %parm_body9, %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %n5 = load i64, ptr %n, align 8
  %sgt6 = icmp sgt i64 %n5, 10
  %sgt_ext7 = zext i1 %sgt6 to i64
  %pguard8 = icmp ne i64 %sgt_ext7, 0
  br i1 %pguard8, label %parm_body3, label %parm_next4

parm_body3:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; preds = %parm_next
  %n11 = load i64, ptr %n, align 8
  %sgt12 = icmp sgt i64 %n11, 0
  %sgt_ext13 = zext i1 %sgt12 to i64
  %pguard14 = icmp ne i64 %sgt_ext13, 0
  br i1 %pguard14, label %parm_body9, label %parm_next10

parm_body9:                                       ; preds = %parm_next4
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next10:                                      ; preds = %parm_next4
  %n17 = load i64, ptr %n, align 8
  %eq = icmp eq i64 %n17, 0
  %eq_ext = zext i1 %eq to i64
  %pguard18 = icmp ne i64 %eq_ext, 0
  br i1 %pguard18, label %parm_body15, label %parm_next16

parm_body15:                                      ; preds = %parm_next10
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next16:                                      ; preds = %parm_next10
  br label %parm_body19

parm_body19:                                      ; preds = %parm_next16
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next20:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 12)
  unreachable
}

define ptr @scale(ptr %0, i64 %1) {
entry:
  %factor = alloca i64, align 8
  %v = alloca ptr, align 8
  store ptr %0, ptr %v, align 8
  store i64 %1, ptr %factor, align 8
  %v1 = load ptr, ptr %v, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Vec, ptr %v1, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Vec, ptr %2, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Vec, ptr %v1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Vec, ptr %2, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %v5 = load ptr, ptr %v, align 8
  %cast = ptrtoint ptr %v5 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 107, i64 35)
  %x_ptr = getelementptr inbounds nuw %Vec, ptr %v5, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %factor6 = load i64, ptr %factor, align 8
  %mul = mul i64 %x, %factor6
  %with_ovr = getelementptr inbounds nuw %Vec, ptr %2, i32 0, i32 0
  store i64 %mul, ptr %with_ovr, align 8
  %v7 = load ptr, ptr %v, align 8
  %cast8 = ptrtoint ptr %v7 to i64
  %null_chk9 = icmp eq i64 %cast8, 0
  %null_ext10 = zext i1 %null_chk9 to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 1, ptr @sty_name.6, i64 3, i64 %null_ext10, ptr @src_file.7, i64 107, i64 35)
  %y_ptr = getelementptr inbounds nuw %Vec, ptr %v7, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %factor11 = load i64, ptr %factor, align 8
  %mul12 = mul i64 %y, %factor11
  %with_ovr13 = getelementptr inbounds nuw %Vec, ptr %2, i32 0, i32 1
  store i64 %mul12, ptr %with_ovr13, align 8
  %cast14 = ptrtoint ptr %2 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  ret ptr %cast15
}

define i64 @main() {
entry:
  %ife_result = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Vec, ptr %0, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Vec, ptr %0, i32 0, i32 1
  store i64 2, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @v, align 8
  %v = load ptr, ptr @v, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Vec, ptr %v, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Vec, ptr %1, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Vec, ptr %v, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Vec, ptr %1, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_ovr = getelementptr inbounds nuw %Vec, ptr %1, i32 0, i32 0
  store i64 10, ptr %with_ovr, align 8
  %cast5 = ptrtoint ptr %1 to i64
  store i64 %cast5, ptr @v2, align 8
  %v6 = load ptr, ptr @v, align 8
  %cast7 = ptrtoint ptr %v6 to i64
  %null_chk = icmp eq i64 %cast7, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.8, i64 1, ptr @sty_name.9, i64 3, i64 %null_ext, ptr @src_file.10, i64 107, i64 7)
  %x_ptr = getelementptr inbounds nuw %Vec, ptr %v6, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen8 = sext i32 %4 to i64
  %v2 = load ptr, ptr @v2, align 8
  %cast9 = ptrtoint ptr %v2 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 1, ptr @sty_name.12, i64 3, i64 %null_ext11, ptr @src_file.13, i64 107, i64 8)
  %x_ptr12 = getelementptr inbounds nuw %Vec, ptr %v2, i32 0, i32 0
  %x13 = load i64, ptr %x_ptr12, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.14, i64 %x13)
  %widen14 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen15 = sext i32 %7 to i64
  %8 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %8, i64 150)
  call void @avra_array_push(ptr %8, i64 50)
  call void @avra_array_push(ptr %8, i64 5)
  call void @avra_array_push(ptr %8, i64 0)
  call void @avra_array_push(ptr %8, i64 -10)
  store ptr %8, ptr @values, align 8
  %values = load ptr, ptr @values, align 8
  %9 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %9, i64 -559038737)
  call void @avra_array_push(ptr %9, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast16 = ptrtoint ptr %9 to i64
  %10 = call ptr @avra_array_map(ptr %values, i64 %cast16)
  store ptr %10, ptr @labels, align 8
  %labels = load ptr, ptr @labels, align 8
  %11 = call i64 @avra_array_get(ptr %labels, i64 0)
  %cast17 = inttoptr i64 %11 to ptr
  %12 = call i32 @puts(ptr %cast17)
  %widen18 = sext i32 %12 to i64
  %labels19 = load ptr, ptr @labels, align 8
  %13 = call i64 @avra_array_get(ptr %labels19, i64 1)
  %cast20 = inttoptr i64 %13 to ptr
  %14 = call i32 @puts(ptr %cast20)
  %widen21 = sext i32 %14 to i64
  %labels22 = load ptr, ptr @labels, align 8
  %15 = call i64 @avra_array_get(ptr %labels22, i64 2)
  %cast23 = inttoptr i64 %15 to ptr
  %16 = call i32 @puts(ptr %cast23)
  %widen24 = sext i32 %16 to i64
  %labels25 = load ptr, ptr @labels, align 8
  %17 = call i64 @avra_array_get(ptr %labels25, i64 3)
  %cast26 = inttoptr i64 %17 to ptr
  %18 = call i32 @puts(ptr %cast26)
  %widen27 = sext i32 %18 to i64
  %labels28 = load ptr, ptr @labels, align 8
  %19 = call i64 @avra_array_get(ptr %labels28, i64 4)
  %cast29 = inttoptr i64 %19 to ptr
  %20 = call i32 @puts(ptr %cast29)
  %widen30 = sext i32 %20 to i64
  %21 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr31 = getelementptr inbounds nuw %Vec, ptr %21, i32 0, i32 0
  store i64 0, ptr %fld_ptr31, align 8
  %fld_ptr32 = getelementptr inbounds nuw %Vec, ptr %21, i32 0, i32 1
  store i64 0, ptr %fld_ptr32, align 8
  %cast33 = ptrtoint ptr %21 to i64
  store i64 %cast33, ptr @base, align 8
  br i1 true, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  store i64 %ife_val, ptr @moved, align 8
  %moved = load ptr, ptr @moved, align 8
  %cast51 = ptrtoint ptr %moved to i64
  %null_chk52 = icmp eq i64 %cast51, 0
  %null_ext53 = zext i1 %null_chk52 to i64
  call void @avra_null_deref_trap(ptr @fld_name.15, i64 1, ptr @sty_name.16, i64 3, i64 %null_ext53, ptr @src_file.17, i64 107, i64 31)
  %x_ptr54 = getelementptr inbounds nuw %Vec, ptr %moved, i32 0, i32 0
  %x55 = load i64, ptr %x_ptr54, align 8
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.18, i64 %x55)
  %widen56 = sext i32 %23 to i64
  %24 = call i64 @strlen(ptr %22)
  %25 = call i64 @strlen(ptr @.str.19)
  %concat_total = add i64 %24, %25
  %concat_size = add i64 %concat_total, 1
  %26 = call ptr @avra_rc_alloc(i64 %concat_size)
  %27 = call ptr @memcpy(ptr %26, ptr %22, i64 %24)
  %cast57 = ptrtoint ptr %26 to i64
  %dst2_int = add i64 %cast57, %24
  %cast58 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast58, ptr @.str.19, i64 %rhs_len_p1)
  %moved59 = load ptr, ptr @moved, align 8
  %cast60 = ptrtoint ptr %moved59 to i64
  %null_chk61 = icmp eq i64 %cast60, 0
  %null_ext62 = zext i1 %null_chk61 to i64
  call void @avra_null_deref_trap(ptr @fld_name.20, i64 1, ptr @sty_name.21, i64 3, i64 %null_ext62, ptr @src_file.22, i64 107, i64 31)
  %y_ptr = getelementptr inbounds nuw %Vec, ptr %moved59, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %29 = call ptr @avra_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.23, i64 %y)
  %widen63 = sext i32 %30 to i64
  %31 = call i64 @strlen(ptr %26)
  %32 = call i64 @strlen(ptr %29)
  %concat_total64 = add i64 %31, %32
  %concat_size65 = add i64 %concat_total64, 1
  %33 = call ptr @avra_rc_alloc(i64 %concat_size65)
  %34 = call ptr @memcpy(ptr %33, ptr %26, i64 %31)
  %cast66 = ptrtoint ptr %33 to i64
  %dst2_int67 = add i64 %cast66, %31
  %cast68 = inttoptr i64 %dst2_int67 to ptr
  %rhs_len_p169 = add i64 %32, 1
  %35 = call ptr @memcpy(ptr %cast68, ptr %29, i64 %rhs_len_p169)
  %36 = call i32 @puts(ptr %33)
  %widen70 = sext i32 %36 to i64
  %37 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr71 = getelementptr inbounds nuw %Vec, ptr %37, i32 0, i32 0
  store i64 3, ptr %fld_ptr71, align 8
  %fld_ptr72 = getelementptr inbounds nuw %Vec, ptr %37, i32 0, i32 1
  store i64 4, ptr %fld_ptr72, align 8
  %cast73 = ptrtoint ptr %37 to i64
  %cast74 = inttoptr i64 %cast73 to ptr
  %38 = call ptr @scale(ptr %cast74, i64 5)
  store ptr %38, ptr @v3, align 8
  %v3 = load ptr, ptr @v3, align 8
  %cast75 = ptrtoint ptr %v3 to i64
  %null_chk76 = icmp eq i64 %cast75, 0
  %null_ext77 = zext i1 %null_chk76 to i64
  call void @avra_null_deref_trap(ptr @fld_name.24, i64 1, ptr @sty_name.25, i64 3, i64 %null_ext77, ptr @src_file.26, i64 107, i64 38)
  %x_ptr78 = getelementptr inbounds nuw %Vec, ptr %v3, i32 0, i32 0
  %x79 = load i64, ptr %x_ptr78, align 8
  %39 = call ptr @avra_rc_alloc(i64 32)
  %40 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %39, i64 32, ptr @.i2s_fmt.27, i64 %x79)
  %widen80 = sext i32 %40 to i64
  %41 = call i64 @strlen(ptr %39)
  %42 = call i64 @strlen(ptr @.str.28)
  %concat_total81 = add i64 %41, %42
  %concat_size82 = add i64 %concat_total81, 1
  %43 = call ptr @avra_rc_alloc(i64 %concat_size82)
  %44 = call ptr @memcpy(ptr %43, ptr %39, i64 %41)
  %cast83 = ptrtoint ptr %43 to i64
  %dst2_int84 = add i64 %cast83, %41
  %cast85 = inttoptr i64 %dst2_int84 to ptr
  %rhs_len_p186 = add i64 %42, 1
  %45 = call ptr @memcpy(ptr %cast85, ptr @.str.28, i64 %rhs_len_p186)
  %v387 = load ptr, ptr @v3, align 8
  %cast88 = ptrtoint ptr %v387 to i64
  %null_chk89 = icmp eq i64 %cast88, 0
  %null_ext90 = zext i1 %null_chk89 to i64
  call void @avra_null_deref_trap(ptr @fld_name.29, i64 1, ptr @sty_name.30, i64 3, i64 %null_ext90, ptr @src_file.31, i64 107, i64 38)
  %y_ptr91 = getelementptr inbounds nuw %Vec, ptr %v387, i32 0, i32 1
  %y92 = load i64, ptr %y_ptr91, align 8
  %46 = call ptr @avra_rc_alloc(i64 32)
  %47 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %46, i64 32, ptr @.i2s_fmt.32, i64 %y92)
  %widen93 = sext i32 %47 to i64
  %48 = call i64 @strlen(ptr %43)
  %49 = call i64 @strlen(ptr %46)
  %concat_total94 = add i64 %48, %49
  %concat_size95 = add i64 %concat_total94, 1
  %50 = call ptr @avra_rc_alloc(i64 %concat_size95)
  %51 = call ptr @memcpy(ptr %50, ptr %43, i64 %48)
  %cast96 = ptrtoint ptr %50 to i64
  %dst2_int97 = add i64 %cast96, %48
  %cast98 = inttoptr i64 %dst2_int97 to ptr
  %rhs_len_p199 = add i64 %49, 1
  %52 = call ptr @memcpy(ptr %cast98, ptr %46, i64 %rhs_len_p199)
  %53 = call i32 @puts(ptr %50)
  %widen100 = sext i32 %53 to i64
  %54 = call i32 @avra_test_summary()
  %widen101 = sext i32 %54 to i64
  call void @avra_rc_collect()
  ret i64 0

ife_then:                                         ; preds = %entry
  %base = load ptr, ptr @base, align 8
  %55 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src34 = getelementptr inbounds nuw %Vec, ptr %base, i32 0, i32 0
  %with_cp_val35 = load i64, ptr %with_cp_src34, align 8
  %with_cp_dst36 = getelementptr inbounds nuw %Vec, ptr %55, i32 0, i32 0
  store i64 %with_cp_val35, ptr %with_cp_dst36, align 8
  %with_cp_src37 = getelementptr inbounds nuw %Vec, ptr %base, i32 0, i32 1
  %with_cp_val38 = load i64, ptr %with_cp_src37, align 8
  %with_cp_dst39 = getelementptr inbounds nuw %Vec, ptr %55, i32 0, i32 1
  store i64 %with_cp_val38, ptr %with_cp_dst39, align 8
  %with_ovr40 = getelementptr inbounds nuw %Vec, ptr %55, i32 0, i32 0
  store i64 100, ptr %with_ovr40, align 8
  %cast41 = ptrtoint ptr %55 to i64
  store i64 %cast41, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %base42 = load ptr, ptr @base, align 8
  %56 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src43 = getelementptr inbounds nuw %Vec, ptr %base42, i32 0, i32 0
  %with_cp_val44 = load i64, ptr %with_cp_src43, align 8
  %with_cp_dst45 = getelementptr inbounds nuw %Vec, ptr %56, i32 0, i32 0
  store i64 %with_cp_val44, ptr %with_cp_dst45, align 8
  %with_cp_src46 = getelementptr inbounds nuw %Vec, ptr %base42, i32 0, i32 1
  %with_cp_val47 = load i64, ptr %with_cp_src46, align 8
  %with_cp_dst48 = getelementptr inbounds nuw %Vec, ptr %56, i32 0, i32 1
  store i64 %with_cp_val47, ptr %with_cp_dst48, align 8
  %with_ovr49 = getelementptr inbounds nuw %Vec, ptr %56, i32 0, i32 1
  store i64 100, ptr %with_ovr49, align 8
  %cast50 = ptrtoint ptr %56 to i64
  store i64 %cast50, ptr %ife_result, align 8
  br label %ife_end
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call ptr @classify(i64 %x1)
  %cast = ptrtoint ptr %1 to i64
  ret i64 %cast
}
