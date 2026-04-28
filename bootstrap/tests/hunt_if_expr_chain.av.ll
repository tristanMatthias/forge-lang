; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@x = global i64 0
@label = global i64 0
@msg = global i64 0
@.str = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"medium\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"value is \00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"high\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"low\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"yes\00", align 1
@.str.12 = private unnamed_addr constant [3 x i8] c"no\00", align 1

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
  %sif_result7 = alloca i64, align 8
  %sif_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sgt = icmp sgt i64 %n1, 0
  %sgt_ext = zext i1 %sgt to i64
  %sif_cond = icmp ne i64 %sgt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  %slt = icmp slt i64 %n2, 0
  %slt_ext = zext i1 %slt to i64
  %sif_cond3 = icmp ne i64 %slt_ext, 0
  store i64 0, ptr %sif_result7, align 8
  br i1 %sif_cond3, label %sif_then4, label %sif_else5

sif_end:                                          ; preds = %sif_end6, %sif_then
  %sif_val8 = load i64, ptr %sif_result, align 8
  %cast = inttoptr i64 %sif_val8 to ptr
  ret ptr %cast

sif_then4:                                        ; preds = %sif_else
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %sif_result7, align 8
  br label %sif_end6

sif_else5:                                        ; preds = %sif_else
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %sif_result7, align 8
  br label %sif_end6

sif_end6:                                         ; preds = %sif_else5, %sif_then4
  %sif_val = load i64, ptr %sif_result7, align 8
  store i64 %sif_val, ptr %sif_result, align 8
  br label %sif_end
}

define ptr @shout(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i64 @strlen(ptr %s1)
  %2 = call i64 @strlen(ptr @.str.3)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %s1, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast2, ptr @.str.3, i64 %rhs_len_p1)
  ret ptr %3
}

define i64 @main() {
entry:
  %ife_result33 = alloca i64, align 8
  %ife_result25 = alloca i64, align 8
  %ife_result12 = alloca i64, align 8
  %ife_result4 = alloca i64, align 8
  %ife_result = alloca i64, align 8
  store i64 10, ptr @x, align 8
  %x = load i64, ptr @x, align 8
  %sgt = icmp sgt i64 %x, 100
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_end5, %ife_then
  %ife_val18 = load i64, ptr %ife_result, align 8
  store i64 %ife_val18, ptr @label, align 8
  %label = load ptr, ptr @label, align 8
  %0 = call i32 @puts(ptr %label)
  %widen = sext i32 %0 to i64
  %1 = call ptr @classify(i64 5)
  %2 = call i32 @puts(ptr %1)
  %widen19 = sext i32 %2 to i64
  %3 = call ptr @classify(i64 -3)
  %4 = call i32 @puts(ptr %3)
  %widen20 = sext i32 %4 to i64
  %5 = call ptr @classify(i64 0)
  %6 = call i32 @puts(ptr %5)
  %widen21 = sext i32 %6 to i64
  %x22 = load i64, ptr @x, align 8
  %sgt23 = icmp sgt i64 %x22, 5
  %sgt_ext24 = zext i1 %sgt23 to i64
  %ife_cond27 = icmp ne i64 %sgt_ext24, 0
  br i1 %ife_cond27, label %ife_then28, label %ife_else29

ife_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %x1 = load i64, ptr @x, align 8
  %sgt2 = icmp sgt i64 %x1, 50
  %sgt_ext3 = zext i1 %sgt2 to i64
  %ife_cond6 = icmp ne i64 %sgt_ext3, 0
  br i1 %ife_cond6, label %ife_then7, label %ife_else8

ife_end5:                                         ; preds = %ife_end13, %ife_then7
  %ife_val17 = load i64, ptr %ife_result4, align 8
  store i64 %ife_val17, ptr %ife_result, align 8
  br label %ife_end

ife_then7:                                        ; preds = %ife_else
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %ife_result4, align 8
  br label %ife_end5

ife_else8:                                        ; preds = %ife_else
  %x9 = load i64, ptr @x, align 8
  %sgt10 = icmp sgt i64 %x9, 0
  %sgt_ext11 = zext i1 %sgt10 to i64
  %ife_cond14 = icmp ne i64 %sgt_ext11, 0
  br i1 %ife_cond14, label %ife_then15, label %ife_else16

ife_end13:                                        ; preds = %ife_else16, %ife_then15
  %ife_val = load i64, ptr %ife_result12, align 8
  store i64 %ife_val, ptr %ife_result4, align 8
  br label %ife_end5

ife_then15:                                       ; preds = %ife_else8
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %ife_result12, align 8
  br label %ife_end13

ife_else16:                                       ; preds = %ife_else8
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %ife_result12, align 8
  br label %ife_end13

ife_end26:                                        ; preds = %ife_else29, %ife_then28
  %ife_val30 = load i64, ptr %ife_result25, align 8
  %rhs_ptr = inttoptr i64 %ife_val30 to ptr
  %7 = call i64 @strlen(ptr @.str.8)
  %8 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.8, i64 %7)
  %cast = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast, %7
  %cast31 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast31, ptr %rhs_ptr, i64 %rhs_len_p1)
  store ptr %9, ptr @msg, align 8
  %msg = load ptr, ptr @msg, align 8
  %12 = call i32 @puts(ptr %msg)
  %widen32 = sext i32 %12 to i64
  br i1 true, label %ife_then35, label %ife_else36

ife_then28:                                       ; preds = %ife_end
  store i64 ptrtoint (ptr @.str.9 to i64), ptr %ife_result25, align 8
  br label %ife_end26

ife_else29:                                       ; preds = %ife_end
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %ife_result25, align 8
  br label %ife_end26

ife_end34:                                        ; preds = %ife_else36, %ife_then35
  %ife_val37 = load i64, ptr %ife_result33, align 8
  %cast38 = inttoptr i64 %ife_val37 to ptr
  %13 = call ptr @shout(ptr %cast38)
  %14 = call i32 @puts(ptr %13)
  %widen39 = sext i32 %14 to i64
  %15 = call i32 @avra_test_summary()
  %widen40 = sext i32 %15 to i64
  call void @avra_rc_collect()
  ret i64 0

ife_then35:                                       ; preds = %ife_end26
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %ife_result33, align 8
  br label %ife_end34

ife_else36:                                       ; preds = %ife_end26
  store i64 ptrtoint (ptr @.str.12 to i64), ptr %ife_result33, align 8
  br label %ife_end34
}
