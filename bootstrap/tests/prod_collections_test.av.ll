; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%PcolPoint = type { i64, i64 }

@spec_str = private unnamed_addr constant [19 x i8] c"\22prod collections\22\00", align 1
@spec_str.1 = private unnamed_addr constant [11 x i8] c"\22find max\22\00", align 1
@.str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@spec_str.3 = private unnamed_addr constant [14 x i8] c"\22map has key\22\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"d\00", align 1
@spec_str.7 = private unnamed_addr constant [18 x i8] c"\22map missing key\22\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@spec_str.14 = private unnamed_addr constant [13 x i8] c"\22map length\22\00", align 1
@spec_str.15 = private unnamed_addr constant [25 x i8] c"\22flatten and sum matrix\22\00", align 1
@spec_str.16 = private unnamed_addr constant [18 x i8] c"\22slice mid value\22\00", align 1
@spec_str.17 = private unnamed_addr constant [19 x i8] c"\22slice mid length\22\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [10 x i8] c"PcolPoint\00", align 1
@src_file = private unnamed_addr constant [31 x i8] c"tests/prod_collections_test.fg\00", align 1
@fld_name.18 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.19 = private unnamed_addr constant [10 x i8] c"PcolPoint\00", align 1
@src_file.20 = private unnamed_addr constant [31 x i8] c"tests/prod_collections_test.fg\00", align 1
@fld_name.21 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.22 = private unnamed_addr constant [10 x i8] c"PcolPoint\00", align 1
@src_file.23 = private unnamed_addr constant [31 x i8] c"tests/prod_collections_test.fg\00", align 1
@fld_name.24 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.25 = private unnamed_addr constant [10 x i8] c"PcolPoint\00", align 1
@src_file.26 = private unnamed_addr constant [31 x i8] c"tests/prod_collections_test.fg\00", align 1
@spec_str.27 = private unnamed_addr constant [18 x i8] c"\22struct list map\22\00", align 1
@dz_file = private unnamed_addr constant [31 x i8] c"tests/prod_collections_test.fg\00", align 1
@spec_str.28 = private unnamed_addr constant [22 x i8] c"\22filter reduce evens\22\00", align 1

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare void @forge_test_flush()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

define i64 @pcol_find_max(ptr %0) {
entry:
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %max_val = alloca i64, align 8
  %scores = alloca ptr, align 8
  store ptr %0, ptr %scores, align 8
  %scores1 = load ptr, ptr %scores, align 8
  %1 = call i64 @forge_array_get(ptr %scores1, i64 0)
  store i64 %1, ptr %max_val, align 8
  %scores2 = load ptr, ptr %scores, align 8
  %2 = call i64 @forge_array_len(ptr %scores2)
  store i64 %2, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %3 = call i64 @forge_array_get(ptr %scores2, i64 %forin_i_val)
  store i64 %3, ptr %s, align 8
  %s3 = load i64, ptr %s, align 8
  %max_val4 = load i64, ptr %max_val, align 8
  %sgt = icmp sgt i64 %s3, %max_val4
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

forin.incr:                                       ; preds = %ifcont
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %max_val6 = load i64, ptr %max_val, align 8
  ret i64 %max_val6

ifcont:                                           ; preds = %if_else, %if_then
  br label %forin.incr

if_then:                                          ; preds = %forin.body
  %s5 = load i64, ptr %s, align 8
  store i64 %s5, ptr %max_val, align 8
  br label %ifcont

if_else:                                          ; preds = %forin.body
  br label %ifcont
}

define i64 @pcol_flatten_sum() {
entry:
  %val = alloca i64, align 8
  %forin_i6 = alloca i64, align 8
  %forin_len5 = alloca i64, align 8
  %row = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %flat = alloca ptr, align 8
  %matrix = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 1)
  call void @forge_array_push(ptr %1, i64 2)
  call void @forge_array_push(ptr %1, i64 3)
  %cast = ptrtoint ptr %1 to i64
  call void @forge_array_push(ptr %0, i64 %cast)
  %2 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %2, i64 4)
  call void @forge_array_push(ptr %2, i64 5)
  call void @forge_array_push(ptr %2, i64 6)
  %cast1 = ptrtoint ptr %2 to i64
  call void @forge_array_push(ptr %0, i64 %cast1)
  %3 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %3, i64 7)
  call void @forge_array_push(ptr %3, i64 8)
  call void @forge_array_push(ptr %3, i64 9)
  %cast2 = ptrtoint ptr %3 to i64
  call void @forge_array_push(ptr %0, i64 %cast2)
  store ptr %0, ptr %matrix, align 8
  %4 = call ptr @forge_array_new()
  store ptr %4, ptr %flat, align 8
  %matrix3 = load ptr, ptr %matrix, align 8
  %5 = call i64 @forge_array_len(ptr %matrix3)
  store i64 %5, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %6 = call i64 @forge_array_get(ptr %matrix3, i64 %forin_i_val)
  store i64 %6, ptr %row, align 8
  %row4 = load ptr, ptr %row, align 8
  %7 = call i64 @forge_array_len(ptr %row4)
  store i64 %7, ptr %forin_len5, align 8
  store i64 0, ptr %forin_i6, align 8
  br label %forin.cond7

