; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Box = type { i64, i64, ptr }
%Shape = type { i64, ptr }
%Counter = type { i64 }
%MaybeBox = type { ptr }

@fld_name = private unnamed_addr constant [6 x i8] c"label\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.str = private unnamed_addr constant [3 x i8] c" (\00", align 1
@fld_name.1 = private unnamed_addr constant [6 x i8] c"width\00", align 1
@sty_name.2 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.3 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@fld_name.5 = private unnamed_addr constant [7 x i8] c"height\00", align 1
@sty_name.6 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.7 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c")\00", align 1
@fld_name.10 = private unnamed_addr constant [6 x i8] c"width\00", align 1
@sty_name.11 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.12 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.13 = private unnamed_addr constant [7 x i8] c"height\00", align 1
@sty_name.14 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.15 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"rect \00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.20 = private unnamed_addr constant [10 x i8] c"circle r=\00", align 1
@.i2s_fmt.21 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [14 x i8] c"Shape__to_str\00", align 1
@mu_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.22 = private unnamed_addr constant [6 x i8] c"start\00", align 1
@sty_name.23 = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file.24 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.25 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.26 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.27 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.28 = private unnamed_addr constant [7 x i8] c"to_str\00", align 1
@sty_name.29 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.30 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.str.31 = private unnamed_addr constant [9 x i8] c" (round)\00", align 1
@fld_name.32 = private unnamed_addr constant [7 x i8] c"to_str\00", align 1
@sty_name.33 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.34 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.str.35 = private unnamed_addr constant [11 x i8] c" (angular)\00", align 1
@fld_name.36 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.37 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.38 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.39 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.40 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.41 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.42 = private unnamed_addr constant [7 x i8] c"to_str\00", align 1
@sty_name.43 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.44 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.str.45 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@fld_name.46 = private unnamed_addr constant [7 x i8] c"to_str\00", align 1
@sty_name.47 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.48 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.49 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.50 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.51 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.i2s_fmt.52 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.53 = private unnamed_addr constant [7 x i8] c"resize\00", align 1
@sty_name.54 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.55 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.56 = private unnamed_addr constant [7 x i8] c"to_str\00", align 1
@sty_name.57 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.58 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.59 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.60 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.61 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.i2s_fmt.62 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.63 = private unnamed_addr constant [7 x i8] c"to_str\00", align 1
@sty_name.64 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.65 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@fld_name.66 = private unnamed_addr constant [7 x i8] c"to_str\00", align 1
@sty_name.67 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.68 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.i2s_fmt.69 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.70 = private unnamed_addr constant [5 x i8] c"tiny\00", align 1
@.i2s_fmt.71 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.72 = private unnamed_addr constant [13 x i8] c"make_counter\00", align 1
@sty_name.73 = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file.74 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.i2s_fmt.75 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.76 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.77 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.i2s_fmt.78 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.79 = private unnamed_addr constant [6 x i8] c"box: \00", align 1
@fld_name.80 = private unnamed_addr constant [7 x i8] c"to_str\00", align 1
@sty_name.81 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.82 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.str.83 = private unnamed_addr constant [9 x i8] c", size: \00", align 1
@fld_name.84 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.85 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.86 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_combo.av\00", align 1
@.i2s_fmt.87 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @Box__to_str(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 97, i64 16)
  %label_ptr = getelementptr inbounds nuw %Box, ptr %self1, i32 0, i32 2
  %label = load ptr, ptr %label_ptr, align 8
  %1 = call i64 @strlen(ptr %label)
  %2 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %label, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr @.str, i64 %rhs_len_p1)
  %self4 = load ptr, ptr %self, align 8
  %cast5 = ptrtoint ptr %self4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 5, ptr @sty_name.2, i64 3, i64 %null_ext7, ptr @src_file.3, i64 97, i64 16)
  %width_ptr = getelementptr inbounds nuw %Box, ptr %self4, i32 0, i32 0
  %width = load i64, ptr %width_ptr, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %width)
  %widen = sext i32 %7 to i64
  %8 = call i64 @strlen(ptr %3)
  %9 = call i64 @strlen(ptr %6)
  %concat_total8 = add i64 %8, %9
  %concat_size9 = add i64 %concat_total8, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %11 = call ptr @memcpy(ptr %10, ptr %3, i64 %8)
  %cast10 = ptrtoint ptr %10 to i64
  %dst2_int11 = add i64 %cast10, %8
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast12, ptr %6, i64 %rhs_len_p113)
  %13 = call i64 @strlen(ptr %10)
  %14 = call i64 @strlen(ptr @.str.4)
  %concat_total14 = add i64 %13, %14
  %concat_size15 = add i64 %concat_total14, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %16 = call ptr @memcpy(ptr %15, ptr %10, i64 %13)
  %cast16 = ptrtoint ptr %15 to i64
  %dst2_int17 = add i64 %cast16, %13
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast18, ptr @.str.4, i64 %rhs_len_p119)
  %self20 = load ptr, ptr %self, align 8
  %cast21 = ptrtoint ptr %self20 to i64
  %null_chk22 = icmp eq i64 %cast21, 0
  %null_ext23 = zext i1 %null_chk22 to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 6, ptr @sty_name.6, i64 3, i64 %null_ext23, ptr @src_file.7, i64 97, i64 16)
  %height_ptr = getelementptr inbounds nuw %Box, ptr %self20, i32 0, i32 1
  %height = load i64, ptr %height_ptr, align 8
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.8, i64 %height)
  %widen24 = sext i32 %19 to i64
  %20 = call i64 @strlen(ptr %15)
  %21 = call i64 @strlen(ptr %18)
  %concat_total25 = add i64 %20, %21
  %concat_size26 = add i64 %concat_total25, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %23 = call ptr @memcpy(ptr %22, ptr %15, i64 %20)
  %cast27 = ptrtoint ptr %22 to i64
  %dst2_int28 = add i64 %cast27, %20
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast29, ptr %18, i64 %rhs_len_p130)
  %25 = call i64 @strlen(ptr %22)
  %26 = call i64 @strlen(ptr @.str.9)
  %concat_total31 = add i64 %25, %26
  %concat_size32 = add i64 %concat_total31, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %28 = call ptr @memcpy(ptr %27, ptr %22, i64 %25)
  %cast33 = ptrtoint ptr %27 to i64
  %dst2_int34 = add i64 %cast33, %25
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast35, ptr @.str.9, i64 %rhs_len_p136)
  ret ptr %27
}

