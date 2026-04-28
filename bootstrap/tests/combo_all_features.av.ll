; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Config = type { ptr, i64, i64 }

@base_config = global i64 0
@dev_config = global i64 0
@prod_config = global i64 0
@processed = global i64 0
@configs = global i64 0
@status_codes = global i64 0
@keys = global i64 0
@error_count = global i64 0
@quadrant = global i64 0
@data = global i64 0
@positive = global i64 0
@total = global i64 0
@words = global i64 0
@long_words = global i64 0
@.str = private unnamed_addr constant [8 x i8] c"default\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"dev\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"prod\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"level\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_all_features.av\00", align 1
@fld_name.3 = private unnamed_addr constant [6 x i8] c"level\00", align 1
@sty_name.4 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.5 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_all_features.av\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"critical\00", align 1
@fld_name.7 = private unnamed_addr constant [6 x i8] c"level\00", align 1
@sty_name.8 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.9 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_all_features.av\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"important\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c"normal\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_all_features.av\00", align 1
@fld_name.12 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.13 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.14 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_all_features.av\00", align 1
@.str.15 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [4 x i8] c"200\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"OK\00", align 1
@.str.18 = private unnamed_addr constant [4 x i8] c"404\00", align 1
@.str.19 = private unnamed_addr constant [10 x i8] c"Not Found\00", align 1
@.str.20 = private unnamed_addr constant [4 x i8] c"500\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"Error\00", align 1
@.str.22 = private unnamed_addr constant [9 x i8] c"critical\00", align 1
@.str.23 = private unnamed_addr constant [8 x i8] c"warning\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c"ok\00", align 1
@.match_fn.25 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.26 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_all_features.av\00", align 1
@.str.27 = private unnamed_addr constant [3 x i8] c"ok\00", align 1
@.i2s_fmt.28 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.29 = private unnamed_addr constant [3 x i8] c"Q1\00", align 1
@.str.30 = private unnamed_addr constant [3 x i8] c"Q2\00", align 1
@.str.31 = private unnamed_addr constant [3 x i8] c"Q3\00", align 1
@.str.32 = private unnamed_addr constant [3 x i8] c"Q4\00", align 1
@.match_fn.33 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.34 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_all_features.av\00", align 1
@.i2s_fmt.35 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.36 = private unnamed_addr constant [20 x i8] c"hello world foo bar\00", align 1
@.str.37 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.match_fn.38 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.39 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_all_features.av\00", align 1

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
  %lw = alloca i64, align 8
  %forin_i197 = alloca i64, align 8
  %forin_len196 = alloca i64, align 8
  %keep = alloca i64, align 8
  %pmatch_result175 = alloca i64, align 8
  %w = alloca i64, align 8
  %forin_i166 = alloca i64, align 8
  %forin_len165 = alloca i64, align 8
  %pmatch_result112 = alloca i64, align 8
  %y110 = alloca i64, align 8
  %x109 = alloca i64, align 8
  %severity = alloca ptr, align 8
  %pmatch_result78 = alloca i64, align 8
  %code = alloca i64, align 8
  %k = alloca i64, align 8
  %forin_i68 = alloca i64, align 8
  %forin_len67 = alloca i64, align 8
  %label = alloca ptr, align 8
  %pmatch_result = alloca i64, align 8
  %cfg = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 1
  store i64 1, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 2
  store i64 0, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @base_config, align 8
  %base_config = load ptr, ptr @base_config, align 8
  %1 = call ptr @avra_rc_alloc(i64 24)
  %with_cp_src = getelementptr inbounds nuw %Config, ptr %base_config, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src3 = getelementptr inbounds nuw %Config, ptr %base_config, i32 0, i32 1
  %with_cp_val4 = load i64, ptr %with_cp_src3, align 8
  %with_cp_dst5 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 1
  store i64 %with_cp_val4, ptr %with_cp_dst5, align 8
  %with_cp_src6 = getelementptr inbounds nuw %Config, ptr %base_config, i32 0, i32 2
  %with_cp_val7 = load i64, ptr %with_cp_src6, align 8
  %with_cp_dst8 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 2
  store i64 %with_cp_val7, ptr %with_cp_dst8, align 8
  %with_ovr = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 0
  store ptr @.str.1, ptr %with_ovr, align 8
  %with_ovr9 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 2
  store i64 1, ptr %with_ovr9, align 8
  %with_ovr10 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 1
  store i64 3, ptr %with_ovr10, align 8
  %cast11 = ptrtoint ptr %1 to i64
  store i64 %cast11, ptr @dev_config, align 8
  %base_config12 = load ptr, ptr @base_config, align 8
  %2 = call ptr @avra_rc_alloc(i64 24)
  %with_cp_src13 = getelementptr inbounds nuw %Config, ptr %base_config12, i32 0, i32 0
  %with_cp_val14 = load ptr, ptr %with_cp_src13, align 8
  %with_cp_dst15 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 0
  store ptr %with_cp_val14, ptr %with_cp_dst15, align 8
  %with_cp_src16 = getelementptr inbounds nuw %Config, ptr %base_config12, i32 0, i32 1
  %with_cp_val17 = load i64, ptr %with_cp_src16, align 8
  %with_cp_dst18 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 1
  store i64 %with_cp_val17, ptr %with_cp_dst18, align 8
  %with_cp_src19 = getelementptr inbounds nuw %Config, ptr %base_config12, i32 0, i32 2
  %with_cp_val20 = load i64, ptr %with_cp_src19, align 8
  %with_cp_dst21 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 2
  store i64 %with_cp_val20, ptr %with_cp_dst21, align 8
  %with_ovr22 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 0
  store ptr @.str.2, ptr %with_ovr22, align 8
  %with_ovr23 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 1
  store i64 5, ptr %with_ovr23, align 8
  %cast24 = ptrtoint ptr %2 to i64
  store i64 %cast24, ptr @prod_config, align 8
  store i64 0, ptr @processed, align 8
  %3 = call ptr @avra_array_new()
  %base_config25 = load ptr, ptr @base_config, align 8
  %cast26 = ptrtoint ptr %base_config25 to i64
  call void @avra_array_push(ptr %3, i64 %cast26)
  %dev_config = load ptr, ptr @dev_config, align 8
  %cast27 = ptrtoint ptr %dev_config to i64
  call void @avra_array_push(ptr %3, i64 %cast27)
  %prod_config = load ptr, ptr @prod_config, align 8
  %cast28 = ptrtoint ptr %prod_config to i64
  call void @avra_array_push(ptr %3, i64 %cast28)
  store ptr %3, ptr @configs, align 8
  %configs = load ptr, ptr @configs, align 8
  %4 = call i64 @avra_array_len(ptr %configs)
  store i64 %4, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %5 = call i64 @avra_array_get(ptr %configs, i64 %forin_i_val)
  store i64 %5, ptr %cfg, align 8
  %cfg29 = load ptr, ptr %cfg, align 8
  %cast30 = ptrtoint ptr %cfg29 to i64
  %null_chk = icmp eq i64 %cast30, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 104, i64 16)
  %level_ptr = getelementptr inbounds nuw %Config, ptr %cfg29, i32 0, i32 1
  %level = load i64, ptr %level_ptr, align 8
  store i64 0, ptr %pmatch_result, align 8
  %cfg31 = load ptr, ptr %cfg, align 8
  %cast32 = ptrtoint ptr %cfg31 to i64
  %null_chk33 = icmp eq i64 %cast32, 0
  %null_ext34 = zext i1 %null_chk33 to i64
  call void @avra_null_deref_trap(ptr @fld_name.3, i64 5, ptr @sty_name.4, i64 6, i64 %null_ext34, ptr @src_file.5, i64 104, i64 16)
  %level_ptr35 = getelementptr inbounds nuw %Config, ptr %cfg31, i32 0, i32 1
  %level36 = load i64, ptr %level_ptr35, align 8
  %sge = icmp sge i64 %level36, 5
  %sge_ext = zext i1 %sge to i64
  %pguard = icmp ne i64 %sge_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