forin.incr:                                       ; preds = %forin.exit10
  %forin_i_old16 = load i64, ptr %forin_i, align 8
  %forin_next17 = add i64 %forin_i_old16, 1
  store i64 %forin_next17, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %flat18 = load ptr, ptr %flat, align 8
  %8 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %8, i64 -559038737)
  call void @forge_array_push(ptr %8, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast19 = ptrtoint ptr %8 to i64
  %9 = call i64 @forge_array_reduce(ptr %flat18, i64 0, i64 %cast19)
  ret i64 %9

forin.cond7:                                      ; preds = %forin.incr9, %forin.body
  %forin_i_val11 = load i64, ptr %forin_i6, align 8
  %forin_len_val12 = load i64, ptr %forin_len5, align 8
  %forin_cmp13 = icmp slt i64 %forin_i_val11, %forin_len_val12
  br i1 %forin_cmp13, label %forin.body8, label %forin.exit10

forin.body8:                                      ; preds = %forin.cond7
  %10 = call i64 @forge_array_get(ptr %row4, i64 %forin_i_val11)
  store i64 %10, ptr %val, align 8
  %flat14 = load ptr, ptr %flat, align 8
  %val15 = load i64, ptr %val, align 8
  call void @forge_array_push(ptr %flat14, i64 %val15)
  br label %forin.incr9

forin.incr9:                                      ; preds = %forin.body8
  %forin_i_old = load i64, ptr %forin_i6, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i6, align 8
  br label %forin.cond7

forin.exit10:                                     ; preds = %forin.cond7
  br label %forin.incr
}

