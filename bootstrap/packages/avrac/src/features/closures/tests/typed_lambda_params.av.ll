; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@csv = global i64 0
@values = global i64 0
@total = global i64 0
@upper_parts = global i64 0
@long_words = global i64 0
@.str = private unnamed_addr constant [15 x i8] c"10,20,30,40,50\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"hello,world\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"hi\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"hey\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"greetings\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"c\00", align 1

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
  %w = alloca i64, align 8
  %forin_i7 = alloca i64, align 8
  %forin_len6 = alloca i64, align 8
  %p = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  store ptr @.str, ptr @csv, align 8
  %csv = load ptr, ptr @csv, align 8
  %0 = call ptr @avra_str_split(ptr %csv, ptr @.str.1)
  store ptr %0, ptr @values, align 8
  %values = load ptr, ptr @values, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %1 to i64
  %2 = call i64 @avra_array_reduce(ptr %values, i64 0, i64 %cast)
  store i64 %2, ptr @total, align 8
  %total = load i64, ptr @total, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %total)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen1 = sext i32 %5 to i64
  %6 = call ptr @avra_str_split(ptr @.str.2, ptr @.str.3)
  %7 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %7, i64 -559038737)
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast2 = ptrtoint ptr %7 to i64
  %8 = call ptr @avra_array_map(ptr %6, i64 %cast2)
  store ptr %8, ptr @upper_parts, align 8
  %upper_parts = load ptr, ptr @upper_parts, align 8
  %9 = call i64 @avra_array_len(ptr %upper_parts)
  store i64 %9, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %10 = call i64 @avra_array_get(ptr %upper_parts, i64 %forin_i_val)
  store i64 %10, ptr %p, align 8
  %p3 = load ptr, ptr %p, align 8
  %11 = call i32 @puts(ptr %p3)
  %widen4 = sext i32 %11 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %12 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %12, i64 ptrtoint (ptr @.str.4 to i64))
  call void @avra_array_push(ptr %12, i64 ptrtoint (ptr @.str.5 to i64))
  call void @avra_array_push(ptr %12, i64 ptrtoint (ptr @.str.6 to i64))
  call void @avra_array_push(ptr %12, i64 ptrtoint (ptr @.str.7 to i64))
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 -559038737)
  call void @avra_array_push(ptr %13, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast5 = ptrtoint ptr %13 to i64
  %14 = call ptr @avra_array_filter(ptr %12, i64 %cast5)
  store ptr %14, ptr @long_words, align 8
  %long_words = load ptr, ptr @long_words, align 8
  %15 = call i64 @avra_array_len(ptr %long_words)
  store i64 %15, ptr %forin_len6, align 8
  store i64 0, ptr %forin_i7, align 8
  br label %forin.cond8

forin.cond8:                                      ; preds = %forin.incr10, %forin.exit
  %forin_i_val12 = load i64, ptr %forin_i7, align 8
  %forin_len_val13 = load i64, ptr %forin_len6, align 8
  %forin_cmp14 = icmp slt i64 %forin_i_val12, %forin_len_val13
  br i1 %forin_cmp14, label %forin.body9, label %forin.exit11

forin.body9:                                      ; preds = %forin.cond8
  %16 = call i64 @avra_array_get(ptr %long_words, i64 %forin_i_val12)
  store i64 %16, ptr %w, align 8
  %w15 = load ptr, ptr %w, align 8
  %17 = call i32 @puts(ptr %w15)
  %widen16 = sext i32 %17 to i64
  br label %forin.incr10

forin.incr10:                                     ; preds = %forin.body9
  %forin_i_old17 = load i64, ptr %forin_i7, align 8
  %forin_next18 = add i64 %forin_i_old17, 1
  store i64 %forin_next18, ptr %forin_i7, align 8
  br label %forin.cond8

forin.exit11:                                     ; preds = %forin.cond8
  %18 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %18, i64 ptrtoint (ptr @.str.8 to i64))
  call void @avra_array_push(ptr %18, i64 ptrtoint (ptr @.str.9 to i64))
  call void @avra_array_push(ptr %18, i64 ptrtoint (ptr @.str.10 to i64))
  %19 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %19, i64 -559038737)
  call void @avra_array_push(ptr %19, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast19 = ptrtoint ptr %19 to i64
  call void @avra_array_foreach(ptr %18, i64 %cast19)
  %20 = call i32 @avra_test_summary()
  %widen20 = sext i32 %20 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store ptr %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load ptr, ptr %x, align 8
  %2 = call i64 @avra_parse_int(ptr %x2)
  %add = add i64 %acc1, %2
  ret i64 %add
}

define i64 @__lambda_1(ptr %0) {
entry:
  %x = alloca ptr, align 8
  store ptr %0, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %1 = call ptr @avra_str_to_upper(ptr %x1)
  %cast = ptrtoint ptr %1 to i64
  ret i64 %cast
}

define i64 @__lambda_2(ptr %0) {
entry:
  %w = alloca ptr, align 8
  store ptr %0, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %1 = call i64 @strlen(ptr %w1)
  %sgt = icmp sgt i64 %1, 3
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_3(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call ptr @avra_str_to_upper(ptr %s1)
  %2 = call i32 @puts(ptr %1)
  %widen = sext i32 %2 to i64
  ret i64 0
}