forin.incr:                                       ; preds = %pmatch_end
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %processed64 = load i64, ptr @processed, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %processed64)
  %widen65 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen66 = sext i32 %8 to i64
  %9 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %9, ptr @.str.16, i64 ptrtoint (ptr @.str.17 to i64))
  call void @avra_map_set_cstr(ptr %9, ptr @.str.18, i64 ptrtoint (ptr @.str.19 to i64))
  call void @avra_map_set_cstr(ptr %9, ptr @.str.20, i64 ptrtoint (ptr @.str.21 to i64))
  store ptr %9, ptr @status_codes, align 8
  %status_codes = load ptr, ptr @status_codes, align 8
  %10 = call ptr @avra_map_keys_cstr(ptr %status_codes)
  store ptr %10, ptr @keys, align 8
  store i64 0, ptr @error_count, align 8
  %keys = load ptr, ptr @keys, align 8
  %11 = call i64 @avra_array_len(ptr %keys)
  store i64 %11, ptr %forin_len67, align 8
  store i64 0, ptr %forin_i68, align 8
  br label %forin.cond69

pmatch_end:                                       ; preds = %parm_body48, %parm_body37, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast50 = inttoptr i64 %pmatch_val to ptr
  store ptr %cast50, ptr %label, align 8
  %cfg51 = load ptr, ptr %cfg, align 8
  %cast52 = ptrtoint ptr %cfg51 to i64
  %null_chk53 = icmp eq i64 %cast52, 0
  %null_ext54 = zext i1 %null_chk53 to i64
  call void @avra_null_deref_trap(ptr @fld_name.12, i64 4, ptr @sty_name.13, i64 6, i64 %null_ext54, ptr @src_file.14, i64 104, i64 21)
  %name_ptr = getelementptr inbounds nuw %Config, ptr %cfg51, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %12 = call i64 @strlen(ptr %name)
  %13 = call i64 @strlen(ptr @.str.15)
  %concat_total = add i64 %12, %13
  %concat_size = add i64 %concat_total, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size)
  %15 = call ptr @memcpy(ptr %14, ptr %name, i64 %12)
  %cast55 = ptrtoint ptr %14 to i64
  %dst2_int = add i64 %cast55, %12
  %cast56 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast56, ptr @.str.15, i64 %rhs_len_p1)
  %label57 = load ptr, ptr %label, align 8
  %17 = call i64 @strlen(ptr %14)
  %18 = call i64 @strlen(ptr %label57)
  %concat_total58 = add i64 %17, %18
  %concat_size59 = add i64 %concat_total58, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size59)
  %20 = call ptr @memcpy(ptr %19, ptr %14, i64 %17)
  %cast60 = ptrtoint ptr %19 to i64
  %dst2_int61 = add i64 %cast60, %17
  %cast62 = inttoptr i64 %dst2_int61 to ptr
  %rhs_len_p163 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast62, ptr %label57, i64 %rhs_len_p163)
  %22 = call i32 @puts(ptr %19)
  %widen = sext i32 %22 to i64
  %processed = load i64, ptr @processed, align 8
  %add = add i64 %processed, 1
  store i64 %add, ptr @processed, align 8
  br label %forin.incr

