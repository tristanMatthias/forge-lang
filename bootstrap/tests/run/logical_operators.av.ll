; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@result = global i64 0
@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"d\00", align 1

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

define i64 @main() {
entry:
  store ptr @.str, ptr @result, align 8
  br i1 true, label %sc_rhs, label %sc_short

sc_rhs:                                           ; preds = %entry
  br i1 true, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ true, %sc_r_merge ]
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
  br i1 true, label %sc_rhs2, label %sc_short3

if_then:                                          ; preds = %sc_merge
  %result = load ptr, ptr @result, align 8
  %0 = call i64 @strlen(ptr %result)
  %1 = call i64 @strlen(ptr @.str.1)
  %concat_total = add i64 %0, %1
  %concat_size = add i64 %concat_total, 1
  %2 = call ptr @forge_rc_alloc(i64 %concat_size)
  %3 = call ptr @memcpy(ptr %2, ptr %result, i64 %0)
  %cast = ptrtoint ptr %2 to i64
  %dst2_int = add i64 %cast, %0
  %cast1 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %1, 1
  %4 = call ptr @memcpy(ptr %cast1, ptr @.str.1, i64 %rhs_len_p1)
  store ptr %2, ptr @result, align 8
  br label %ifcont

if_else:                                          ; preds = %sc_merge
  br label %ifcont

sc_rhs2:                                          ; preds = %ifcont
  br i1 false, label %sc_r_true5, label %sc_r_false6

sc_short3:                                        ; preds = %ifcont
  br label %sc_merge4

sc_merge4:                                        ; preds = %sc_r_merge7, %sc_short3
  %sc_phi8 = phi i1 [ false, %sc_short3 ], [ false, %sc_r_merge7 ]
  %sc_ext9 = zext i1 %sc_phi8 to i64
  %if_cond11 = icmp ne i64 %sc_ext9, 0
  br i1 %if_cond11, label %if_then12, label %if_else13

sc_r_true5:                                       ; preds = %sc_rhs2
  br label %sc_r_merge7

sc_r_false6:                                      ; preds = %sc_rhs2
  br label %sc_r_merge7

sc_r_merge7:                                      ; preds = %sc_r_false6, %sc_r_true5
  br label %sc_merge4

ifcont10:                                         ; preds = %if_else13, %if_then12
  br i1 false, label %sc_short22, label %sc_rhs21

if_then12:                                        ; preds = %sc_merge4
  %result14 = load ptr, ptr @result, align 8
  %5 = call i64 @strlen(ptr %result14)
  %6 = call i64 @strlen(ptr @.str.2)
  %concat_total15 = add i64 %5, %6
  %concat_size16 = add i64 %concat_total15, 1
  %7 = call ptr @forge_rc_alloc(i64 %concat_size16)
  %8 = call ptr @memcpy(ptr %7, ptr %result14, i64 %5)
  %cast17 = ptrtoint ptr %7 to i64
  %dst2_int18 = add i64 %cast17, %5
  %cast19 = inttoptr i64 %dst2_int18 to ptr
  %rhs_len_p120 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast19, ptr @.str.2, i64 %rhs_len_p120)
  store ptr %7, ptr @result, align 8
  br label %ifcont10

if_else13:                                        ; preds = %sc_merge4
  br label %ifcont10

sc_rhs21:                                         ; preds = %ifcont10
  br i1 true, label %sc_r_true24, label %sc_r_false25

sc_short22:                                       ; preds = %ifcont10
  br label %sc_merge23

sc_merge23:                                       ; preds = %sc_r_merge26, %sc_short22
  %sc_phi27 = phi i1 [ true, %sc_short22 ], [ true, %sc_r_merge26 ]
  %sc_ext28 = zext i1 %sc_phi27 to i64
  %if_cond30 = icmp ne i64 %sc_ext28, 0
  br i1 %if_cond30, label %if_then31, label %if_else32

sc_r_true24:                                      ; preds = %sc_rhs21
  br label %sc_r_merge26

sc_r_false25:                                     ; preds = %sc_rhs21
  br label %sc_r_merge26

sc_r_merge26:                                     ; preds = %sc_r_false25, %sc_r_true24
  br label %sc_merge23

ifcont29:                                         ; preds = %if_else32, %if_then31
  br i1 false, label %sc_short41, label %sc_rhs40

if_then31:                                        ; preds = %sc_merge23
  %result33 = load ptr, ptr @result, align 8
  %10 = call i64 @strlen(ptr %result33)
  %11 = call i64 @strlen(ptr @.str.3)
  %concat_total34 = add i64 %10, %11
  %concat_size35 = add i64 %concat_total34, 1
  %12 = call ptr @forge_rc_alloc(i64 %concat_size35)
  %13 = call ptr @memcpy(ptr %12, ptr %result33, i64 %10)
  %cast36 = ptrtoint ptr %12 to i64
  %dst2_int37 = add i64 %cast36, %10
  %cast38 = inttoptr i64 %dst2_int37 to ptr
  %rhs_len_p139 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast38, ptr @.str.3, i64 %rhs_len_p139)
  store ptr %12, ptr @result, align 8
  br label %ifcont29

if_else32:                                        ; preds = %sc_merge23
  br label %ifcont29

sc_rhs40:                                         ; preds = %ifcont29
  br i1 false, label %sc_r_true43, label %sc_r_false44

sc_short41:                                       ; preds = %ifcont29
  br label %sc_merge42

sc_merge42:                                       ; preds = %sc_r_merge45, %sc_short41
  %sc_phi46 = phi i1 [ true, %sc_short41 ], [ false, %sc_r_merge45 ]
  %sc_ext47 = zext i1 %sc_phi46 to i64
  %if_cond49 = icmp ne i64 %sc_ext47, 0
  br i1 %if_cond49, label %if_then50, label %if_else51

sc_r_true43:                                      ; preds = %sc_rhs40
  br label %sc_r_merge45

sc_r_false44:                                     ; preds = %sc_rhs40
  br label %sc_r_merge45

sc_r_merge45:                                     ; preds = %sc_r_false44, %sc_r_true43
  br label %sc_merge42

ifcont48:                                         ; preds = %if_else51, %if_then50
  %result59 = load ptr, ptr @result, align 8
  %15 = call i32 @forge_test_summary()
  %widen = sext i32 %15 to i64
  call void @forge_rc_collect()
  ret i64 0

if_then50:                                        ; preds = %sc_merge42
  %result52 = load ptr, ptr @result, align 8
  %16 = call i64 @strlen(ptr %result52)
  %17 = call i64 @strlen(ptr @.str.4)
  %concat_total53 = add i64 %16, %17
  %concat_size54 = add i64 %concat_total53, 1
  %18 = call ptr @forge_rc_alloc(i64 %concat_size54)
  %19 = call ptr @memcpy(ptr %18, ptr %result52, i64 %16)
  %cast55 = ptrtoint ptr %18 to i64
  %dst2_int56 = add i64 %cast55, %16
  %cast57 = inttoptr i64 %dst2_int56 to ptr
  %rhs_len_p158 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast57, ptr @.str.4, i64 %rhs_len_p158)
  store ptr %18, ptr @result, align 8
  br label %ifcont48

if_else51:                                        ; preds = %sc_merge42
  br label %ifcont48
}