define i64 @main() {
entry:
  %even_sum = alloca i64, align 8
  %evens = alloca ptr, align 8
  %dists = alloca ptr, align 8
  %points = alloca ptr, align 8
  %mid2 = alloca ptr, align 8
  %nums2 = alloca ptr, align 8
  %mid1 = alloca ptr, align 8
  %nums1 = alloca ptr, align 8
  %counts312 = alloca ptr, align 8
  %counts2 = alloca ptr, align 8
  %counts = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 42)
  call void @forge_array_push(ptr %1, i64 17)
  call void @forge_array_push(ptr %1, i64 93)
  call void @forge_array_push(ptr %1, i64 65)
  call void @forge_array_push(ptr %1, i64 28)
  call void @forge_array_push(ptr %1, i64 81)
  call void @forge_array_push(ptr %1, i64 54)
  %2 = call i64 @pcol_find_max(ptr %1)
  %eq = icmp eq i64 %2, 93
  %eq_ext = zext i1 %eq to i64
  %3 = call i64 @forge_test_run_then(ptr @spec_str.1, i64 %eq_ext)
  %4 = call ptr @forge_map_new_cstr()
  store ptr %4, ptr %counts, align 8
  %counts1 = load ptr, ptr %counts, align 8
  %5 = call ptr @forge_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 1)
  %widen2 = sext i32 %6 to i64
  %cast = ptrtoint ptr %5 to i64
  call void @forge_map_set_cstr(ptr %counts1, ptr @.str, i64 %cast)
  %counts3 = load ptr, ptr %counts, align 8
  %7 = call i64 @forge_map_has_cstr(ptr %counts3, ptr @.str.2)
  %eq4 = icmp eq i64 %7, 1
  %eq_ext5 = zext i1 %eq4 to i64
  %8 = call i64 @forge_test_run_then(ptr @spec_str.3, i64 %eq_ext5)
  %9 = call ptr @forge_map_new_cstr()
  store ptr %9, ptr %counts2, align 8
  %counts26 = load ptr, ptr %counts2, align 8
  %10 = call ptr @forge_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.5, i64 1)
  %widen7 = sext i32 %11 to i64
  %cast8 = ptrtoint ptr %10 to i64
  call void @forge_map_set_cstr(ptr %counts26, ptr @.str.4, i64 %cast8)
  %counts29 = load ptr, ptr %counts2, align 8
  %12 = call i64 @forge_map_has_cstr(ptr %counts29, ptr @.str.6)
  %eq10 = icmp eq i64 %12, 0
  %eq_ext11 = zext i1 %eq10 to i64
  %13 = call i64 @forge_test_run_then(ptr @spec_str.7, i64 %eq_ext11)
  %14 = call ptr @forge_map_new_cstr()
  store ptr %14, ptr %counts312, align 8
  %counts313 = load ptr, ptr %counts312, align 8
  %15 = call ptr @forge_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.9, i64 1)
  %widen14 = sext i32 %16 to i64
  %cast15 = ptrtoint ptr %15 to i64
  call void @forge_map_set_cstr(ptr %counts313, ptr @.str.8, i64 %cast15)
  %counts316 = load ptr, ptr %counts312, align 8
  %17 = call ptr @forge_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.11, i64 2)
  %widen17 = sext i32 %18 to i64
  %cast18 = ptrtoint ptr %17 to i64
  call void @forge_map_set_cstr(ptr %counts316, ptr @.str.10, i64 %cast18)
  %counts319 = load ptr, ptr %counts312, align 8
  %19 = call ptr @forge_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.13, i64 3)
  %widen20 = sext i32 %20 to i64
  %cast21 = ptrtoint ptr %19 to i64
  call void @forge_map_set_cstr(ptr %counts319, ptr @.str.12, i64 %cast21)
  %counts322 = load ptr, ptr %counts312, align 8
  %21 = call i64 @forge_map_len_cstr(ptr %counts322)
  %eq23 = icmp eq i64 %21, 3
  %eq_ext24 = zext i1 %eq23 to i64
  %22 = call i64 @forge_test_run_then(ptr @spec_str.14, i64 %eq_ext24)
  %23 = call i64 @pcol_flatten_sum()
  %eq25 = icmp eq i64 %23, 45
  %eq_ext26 = zext i1 %eq25 to i64
  %24 = call i64 @forge_test_run_then(ptr @spec_str.15, i64 %eq_ext26)
  %25 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %25, i64 10)
  call void @forge_array_push(ptr %25, i64 20)
  call void @forge_array_push(ptr %25, i64 30)
  call void @forge_array_push(ptr %25, i64 40)
  call void @forge_array_push(ptr %25, i64 50)
  store ptr %25, ptr %nums1, align 8
  %nums127 = load ptr, ptr %nums1, align 8
  %26 = call ptr @forge_array_slice(ptr %nums127, i64 1, i64 4)
  store ptr %26, ptr %mid1, align 8
  %mid128 = load ptr, ptr %mid1, align 8
  %27 = call i64 @forge_array_get(ptr %mid128, i64 0)
  %eq29 = icmp eq i64 %27, 20
  %eq_ext30 = zext i1 %eq29 to i64
  %28 = call i64 @forge_test_run_then(ptr @spec_str.16, i64 %eq_ext30)
  %29 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %29, i64 10)
  call void @forge_array_push(ptr %29, i64 20)
  call void @forge_array_push(ptr %29, i64 30)
  call void @forge_array_push(ptr %29, i64 40)
  call void @forge_array_push(ptr %29, i64 50)
  store ptr %29, ptr %nums2, align 8
  %nums231 = load ptr, ptr %nums2, align 8
  %30 = call ptr @forge_array_slice(ptr %nums231, i64 1, i64 4)
  store ptr %30, ptr %mid2, align 8
  %mid232 = load ptr, ptr %mid2, align 8
  %31 = call i64 @forge_array_len(ptr %mid232)
  %eq33 = icmp eq i64 %31, 3
  %eq_ext34 = zext i1 %eq33 to i64
  %32 = call i64 @forge_test_run_then(ptr @spec_str.17, i64 %eq_ext34)
  %33 = call ptr @forge_array_new()
  %34 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %PcolPoint, ptr %34, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr35 = getelementptr inbounds nuw %PcolPoint, ptr %34, i32 0, i32 1
  store i64 2, ptr %fld_ptr35, align 8
  %cast36 = ptrtoint ptr %34 to i64
  call void @forge_array_push(ptr %33, i64 %cast36)
  %35 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr37 = getelementptr inbounds nuw %PcolPoint, ptr %35, i32 0, i32 0
  store i64 3, ptr %fld_ptr37, align 8
  %fld_ptr38 = getelementptr inbounds nuw %PcolPoint, ptr %35, i32 0, i32 1
  store i64 4, ptr %fld_ptr38, align 8
  %cast39 = ptrtoint ptr %35 to i64
  call void @forge_array_push(ptr %33, i64 %cast39)
  store ptr %33, ptr %points, align 8
  %points40 = load ptr, ptr %points, align 8
  %36 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %36, i64 -559038737)
  call void @forge_array_push(ptr %36, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast41 = ptrtoint ptr %36 to i64
  %37 = call ptr @forge_array_map(ptr %points40, i64 %cast41)
  store ptr %37, ptr %dists, align 8
  %dists42 = load ptr, ptr %dists, align 8
  %38 = call i64 @forge_array_get(ptr %dists42, i64 0)
  %eq43 = icmp eq i64 %38, 5
  %eq_ext44 = zext i1 %eq43 to i64
  %39 = call i64 @forge_test_run_then(ptr @spec_str.27, i64 %eq_ext44)
  %40 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %40, i64 1)
  call void @forge_array_push(ptr %40, i64 2)
  call void @forge_array_push(ptr %40, i64 3)
  call void @forge_array_push(ptr %40, i64 4)
  call void @forge_array_push(ptr %40, i64 5)
  call void @forge_array_push(ptr %40, i64 6)
  call void @forge_array_push(ptr %40, i64 7)
  call void @forge_array_push(ptr %40, i64 8)
  call void @forge_array_push(ptr %40, i64 9)
  call void @forge_array_push(ptr %40, i64 10)
  %41 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %41, i64 -559038737)
  call void @forge_array_push(ptr %41, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast45 = ptrtoint ptr %41 to i64
  %42 = call ptr @forge_array_filter(ptr %40, i64 %cast45)
  store ptr %42, ptr %evens, align 8
  %evens46 = load ptr, ptr %evens, align 8
  %43 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %43, i64 -559038737)
  call void @forge_array_push(ptr %43, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast47 = ptrtoint ptr %43 to i64
  %44 = call i64 @forge_array_reduce(ptr %evens46, i64 0, i64 %cast47)
  store i64 %44, ptr %even_sum, align 8
  %even_sum48 = load i64, ptr %even_sum, align 8
  %eq49 = icmp eq i64 %even_sum48, 30
  %eq_ext50 = zext i1 %eq49 to i64
  %45 = call i64 @forge_test_run_then(ptr @spec_str.28, i64 %eq_ext50)
  %46 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen51 = sext i32 %46 to i64
  %47 = call i32 @forge_test_summary()
  %widen52 = sext i32 %47 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0, i64 %1) {
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

define i64 @__lambda_1(ptr %0) {
entry:
  %p = alloca ptr, align 8
  store ptr %0, ptr %p, align 8
  %p1 = load ptr, ptr %p, align 8
  %cast = ptrtoint ptr %p1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 9, i64 %null_ext, ptr @src_file, i64 30, i64 60)
  %x_ptr = getelementptr inbounds nuw %PcolPoint, ptr %p1, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %p2 = load ptr, ptr %p, align 8
  %cast3 = ptrtoint ptr %p2 to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @forge_null_deref_trap(ptr @fld_name.18, i64 1, ptr @sty_name.19, i64 9, i64 %null_ext5, ptr @src_file.20, i64 30, i64 60)
  %x_ptr6 = getelementptr inbounds nuw %PcolPoint, ptr %p2, i32 0, i32 0
  %x7 = load i64, ptr %x_ptr6, align 8
  %mul = mul i64 %x, %x7
  %p8 = load ptr, ptr %p, align 8
  %cast9 = ptrtoint ptr %p8 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @forge_null_deref_trap(ptr @fld_name.21, i64 1, ptr @sty_name.22, i64 9, i64 %null_ext11, ptr @src_file.23, i64 30, i64 60)
  %y_ptr = getelementptr inbounds nuw %PcolPoint, ptr %p8, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %p12 = load ptr, ptr %p, align 8
  %cast13 = ptrtoint ptr %p12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @forge_null_deref_trap(ptr @fld_name.24, i64 1, ptr @sty_name.25, i64 9, i64 %null_ext15, ptr @src_file.26, i64 30, i64 60)
  %y_ptr16 = getelementptr inbounds nuw %PcolPoint, ptr %p12, i32 0, i32 1
  %y17 = load i64, ptr %y_ptr16, align 8
  %mul18 = mul i64 %y, %y17
  %add = add i64 %mul, %mul18
  ret i64 %add
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  call void @forge_div_by_zero_trap(i64 0, ptr @dz_file, i64 30, i64 64)
  %mod = srem i64 %x1, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  ret i64 %eq_ext
}

define i64 @__lambda_3(i64 %0, i64 %1) {
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