parm_body:                                        ; preds = %forin.body
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %forin.body
  %cfg39 = load ptr, ptr %cfg, align 8
  %cast40 = ptrtoint ptr %cfg39 to i64
  %null_chk41 = icmp eq i64 %cast40, 0
  %null_ext42 = zext i1 %null_chk41 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 5, ptr @sty_name.8, i64 6, i64 %null_ext42, ptr @src_file.9, i64 104, i64 16)
  %level_ptr43 = getelementptr inbounds nuw %Config, ptr %cfg39, i32 0, i32 1
  %level44 = load i64, ptr %level_ptr43, align 8
  %sge45 = icmp sge i64 %level44, 3
  %sge_ext46 = zext i1 %sge45 to i64
  %pguard47 = icmp ne i64 %sge_ext46, 0
  br i1 %pguard47, label %parm_body37, label %parm_next38

parm_body37:                                      ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next38:                                      ; preds = %parm_next
  br label %parm_body48

parm_body48:                                      ; preds = %parm_next38
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next49:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 16)
  unreachable

forin.cond69:                                     ; preds = %forin.incr71, %forin.exit
  %forin_i_val73 = load i64, ptr %forin_i68, align 8
  %forin_len_val74 = load i64, ptr %forin_len67, align 8
  %forin_cmp75 = icmp slt i64 %forin_i_val73, %forin_len_val74
  br i1 %forin_cmp75, label %forin.body70, label %forin.exit72

