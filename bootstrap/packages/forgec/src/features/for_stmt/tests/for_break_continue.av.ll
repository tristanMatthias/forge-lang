; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@sum = global i64 0
@found = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %for_end26 = alloca i64, align 8
  %j = alloca i64, align 8
  %for_end18 = alloca i64, align 8
  %i17 = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  store i64 0, ptr @sum, align 8
  store i64 0, ptr %i, align 8
  store i64 10, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %i2 = load i64, ptr %i, align 8
  %eq = icmp eq i64 %i2, 7
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

for.incr:                                         ; preds = %ifcont9, %if_then11
  %i14 = load i64, ptr %i, align 8
  %for_next = add i64 %i14, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %if_then, %for.cond
  %sum15 = load i64, ptr @sum, align 8
  %0 = call ptr @avra_rc_alloc(i64 32)
  %1 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %0, i64 32, ptr @.i2s_fmt, i64 %sum15)
  %widen = sext i32 %1 to i64
  %2 = call i32 @puts(ptr %0)
  %widen16 = sext i32 %2 to i64
  store i64 0, ptr @found, align 8
  store i64 0, ptr %i17, align 8
  store i64 5, ptr %for_end18, align 8
  br label %for.cond19

ifcont:                                           ; preds = %if_else
  %i3 = load i64, ptr %i, align 8
  %eq4 = icmp eq i64 %i3, 3
  %eq_ext5 = zext i1 %eq4 to i64
  %l_bool = icmp ne i64 %eq_ext5, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

if_then:                                          ; preds = %for.body
  br label %for.exit

if_else:                                          ; preds = %for.body
  br label %ifcont

sc_rhs:                                           ; preds = %ifcont
  %i6 = load i64, ptr %i, align 8
  %eq7 = icmp eq i64 %i6, 5
  %eq_ext8 = zext i1 %eq7 to i64
  %r_bool = icmp ne i64 %eq_ext8, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %ifcont
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ true, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond10 = icmp ne i64 %sc_ext, 0
  br i1 %if_cond10, label %if_then11, label %if_else12

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont9:                                          ; preds = %if_else12
  %sum = load i64, ptr @sum, align 8
  %i13 = load i64, ptr %i, align 8
  %add = add i64 %sum, %i13
  store i64 %add, ptr @sum, align 8
  br label %for.incr

if_then11:                                        ; preds = %sc_merge
  br label %for.incr

if_else12:                                        ; preds = %sc_merge
  br label %ifcont9

for.cond19:                                       ; preds = %for.incr21, %for.exit
  %i23 = load i64, ptr %i17, align 8
  %for_end_val24 = load i64, ptr %for_end18, align 8
  %for_cmp25 = icmp slt i64 %i23, %for_end_val24
  br i1 %for_cmp25, label %for.body20, label %for.exit22

for.body20:                                       ; preds = %for.cond19
  store i64 0, ptr %j, align 8
  store i64 5, ptr %for_end26, align 8
  br label %for.cond27

for.incr21:                                       ; preds = %ifcont49
  %i53 = load i64, ptr %i17, align 8
  %for_next54 = add i64 %i53, 1
  store i64 %for_next54, ptr %i17, align 8
  br label %for.cond19

for.exit22:                                       ; preds = %if_then51, %for.cond19
  %found55 = load i64, ptr @found, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.1, i64 %found55)
  %widen56 = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen57 = sext i32 %5 to i64
  %6 = call i32 @avra_test_summary()
  %widen58 = sext i32 %6 to i64
  call void @avra_rc_collect()
  ret i64 0

for.cond27:                                       ; preds = %for.incr29, %for.body20
  %j31 = load i64, ptr %j, align 8
  %for_end_val32 = load i64, ptr %for_end26, align 8
  %for_cmp33 = icmp slt i64 %j31, %for_end_val32
  br i1 %for_cmp33, label %for.body28, label %for.exit30

for.body28:                                       ; preds = %for.cond27
  %i34 = load i64, ptr %i17, align 8
  %mul = mul i64 %i34, 5
  %j35 = load i64, ptr %j, align 8
  %add36 = add i64 %mul, %j35
  %eq37 = icmp eq i64 %add36, 13
  %eq_ext38 = zext i1 %eq37 to i64
  %if_cond40 = icmp ne i64 %eq_ext38, 0
  br i1 %if_cond40, label %if_then41, label %if_else42

for.incr29:                                       ; preds = %ifcont39
  %j47 = load i64, ptr %j, align 8
  %for_next48 = add i64 %j47, 1
  store i64 %for_next48, ptr %j, align 8
  br label %for.cond27

for.exit30:                                       ; preds = %if_then41, %for.cond27
  %found = load i64, ptr @found, align 8
  %sgt = icmp sgt i64 %found, 0
  %sgt_ext = zext i1 %sgt to i64
  %if_cond50 = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond50, label %if_then51, label %if_else52

ifcont39:                                         ; preds = %if_else42
  br label %for.incr29

if_then41:                                        ; preds = %for.body28
  %i43 = load i64, ptr %i17, align 8
  %mul44 = mul i64 %i43, 5
  %j45 = load i64, ptr %j, align 8
  %add46 = add i64 %mul44, %j45
  store i64 %add46, ptr @found, align 8
  br label %for.exit30

if_else42:                                        ; preds = %for.body28
  br label %ifcont39

ifcont49:                                         ; preds = %if_else52
  br label %for.incr21

if_then51:                                        ; preds = %for.exit30
  br label %for.exit22

if_else52:                                        ; preds = %for.exit30
  br label %ifcont49
}
