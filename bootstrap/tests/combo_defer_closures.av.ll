; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@log = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"empty\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"[cleanup]\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"[cleanup]\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"huge\00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c"classify done\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.str.6 = private unnamed_addr constant [14 x i8] c"classify done\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.8 = private unnamed_addr constant [14 x i8] c"classify done\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.str.10 = private unnamed_addr constant [14 x i8] c"classify done\00", align 1
@.str.11 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.12 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [10 x i8] c"join done\00", align 1
@.str.16 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.17 = private unnamed_addr constant [2 x i8] c"-\00", align 1

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

define ptr @process(ptr %0) {
entry:
  %results = alloca ptr, align 8
  %items = alloca ptr, align 8
  store ptr %0, ptr %items, align 8
  %items1 = load ptr, ptr %items, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @avra_array_map(ptr %items1, i64 %cast)
  store ptr %2, ptr %results, align 8
  %results2 = load ptr, ptr %results, align 8
  %3 = call i64 @avra_array_len(ptr %results2)
  %eq = icmp eq i64 %3, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %results5 = load ptr, ptr %results, align 8
  %4 = call i64 @avra_array_get(ptr %results5, i64 0)
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %4)
  %widen = sext i32 %6 to i64
  %log6 = load i64, ptr @log, align 8
  %lhs_ptr7 = inttoptr i64 %log6 to ptr
  %7 = call i64 @strlen(ptr %lhs_ptr7)
  %8 = call i64 @strlen(ptr @.str.2)
  %concat_total8 = add i64 %7, %8
  %concat_size9 = add i64 %concat_total8, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %10 = call ptr @memcpy(ptr %9, ptr %lhs_ptr7, i64 %7)
  %cast10 = ptrtoint ptr %9 to i64
  %dst2_int11 = add i64 %cast10, %7
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast12, ptr @.str.2, i64 %rhs_len_p113)
  store ptr %9, ptr @log, align 8
  ret ptr %5

if_then:                                          ; preds = %entry
  %log = load i64, ptr @log, align 8
  %lhs_ptr = inttoptr i64 %log to ptr
  %12 = call i64 @strlen(ptr %lhs_ptr)
  %13 = call i64 @strlen(ptr @.str.1)
  %concat_total = add i64 %12, %13
  %concat_size = add i64 %concat_total, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size)
  %15 = call ptr @memcpy(ptr %14, ptr %lhs_ptr, i64 %12)
  %cast3 = ptrtoint ptr %14 to i64
  %dst2_int = add i64 %cast3, %12
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast4, ptr @.str.1, i64 %rhs_len_p1)
  store ptr %14, ptr @log, align 8
  ret ptr @.str

if_else:                                          ; preds = %entry
  br label %ifcont
}

define ptr @classify(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sgt = icmp sgt i64 %n1, 100
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %n2 = load i64, ptr %n, align 8
  %sgt3 = icmp sgt i64 %n2, 10
  %sgt_ext4 = zext i1 %sgt3 to i64
  %if_cond6 = icmp ne i64 %sgt_ext4, 0
  br i1 %if_cond6, label %if_then7, label %if_else8

if_then:                                          ; preds = %entry
  %1 = call i32 @puts(ptr @.str.4)
  %widen = sext i32 %1 to i64
  ret ptr @.str.3

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont5:                                          ; preds = %if_else8
  %n10 = load i64, ptr %n, align 8
  %sgt11 = icmp sgt i64 %n10, 0
  %sgt_ext12 = zext i1 %sgt11 to i64
  %if_cond14 = icmp ne i64 %sgt_ext12, 0
  br i1 %if_cond14, label %if_then15, label %if_else16

if_then7:                                         ; preds = %ifcont
  %2 = call i32 @puts(ptr @.str.6)
  %widen9 = sext i32 %2 to i64
  ret ptr @.str.5

if_else8:                                         ; preds = %ifcont
  br label %ifcont5

ifcont13:                                         ; preds = %if_else16
  %3 = call i32 @puts(ptr @.str.10)
  %widen18 = sext i32 %3 to i64
  ret ptr @.str.9

if_then15:                                        ; preds = %ifcont5
  %4 = call i32 @puts(ptr @.str.8)
  %widen17 = sext i32 %4 to i64
  ret ptr @.str.7

if_else16:                                        ; preds = %ifcont5
  br label %ifcont13
}