define i64 @Box__size(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 5, ptr @sty_name.11, i64 3, i64 %null_ext, ptr @src_file.12, i64 97, i64 22)
  %width_ptr = getelementptr inbounds nuw %Box, ptr %self1, i32 0, i32 0
  %width = load i64, ptr %width_ptr, align 8
  %self2 = load ptr, ptr %self, align 8
  %cast3 = ptrtoint ptr %self2 to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 6, ptr @sty_name.14, i64 3, i64 %null_ext5, ptr @src_file.15, i64 97, i64 22)
  %height_ptr = getelementptr inbounds nuw %Box, ptr %self2, i32 0, i32 1
  %height = load i64, ptr %height_ptr, align 8
  %mul = mul i64 %width, %height
  ret i64 %mul
}

define ptr @Shape__to_str(ptr %0) {
entry:
  %r28 = alloca i64, align 8
  %h5 = alloca i64, align 8
  %w2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm23, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast38 = inttoptr i64 %match_val to ptr
  ret ptr %cast38

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %w_slot_base = ptrtoint ptr %payload to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load i64, ptr %w_slot, align 8
  store i64 %w, ptr %w2, align 8
  %pay_slot3 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload4 = load ptr, ptr %pay_slot3, align 8
  %h_slot_base = ptrtoint ptr %payload4 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h5, align 8
  %w6 = load i64, ptr %w2, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.17, i64 %w6)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.16)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.16, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast7 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast7, ptr %1, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.18)
  %concat_total8 = add i64 %8, %9
  %concat_size9 = add i64 %concat_total8, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast10 = ptrtoint ptr %10 to i64
  %dst2_int11 = add i64 %cast10, %8
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast12, ptr @.str.18, i64 %rhs_len_p113)
  %h14 = load i64, ptr %h5, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.19, i64 %h14)
  %widen15 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr %10)
  %16 = call i64 @strlen(ptr %13)
  %concat_total16 = add i64 %15, %16
  %concat_size17 = add i64 %concat_total16, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %18 = call ptr @memcpy(ptr %17, ptr %10, i64 %15)
  %cast18 = ptrtoint ptr %17 to i64
  %dst2_int19 = add i64 %cast18, %15
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast20, ptr %13, i64 %rhs_len_p121)
  %cast22 = ptrtoint ptr %17 to i64
  store i64 %cast22, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq25 = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq25, label %march_arm23, label %march_next24

