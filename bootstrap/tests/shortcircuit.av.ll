; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@x = global i64 0
@.str = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"ok\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"ok2\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @side_effect() {
entry:
  %x = load i64, ptr @x, align 8
  %add = add i64 %x, 1
  store i64 %add, ptr @x, align 8
  ret i64 1
}

define i64 @main() {
entry:
  store i64 0, ptr @x, align 8
  br i1 false, label %sc_rhs, label %sc_short

sc_rhs:                                           ; preds = %entry
  %0 = call i64 @side_effect()
  %eq = icmp eq i64 %0, 1
  %eq_ext = zext i1 %eq to i64
  %r_bool = icmp ne i64 %eq_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond = icmp ne i64 %sc_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont:                                           ; preds = %if_else, %if_then
  %x = load i64, ptr @x, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen1 = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen2 = sext i32 %3 to i64
  br i1 true, label %sc_short4, label %sc_rhs3

if_then:                                          ; preds = %sc_merge
  %4 = call i32 @puts(ptr @.str)
  %widen = sext i32 %4 to i64
  br label %ifcont

if_else:                                          ; preds = %sc_merge
  br label %ifcont

sc_rhs3:                                          ; preds = %ifcont
  %5 = call i64 @side_effect()
  %eq6 = icmp eq i64 %5, 1
  %eq_ext7 = zext i1 %eq6 to i64
  %r_bool8 = icmp ne i64 %eq_ext7, 0
  br i1 %r_bool8, label %sc_r_true9, label %sc_r_false10

sc_short4:                                        ; preds = %ifcont
  br label %sc_merge5

sc_merge5:                                        ; preds = %sc_r_merge11, %sc_short4
  %sc_phi12 = phi i1 [ true, %sc_short4 ], [ %r_bool8, %sc_r_merge11 ]
  %sc_ext13 = zext i1 %sc_phi12 to i64
  %if_cond15 = icmp ne i64 %sc_ext13, 0
  br i1 %if_cond15, label %if_then16, label %if_else17

sc_r_true9:                                       ; preds = %sc_rhs3
  br label %sc_r_merge11

sc_r_false10:                                     ; preds = %sc_rhs3
  br label %sc_r_merge11

sc_r_merge11:                                     ; preds = %sc_r_false10, %sc_r_true9
  br label %sc_merge5

ifcont14:                                         ; preds = %if_else17, %if_then16
  %x19 = load i64, ptr @x, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.2, i64 %x19)
  %widen20 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen21 = sext i32 %8 to i64
  br i1 true, label %sc_rhs22, label %sc_short23

if_then16:                                        ; preds = %sc_merge5
  %9 = call i32 @puts(ptr @.str.1)
  %widen18 = sext i32 %9 to i64
  br label %ifcont14

if_else17:                                        ; preds = %sc_merge5
  br label %ifcont14

sc_rhs22:                                         ; preds = %ifcont14
  %10 = call i64 @side_effect()
  %eq25 = icmp eq i64 %10, 1
  %eq_ext26 = zext i1 %eq25 to i64
  %r_bool27 = icmp ne i64 %eq_ext26, 0
  br i1 %r_bool27, label %sc_r_true28, label %sc_r_false29

sc_short23:                                       ; preds = %ifcont14
  br label %sc_merge24

sc_merge24:                                       ; preds = %sc_r_merge30, %sc_short23
  %sc_phi31 = phi i1 [ false, %sc_short23 ], [ %r_bool27, %sc_r_merge30 ]
  %sc_ext32 = zext i1 %sc_phi31 to i64
  %if_cond34 = icmp ne i64 %sc_ext32, 0
  br i1 %if_cond34, label %if_then35, label %if_else36

sc_r_true28:                                      ; preds = %sc_rhs22
  br label %sc_r_merge30

sc_r_false29:                                     ; preds = %sc_rhs22
  br label %sc_r_merge30

sc_r_merge30:                                     ; preds = %sc_r_false29, %sc_r_true28
  br label %sc_merge24

ifcont33:                                         ; preds = %if_else36, %if_then35
  %x38 = load i64, ptr @x, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.4, i64 %x38)
  %widen39 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen40 = sext i32 %13 to i64
  %14 = call i32 @avra_test_summary()
  %widen41 = sext i32 %14 to i64
  call void @avra_rc_collect()
  ret i64 0

if_then35:                                        ; preds = %sc_merge24
  %15 = call i32 @puts(ptr @.str.3)
  %widen37 = sext i32 %15 to i64
  br label %ifcont33

if_else36:                                        ; preds = %sc_merge24
  br label %ifcont33
}