forin.body70:                                     ; preds = %forin.cond69
  %23 = call i64 @avra_array_get(ptr %keys, i64 %forin_i_val73)
  store i64 %23, ptr %k, align 8
  %k76 = load ptr, ptr %k, align 8
  %24 = call i64 @avra_parse_int(ptr %k76)
  store i64 %24, ptr %code, align 8
  %code77 = load i64, ptr %code, align 8
  store i64 0, ptr %pmatch_result78, align 8
  %code82 = load i64, ptr %code, align 8
  %sge83 = icmp sge i64 %code82, 500
  %sge_ext84 = zext i1 %sge83 to i64
  %pguard85 = icmp ne i64 %sge_ext84, 0
  br i1 %pguard85, label %parm_body80, label %parm_next81

forin.incr71:                                     ; preds = %ifcont
  %forin_i_old99 = load i64, ptr %forin_i68, align 8
  %forin_next100 = add i64 %forin_i_old99, 1
  store i64 %forin_next100, ptr %forin_i68, align 8
  br label %forin.cond69

forin.exit72:                                     ; preds = %forin.cond69
  %error_count101 = load i64, ptr @error_count, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.28, i64 %error_count101)
  %widen102 = sext i32 %26 to i64
  %27 = call i32 @puts(ptr %25)
  %widen103 = sext i32 %27 to i64
  %28 = call ptr @avra_rc_alloc(i64 16)
  %slot_base = ptrtoint ptr %28 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %slot_base104 = ptrtoint ptr %28 to i64
  %slot_addr105 = add i64 %slot_base104, 8
  %slot106 = inttoptr i64 %slot_addr105 to ptr
  store i64 -7, ptr %slot106, align 8
  %cast107 = ptrtoint ptr %28 to i64
  %cast108 = inttoptr i64 %cast107 to ptr
  %x_slot_base = ptrtoint ptr %cast108 to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x109, align 8
  %y_slot_base = ptrtoint ptr %cast108 to i64
  %y_slot_addr = add i64 %y_slot_base, 8
  %y_slot = inttoptr i64 %y_slot_addr to ptr
  %y = load i64, ptr %y_slot, align 8
  store i64 %y, ptr %y110, align 8
  %x111 = load i64, ptr %x109, align 8
  store i64 0, ptr %pmatch_result112, align 8
  %x116 = load i64, ptr %x109, align 8
  %sgt = icmp sgt i64 %x116, 0
  %sgt_ext = zext i1 %sgt to i64
  %l_bool = icmp ne i64 %sgt_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

pmatch_end79:                                     ; preds = %parm_body92, %parm_body86, %parm_body80
  %pmatch_val94 = load i64, ptr %pmatch_result78, align 8
  %cast95 = inttoptr i64 %pmatch_val94 to ptr
  store ptr %cast95, ptr %severity, align 8
  %severity96 = load ptr, ptr %severity, align 8
  %29 = call i32 @strcmp(ptr %severity96, ptr @.str.27)
  %widen97 = sext i32 %29 to i64
  %streq_cmp = icmp ne i64 %widen97, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

parm_body80:                                      ; preds = %forin.body70
  store i64 ptrtoint (ptr @.str.22 to i64), ptr %pmatch_result78, align 8
  br label %pmatch_end79

parm_next81:                                      ; preds = %forin.body70
  %code88 = load i64, ptr %code, align 8
  %sge89 = icmp sge i64 %code88, 400
  %sge_ext90 = zext i1 %sge89 to i64
  %pguard91 = icmp ne i64 %sge_ext90, 0
  br i1 %pguard91, label %parm_body86, label %parm_next87