define ptr @join_with(ptr %0, ptr %1) {
entry:
  %sep = alloca ptr, align 8
  %items = alloca ptr, align 8
  store ptr %0, ptr %items, align 8
  store ptr %1, ptr %sep, align 8
  %items1 = load ptr, ptr %items, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %sep, align 8
  call void @avra_array_push(ptr %2, i64 %cap_val)
  %cast = ptrtoint ptr %2 to i64
  %3 = call i64 @avra_array_reduce(ptr %items1, i64 ptrtoint (ptr @.str.11 to i64), i64 %cast)
  %4 = call i32 @puts(ptr @.str.15)
  %widen = sext i32 %4 to i64
  %cast2 = inttoptr i64 %3 to ptr
  ret ptr %cast2
}

define i64 @main() {
entry:
  store ptr @.str.16, ptr @log, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 5)
  call void @avra_array_push(ptr %0, i64 10)
  %1 = call ptr @process(ptr %0)
  %2 = call i32 @puts(ptr %1)
  %widen = sext i32 %2 to i64
  %log = load ptr, ptr @log, align 8
  %3 = call i32 @puts(ptr %log)
  %widen1 = sext i32 %3 to i64
  %4 = call ptr @classify(i64 200)
  %5 = call i32 @puts(ptr %4)
  %widen2 = sext i32 %5 to i64
  %6 = call ptr @classify(i64 50)
  %7 = call i32 @puts(ptr %6)
  %widen3 = sext i32 %7 to i64
  %8 = call ptr @classify(i64 3)
  %9 = call i32 @puts(ptr %8)
  %widen4 = sext i32 %9 to i64
  %10 = call ptr @classify(i64 0)
  %11 = call i32 @puts(ptr %10)
  %widen5 = sext i32 %11 to i64
  %12 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %12, i64 1)
  call void @avra_array_push(ptr %12, i64 2)
  call void @avra_array_push(ptr %12, i64 3)
  %13 = call ptr @join_with(ptr %12, ptr @.str.17)
  %14 = call i32 @puts(ptr %13)
  %widen6 = sext i32 %14 to i64
  %15 = call i32 @avra_test_summary()
  %widen7 = sext i32 %15 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %it = alloca i64, align 8
  store i64 %0, ptr %it, align 8
  %it1 = load i64, ptr %it, align 8
  %mul = mul i64 %it1, 2
  ret i64 %mul
}

define i64 @__lambda_1(ptr %0, i64 %1, i64 %2) {
entry:
  %sep = alloca ptr, align 8
  %x = alloca i64, align 8
  %acc = alloca ptr, align 8
  store ptr %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %cast = inttoptr i64 %2 to ptr
  store ptr %cast, ptr %sep, align 8
  %acc1 = load ptr, ptr %acc, align 8
  %3 = call i32 @strcmp(ptr %acc1, ptr @.str.12)
  %widen = sext i32 %3 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %acc5 = load ptr, ptr %acc, align 8
  %sep6 = load ptr, ptr %sep, align 8
  %4 = call i64 @strlen(ptr %acc5)
  %5 = call i64 @strlen(ptr %sep6)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr %acc5, i64 %4)
  %cast7 = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast7, %4
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast8, ptr %sep6, i64 %rhs_len_p1)
  %x9 = load i64, ptr %x, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.14, i64 %x9)
  %widen10 = sext i32 %10 to i64
  %11 = call i64 @strlen(ptr %6)
  %12 = call i64 @strlen(ptr %9)
  %concat_total11 = add i64 %11, %12
  %concat_size12 = add i64 %concat_total11, 1
  %13 = call ptr @avra_rc_alloc(i64 %concat_size12)
  %14 = call ptr @memcpy(ptr %13, ptr %6, i64 %11)
  %cast13 = ptrtoint ptr %13 to i64
  %dst2_int14 = add i64 %cast13, %11
  %cast15 = inttoptr i64 %dst2_int14 to ptr
  %rhs_len_p116 = add i64 %12, 1
  %15 = call ptr @memcpy(ptr %cast15, ptr %9, i64 %rhs_len_p116)
  %cast17 = ptrtoint ptr %13 to i64
  ret i64 %cast17

if_then:                                          ; preds = %entry
  %x2 = load i64, ptr %x, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.13, i64 %x2)
  %widen3 = sext i32 %17 to i64
  %cast4 = ptrtoint ptr %16 to i64
  ret i64 %cast4

if_else:                                          ; preds = %entry
  br label %ifcont
}