march_arm23:                                      ; preds = %march_next
  %pay_slot26 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload27 = load ptr, ptr %pay_slot26, align 8
  %r_slot_base = ptrtoint ptr %payload27 to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r28, align 8
  %r29 = load i64, ptr %r28, align 8
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.21, i64 %r29)
  %widen30 = sext i32 %21 to i64
  %22 = call i64 @strlen(ptr @.str.20)
  %23 = call i64 @strlen(ptr %20)
  %concat_total31 = add i64 %22, %23
  %concat_size32 = add i64 %concat_total31, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.20, i64 %22)
  %cast33 = ptrtoint ptr %24 to i64
  %dst2_int34 = add i64 %cast33, %22
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast35, ptr %20, i64 %rhs_len_p136)
  %cast37 = ptrtoint ptr %24 to i64
  store i64 %cast37, ptr %match_result, align 8
  br label %match_end

march_next24:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 34)
  unreachable
}

define ptr @Counter__make_counter(ptr %0) {
entry:
  %base = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.22, i64 5, ptr @sty_name.23, i64 7, i64 %null_ext, ptr @src_file.24, i64 97, i64 46)
  %start_ptr = getelementptr inbounds nuw %Counter, ptr %self1, i32 0, i32 0
  %start = load i64, ptr %start_ptr, align 8
  store i64 %start, ptr %base, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %base, align 8
  call void @avra_array_push(ptr %1, i64 %cap_val)
  %cast2 = ptrtoint ptr %1 to i64
  %cast3 = inttoptr i64 %cast2 to ptr
  ret ptr %cast3
}

define ptr @Box__resize(ptr %0, i64 %1, i64 %2) {
entry:
  %h = alloca i64, align 8
  %w = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  store i64 %1, ptr %w, align 8
  store i64 %2, ptr %h, align 8
  %self1 = load ptr, ptr %self, align 8
  %3 = call ptr @avra_rc_alloc(i64 24)
  %with_cp_src = getelementptr inbounds nuw %Box, ptr %self1, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Box, ptr %3, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Box, ptr %self1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Box, ptr %3, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %Box, ptr %self1, i32 0, i32 2
  %with_cp_val6 = load ptr, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %Box, ptr %3, i32 0, i32 2
  store ptr %with_cp_val6, ptr %with_cp_dst7, align 8
  %w8 = load i64, ptr %w, align 8
  %with_ovr = getelementptr inbounds nuw %Box, ptr %3, i32 0, i32 0
  store i64 %w8, ptr %with_ovr, align 8
  %h9 = load i64, ptr %h, align 8
  %with_ovr10 = getelementptr inbounds nuw %Box, ptr %3, i32 0, i32 1
  store i64 %h9, ptr %with_ovr10, align 8
  %cast = ptrtoint ptr %3 to i64
  %cast11 = inttoptr i64 %cast to ptr
  ret ptr %cast11
}

define i1 @is_big(ptr %0) {
entry:
  %b = alloca ptr, align 8
  store ptr %0, ptr %b, align 8
  %b1 = load ptr, ptr %b, align 8
  %cast = ptrtoint ptr %b1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.25, i64 4, ptr @sty_name.26, i64 3, i64 %null_ext, ptr @src_file.27, i64 97, i64 63)
  %1 = call i64 @Box__size(ptr %b1)
  %sgt = icmp sgt i64 %1, 50
  %sgt_ext = zext i1 %sgt to i64
  %cast2 = trunc i64 %sgt_ext to i1
  ret i1 %cast2
}