parm_body86:                                      ; preds = %parm_next81
  store i64 ptrtoint (ptr @.str.23 to i64), ptr %pmatch_result78, align 8
  br label %pmatch_end79

parm_next87:                                      ; preds = %parm_next81
  br label %parm_body92

parm_body92:                                      ; preds = %parm_next87
  store i64 ptrtoint (ptr @.str.24 to i64), ptr %pmatch_result78, align 8
  br label %pmatch_end79

parm_next93:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.25, i64 -1, ptr @mu_file.26, i64 32)
  unreachable

ifcont:                                           ; preds = %if_else, %if_then
  br label %forin.incr71

if_then:                                          ; preds = %pmatch_end79
  %error_count = load i64, ptr @error_count, align 8
  %add98 = add i64 %error_count, 1
  store i64 %add98, ptr @error_count, align 8
  br label %ifcont

if_else:                                          ; preds = %pmatch_end79
  br label %ifcont

pmatch_end113:                                    ; preds = %parm_body157, %parm_body138, %parm_body121, %parm_body114
  %pmatch_val159 = load i64, ptr %pmatch_result112, align 8
  store i64 %pmatch_val159, ptr @quadrant, align 8
  %quadrant = load ptr, ptr @quadrant, align 8
  %30 = call i32 @puts(ptr %quadrant)
  %widen160 = sext i32 %30 to i64
  %31 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %31, i64 1)
  call void @avra_array_push(ptr %31, i64 -2)
  call void @avra_array_push(ptr %31, i64 3)
  call void @avra_array_push(ptr %31, i64 -4)
  call void @avra_array_push(ptr %31, i64 5)
  call void @avra_array_push(ptr %31, i64 -6)
  call void @avra_array_push(ptr %31, i64 7)
  call void @avra_array_push(ptr %31, i64 -8)
  call void @avra_array_push(ptr %31, i64 9)
  call void @avra_array_push(ptr %31, i64 -10)
  store ptr %31, ptr @data, align 8
  %data = load ptr, ptr @data, align 8
  %32 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %32, i64 -559038737)
  call void @avra_array_push(ptr %32, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast161 = ptrtoint ptr %32 to i64
  %33 = call ptr @avra_array_filter(ptr %data, i64 %cast161)
  store ptr %33, ptr @positive, align 8
  %positive = load ptr, ptr @positive, align 8
  %34 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %34, i64 -559038737)
  call void @avra_array_push(ptr %34, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast162 = ptrtoint ptr %34 to i64
  %35 = call i64 @avra_array_reduce(ptr %positive, i64 0, i64 %cast162)
  store i64 %35, ptr @total, align 8
  %total = load i64, ptr @total, align 8
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.35, i64 %total)
  %widen163 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen164 = sext i32 %38 to i64
  %39 = call ptr @avra_str_split(ptr @.str.36, ptr @.str.37)
  store ptr %39, ptr @words, align 8
  %40 = call ptr @avra_array_new()
  store ptr %40, ptr @long_words, align 8
  %words = load ptr, ptr @words, align 8
  %41 = call i64 @avra_array_len(ptr %words)
  store i64 %41, ptr %forin_len165, align 8
  store i64 0, ptr %forin_i166, align 8
  br label %forin.cond167

parm_body114:                                     ; preds = %sc_merge
  store i64 ptrtoint (ptr @.str.29 to i64), ptr %pmatch_result112, align 8
  br label %pmatch_end113

parm_next115:                                     ; preds = %sc_merge
  %x123 = load i64, ptr %x109, align 8
  %slt = icmp slt i64 %x123, 0
  %slt_ext = zext i1 %slt to i64
  %l_bool124 = icmp ne i64 %slt_ext, 0
  br i1 %l_bool124, label %sc_rhs125, label %sc_short126

sc_rhs:                                           ; preds = %forin.exit72
  %y117 = load i64, ptr %y110, align 8
  %sgt118 = icmp sgt i64 %y117, 0
  %sgt_ext119 = zext i1 %sgt118 to i64
  %r_bool = icmp ne i64 %sgt_ext119, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %forin.exit72
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %pguard120 = icmp ne i64 %sc_ext, 0
  br i1 %pguard120, label %parm_body114, label %parm_next115

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