define ptr @describe_shape(ptr %0) {
entry:
  %sif_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 6952139942519
  %is_eq_ext = zext i1 %is_eq to i64
  %sif_cond = icmp ne i64 %is_eq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %s2 = load ptr, ptr %s, align 8
  %cast = ptrtoint ptr %s2 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.28, i64 6, ptr @sty_name.29, i64 5, i64 %null_ext, ptr @src_file.30, i64 97, i64 69)
  %1 = call ptr @Shape__to_str(ptr %s2)
  %2 = call i64 @strlen(ptr %1)
  %3 = call i64 @strlen(ptr @.str.31)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr %1, i64 %2)
  %cast3 = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast3, %2
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast4, ptr @.str.31, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %4 to i64
  store i64 %cast5, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %s6 = load ptr, ptr %s, align 8
  %cast7 = ptrtoint ptr %s6 to i64
  %null_chk8 = icmp eq i64 %cast7, 0
  %null_ext9 = zext i1 %null_chk8 to i64
  call void @avra_null_deref_trap(ptr @fld_name.32, i64 6, ptr @sty_name.33, i64 5, i64 %null_ext9, ptr @src_file.34, i64 97, i64 71)
  %7 = call ptr @Shape__to_str(ptr %s6)
  %8 = call i64 @strlen(ptr %7)
  %9 = call i64 @strlen(ptr @.str.35)
  %concat_total10 = add i64 %8, %9
  %concat_size11 = add i64 %concat_total10, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size11)
  %11 = call ptr @memcpy(ptr %10, ptr %7, i64 %8)
  %cast12 = ptrtoint ptr %10 to i64
  %dst2_int13 = add i64 %cast12, %8
  %cast14 = inttoptr i64 %dst2_int13 to ptr
  %rhs_len_p115 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast14, ptr @.str.35, i64 %rhs_len_p115)
  %cast16 = ptrtoint ptr %10 to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast17 = inttoptr i64 %sif_val to ptr
  ret ptr %cast17
}

define i64 @sum_two_boxes(ptr %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %cast = ptrtoint ptr %a1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.36, i64 4, ptr @sty_name.37, i64 3, i64 %null_ext, ptr @src_file.38, i64 97, i64 78)
  %2 = call i64 @Box__size(ptr %a1)
  %b2 = load ptr, ptr %b, align 8
  %cast3 = ptrtoint ptr %b2 to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @avra_null_deref_trap(ptr @fld_name.39, i64 4, ptr @sty_name.40, i64 3, i64 %null_ext5, ptr @src_file.41, i64 97, i64 78)
  %3 = call i64 @Box__size(ptr %b2)
  %add = add i64 %2, %3
  ret i64 %add
}