parm_body121:                                     ; preds = %sc_merge127
  store i64 ptrtoint (ptr @.str.30 to i64), ptr %pmatch_result112, align 8
  br label %pmatch_end113

parm_next122:                                     ; preds = %sc_merge127
  %x140 = load i64, ptr %x109, align 8
  %slt141 = icmp slt i64 %x140, 0
  %slt_ext142 = zext i1 %slt141 to i64
  %l_bool143 = icmp ne i64 %slt_ext142, 0
  br i1 %l_bool143, label %sc_rhs144, label %sc_short145

sc_rhs125:                                        ; preds = %parm_next115
  %y128 = load i64, ptr %y110, align 8
  %sgt129 = icmp sgt i64 %y128, 0
  %sgt_ext130 = zext i1 %sgt129 to i64
  %r_bool131 = icmp ne i64 %sgt_ext130, 0
  br i1 %r_bool131, label %sc_r_true132, label %sc_r_false133

sc_short126:                                      ; preds = %parm_next115
  br label %sc_merge127

sc_merge127:                                      ; preds = %sc_r_merge134, %sc_short126
  %sc_phi135 = phi i1 [ false, %sc_short126 ], [ %r_bool131, %sc_r_merge134 ]
  %sc_ext136 = zext i1 %sc_phi135 to i64
  %pguard137 = icmp ne i64 %sc_ext136, 0
  br i1 %pguard137, label %parm_body121, label %parm_next122

sc_r_true132:                                     ; preds = %sc_rhs125
  br label %sc_r_merge134

sc_r_false133:                                    ; preds = %sc_rhs125
  br label %sc_r_merge134

sc_r_merge134:                                    ; preds = %sc_r_false133, %sc_r_true132
  br label %sc_merge127

parm_body138:                                     ; preds = %sc_merge146
  store i64 ptrtoint (ptr @.str.31 to i64), ptr %pmatch_result112, align 8
  br label %pmatch_end113

parm_next139:                                     ; preds = %sc_merge146
  br label %parm_body157

sc_rhs144:                                        ; preds = %parm_next122
  %y147 = load i64, ptr %y110, align 8
  %slt148 = icmp slt i64 %y147, 0
  %slt_ext149 = zext i1 %slt148 to i64
  %r_bool150 = icmp ne i64 %slt_ext149, 0
  br i1 %r_bool150, label %sc_r_true151, label %sc_r_false152

sc_short145:                                      ; preds = %parm_next122
  br label %sc_merge146

sc_merge146:                                      ; preds = %sc_r_merge153, %sc_short145
  %sc_phi154 = phi i1 [ false, %sc_short145 ], [ %r_bool150, %sc_r_merge153 ]
  %sc_ext155 = zext i1 %sc_phi154 to i64
  %pguard156 = icmp ne i64 %sc_ext155, 0
  br i1 %pguard156, label %parm_body138, label %parm_next139

sc_r_true151:                                     ; preds = %sc_rhs144
  br label %sc_r_merge153

sc_r_false152:                                    ; preds = %sc_rhs144
  br label %sc_r_merge153

sc_r_merge153:                                    ; preds = %sc_r_false152, %sc_r_true151
  br label %sc_merge146

parm_body157:                                     ; preds = %parm_next139
  store i64 ptrtoint (ptr @.str.32 to i64), ptr %pmatch_result112, align 8
  br label %pmatch_end113

parm_next158:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.33, i64 -1, ptr @mu_file.34, i64 45)
  unreachable

forin.cond167:                                    ; preds = %forin.incr169, %pmatch_end113
  %forin_i_val171 = load i64, ptr %forin_i166, align 8
  %forin_len_val172 = load i64, ptr %forin_len165, align 8
  %forin_cmp173 = icmp slt i64 %forin_i_val171, %forin_len_val172
  br i1 %forin_cmp173, label %forin.body168, label %forin.exit170

forin.body168:                                    ; preds = %forin.cond167
  %42 = call i64 @avra_array_get(ptr %words, i64 %forin_i_val171)
  store i64 %42, ptr %w, align 8
  %w174 = load ptr, ptr %w, align 8
  store i64 0, ptr %pmatch_result175, align 8
  %w179 = load ptr, ptr %w, align 8
  %43 = call i64 @strlen(ptr %w179)
  %sge180 = icmp sge i64 %43, 4
  %sge_ext181 = zext i1 %sge180 to i64
  %pguard182 = icmp ne i64 %sge_ext181, 0
  br i1 %pguard182, label %parm_body177, label %parm_next178

forin.incr169:                                    ; preds = %ifcont187
  %forin_i_old193 = load i64, ptr %forin_i166, align 8
  %forin_next194 = add i64 %forin_i_old193, 1
  store i64 %forin_next194, ptr %forin_i166, align 8
  br label %forin.cond167

forin.exit170:                                    ; preds = %forin.cond167
  %long_words195 = load ptr, ptr @long_words, align 8
  %44 = call i64 @avra_array_len(ptr %long_words195)
  store i64 %44, ptr %forin_len196, align 8
  store i64 0, ptr %forin_i197, align 8
  br label %forin.cond198

pmatch_end176:                                    ; preds = %parm_body183, %parm_body177
  %pmatch_val185 = load i64, ptr %pmatch_result175, align 8
  store i64 %pmatch_val185, ptr %keep, align 8
  %keep186 = load i64, ptr %keep, align 8
  %eq = icmp eq i64 %keep186, 1
  %eq_ext = zext i1 %eq to i64
  %if_cond188 = icmp ne i64 %eq_ext, 0
  br i1 %if_cond188, label %if_then189, label %if_else190

parm_body177:                                     ; preds = %forin.body168
  store i64 1, ptr %pmatch_result175, align 8
  br label %pmatch_end176

parm_next178:                                     ; preds = %forin.body168
  br label %parm_body183

parm_body183:                                     ; preds = %parm_next178
  store i64 0, ptr %pmatch_result175, align 8
  br label %pmatch_end176

parm_next184:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.38, i64 -1, ptr @mu_file.39, i64 63)
  unreachable

ifcont187:                                        ; preds = %if_else190, %if_then189
  br label %forin.incr169

if_then189:                                       ; preds = %pmatch_end176
  %long_words = load ptr, ptr @long_words, align 8
  %w191 = load ptr, ptr %w, align 8
  %45 = call ptr @avra_str_to_upper(ptr %w191)
  %cast192 = ptrtoint ptr %45 to i64
  call void @avra_array_push(ptr %long_words, i64 %cast192)
  br label %ifcont187

if_else190:                                       ; preds = %pmatch_end176
  br label %ifcont187

forin.cond198:                                    ; preds = %forin.incr200, %forin.exit170
  %forin_i_val202 = load i64, ptr %forin_i197, align 8
  %forin_len_val203 = load i64, ptr %forin_len196, align 8
  %forin_cmp204 = icmp slt i64 %forin_i_val202, %forin_len_val203
  br i1 %forin_cmp204, label %forin.body199, label %forin.exit201

forin.body199:                                    ; preds = %forin.cond198
  %46 = call i64 @avra_array_get(ptr %long_words195, i64 %forin_i_val202)
  store i64 %46, ptr %lw, align 8
  %lw205 = load i64, ptr %lw, align 8
  %cast206 = inttoptr i64 %lw205 to ptr
  %47 = call i32 @puts(ptr %cast206)
  %widen207 = sext i32 %47 to i64
  br label %forin.incr200

forin.incr200:                                    ; preds = %forin.body199
  %forin_i_old208 = load i64, ptr %forin_i197, align 8
  %forin_next209 = add i64 %forin_i_old208, 1
  store i64 %forin_next209, ptr %forin_i197, align 8
  br label %forin.cond198

forin.exit201:                                    ; preds = %forin.cond198
  %48 = call i32 @avra_test_summary()
  %widen210 = sext i32 %48 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Config(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_1(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %a1 = load i64, ptr %a, align 8
  %b2 = load i64, ptr %b, align 8
  %add = add i64 %a1, %b2
  ret i64 %add
}