define ptr @box_to_str(ptr %0) {
entry:
  %b = alloca ptr, align 8
  store ptr %0, ptr %b, align 8
  %b1 = load ptr, ptr %b, align 8
  %cast = ptrtoint ptr %b1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.42, i64 6, ptr @sty_name.43, i64 3, i64 %null_ext, ptr @src_file.44, i64 97, i64 82)
  %1 = call ptr @Box__to_str(ptr %b1)
  ret ptr %1
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %b3 = alloca ptr, align 8
  %a = alloca ptr, align 8
  %add = alloca ptr, align 8
  %c = alloca ptr, align 8
  %c_copy = alloca %Counter, align 8
  %s2 = alloca ptr, align 8
  %s1 = alloca ptr, align 8
  %b2 = alloca ptr, align 8
  %b = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr = getelementptr inbounds nuw %Box, ptr %1, i32 0, i32 0
  store i64 10, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Box, ptr %1, i32 0, i32 1
  store i64 5, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Box, ptr %1, i32 0, i32 2
  store ptr @.str.45, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %b, align 8
  %b4 = load ptr, ptr %b, align 8
  %cast5 = ptrtoint ptr %b4 to i64
  %null_chk = icmp eq i64 %cast5, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.46, i64 6, ptr @sty_name.47, i64 3, i64 %null_ext, ptr @src_file.48, i64 97, i64 88)
  %2 = call ptr @Box__to_str(ptr %b4)
  %3 = call i32 @puts(ptr %2)
  %widen = sext i32 %3 to i64
  %b6 = load ptr, ptr %b, align 8
  %cast7 = ptrtoint ptr %b6 to i64
  %null_chk8 = icmp eq i64 %cast7, 0
  %null_ext9 = zext i1 %null_chk8 to i64
  call void @avra_null_deref_trap(ptr @fld_name.49, i64 4, ptr @sty_name.50, i64 3, i64 %null_ext9, ptr @src_file.51, i64 97, i64 89)
  %4 = call i64 @Box__size(ptr %b6)
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.52, i64 %4)
  %widen10 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen11 = sext i32 %7 to i64
  %b12 = load ptr, ptr %b, align 8
  %cast13 = ptrtoint ptr %b12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.53, i64 6, ptr @sty_name.54, i64 3, i64 %null_ext15, ptr @src_file.55, i64 97, i64 92)
  %8 = call ptr @Box__resize(ptr %b12, i64 20, i64 3)
  store ptr %8, ptr %b2, align 8
  %b216 = load ptr, ptr %b2, align 8
  %cast17 = ptrtoint ptr %b216 to i64
  %null_chk18 = icmp eq i64 %cast17, 0
  %null_ext19 = zext i1 %null_chk18 to i64
  call void @avra_null_deref_trap(ptr @fld_name.56, i64 6, ptr @sty_name.57, i64 3, i64 %null_ext19, ptr @src_file.58, i64 97, i64 93)
  %9 = call ptr @Box__to_str(ptr %b216)
  %10 = call i32 @puts(ptr %9)
  %widen20 = sext i32 %10 to i64
  %b221 = load ptr, ptr %b2, align 8
  %cast22 = ptrtoint ptr %b221 to i64
  %null_chk23 = icmp eq i64 %cast22, 0
  %null_ext24 = zext i1 %null_chk23 to i64
  call void @avra_null_deref_trap(ptr @fld_name.59, i64 4, ptr @sty_name.60, i64 3, i64 %null_ext24, ptr @src_file.61, i64 97, i64 94)
  %11 = call i64 @Box__size(ptr %b221)
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.62, i64 %11)
  %widen25 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen26 = sext i32 %14 to i64
  %15 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %15, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %15, i32 0, i32 1
  %16 = call ptr @avra_rc_alloc(i64 16)
  store ptr %16, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %16 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 4, ptr %slot, align 8
  %slot_base27 = ptrtoint ptr %16 to i64
  %slot_addr28 = add i64 %slot_base27, 8
  %slot29 = inttoptr i64 %slot_addr28 to ptr
  store i64 6, ptr %slot29, align 8
  %cast30 = ptrtoint ptr %15 to i64
  %cast31 = inttoptr i64 %cast30 to ptr
  store ptr %cast31, ptr %s1, align 8
  %17 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr32 = getelementptr inbounds nuw %Shape, ptr %17, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr32, align 8
  %pay_ptr33 = getelementptr inbounds nuw %Shape, ptr %17, i32 0, i32 1
  %18 = call ptr @avra_rc_alloc(i64 8)
  store ptr %18, ptr %pay_ptr33, align 8
  %slot_base34 = ptrtoint ptr %18 to i64
  %slot_addr35 = add i64 %slot_base34, 0
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  store i64 3, ptr %slot36, align 8
  %cast37 = ptrtoint ptr %17 to i64
  %cast38 = inttoptr i64 %cast37 to ptr
  store ptr %cast38, ptr %s2, align 8
  %s139 = load ptr, ptr %s1, align 8
  %cast40 = ptrtoint ptr %s139 to i64
  %null_chk41 = icmp eq i64 %cast40, 0
  %null_ext42 = zext i1 %null_chk41 to i64
  call void @avra_null_deref_trap(ptr @fld_name.63, i64 6, ptr @sty_name.64, i64 5, i64 %null_ext42, ptr @src_file.65, i64 97, i64 99)
  %19 = call ptr @Shape__to_str(ptr %s139)
  %20 = call i32 @puts(ptr %19)
  %widen43 = sext i32 %20 to i64
  %s244 = load ptr, ptr %s2, align 8
  %cast45 = ptrtoint ptr %s244 to i64
  %null_chk46 = icmp eq i64 %cast45, 0
  %null_ext47 = zext i1 %null_chk46 to i64
  call void @avra_null_deref_trap(ptr @fld_name.66, i64 6, ptr @sty_name.67, i64 5, i64 %null_ext47, ptr @src_file.68, i64 97, i64 100)
  %21 = call ptr @Shape__to_str(ptr %s244)
  %22 = call i32 @puts(ptr %21)
  %widen48 = sext i32 %22 to i64
  %b49 = load ptr, ptr %b, align 8
  %23 = call i1 @is_big(ptr %b49)
  %widen50 = zext i1 %23 to i64
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.69, i64 %widen50)
  %widen51 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen52 = sext i32 %26 to i64
  %27 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr53 = getelementptr inbounds nuw %Box, ptr %27, i32 0, i32 0
  store i64 2, ptr %fld_ptr53, align 8
  %fld_ptr54 = getelementptr inbounds nuw %Box, ptr %27, i32 0, i32 1
  store i64 2, ptr %fld_ptr54, align 8
  %fld_ptr55 = getelementptr inbounds nuw %Box, ptr %27, i32 0, i32 2
  store ptr @.str.70, ptr %fld_ptr55, align 8
  %cast56 = ptrtoint ptr %27 to i64
  %cast57 = inttoptr i64 %cast56 to ptr
  %28 = call i1 @is_big(ptr %cast57)
  %widen58 = zext i1 %28 to i64
  %29 = call ptr @avra_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.71, i64 %widen58)
  %widen59 = sext i32 %30 to i64
  %31 = call i32 @puts(ptr %29)
  %widen60 = sext i32 %31 to i64
  %s161 = load ptr, ptr %s1, align 8
  %32 = call ptr @describe_shape(ptr %s161)
  %33 = call i32 @puts(ptr %32)
  %widen62 = sext i32 %33 to i64
  %s263 = load ptr, ptr %s2, align 8
  %34 = call ptr @describe_shape(ptr %s263)
  %35 = call i32 @puts(ptr %34)
  %widen64 = sext i32 %35 to i64
  %fld_ptr65 = getelementptr inbounds nuw %Counter, ptr %c_copy, i32 0, i32 0
  store i64 100, ptr %fld_ptr65, align 8
  %cast66 = ptrtoint ptr %c_copy to i64
  %cast67 = inttoptr i64 %cast66 to ptr
  store ptr %cast67, ptr %c, align 8
  %c68 = load ptr, ptr %c, align 8
  %cast69 = ptrtoint ptr %c68 to i64
  %null_chk70 = icmp eq i64 %cast69, 0
  %null_ext71 = zext i1 %null_chk70 to i64
  call void @avra_null_deref_trap(ptr @fld_name.72, i64 12, ptr @sty_name.73, i64 7, i64 %null_ext71, ptr @src_file.74, i64 97, i64 112)
  %36 = call ptr @Counter__make_counter(ptr %c68)
  store ptr %36, ptr %add, align 8
  %add72 = load i64, ptr %add, align 8
  %37 = call i64 @avra_closure_call_1(i64 %add72, i64 5)
  %38 = call ptr @avra_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.75, i64 %37)
  %widen73 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen74 = sext i32 %40 to i64
  %41 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr75 = getelementptr inbounds nuw %Box, ptr %41, i32 0, i32 0
  store i64 3, ptr %fld_ptr75, align 8
  %fld_ptr76 = getelementptr inbounds nuw %Box, ptr %41, i32 0, i32 1
  store i64 4, ptr %fld_ptr76, align 8
  %fld_ptr77 = getelementptr inbounds nuw %Box, ptr %41, i32 0, i32 2
  store ptr @.str.76, ptr %fld_ptr77, align 8
  %cast78 = ptrtoint ptr %41 to i64
  %cast79 = inttoptr i64 %cast78 to ptr
  store ptr %cast79, ptr %a, align 8
  %42 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr80 = getelementptr inbounds nuw %Box, ptr %42, i32 0, i32 0
  store i64 5, ptr %fld_ptr80, align 8
  %fld_ptr81 = getelementptr inbounds nuw %Box, ptr %42, i32 0, i32 1
  store i64 6, ptr %fld_ptr81, align 8
  %fld_ptr82 = getelementptr inbounds nuw %Box, ptr %42, i32 0, i32 2
  store ptr @.str.77, ptr %fld_ptr82, align 8
  %cast83 = ptrtoint ptr %42 to i64
  %cast84 = inttoptr i64 %cast83 to ptr
  store ptr %cast84, ptr %b3, align 8
  %a85 = load ptr, ptr %a, align 8
  %b386 = load ptr, ptr %b3, align 8
  %43 = call i64 @sum_two_boxes(ptr %a85, ptr %b386)
  %44 = call ptr @avra_rc_alloc(i64 32)
  %45 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %44, i64 32, ptr @.i2s_fmt.78, i64 %43)
  %widen87 = sext i32 %45 to i64
  %46 = call i32 @puts(ptr %44)
  %widen88 = sext i32 %46 to i64
  %b89 = load ptr, ptr %b, align 8
  %47 = call ptr @box_to_str(ptr %b89)
  %48 = call i32 @puts(ptr %47)
  %widen90 = sext i32 %48 to i64
  %b91 = load ptr, ptr %b, align 8
  %cast92 = ptrtoint ptr %b91 to i64
  %null_chk93 = icmp eq i64 %cast92, 0
  %null_ext94 = zext i1 %null_chk93 to i64
  call void @avra_null_deref_trap(ptr @fld_name.80, i64 6, ptr @sty_name.81, i64 3, i64 %null_ext94, ptr @src_file.82, i64 97, i64 124)
  %49 = call ptr @Box__to_str(ptr %b91)
  %50 = call i64 @strlen(ptr @.str.79)
  %51 = call i64 @strlen(ptr %49)
  %concat_total = add i64 %50, %51
  %concat_size = add i64 %concat_total, 1
  %52 = call ptr @avra_rc_alloc(i64 %concat_size)
  %53 = call ptr @memcpy(ptr %52, ptr @.str.79, i64 %50)
  %cast95 = ptrtoint ptr %52 to i64
  %dst2_int = add i64 %cast95, %50
  %cast96 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %51, 1
  %54 = call ptr @memcpy(ptr %cast96, ptr %49, i64 %rhs_len_p1)
  %55 = call i64 @strlen(ptr %52)
  %56 = call i64 @strlen(ptr @.str.83)
  %concat_total97 = add i64 %55, %56
  %concat_size98 = add i64 %concat_total97, 1
  %57 = call ptr @avra_rc_alloc(i64 %concat_size98)
  %58 = call ptr @memcpy(ptr %57, ptr %52, i64 %55)
  %cast99 = ptrtoint ptr %57 to i64
  %dst2_int100 = add i64 %cast99, %55
  %cast101 = inttoptr i64 %dst2_int100 to ptr
  %rhs_len_p1102 = add i64 %56, 1
  %59 = call ptr @memcpy(ptr %cast101, ptr @.str.83, i64 %rhs_len_p1102)
  %b103 = load ptr, ptr %b, align 8
  %cast104 = ptrtoint ptr %b103 to i64
  %null_chk105 = icmp eq i64 %cast104, 0
  %null_ext106 = zext i1 %null_chk105 to i64
  call void @avra_null_deref_trap(ptr @fld_name.84, i64 4, ptr @sty_name.85, i64 3, i64 %null_ext106, ptr @src_file.86, i64 97, i64 124)
  %60 = call i64 @Box__size(ptr %b103)
  %61 = call ptr @avra_rc_alloc(i64 32)
  %62 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %61, i64 32, ptr @.i2s_fmt.87, i64 %60)
  %widen107 = sext i32 %62 to i64
  %63 = call i64 @strlen(ptr %57)
  %64 = call i64 @strlen(ptr %61)
  %concat_total108 = add i64 %63, %64
  %concat_size109 = add i64 %concat_total108, 1
  %65 = call ptr @avra_rc_alloc(i64 %concat_size109)
  %66 = call ptr @memcpy(ptr %65, ptr %57, i64 %63)
  %cast110 = ptrtoint ptr %65 to i64
  %dst2_int111 = add i64 %cast110, %63
  %cast112 = inttoptr i64 %dst2_int111 to ptr
  %rhs_len_p1113 = add i64 %64, 1
  %67 = call ptr @memcpy(ptr %cast112, ptr %61, i64 %rhs_len_p1113)
  %68 = call i32 @puts(ptr %65)
  %widen114 = sext i32 %68 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_MaybeBox(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_inner_ptr = getelementptr inbounds nuw %MaybeBox, ptr %0, i32 0, i32 0
  %rel_inner = load ptr, ptr %rel_inner_ptr, align 8
  %is_null_inner = icmp eq ptr %rel_inner, null
  br i1 %is_null_inner, label %rel_inner_skip, label %rel_inner_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_inner_skip
  ret i64 0

rel_inner_skip:                                   ; preds = %rel_inner_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_inner_do:                                     ; preds = %do_free
  %2 = call i64 @__release_Box(ptr %rel_inner)
  br label %rel_inner_skip
}

define i64 @__release_Box(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_label_ptr = getelementptr inbounds nuw %Box, ptr %0, i32 0, i32 2
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

define i64 @__lambda_0(i64 %0, i64 %1) {
entry:
  %base = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  store i64 %1, ptr %base, align 8
  %n1 = load i64, ptr %n, align 8
  %base2 = load i64, ptr %base, align 8
  %add = add i64 %n1, %base2
  ret i64 %add
}
